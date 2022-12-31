import 'package:flutter/material.dart';
import 'package:flutter_front/models/api.dart';
import 'package:flutter_front/views/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  bool passwordVisible = true;
  var formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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

  Future showSuccess() {
    return showDialog(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {

          return AlertDialog(
            title: const Center(child: Text("Successful Registration",
              style: TextStyle(
                color: Colors.green,
                fontSize: 20
                ),
              )
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            content: const Icon(Icons.check, size: 60, color: Colors.green),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              OutlinedButton(
                  onPressed: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
              },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    side: const BorderSide(width: 1.0, color: Colors.green),
                    fixedSize: const Size(120, 40),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  child: const Text("LOG IN")
              )
            ],
          );
        }
    );
  }

  registerUser(context) async {

    if(formKey.currentState!.validate()) {

      String fullName = "${firstNameController.text} "
          "${middleNameController.text} ${lastNameController.text}";

      Map credentials = {
        'name' : fullName,
        'contactNo' : contactNoController.text,
        'address' : addressController.text,
        'email' : emailAddressController.text,
        'password' : passwordController.text
      };

      var response = await Api.instance.registerUser(credentials);

      if(response.runtimeType != List<Object>){
        if(response.statusCode == 500){
          showStatus(color: Colors.red, text: response.body);
          return;
        }
      }

      if(response[1] != 201) {
        showStatus(color: Colors.red, text: response[0].message);
        return;
      }
      showSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.app_registration),
            Text("Registration Form")
          ],
        ),
      ),
      body: Column(children: [
        Form(
          key: formKey,
          child: Expanded(
            child: Stepper(
              type: stepperType,
              physics: const ScrollPhysics(),
              currentStep: _currentStep,
              onStepContinue: continued,
              onStepCancel: cancel,
              steps: <Step>[
                Step(
                  title: const Text('Account Name'),
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
                        child: TextFormField(
                          controller: firstNameController,
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: 'First Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 0.75,
                                  ),
                                  )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextFormField(
                          controller: lastNameController,
                          maxLines: 1,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                              hintText: 'Last Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 0.75,
                                  ),
                                  )),
                        ),
                      ),
                      TextFormField(
                        controller: middleNameController,
                        maxLines: 1,
                        decoration: InputDecoration(
                            hintText: 'Middle Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 0.75,
                                ),
                                )),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: const Text('Contact No.'),
                  content: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: TextFormField(
                            controller: contactNoController,
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Contact Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 0.75,
                                  ),
                                )),
                          ))
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 1
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: const Text('Address'),
                  content: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: TextFormField(
                            controller: addressController,
                            maxLines: 1,
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                                hintText: 'Address',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 0.75,
                                    ),
                                   )),
                          ))
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 2
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: const Text('Email Address'),
                  content: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: TextFormField(
                            controller: emailAddressController,
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintText: 'Email Address',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 0.75,
                                    ),
                                    )),
                          ))
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 3
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: const Text('Passwords'),
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                        child: TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: passwordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          maxLines: 1,

                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 0.75,
                                ),
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                        child: TextFormField(
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: passwordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          maxLines: 1,

                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 0.75,
                                ),
                                ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return (value != passwordController.text)
                                ? "Password not matched"
                                : null;
                          },
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 4
                      ? StepState.complete
                      : StepState.disabled,
                ),
                Step(
                  title: const Text('Confirmation'),
                  content: Card(
                    margin: const EdgeInsetsDirectional.only(start: 2),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  "First Name: ${firstNameController.text}",
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Divider(
                                  thickness: 2,
                                )),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  "Last Name: ${lastNameController.text}",
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Divider(
                                  thickness: 2,
                                )),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  "Middle Name: ${middleNameController.text}",
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Divider(
                                  thickness: 2,
                                )),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text("Contact Number: ${contactNoController.text}",
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Divider(
                                  thickness: 2,
                                )),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text("Address: ${addressController.text}",
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Divider(
                                  thickness: 2,
                                )),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  "Email Address: ${emailAddressController.text}",
                                  style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                ),
                          ],
                        )),
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 5
                      ? StepState.complete
                      : StepState.disabled,
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  continued() async {
    if (_currentStep == 0) {
      if (firstNameController.text.isEmpty ||
          lastNameController.text.isEmpty ||
          middleNameController.text.isEmpty) {
        return null;
      }
    } else if (_currentStep == 1) {
      if (contactNoController.text.isEmpty) {
        return null;
      }
    } else if (_currentStep == 2) {
      if (addressController.text.isEmpty) {
        return null;
      }
    } else if (_currentStep == 3) {
      if (emailAddressController.text.isEmpty) {
        return null;
      }
    } else if (_currentStep == 4) {
      if (passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty ||
          passwordController.text != confirmPasswordController.text) {
        return null;
      }
    } else if(_currentStep == 5) {
      await registerUser(context);
      return null;
      }

    setState(() {
      _currentStep += 1;
    });
    // _currentStep < 4 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
