import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mime_type/mime_type.dart';
import 'package:mfitness/accountAuth/login.dart';
import 'package:mfitness/model/services/core/globalvariables.dart';
import 'package:mfitness/model/services/core/myfunctions.dart';
import 'package:mfitness/model/services/core/mytexts.dart';

class NetworkService {
  static final NetworkService instance = NetworkService._init();
  NetworkService._init();
  final networkClient = http.Client();

  Future<NetworkResponse> get({
    required String path,
    required Map<String, String>? customHeader,
    bool showResult = false,
  }) async {
    Uri url = Uri.parse('${MyTexts.baseURL}$path');
    myLog(name: 'url GET called', logContent: url);
    try {
      var send = await networkClient.get(url, headers: customHeader);
      if (showResult) {
        myLog(name: 'backend data', logContent: send.body);
      }
      var jsonData = jsonDecode(send.body);

      if (send.statusCode == 200) {
        return NetworkResponse(
          statusCode: send.statusCode,
          networkData: dataIsList(jsonData, isError: false),
        );
      } else {
        canLogout(jsonData);
        return NetworkResponse(
          statusCode: send.statusCode,
          networkData: dataIsList(jsonData, isError: true),
        );
      }
    } catch (e) {
      myLog(name: 'error getNetwork of $url link', logContent: e);
      return NetworkResponse(
        statusCode: 500,
        networkData: {'message': MyTexts.servererror},
      );
    }
  }

  Future<NetworkResponse> post({
    required String path,
    required Map body,
    required Map<String, String>? customHeader,
    bool showResult = false,
  }) async {
    Uri url = Uri.parse('${MyTexts.baseURL}$path');
    myLog(name: 'url POST called', logContent: url);
    myLog(name: 'body sent', logContent: body);

    try {
      var encodedBody = jsonEncode(body);
      var send = await networkClient.post(
        url,
        body: encodedBody,
        headers: customHeader,
      );
      if (showResult) {
        myLog(name: 'backend data', logContent: send.body);
        myLog(name: 'status code', logContent: send.statusCode);
      }
      var jsonData = jsonDecode(send.body);
      if (send.statusCode == 200) {
        return NetworkResponse(
          statusCode: send.statusCode,
          networkData: dataIsList(jsonData, isError: false),
        );
      } else {
        canLogout(jsonData);
        return NetworkResponse(
          statusCode: send.statusCode,
          networkData: dataIsList(jsonData, isError: true),
        );
      }
    } catch (e) {
      myLog(name: 'error postNetwork of $url link', logContent: e);

      return NetworkResponse(
        statusCode: 500,
        networkData: {'message': MyTexts.servererror},
      );
    }
  }

  Future<NetworkResponse> put({
    required String path,
    Map? body,
    required Map<String, String>? customHeader,
    bool showResult = false,
  }) async {
    Uri url = Uri.parse('${MyTexts.baseURL}$path');
    myLog(name: 'url PUT called', logContent: url);
    try {
      late String encodedBody;
      if (body != null) {
        encodedBody = jsonEncode(body);
      }

      Response send = await networkClient.put(
        url,
        body: body != null ? encodedBody : null,
        headers: customHeader,
      );
      if (showResult) {
        myLog(name: 'backend data', logContent: send.body);
      }
      var jsonData = jsonDecode(send.body);
      if (send.statusCode == 200) {
        return NetworkResponse(
          statusCode: send.statusCode,
          networkData: dataIsList(jsonData, isError: false),
        );
      } else {
        canLogout(jsonData);
        return NetworkResponse(
          statusCode: send.statusCode,
          networkData: dataIsList(jsonData, isError: true),
        );
      }
    } catch (e) {
      myLog(name: 'error putNetwork of $url link', logContent: e);
      return NetworkResponse(statusCode: 500);
    }
  }

  Future<NetworkResponse> patch({
    required String path,
    Map? body,
    required Map<String, String>? customHeader,
    bool showResult = false,
  }) async {
    Uri url = Uri.parse('${MyTexts.baseURL}$path');
    myLog(name: 'url PATCH called', logContent: url);
    try {
      late String encodedBody;
      if (body != null) {
        encodedBody = jsonEncode(body);
      }

      Response send = await networkClient.patch(
        url,
        body: body != null ? encodedBody : null,
        headers: customHeader,
      );
      if (showResult) {
        myLog(name: 'backend data', logContent: send.body);
      }
      var jsonData = jsonDecode(send.body);
      if (send.statusCode == 200) {
        return NetworkResponse(
          statusCode: send.statusCode,
          networkData: dataIsList(jsonData),
        );
      } else {
        canLogout(jsonData);
        return NetworkResponse(
          statusCode: send.statusCode,
          networkData: dataIsList(jsonData, isError: true),
        );
      }
    } catch (e) {
      myLog(name: 'error getNetwork of $url link', logContent: e);
      return NetworkResponse(statusCode: 500);
    }
  }

  Future<NetworkResponse> delete({
    required String path,
    Map? body,
    required Map<String, String>? customHeader,
    bool showResult = false,
  }) async {
    Uri url = Uri.parse('${MyTexts.baseURL}$path');
    myLog(name: 'url DELETE called', logContent: url);
    try {
      late String encodedBody;
      if (body != null) {
        encodedBody = jsonEncode(body);
      }

      Response send = await networkClient.delete(
        url,
        body: body != null ? encodedBody : null,
        headers: customHeader,
      );
      if (showResult) {
        myLog(name: 'backend data', logContent: send.body);
      }
      var jsonData = jsonDecode(send.body);
      if (send.statusCode == 200) {
        return NetworkResponse(
          statusCode: send.statusCode,
          networkData: dataIsList(jsonData),
        );
      } else {
        canLogout(jsonData);
        return NetworkResponse(
          statusCode: send.statusCode,
          networkData: dataIsList(jsonData, isError: true),
        );
      }
    } catch (e) {
      myLog(name: 'error getNetwork of $url link', logContent: e);
      return NetworkResponse(
        statusCode: 500,
        networkData: {'message': MyTexts.servererror},
      );
    }
  }

  Future<NetworkResponse> uploadMedia({
    required String path,
    required Map<String, String> body,
    required Map<String, String>? customHeader,
    required List<File> mediaList,
    bool multipleFiles = true,
    String mediaName = 'images',
    String method = 'POST',
  }) async {
    Uri url = Uri.parse('${MyTexts.baseURL}$path');
    myLog(name: 'url uploadMedia called', logContent: url);
    try {
      MultipartRequest request = http.MultipartRequest(method, url);
      request.fields.addAll(body);
      // request.fields.addAll({'data': jsonEncode(body)});
      request.headers.addAll(customHeader!);
      if (multipleFiles) {
        final futures = multiCreator(mediaList).map((data) async {
          return await MultipartFile.fromPath(
            mediaName,
            data['path'],
            contentType: MediaType.parse(lookupMime(data['path'])),
          );
        });

        request.files.addAll(await Future.wait(futures));
      } else {
        request.files.add(
          await MultipartFile.fromPath(
            mediaName,
            mediaList.first.path,
            contentType: MediaType.parse(lookupMime(mediaList.first.path)),
          ),
        );
      }

      var send = await request.send();
      final res = await http.Response.fromStream(send);
      var jsonData = jsonDecode(res.body);
      myLog(name: 'data from media Upload called', logContent: jsonData);
      myLog(
        name: 'data from media Upload status Code',
        logContent: send.statusCode,
      );
      myLog(name: 'header', logContent: request.headers);
      if (send.statusCode == 200) {
        return NetworkResponse(
          statusCode: send.statusCode,
          networkData: jsonData,
        );
      } else {
        canLogout(jsonData);
        return NetworkResponse(
          statusCode: send.statusCode,
          networkData: jsonData,
        );
      }
    } catch (e) {
      myLog(name: 'error uploadMedia of $url link', logContent: e);

      return NetworkResponse(
        statusCode: 500,
        networkData: {'message': MyTexts.servererror},
      );
    }
  }
}

Map<String, dynamic> dataIsList(var jsonData, {bool isError = false}) =>
    jsonData is List
    ? {
        'message': isError
            ? 'Unable to fetch data. Please try again'
            : 'Fetched successfully',
        'data': jsonData,
      }
    : jsonData;

canLogout(Map jsonData) {
  if (jsonData['error'] != null &&
      jsonData['error'].toString().contains('token is expired')) {
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Login()),
      (predicate) => false,
    );
  }
}

List<Map> multiCreator(List<File> medias) {
  List<Map> uploadMedia = [];
  for (var i = 0; i < medias.length; i++) {
    String mimeType = mime(medias[i].path) ?? '';
    uploadMedia.add({
      'field': 'image${i + 1}',
      'path': medias[i].path,
      'subtype': mimeType.split('/')[1],
    });
  }
  return uploadMedia;
}

String lookupMime(String path) {
  final ext = path.split('.').last.toLowerCase();
  switch (ext) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'gif':
      return 'image/gif';
    case 'webp':
      return 'image/webp';
    default:
      return 'application/octet-stream';
  }
}

// NetworkService networkService = NetworkService();

class NetworkResponse {
  int statusCode;
  Map<String, dynamic>? networkData = {'message': MyTexts.servererror};
  NetworkResponse({required this.statusCode, this.networkData});
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
