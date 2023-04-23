import 'dart:convert';

import 'package:ecommerce/pages/model/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<User> login(String username, dynamic password) async {
    var url = Uri.https("apicommand.izzi.asia", "/User/LoginByMerchantCode");
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": username,
          "password": password,
          "merchantCode": "labo"
        }));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load user");
    }
  }
}
