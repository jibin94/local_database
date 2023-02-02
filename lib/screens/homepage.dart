import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_database/models/user.dart';
import 'package:local_database/screens/login_screen.dart';
import 'package:local_database/services/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _userData = await DatabaseHelper.getUserData();

    print(_userData![0].userName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("User Home"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () async {
                  await DatabaseHelper.deleteUser();
                  Fluttertoast.showToast(msg: "Logged out successfully");
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const LoginScreen();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.logout)),
          )
        ],
      ),
      body: Center(
        child: _userData != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textWidget("User Id", _userData![0].id.toString()),
                  textWidget("User email", _userData![0].userName),
                ],
              )
            : const Center(
                child: Text("no data available"),
              ),
      ),
    );
  }

  Widget textWidget(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10),
      child: Text("$key : $value"),
    );
  }
}
