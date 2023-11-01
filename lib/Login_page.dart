import 'package:flutter/material.dart';
import 'package:sikesdes/Anak_page.dart';
import 'package:sikesdes/service/LoginService.dart';
import 'package:sikesdes/utils/colors.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback login;
  const LoginPage({Key? key, required this.login}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contollerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  late bool _showPassword = true;
  late bool _isLoading = false;

  late bool _validUsername = true;
  late bool _validPassword = true;

  String? _version;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 16,right: 16),
      child: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("LOGIN",style: TextStyle(fontSize: 18, color: primaryColor, fontWeight: FontWeight.bold),),
              Text("untuk melanjutkan!",style: TextStyle(fontSize: 15, color: primaryColor)),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  color: Colors.white.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: _contollerUsername,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.account_circle_outlined,
                        color: _validUsername ? primaryColor : Colors.red,
                        size: 20,
                      ),
                      labelText: 'Username',
                      labelStyle: TextStyle(fontSize: 13,
                          color: _validUsername ? null : Colors.red
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _validUsername = false;
                        });
                      }else{
                        setState(() {
                          _validUsername = true;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Card(
                  color: Colors.white.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: _controllerPassword,
                    obscureText: _showPassword,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Password",
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: _validPassword ? primaryColor : Colors.red,
                        size: 20,
                      ),
                      labelStyle: TextStyle(fontSize: 13,
                        color: _validPassword ? null : Colors.red,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: togglePasswordVisibility,
                        child: _showPassword
                            ? Icon(
                          Icons.visibility_off,
                          color: _validPassword ? primaryColor : Colors.red,
                          size: 20,
                        )
                            : Icon(
                          Icons.visibility,
                          color: _validPassword ? primaryColor : Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        setState(() {
                          _validPassword = false;
                        });
                      }else{
                        setState(() {
                          _validPassword = true;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height: 15),
                Card(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onTap: (){
                      if (!_isLoading) {
                        if (_formKey.currentState!.validate()) {
                          if(!_contollerUsername.text.isEmpty && !_controllerPassword.text.isEmpty){
                            showAlertDialogLoading(context);
                            login();
                          }
                        }
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (context){
                      //   return AppScreen();
                      // }))
                    },
                    child: Container(
                      height: 45,
                      child: Center(
                        child: Text(
                          'Masuk',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            alignment: Alignment.bottomCenter,
            child: Text(
              "v1.0.0",
              style: const TextStyle(fontSize: 12, color: primaryColor),
            ),
          )
        ],
      ),
    );
  }

  void togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  login() async{
    var loginService = await LoginService().login(_contollerUsername.text, _controllerPassword.text);
    FocusManager.instance.primaryFocus?.unfocus();
    if(loginService == 1 || loginService == 0){
      Navigator.pop(context);
      if(loginService == 1){
        showMessage("Username atau Password salah");
      }else{
        showMessage("Gagal Terhubung Keserver");
      }
    }else{
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("access_token", loginService['auth']['token']);
      await preferences.setString("nama", loginService['user']['nama']);
      await preferences.setString("username", loginService['user']['username']);
      await preferences.setString("role", loginService['user']['role']);
      Navigator.pop(context);
      print("Berhasil");
      widget.login();
    }
  }

  showMessage(String text) async{
    await Future.delayed(Duration(seconds: 0));
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      confirmBtnColor: primaryColor,
      title: "Gagal",
      text: '${text}',
    );
  }

  showAlertDialogLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: primaryColor,
          ),
          Container(
              margin: const EdgeInsets.only(left: 15),
              child: const Text(
                "Loading...",
                style: const TextStyle(fontFamily: 'poppins'),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: alert,
        );
      },
    );
  }
}
