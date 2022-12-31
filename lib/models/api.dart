import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_front/models/api_response.dart';
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
          price: jsonResponse[i]['price'],
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

    Future addItem (var newItem) async {

      Map data = {
        "name" : newItem.name,
        "details" : newItem.details,
        "price" : newItem.price,
        "userId" : newItem.userId,
        "sold" : newItem.sold,
        "picture" : newItem.picture,
      };

      var url = Uri.parse("${dotenv.env['API_URL']}/items");

      var response = await http.post(url, body: convert.jsonEncode(data),
          headers: {
            "Content-type" : "application/json"
          });

      if(response.statusCode == 201) {



        return response.statusCode;
      }
    }

    Future fetchItemSeller (int userId) async {

      var url = Uri.parse('${dotenv.env['API_URL']}/item/$userId');

      var response = await http.get(url);

      if(response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        return jsonResponse['name'];
      }
      else {
        return "User";
      }
    }

    Future updateItem (var updatedItem) async {

    var url = Uri.parse('${dotenv.env['API_URL']}/items/${updatedItem.id}?'
        '&title=${updatedItem.title}&details=${updatedItem.details}'
        '&picture=${updatedItem.picture}');

    var response = await http.put(url);

    if(response.statusCode == 200) {
      return Item(
        id: updatedItem.id,
        name: updatedItem.name,
        details: updatedItem.details,
        price: updatedItem.price,
        userId: updatedItem.userId,
        sold: "Available",
        picture: updatedItem.picture,
        updatedAt: date
      );
    }
    else {
      Exception(
          "Error Fetching Data with a Status Code: ${response.statusCode}");
    }
  }

  Future setStatus (var updatedItem) async {

    var url = Uri.parse('${dotenv.env['API_URL']}/items/${updatedItem.id}?sold=${updatedItem.sold}');

    var response = await http.patch(url);

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

}