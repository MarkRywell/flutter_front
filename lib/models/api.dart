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
          userId: jsonResponse[i]['userId'],
          sold: jsonResponse[i]['sold'],
          picture: jsonResponse[i]['picture'],
          soldTo: jsonResponse[i]['soldTo'],
          createdAt: jsonResponse[i]['created_at'],
          updatedAt: jsonResponse[i]['updatedAt'],
        );
      }) : [];
    }
    else {
      Exception(
          "Error Fetching Data with a Status Code: ${response.statusCode}");
    }
  }

    Future addItem (var newItem) async {

      var url = Uri.parse('${dotenv.env}/items?'
          '&name=${newItem.title}&details=${newItem.details}'
          '&userId=${newItem.userId}&picture=${newItem.picture}');

      var response = await http.post(url);

      if(response.statusCode == 201) {
        return response.statusCode;
      }
    }

    Future updateItem (var updatedItem) async {

    var url = Uri.parse('${dotenv.env}/items/${updatedItem.id}?'
        '&title=${updatedItem.title}&details=${updatedItem.details}'
        '&picture=${updatedItem.picture}');

    var response = await http.put(url);

    if(response.statusCode == 200) {
      return Item(
        id: updatedItem.id,
        name: updatedItem.name,
        details: updatedItem.details,
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

    var url = Uri.parse('${dotenv.env}/items/${updatedItem.id}?sold=${updatedItem.sold}');

    var response = await http.patch(url);

  }

  Future loginUser (Map credentials) async {

    var url = Uri.parse("${dotenv.env['API_URL']}/login");

    var response = await http.post(url, body: convert.jsonEncode(credentials),
    headers: {
        "Content-type" : "application/json"
      }
    ).timeout(const Duration(seconds: 2), onTimeout: () {

      return http.Response("Request Timeout", 500);
    });

    if(response.statusCode == 500){
      return response;
    }

    var jsonResponse = await convert.jsonDecode(response.body);

    ApiResponse apiResponse = ApiResponse(
        status: jsonResponse['status'],
        message: jsonResponse['message'],
        data: jsonResponse['data'] ?? Map());

    if(response.statusCode != 200) {
      return([apiResponse, 400]);
    }

    return ([apiResponse, 200]);

  }

}