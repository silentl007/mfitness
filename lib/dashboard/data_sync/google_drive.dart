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
    Map serviceAccount = {};
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
