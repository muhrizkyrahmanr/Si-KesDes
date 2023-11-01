import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sikesdes/service/Model/Anak_model.dart';
import 'package:sikesdes/service/Model/Perkembangan_model.dart';
import 'package:sikesdes/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  getPerkembangan(String nik) async{
    var url = Uri.parse("$API/listperkembangan/${nik}");
    print(url);
    try{
      final response = await http.get(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });
      if (response.statusCode == 200) {
        var responseJson = jsonDecode(response.body);
        List<dynamic> data = responseJson;
        print(data);
        if (data.length > 0) {
          return data.map((p) => PerkembanganModel.fromJson(p)).toList();
        } else {
          return [];
        }
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }

  getListAnak() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url = Uri.parse("$API/listanak");
    print(url);
    try{
      final response = await http.get(url,
          headers: <String, String>{
            'Authorization': 'Bearer '+preferences.getString("access_token")!,
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          });
      var responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var data = responseJson;
        if (data.length > 0) {
          return data.map((p) => AnakModel.fromJson(p)).toList();
        } else {
          return [];
        }
      } else if(response.statusCode == 401){
        return 401;
      } else {
        return;
      }
    } on Exception catch (_) {
      return;
    }
  }

  tambahAnak(String nik, String nama, String jeniskelamin, String tanggallahir, String nokeluarga, String namaorangtua, String beratbadan, String tinggibadan) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url = Uri.parse("$API/tambahanak");
    print(url);
    try{
      final response = await http.post(url,
          headers: <String, String>{
            'Authorization': 'Bearer '+preferences.getString("access_token")!,
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          },
          body: jsonEncode(<String, String>{
            'nik': nik,
            'nama': nama,
            'jenis_kelamin': jeniskelamin,
            'tanggal_lahir': tanggallahir,
            'nik_keluarga': nokeluarga,
            'nama_orang_tua': namaorangtua,
            'berat_badan': beratbadan,
            'tinggi_badan': tinggibadan
          }));
      var responseJson = jsonDecode(response.body);
      if(response.statusCode == 201) {
        return 1;
      }else if(response.statusCode == 400){
        return 2;
      }else if(response.statusCode == 401){
        return 3;
      }else{
        return 0;
      }
    } on Exception catch (_) {
      return 0;
    }
  }

  deleteAnak(String nik) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url = Uri.parse("$API/hapusanak/${nik}");
    print(url);
    try{
      final response = await http.delete(url,
          headers: <String, String>{
            'Authorization': 'Bearer '+preferences.getString("access_token")!,
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          },
      );
      if(response.statusCode == 200){
        return 1;
      }else if(response.statusCode == 404) {
        return 2;
      }else if(response.statusCode == 401){
        return 3;
      }else{
        return 0;
      }
    } on Exception catch (e) {
      return 0;
    }
  }

  tambahPerkembangan(String nik, String tanggal, String beratbadan, String tinggibadan) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url = Uri.parse("$API/tambahperkembangan");
    print(url);
    try{
      final response = await http.post(url,
          headers: <String, String>{
            'Authorization': 'Bearer '+preferences.getString("access_token")!,
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          },
          body: jsonEncode(<String, String>{
            'nik': nik,
            'berat_badan': beratbadan,
            'tinggi_badan': tinggibadan,
            'tanggal': tanggal,
          }));
      var responseJson = jsonDecode(response.body);
      if(response.statusCode == 201) {
        return 1;
      }else if(response.statusCode == 400){
        return 2;
      }else if(response.statusCode == 401){
        return 3;
      }else{
        return 0;
      }
    } on Exception catch (_) {
      return 0;
    }
  }

  deletePerkembangan(String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var url = Uri.parse("$API/hapusperkembangan/${id}");
    print(url);
    try{
      final response = await http.delete(url,
        headers: <String, String>{
          'Authorization': 'Bearer '+preferences.getString("access_token")!,
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
      );
      if(response.statusCode == 200){
        return 1;
      }else if(response.statusCode == 404) {
        return 2;
      }else if(response.statusCode == 401){
        return 3;
      }else{
        return 0;
      }
    } on Exception catch (e) {
      return 0;
    }
  }
}