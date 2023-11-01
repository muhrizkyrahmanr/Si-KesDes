import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sikesdes/utils/config.dart';

class LoginService{
  login(String username, String password) async {
    var url = Uri.parse("$API/login");
    try{
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          },
          body: jsonEncode(<String, String>{
            'username': username,
            'password': password,
          }));
      var responseJson = jsonDecode(response.body);
      if(response.statusCode == 200) {
        return responseJson;
      }else if(response.statusCode == 401){
        return 1;
      }else{
        return 0;
      }
    } on Exception catch (_) {
      return 0;
    }
  }
}