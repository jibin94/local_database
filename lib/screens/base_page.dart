import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  var isLoading = false;
  //SharedPreferencesService? sharedPrefService;

  @override
  void initState() {
    super.initState();
    /** initialize session**/
    initSession();
  }

  void initSession() async {
/*    sharedPrefService = await SharedPreferencesService.instance;

    try {
      var route = ModalRoute.of(context)!.settings.name;
      debugPrint("***Base page-lock:####- $route");
      if (route != null) {
        sharedPrefService!
            .setStringSesssion(SharedPrefKeys.currentScreen, route);
      }
    } catch (e) {
      e.toString();
    }*/
  }

  //SharedPreferencesService? get sessionValues => sharedPrefService;

  void showLoadingDialogue() {
    Future.delayed(Duration.zero, () {
      if (!isLoading) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return loader;
            });
      }
      isLoading = true;
    });
  }

  void hideLoadingDialogue() {
    if (isLoading) {
      Navigator.of(context).pop();
    }
    isLoading = false;
  }

  static final loader = WillPopScope(
      // device back arrow press time did not hide the dialog
      onWillPop: () async => true,
      child: Center(
        child: AlertDialog(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          content: spinkitloader,
        ),
      ));

  static final spinkitloader = Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        // PouringHourGlass

        CircularProgressIndicator(
          color: Colors.blue,
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
