import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:robo_friends/model/user_model.dart';
import 'package:robo_friends/utils/constants.dart';

class ApiService {
  /// This function fetches the users from the Users API
  static Future<List<UserModel>> getUsers() async {
    try {
      final url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<UserModel> model = userModelFromJson(response.body);
        return model;
      } else {
        return <UserModel>[];
      }
    } catch (e) {
      log(e.toString());
      return <UserModel>[];
    }
  }
}
