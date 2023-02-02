import 'package:flutter/material.dart';
import 'package:local_database/screens/base_page.dart';
import 'package:local_database/screens/homepage.dart';
import 'package:local_database/utils/common_util.dart';
import 'package:local_database/utils/validators.dart';
import '../models/user.dart';
import '../services/database_helper.dart';
import '../widgets/redCommonButtonCurved.dart';

class LoginScreen extends BasePage {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BasePageState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordObscure = true;
  final focusPassword = FocusNode();
  bool _rememberMeCheckBox = false;

  late int userId;
  List<User>? _userData;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    checkLoginStatus();
  }

  checkLoginStatus() async {
    _userData = await DatabaseHelper.getUserData();

    if (_userData != null) {
      debugPrint("user exists");

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const HomePage();
          },
        ),
      );
    } else {
      _isLoading = false;
      debugPrint("new user");
    }

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    //hideLoadingDialogue();

    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.06,
                    right: MediaQuery.of(context).size.width * 0.06),
                child: Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.09),
                          const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          const Text(
                            "Welcome back. Enter your credentials to access your account",
                            // style: AppTextStyles.mediumTextSubtitleSilver,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          const Text(
                            "Email Address",
                            //style: AppTextStyles.textFieldTitleWhite,
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          _textFormField(_emailController,
                              TextInputType.emailAddress, TextInputAction.next),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Password",
                                // style: AppTextStyles.textFieldTitleWhite,
                              ),
                              InkWell(
                                child: const Text(
                                  "Forgot Password",
                                  //style: AppTextStyles.textFieldTitle2,
                                ),
                                onTap: () {},
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          _textFormField(
                              _passwordController,
                              TextInputType.visiblePassword,
                              TextInputAction.done),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                    side: const BorderSide(
                                      color: Colors.black,
                                    ),
                                    value: _rememberMeCheckBox,
                                    checkColor: Colors.white,
                                    activeColor: Colors.blue,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _rememberMeCheckBox =
                                            !_rememberMeCheckBox;
                                      });
                                    }),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02),
                              const Expanded(
                                child: Text(
                                  "Keep me signed in",
                                  //style: AppTextStyles.mediumTextSubtitleGrey12
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          CommonButtonCurved(
                              text: "Login",
                              fn: loginAction,
                              color: Colors.blue,
                              borderColor: Colors.blue,
                              textcolor: Colors.white,
                              curving: false),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          /*     Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: AppTextStyles.mediumTextSubtitleGrey12,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Sign Up",
                              style: AppTextStyles.mediumTextRedBold,
                            ),
                          ),
                        ],
                      ),*/
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  loginAction() async {
    CommonUtil().keyboardHide(context);
    if (_formKey.currentState!.validate()) {
      //showLoadingDialogue();

      ///String date = DateFormat('dd/MM/yyyy').format(DateTime.now());

      final User model = User(userName: _emailController.text, isLogged: 1);
      debugPrint(model.toString());

      //await DatabaseHelper.deleteUser();
      await DatabaseHelper.addUser(model);

      debugPrint(model.toString());

      hideLoadingDialogue();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return const HomePage();
      }));
    }
  }

  Widget _textFormField(TextEditingController controller,
      TextInputType inputType, TextInputAction inputAction) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      keyboardType: inputType,
      onChanged: (val) {},
      obscureText: inputType == TextInputType.visiblePassword
          ? _isPasswordObscure
              ? true
              : false
          : false,
      textInputAction: inputAction,
      maxLines: 1,
      validator: (value) {
        if (inputType == TextInputType.emailAddress) {
          return Validator.validateEmail(value!);
        } else {
          return Validator.validatePassword(value!);
        }
      },
      autofocus: false,
      decoration: InputDecoration(
        //errorStyle: AppTextStyles.textFieldErrorStyle,
        contentPadding: const EdgeInsets.all(15),
        suffixIcon: inputType == TextInputType.visiblePassword
            ? InkWell(
                onTap: () {
                  setState(() {
                    _isPasswordObscure = !_isPasswordObscure;
                  });
                },
                child: Icon(
                  _isPasswordObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                ))
            : null,
        errorMaxLines: 3,
        counterText: "",
        filled: true,
        fillColor: Colors.white,
        disabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 1, color: Colors.blue),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(
              width: 1,
              color: Colors.red,
            )),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
