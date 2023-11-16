import 'package:flutter/material.dart';
import 'alert.dart';
import 'login_screen.dart';
import 'request.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKeyRegister = GlobalKey<FormState>();
  // Define controllers for text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register your Store'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Future.delayed(const Duration(seconds: 0), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginRegisterPage(),
                ),
              );
            });// Navigate back to the previous screen/page
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKeyRegister,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Store Name',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Store Name';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: panNumberController,
                      decoration: const InputDecoration(
                        labelText: 'PAN Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your PAN number';
                        }
                        // if (value )
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Email address';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Phone number';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Password';
                        }
                        if (value .length < 6) {
                          return 'Minimum length of password is 6';
                        }
                        if (value != confirmPasswordController.text) {
                          return 'Passwords are not same';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm your password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Password';
                        }
                        if (value .length < 6) {
                          return 'Minimum length of password is 6';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords are not same';
                        }
                        return null; // Return null if the input is valid
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        // Handle registration logic here
                        print("Registration button pressed.");
                        FocusScope.of(context).unfocus();
                        _formKeyRegister.currentState!.save();
                        if(_formKeyRegister.currentState!.validate()) {
                          final data = {
                            'username': panNumberController.text,
                            'display_name': nameController.text,
                            'email': emailController.text,
                            'phone_number': phoneNumberController.text,
                            'password': passwordController.text,
                          };
                          Map<String, dynamic> response = await Requests.register(data);
                          if(response["status"] == true) {
                            Alerts.showSuccess("Please continue to Login with the store (${panNumberController.text}) you just registered with!");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginRegisterPage()),
                            );
                          }
                          else{
                            Alerts.showError(response["messages"]["error"]);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // Set button background color to green
                      ),
                      child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18.0,
                          )
                      ),
                    ),
                  ],
                ),
              )
            ),
          )
        )
      ),
    );
  }
}
