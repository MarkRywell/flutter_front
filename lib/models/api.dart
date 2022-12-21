import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_front/models/item.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {

  Api.privateConstructor();
  static final Api instance = Api.privateConstructor();

  Future <dynamic> fetchItems () async {

    var url = Uri.parse('${dotenv.env['API_URL']}/items');

    var response = await http.get(url);

    if(response.statusCode == 200) {

      var jsonResponse = convert.jsonDecode(response.body);

      return jsonResponse.isNotEmpty ?
      List.generate(jsonResponse.length, (i){
        return Item(
          id: jsonResponse[i]['id'],
          name: jsonResponse[i]['name'],
          details: jsonResponse[i]['details'],
          userId: jsonResponse[i]['userId'],
          sold: jsonResponse[i]['sold'],
          picture: jsonResponse[i]['picture'],
          createdAt: jsonResponse[i]['created_at'],
          updatedAt: jsonResponse[i]['updatedAt'],
        );
      }) : [];
    }
    else {
      Exception("Error Fetching Data with a Status Code: ${response.statusCode}");
    }

    Future addItem (var newItem) async {

      var url = Uri.parse('${dotenv.env}/items?'
          '&title=${newItem.title}&details=${newItem.details}'
          '&userId=${newItem.userId}&sold==${newItem.sold}&picture=${newItem.picture}');

    }

}

}