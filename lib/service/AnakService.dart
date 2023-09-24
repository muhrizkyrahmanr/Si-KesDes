import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sikesdes/utils/config.dart';

class AnakService{
  getAnak(String nik) async {
    var url = Uri.parse("$API/anak/$nik");
    print(url);
    try{
      final response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });
      var responseJson = jsonDecode(response.body);
      if(response.statusCode == 200) {
        return responseJson;
      }else if (response.statusCode == 404){
        return 1;
      }else{
        return 0;
      }
    } on Exception catch (_) {
      return 0;
    }
  }
}