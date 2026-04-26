import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:mfitness/model/services/shared_prefs/shared_prefs.dart';

class GDriveUpload {
  final GoogleSignIn googleInstance = GoogleSignIn.instance;
  initialize() async {
    /// Generate serverClientId by activating OAuth in https://console.cloud.google.com and download the new .json file

    await googleInstance.initialize();
  }

  Future<GoogleSignInResult> signInWithGoogle() async {
    if (googleInstance.supportsAuthenticate()) {
      try {
        // this signs the user in
        GoogleSignInAccount signIn = await googleInstance.authenticate(
          scopeHint: [
            'https://www.googleapis.com/auth/userinfo.email',
            'https://www.googleapis.com/auth/userinfo.profile',
            'https://www.googleapis.com/auth/drive.file',
          ],
        );
        // this fetches OAuth via accessToken required for HTTPS requests such as uploading to GDrive
        GoogleSignInClientAuthorization auth = await signIn.authorizationClient
            .authorizeScopes(['https://www.googleapis.com/auth/drive.file']);
        // accessToken for HTTPS, idToken for login auth
        myLog(name: 'auth', logContent: auth.accessToken);
        if (signIn.authentication.idToken != null) {
          prefsHandler.savePrefData(
            key: 'emailAddress',
            stringValue: signIn.email,
            type: PrefsType.string,
          );
          prefsHandler.savePrefData(
            key: 'name',
            stringValue: signIn.displayName ?? 'N/A',
            type: PrefsType.string,
          );
          prefsHandler.savePrefData(
            key: 'isLogged',
            boolValue: true,
            type: PrefsType.boolean,
          );
        }

        return GoogleSignInResult(
          state: signIn.authentication.idToken == null
              ? EmailAuthState.failed
              : EmailAuthState.success,
          token: auth.accessToken,
          errorMessage: signIn.authentication.idToken == null
              ? 'Unable to authorize user. Please try again'
              : '',
        );
      } catch (e) {
        // ···
        myLog(name: 'google sign in catch', logContent: e);
        return GoogleSignInResult(
          state: EmailAuthState.failed,
          token: '',
          errorMessage: e.toString(),
        );
      }
    } else {
      return GoogleSignInResult(
        state: EmailAuthState.failed,
        token: '',
        errorMessage: 'Devices does not support authentication',
      );
    }
  }

  Future<GoogleSignInResult> silentLogin() async {
    try {
      GoogleSignInAccount? signIn = await googleInstance
          .attemptLightweightAuthentication();
      if (signIn != null) {
        GoogleSignInClientAuthorization auth = await signIn.authorizationClient
            .authorizeScopes(['https://www.googleapis.com/auth/drive.file']);
        return GoogleSignInResult(
          state: signIn.authentication.idToken == null
              ? EmailAuthState.failed
              : EmailAuthState.success,
          token: auth.accessToken,
          errorMessage: signIn.authentication.idToken == null
              ? 'Unable to authorize user. Please try again'
              : '',
        );
      } else {
        return await signInWithGoogle();
      }
    } catch (e) {
      myLog(name: 'google sign in catch', logContent: e);
      return GoogleSignInResult(
        state: EmailAuthState.failed,
        token: '',
        errorMessage: e.toString(),
      );
    }
  }

  Future<String?> uploadFileHTTP({
    required File file,
    required String accessToken, // uses OAuth from above
  }) async {
    myLog(name: 'file path', logContent: file.path);
    final folderId = await getOrCreateFolder(
      accessToken: accessToken,
      folderName: 'Mfitness Backups',
    );

    if (folderId == null) return null;
    try {
      final uri = Uri.parse(
        'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart',
      );

      final request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $accessToken';

      /// metadata
      // Add metadata
      final metadata = {
        'name': 'backup-${DateTime.now().toIso8601String()}.db',
        'parents': [folderId],
      };
      request.files.add(
        http.MultipartFile.fromString(
          'metadata',
          json.encode(metadata),
          contentType: MediaType('application', 'json'),
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('application', 'x-sqlite3'),
        ),
      );

      final response = await request.send();

      final body = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(body);
        return json['id'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getOrCreateFolder({
    required String accessToken,
    required String folderName,
  }) async {
    final existingId = await findFolder(
      accessToken: accessToken,
      folderName: folderName,
    );

    if (existingId != null) return existingId;

    return await createFolder(accessToken: accessToken, folderName: folderName);
  }

  Future<String?> findFolder({
    required String accessToken,
    required String folderName,
  }) async {
    final url = Uri.parse(
      'https://www.googleapis.com/drive/v3/files'
      '?q=name="$folderName" and '
      'mimeType="application/vnd.google-apps.folder" '
      'and trashed=false'
      '&fields=files(id,name)',
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    final data = jsonDecode(response.body);

    if (data['files'] != null && data['files'].isNotEmpty) {
      return data['files'][0]['id'];
    }

    return null;
  }

  Future<String?> createFolder({
    required String accessToken,
    required String folderName,
  }) async {
    final url = Uri.parse('https://www.googleapis.com/drive/v3/files');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': folderName,
        'mimeType': 'application/vnd.google-apps.folder',
      }),
    );

    final data = jsonDecode(response.body);

    return data['id'];
  }

  signOutGoogle() async {
    await googleInstance.signOut();
  }

  uploadServiceAccount({required File file}) async {
    myLog(name: 'file path', logContent: file.path);
    Map serviceAccount = {
      "type": "service_account",
      "project_id": "betslipchat",
      "private_key_id": "ddbd3cc7ca78772904e977aa2b7a190c8e3355cd",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC3/Cxz1uamoeeu\nP6KJG0R+9jw8PNx4fjoBnFfDMHKXxmmIcqbChT3GMOOPdE7B2U0EQF6MMIFoCsUV\nhxg+BfRYOPcrZ1T/EmrFiLdbDcLfraqIP0wTmKdId0sP2wrLpFtPo3pExD5GY30a\n7qFCf749i+ONsP8md9IHajHnYWWnOSWP/tB2n/bvLTj2ANzjKUaAePA0YBb8WasK\nc76fRzNr+FzF6IZVCYGIu7D9fkP5NPirbKtVb5VovkjZvxNjol2HxEGZyskpg8sq\nEEVtaW/8WULlgreSvBqcWW5pqh41bU5rNT19zAk80TLN8/uBrfKQYtpH6rRhYuus\nvgvUYD0DAgMBAAECggEARRZfFOKqOwFKD98aaBTCrFBHfzE1ctOncYplVEjhhwe9\nAj1XTG0fLMiX8vrwRg+UwZdwSYE/XrPInRRdMJEo12YQvo4vVxbx3BpCC+GHf1nl\n0wK9zRACJQ6Ss7IDhEPD/Aw9sgvk/KaISHA6Qs/YPqFEgiToMuhEiH9CnQmwU9HY\nd4AGpw5ni4EN7SS5T5ubpuCqTMzbjk4UzAtgPP/h9Wa3tasVtUEA0/5saSx7CKqS\n4EOh2tbZAORqw6Ke6F8fiOkxgsdWfjoRJ7RpqA0+Z+u49Xw2mHOkAD0Z3+GMXtN9\n39T5NOLRAX5KJ1tqerkEYMnrZsKF9LCqLXpii5bfvQKBgQDvavx28f0TAXejPORS\nlQmE6aUcDcERlDOiqrJfJPIzt7YE1UbfGGdDHxMi8wY/lEKll0U5vLepPO71sOXS\nBMc2WOSeXawiR3JYERb6qWr4DPB1zAxOzbc3rnA70kKzbCAA8+Vic4LASw5Gjl6r\nlSTAUgaByLMI+jOOx9W69g3wzQKBgQDEulTtoLuZs9rXkvAgl3ZhVcmt4rufzysN\nBHdvMS40BT7yKcjsh4ze/Ey2WCUzaCZA2EhQea+Lg5Dp2soiiE3wtcqdcjbYYfSp\ndUeRJ4arL8CsFxgcIKhHXy67W7nICm2cUu5KUSnS4M1i3yFzdRmM7zsqPDdATqeZ\n9I1bNselDwKBgAMdvF179tRJf5ojT8F3aSFOvTRpRWsKJ8XlPN8aJwDfUkIr2HlM\n4wMvo1sgGKO5NUjceC0xNJ7CSUXvYH5kS4d8jrU0+OmVTnqw9kCa9eZ2nKab2kko\nSksyPQm6Sd31+VCp3AF1CW2hTHVEoxzOmyTZrHYB+7qRLxyboz+Etle9AoGAYG6q\nBNV+QCiehH99f6xfFfVUaA01RW/qvXXMCdBEwrEzmscKu47yabeo7tUkXx+VaMHc\nKL6NY0j5tvhNj0HbWrvx9t2ursDNimd3zlpes/kza+fiJJ+JfXrV0Hd1CO67rh4k\nun8wjjMt2mJf5lWnUaNPEDP2LWqg02HCDM08bdcCgYBG9x+MEO4iApAtSgKBofOS\nim5/k0JadUaL1sFg4GOXM8yM3NSETmefxqyrWfAWCXCm8NUhAVUEEpi900cqI9gk\nL3oG5pXeCFcewJSm3VjxDOyuVdZM2mxcGHtD3K5UhQM7ERpsgGvImDGvumfaalFK\n5VRfFKcWn/h9byYx/uhLwQ==\n-----END PRIVATE KEY-----\n",
      "client_email": "betslipchat@appspot.gserviceaccount.com",
      "client_id": "103638126063551354242",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/betslipchat%40appspot.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };
    final credentials = ServiceAccountCredentials.fromJson(serviceAccount);

    // Define the scopes for Google Drive access
    final scopes = [drive.DriveApi.driveFileScope];

    // Authenticate the service account
    final client = await clientViaServiceAccount(credentials, scopes);

    // Instantiate the Google Drive API
    var driveApi = drive.DriveApi(client);

    // Create a file to upload
    var fileStream = file.openRead();
    var media = drive.Media(fileStream, file.lengthSync());

    // Define the metadata for the file
    var driveFile = drive.File();
    driveFile.name = 'backup-${DateTime.now().toIso8601String()}.db';
    // driveFile.parents = ['1T0butncOiWDlHiMFSXIXEffB2yh7YYzG'];

    try {
      // Upload the file
      var response = await driveApi.files.create(driveFile, uploadMedia: media);
      myLog(name: 'response id', logContent: 'File uploaded: ${response.id}');
      if (response.id != null) {
        // Close the client
        client.close();
        return true;
      } else {
        client.close();
        return false;
      }
    } catch (e) {
      myLog(name: 'response error', logContent: e);
      client.close();
      return false;
    }
  }
}

GDriveUpload gDriveInstance = GDriveUpload();

class GoogleSignInResult {
  EmailAuthState state;
  String token;
  String errorMessage;
  String email;
  String fullName;
  GoogleSignInResult({
    required this.state,
    required this.token,
    required this.errorMessage,
    this.email = '',
    this.fullName = '',
  });
}

enum EmailAuthState { success, failed }
