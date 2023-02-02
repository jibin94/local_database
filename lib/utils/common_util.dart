import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


enum DeviceCategory { Phone, Tablet }

class CommonUtil {
  factory CommonUtil() {
    return _singleton;
  }

  static final CommonUtil _singleton = CommonUtil._internal();
  CommonUtil._internal() {
    debugPrint("Instance created CommonUtil");
  }

  void keyboardHide(BuildContext context) {
    try {
      // keyboard on the screen
      FocusScope.of(context)
          .requestFocus(FocusNode()); // not refocus to textview
      /// hides the keyboard if its already open
      //FocusScope.of(context).unfocus();  //  refocus to textview
    } catch (e) {}
  }



  DeviceCategory getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
    return data.size.shortestSide < 600
        ? DeviceCategory.Phone
        : DeviceCategory.Tablet;
  }

  /// accepts a double [scale] and returns scaled sized based on the screen
  /// orientation
  double getScaledSize(BuildContext context, double scale) =>
      scale *
      (MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.height);

  /// accepts a double [scale] and returns scaled sized based on the screen
  /// width
  double getScaledWidth(BuildContext context, double scale) =>
      scale * MediaQuery.of(context).size.width;

  /// accepts a double [scale] and returns scaled sized based on the screen
  /// height

  double getScaledHeight(BuildContext context, double scale) =>
      scale * MediaQuery.of(context).size.height;


  Future<bool?> exitDialog(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String message,
        String? positiveButtonText,
        String? negativeButtonText,
        Color? negativeTint,
        Color? positiveTint,
        Function? logout,
        bool? isAppExit,
      }) {
    return showGeneralDialog(
        barrierColor:
        Colors.black.withOpacity(0.7),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.translate(
            child: Opacity(
              opacity: a1.value,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 50,
                          right: 50,
                          top: 30,
                          bottom: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.2),
                              blurRadius: 5,
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ClipPath(
                              clipper: ClipArcBottom(),
                              child: Container(
                                decoration: const BoxDecoration(
                                  //color: AppColors.reddenGradient,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10),
                                  ),
                                ),
                                height: 80,
                                width: double.maxFinite,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[

                                    icon==null? Container(): const Icon(Icons.exit_to_app,color: Colors.white,),

                                    Flexible(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(left: 10),
                                        child: Text(
                                          title,
                                          textScaleFactor: 1.2,
                                          //style: AppTextStyles.smallMediumTextWhiteBold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                message,
                                //style: AppTextStyles.smallMediumTextBlackBold,
                                textAlign: TextAlign.center,
                                textScaleFactor: 1,
                              ),
                            ),
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),

                                      child: Text(
                                          negativeButtonText ?? "Cancel",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textScaleFactor:1,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton(

                                      onPressed: () {

                                        if(isAppExit!){

                                          debugPrint("app exited");
                                          SystemNavigator.pop();

                                        }else{
                                          Navigator.pop(context, true);
                                        }
                                      },
                                      child: Text(
                                          positiveButtonText ?? "Submit",
                                          maxLines: 1,
                                          textScaleFactor:1,
                                          overflow: TextOverflow.ellipsis,
                                          //style: AppTextStyles.smallMediumTextRedBold
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            offset: Offset(0, 200 - (a1.value * 200)),
          );
        },
        transitionDuration: const Duration(milliseconds: 150),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) => Container()

    );
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }


  goToHomePage(context){
    /*Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const EmergencyRequests(),
        ),
            (Route<dynamic> route) => false);*/
  }
}

class ClipArcBottom extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 1.5);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 1.2,
      0,
      size.height / 1.5,
    );
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
