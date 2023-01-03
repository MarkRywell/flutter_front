import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_front/models/api.dart';
import 'package:flutter_front/models/api_response.dart';
import 'package:flutter_front/views/navigated_pages/main_page.dart';
import 'package:flutter_front/views/auth/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert' as convert;

class LoginPage extends StatefulWidget {

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String email = "";
  String password = "";

  bool validate(String email, String password){     // Validate if email is valid
    if(email.isEmpty || password.isEmpty) {
      return false;
    }
    else if(EmailValidator.validate(email, true)){
      return true;
    }
    else {
      return false;
    }
  }

  showStatus({required Color color, required String text}) {    // Snackbar to show message of API Response

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(text),
            backgroundColor: color,
            padding: const EdgeInsets.all(15),
            behavior: SnackBarBehavior.fixed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            )
        )
    );
  }


  login(context) async {    //  Login function to attempt Authentication and set Shared Preferences

    if(!formKey.currentState!.validate()){
      return;
    }

    Map credentials = {
      'email' : emailController.text,
      'password' : passwordController.text
    };

    print(credentials);

    var connectivity = await Connectivity().checkConnectivity();
    print(connectivity);

    if(connectivity == ConnectivityResult.none) {
      showStatus(color: Colors.red, text: "No Internet Connection");
      return;
    }

    var response = await Api.instance.loginUser(credentials);  // Call API Method

    if(response.runtimeType != List<Object>){
      if(response.statusCode == 500){
        showStatus(color: Colors.red, text: response.body);
        return;
      }
    }

    if(response[1] != 200){
      showStatus(color: Colors.red, text: response[0].message);
      return;
    }

    preferences(response[0]);
  }

  preferences(ApiResponse response) async {

    final pref = await SharedPreferences.getInstance();
    pref.setString("token", response.data!['token']);
    pref.setString("user", convert.jsonEncode(response.data!['user']));
    pref.setBool("loggedIn", true);

    String? data = pref.getString("user");
    print(data);

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(
          builder: (context) => const MainPage()
        ), (route) => false);
  }

  @override
  void dispose() {
    emailController;
    passwordController;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
            padding: const EdgeInsets.only(top: 180, left: 40, right: 40),
            child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Image.asset('assets/OnlySells1.png'),
                      Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 10, left: 5),
                        child: Row(
                          children: const [
                            Text("Log in",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              prefixIcon: const Icon(Icons.email_rounded),
                              hintText: "Email"
                          ),
                          onChanged: (value) {
                            return value.isEmpty ?
                            "The Email field is required" : setState(() {
                              email = value;
                            });
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            prefixIcon: const Icon(Icons.lock),
                            hintText: "Password",
                          ),
                          onChanged: (value) {
                            return value.isEmpty ?
                            "The Password field is required" : setState(() {
                              password = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: size.width * 0.8,
                          height: 40,
                          child: ElevatedButton(
                              onPressed: validate(email, password) ? () => login(context) : null,
                              child: const Text("LOG IN",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600
                                ),)),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()));
                          },
                          child: const Text("Sign Up for Only Sells"))
                    ],
                  ),
                )
            )
        )
    );
  }
}
