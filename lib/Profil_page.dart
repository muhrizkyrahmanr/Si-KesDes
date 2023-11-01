import 'package:flutter/material.dart';
import 'package:sikesdes/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPage extends StatefulWidget {
  final VoidCallback login;
  const ProfilPage({Key? key, required this.login}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String? nama, role, username;

  getUser() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nama = preferences.getString("nama");
      if(preferences.getString("role") == "desa"){
        role = "User Desa";
      }else{
        role = "User Admin";
      }
      username = preferences.getString("username");
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: ListView(
              children: [
                Stack(
                  children: [
                    buildHeader(),
                    buildBody(),
                  ],
                )
              ]
          ),
        )
    );
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.only(left: 18, right: 18),
      color: primaryColor,
      height: 200.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 12.0,
            width: double.infinity,
          ),
          const SizedBox(
            height: 12.0,
          ),
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: ExactAssetImage(
              'assets/profile.jpg',
            ),
            radius: 26,
          ),
          const SizedBox(
            height: 12.0,
          ),
          Text(
              "${nama}",
              style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w600)
          ),
          Text("${role}",
            style: TextStyle(fontSize: 15.0, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.only(left: 18, right: 18, top: 200),
      child: Column(
        children: [
          cardUsername(),
          buttonLogout()
        ],
      ),
    );
  }

  Widget cardUsername() {
    return Container(
        width: double.infinity,
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 4),
        child: ListTile(
          title: const Text(
            "Username",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          subtitle: Text(
            '${username}',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        )
    );
  }

  Widget buttonLogout() {
    return Container(
        width: double.infinity,
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 4),
        child: GestureDetector(
          onTap: () {
            showAlertExit(context);
          },
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  ),
                ),
                Text(
                  "Logout",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.red),
                ),
              ],
            ),
          ),
        ));
  }

  showAlertExit(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Konfirmasi'),
            content: const Text('Anda yakin ingin Keluar ?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  )),
              TextButton(
                  onPressed: () {
                    signOut();
                  },
                  child: const Text('Ya'))
            ],
          );
        });
  }

  signOut() async {
    Navigator.pop(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    setState(() {
      widget.login();
    });
  }
}
