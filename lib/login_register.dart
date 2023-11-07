import 'package:flutter/material.dart';
import 'register.dart';
import 'request.dart';
import 'screens/home_screen.dart';
import 'alert.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKeyLogin = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Alerts.setContext(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login/Register'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white, // Set the background color to white
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to My Store',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Form(
                    key: _formKeyLogin,
                    // padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'PAN Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your PAN number';
                            }
                            return null; // Return null if the input is valid
                          },
                        ),
                        const SizedBox(height: 16.0),
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
                            return null; // Return null if the input is valid
                          },
                        ),
                        const SizedBox(height: 16.0),
                        ButtonTheme(
                          minWidth: double.infinity, // Set a fixed button width
                          height: 80.0, // Set a fixed button height
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              _formKeyLogin.currentState!.save();
                              if(_formKeyLogin.currentState!.validate()){
                                final data = {
                                  'username': usernameController.text,
                                  'password': passwordController.text,
                                };
                                Map<String, dynamic> response = await Requests.login(data);
                                if(response["status"] == true) {
                                  Alerts.showSuccess(response["messages"]["success"]);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeScreen()),
                                  );
                                }
                                else{
                                  Alerts.showError(response["messages"]["error"]);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: Size.fromHeight(40),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegisterPage()), // Navigate to RegisterPage
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size.fromHeight(40),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () {
                      // Add code to handle the "Forgot Password" functionality here
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Forgot Password'),
                            content: const Text('Enter your email to reset your password.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Implement password reset logic here
                                  // Send a password reset email or navigate to a reset password screen
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Reset Password'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.green, // Set text color to blue
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
