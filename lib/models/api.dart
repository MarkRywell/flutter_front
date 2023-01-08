import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_front/models/api_response.dart';
import 'package:flutter_front/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_front/models/item.dart';
import 'package:intl/intl.dart';

class Api {

  String date = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  Api.privateConstructor();
  static final Api instance = Api.privateConstructor();

  Future <dynamic> fetchOtherItems (int id) async {

    var url = Uri.parse('${dotenv.env['API_URL']}/items/$id');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      return jsonResponse.isNotEmpty ?
      List.generate(jsonResponse.length, (i) {
        return Item(
          id: jsonResponse[i]['id'],
          name: jsonResponse[i]['name'],
          details: jsonResponse[i]['details'],
          price: jsonResponse[i]['price'].toDouble(),
          userId: jsonResponse[i]['userId'],
          sold: jsonResponse[i]['sold'],
          picture: jsonResponse[i]['picture'],
          soldTo: jsonResponse[i]['soldTo'],
          createdAt: jsonResponse[i]['created_at'],
          updatedAt: jsonResponse[i]['updated_at'],
        );
      }) : [];
    }
    else {
      Exception(
          "Error Fetching Data with a Status Code: ${response.statusCode}");
    }
  }

  Future <dynamic> fetchMyItems (int id) async {

    var url = Uri.parse('${dotenv.env['API_URL']}/v2/items/$id');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      return jsonResponse.isNotEmpty ?
      List.generate(jsonResponse.length, (i) {
        return Item(
          id: jsonResponse[i]['id'],
          name: jsonResponse[i]['name'],
          details: jsonResponse[i]['details'],
          price: jsonResponse[i]['price'].toDouble(),
          userId: jsonResponse[i]['userId'],
          sold: jsonResponse[i]['sold'],
          picture: jsonResponse[i]['picture'],
          soldTo: jsonResponse[i]['soldTo'],
          createdAt: jsonResponse[i]['created_at'],
          updatedAt: jsonResponse[i]['updated_at'],
        );
      }) : [];
    }
    else {
      Exception(
          "Error Fetching Data with a Status Code: ${response.statusCode}");
    }
  }

  Future fetchPicture (String picture) async {

    var url = Uri.parse('${dotenv.env['API_URL']}/picture/$picture');

    var response = await http.get(url);

    if(response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    }
    else {
      Exception("Error with a status code: ${response.statusCode}");
    }
  }

  Future fetchItemSeller (int userId) async {

    var url = Uri.parse('${dotenv.env['API_URL']}/item/$userId');

    var response = await http.get(url);

    if(response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse;
    }
    else {
      return {'name': "User", 'address' : "Address"};
    }
  }

  Future addItem (var data) async {

    var url = Uri.parse("${dotenv.env['API_URL']}/items");

    var request = http.MultipartRequest('POST', url);

    var file;

    if(data['picture'] == "assets/OnlySells1.png") {
      ByteData byteData = await rootBundle.load('assets/OnlySells1.png');
      List <int> imageData = byteData.buffer.asUint8List();
      file = http.MultipartFile.fromBytes('picture', imageData, filename: "OnlySells1.png");
    }
    else {
      file = await http.MultipartFile.fromPath('picture', data['picture']);
    }

    request.files.add(file);
    request.fields['name'] = data['name'];
    request.fields['details'] = data['details'];
    request.fields['price'] = data['price'].toString();
    request.fields['userId'] = data['userId'].toString();
    request.fields['sold'] = data['sold'];

    final streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);

    if(response.statusCode == 500){
      return response;
    }

    var jsonResponse = await convert.jsonDecode(response.body);

    ApiResponse apiResponse = ApiResponse(
        status: jsonResponse['status'],
        message: jsonResponse['message'],
        data: jsonResponse['data'] ?? {});

    if(response.statusCode != 201) {
      return ([apiResponse, 400]);
    }

    print(streamResponse);

    return ([apiResponse, 201]);
  }

  Future updateItem (var updatedItem) async {

    var url = Uri.parse('${dotenv.env['API_URL']}/items/${updatedItem.id}');

    Map data = {
      'name' : updatedItem.name,
      'details' : updatedItem.details,
      'price' : updatedItem.price,
      'userId' : updatedItem.userId,
      'sold' : updatedItem.sold,
    };

    var response = await http.put(url, body: convert.jsonEncode(data),
        headers: {
          "Content-type" : "application/json"
        }).timeout(const Duration(seconds: 2), onTimeout: () {
      return http.Response('Request Timeout', 500);
    });

    if(response.statusCode == 500) {
      return response;
    }

    var jsonResponse = await convert.jsonDecode(response.body);

    ApiResponse apiResponse = ApiResponse(
        status: jsonResponse['status'],
        message: jsonResponse['message'],
        data: jsonResponse['data'] ?? {});

    if(response.statusCode != 200) {
      return ([apiResponse, 400]);
    }

    return ([apiResponse, 200]);
  }

  Future updatePicture (var updateData) async {

    var url = Uri.parse('${dotenv.env['API_URL']}/picture/${updateData.id}');

    var request = http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromPath('picture', updateData.picture));

    final streamResponse = await request.send();
    var response = await http.Response.fromStream(streamResponse);

    var jsonResponse = convert.jsonDecode(response.body);

    ApiResponse apiResponse = ApiResponse(
        status: jsonResponse['status'],
        message: jsonResponse['message'],
        data: jsonResponse['data'] ?? {});

    if(response.statusCode != 200) {
      return ([apiResponse, 400]);
    }

    return ([apiResponse, 200]);
  }



  Future purchase (var updatedItem) async {

    var url = Uri.parse('${dotenv.env['API_URL']}/v2/item/${updatedItem.id}?soldTo=${updatedItem.soldTo}&sold=${updatedItem.sold}');

    var response = await http.put(url).timeout(const Duration(seconds: 2), onTimeout: () {
      return http.Response('Request Timeout', 500);
    });

    var jsonResponse = await convert.jsonDecode(response.body);

    ApiResponse apiResponse = ApiResponse(
        status: jsonResponse['status'],
        message: jsonResponse['message'],
        data: jsonResponse['data'] ?? {});

    if(response.statusCode != 200) {
      return ([apiResponse, 400]);
    }

    return ([apiResponse, 200]);
  }

  Future removeItem (var item) async {
    var url = Uri.parse('${dotenv.env['API_URL']}/item/${item.id}');

    try {
      var response = await http.patch(url).timeout(const Duration(seconds: 2));

      var jsonResponse = await convert.jsonDecode(response.body);

      ApiResponse apiResponse = ApiResponse(
          status: jsonResponse['status'],
          message: jsonResponse['message'],
          data: jsonResponse['data'] ?? {});

      if (response.statusCode != 200) {
        return [apiResponse, 400];
      }
      return [apiResponse, 200];
    } on TimeoutException {
      return http.Response("Request Timeout", 500);
    }
  }

  Future deleteItem (var item) async {

    var url = Uri.parse('${dotenv.env['API_URL']}/items/${item.id}');

    try {
      var response = await http.delete(url).timeout(const Duration(seconds: 2));

      var jsonResponse = await convert.jsonDecode(response.body);


      ApiResponse apiResponse = ApiResponse(
          status: jsonResponse['status'],
          message: jsonResponse['message'],
          data: jsonResponse['data'] ?? {});

      if (response.statusCode != 200) {
        return [apiResponse, 400];
      }
      return [apiResponse, 200];
    } on TimeoutException {
      return http.Response("Request Timeout", 500);
    }
  }

  Future <dynamic> myPurchases(String name) async {

    var url = Uri.parse("${dotenv.env['API_URL']}/myPurchases/$name");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      return jsonResponse.isNotEmpty ?
      List.generate(jsonResponse.length, (i) {
        return Item(
          id: jsonResponse[i]['id'],
          name: jsonResponse[i]['name'],
          details: jsonResponse[i]['details'],
          price: jsonResponse[i]['price'].toDouble(),
          userId: jsonResponse[i]['userId'],
          sold: jsonResponse[i]['sold'],
          picture: jsonResponse[i]['picture'],
          soldTo: jsonResponse[i]['soldTo'],
          createdAt: jsonResponse[i]['created_at'],
          updatedAt: jsonResponse[i]['updated_at'],
        );
      }) : [];
    }
    else {
      Exception(
          "Error Fetching Data with a Status Code: ${response.statusCode}");
    }

  }

  Future loginUser(Map credentials) async {
    var url = Uri.parse("${dotenv.env['API_URL']}/login");
    try {
      var response = await http.post(url, body: convert.jsonEncode(credentials),
          headers: {
        "Content-type": "application/json"
      }).timeout(const Duration(seconds: 2));
      var jsonResponse = await convert.jsonDecode(response.body);
      ApiResponse apiResponse = ApiResponse(
          status: jsonResponse['status'],
          message: jsonResponse['message'],
          data: jsonResponse['data'] ?? {});
      if (response.statusCode != 200) {
        return [apiResponse, 400];
      }
      return [apiResponse, 200];
    } on TimeoutException {
      return http.Response("Request Timeout", 500);
    }
  }


  Future registerUser (Map credentials) async {

    var url = Uri.parse("${dotenv.env['API_URL']}/register");

    var response = await http.post(url, body: convert.jsonEncode(credentials),
    headers: {
      "Content-type" : "application/json"
    }
    ).timeout(const Duration(seconds: 2), onTimeout: () {

      return http.Response('Request Timeout', 500);
    });

    if(response.statusCode == 500) {
      return response;
    }

    var jsonResponse = await convert.jsonDecode(response.body);

    ApiResponse apiResponse = ApiResponse(
      status: jsonResponse['status'],
      message: jsonResponse['message'],
      data: jsonResponse['data'] ?? {});

    if(response.statusCode != 201) {
      return ([apiResponse, 400]);
    }

    return ([apiResponse, 201]);
  }

  Future <dynamic> fetchUsers () async {
    
    var url = Uri.parse('${dotenv.env['API_URL']}/users');

    var response = await http.get(url).timeout(const Duration(seconds: 2),
        onTimeout: () {
          return http.Response('Request Timeout', 500);
        });

    if(response.statusCode == 500) {
      return response;
    }

    if(response.statusCode == 200) {
      var jsonResponse = await convert.jsonDecode(response.body);

      return jsonResponse.isNotEmpty ?
      List.generate(jsonResponse.length, (i) {
        return User(
          id: jsonResponse[i]['id'],
          name: jsonResponse[i]['name'],
          contactNo: jsonResponse[i]['contactNo'],
          picture: jsonResponse[i]['picture'],
          email: jsonResponse[i]['email'],
          address: jsonResponse[i]['address'],
        );
      }) : [];
    }
    else {
      Exception(
          "Error Fetching Data with a Status Code: ${response.statusCode}");
    }
  }

  Future updateProfPic (int id, String filePath) async {

      var url = Uri.parse('${dotenv.env['API_URL']}/users/picture/$id');

      var request = http.MultipartRequest('POST', url);

      request.files.add(await http.MultipartFile.fromPath('picture', filePath));

      final streamResponse = await request.send();
      var response = await http.Response.fromStream(streamResponse);

      var jsonResponse = convert.jsonDecode(response.body);

      ApiResponse apiResponse = ApiResponse(
          status: jsonResponse['status'],
          message: jsonResponse['message'],
          data: {'picture' : jsonResponse['data']});

      if(response.statusCode != 200) {
        return ([apiResponse, 400]);
      }

      return ([apiResponse, 200]);
  }

}