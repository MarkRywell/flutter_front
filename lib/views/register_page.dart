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
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerConfirmPassword = TextEditingController();

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
              onStepTapped: (step) => tapped(step),
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
                          controller: firstName,
                          maxLines: 1,
                          decoration: const InputDecoration(
                              hintText: 'e.x John ',
                              labelText: 'First Name',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
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
                          controller: lastName,
                          maxLines: 1,
                          decoration: const InputDecoration(
                              hintText: 'e.x Cruz',
                              labelText: 'Last Name',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0.75,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ))),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return (value == '')
                                ? "Please Enter your Last Name"
                                : null;
                          },
                        ),
                      ),
                      TextFormField(
                        controller: middleName,
                        maxLines: 1,
                        decoration: const InputDecoration(
                            hintText: 'e.x Dela',
                            labelText: 'Middle Name',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.75,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ))),
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
                            controller: controllerAddress,
                            maxLines: 1,
                            keyboardType: TextInputType.streetAddress,
                            decoration: const InputDecoration(
                                hintText: 'e.x Lapasan',
                                labelText: 'Address',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
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
                            controller: controllerEmail,
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                hintText: 'e.x Juan@gmail.com ',
                                labelText: 'Email Address',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
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
                          controller: controllerPassword,
                          obscureText: passwordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.75,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                )),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return (value == '')
                                ? "Please enter your Password"
                                : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: TextFormField(
                          controller: controllerConfirmPassword,
                          obscureText: passwordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0.75,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                )),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return (value != controllerPassword.text)
                                ? "Password not match"
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
                              child: Text("First Name: ${firstName.text}",
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
                              child: Text("Last Name: ${lastName.text}",
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
                              child: Text("Middle Name: ${middleName.text}",
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
                              child: Text("Address: ${controllerAddress.text}",
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
                                  "Email Address: ${controllerEmail.text}",
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

  tapped(int step) {
    setState(() => _currentStep = step);
  }


  continued() {

    if(_currentStep == 0) {
      if(firstName.text.isEmpty || lastName.text.isEmpty || middleName.text.isEmpty) {
        return null;
      }
    }
    else if(_currentStep == 1) {
      if(controllerAddress.text.isEmpty) {
        return null;
      }
    }
    else if(_currentStep == 2) {
      if(controllerEmail.text.isEmpty) {
        return null;
      }
    }
    else if(_currentStep == 3) {
      if(controllerPassword.text.isEmpty || controllerConfirmPassword.text.isEmpty || controllerPassword.text != controllerConfirmPassword.text) {
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
