import 'package:flutter/material.dart';
import 'package:sikesdes/Anak_page.dart';
import 'package:sikesdes/utils/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                if(_validUsername == false)...[
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text("Username masih kosong", style: TextStyle(fontSize: 13, color: Colors.red),),
                  )
                ],
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
                if(_validPassword == false)...[
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text("Password masih kosong", style: TextStyle(fontSize: 13, color: Colors.red),),
                  )
                ],
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnakPage()
                                )
                            );
                          }
                        }
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (context){
                      //   return AppScreen();
                      // }))
                    },
                    child: Container(
                      height: 48,
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
}
