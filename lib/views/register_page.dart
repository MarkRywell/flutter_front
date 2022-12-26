import 'package:flutter/material.dart';

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
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
                          decoration: const InputDecoration(
                              hintText: 'First Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 0.75,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ))),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return (value == '')
                                ? "Please Enter your First Name"
                                : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextFormField(
                          controller: lastNameController,
                          maxLines: 1,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
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
                        decoration: const InputDecoration(
                            hintText: 'Middle Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 0.75,
                                ),
                                )),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return (value == '')
                              ? "Please enter your Middle Name"
                              : null;
                        },
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0
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
                            decoration: const InputDecoration(
                                hintText: 'Address',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 0.75,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ))),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return (value == '')
                                  ? "Please enter your Address"
                                  : null;
                            },
                          ))
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 1
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
                            decoration: const InputDecoration(
                                hintText: 'Email Address',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 0.75,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ))),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return (value == '')
                                  ? "Please enter your Email Address"
                                  : null;
                            },
                          ))
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 1
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
                          decoration: const InputDecoration(
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
                          decoration: const InputDecoration(
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
                  state: _currentStep >= 2
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
                                child: Divider(
                                  thickness: 2,
                                )),
                          ],
                        )),
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 3
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

  continued() {
    if (_currentStep == 0) {
      if (firstNameController.text.isEmpty ||
          lastNameController.text.isEmpty ||
          middleNameController.text.isEmpty) {
        return null;
      }
    } else if (_currentStep == 1) {
      if (addressController.text.isEmpty) {
        return _currentStep == 1;
      }
    } else if (_currentStep == 2) {
      if (emailAddressController.text.isEmpty) {
        return _currentStep == 2;
      }
    } else if (_currentStep == 3) {
      if (passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty ||
          passwordController.text != confirmPasswordController.text) {
        return null;
      }
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
