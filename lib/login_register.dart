import 'package:flutter/material.dart';
import 'register.dart';
import 'screens/home_screen.dart';

final FocusNode _emailFocus = FocusNode();
final FocusNode _passwordFocus = FocusNode();

class LoginRegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login/Register'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white, // Set the background color to white
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to My Store',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                focusNode: _emailFocus,
                decoration: InputDecoration(
                  labelText: 'PAN Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                focusNode: _passwordFocus,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomeScreen(),
                      ),
                    );
                  });
                  _emailFocus.unfocus();
                  _passwordFocus.unfocus();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Change button color to green
                  elevation: 5, // Add elevation to the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  minimumSize: Size(200, 50), // Set button size
                ),
                child: Text(
                  'Sign-In',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => RegisterPage(),
                      ),
                    );
                  });
                  _emailFocus.unfocus();
                  _passwordFocus.unfocus();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Change button color to green
                  elevation: 5, // Add elevation to the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  minimumSize: Size(200, 50), // Set button size
                ),
                child: Text(
                  'Sign-Up',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // Add code to handle the "Forgot Password" functionality here
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Forgot Password'),
                        content: Text('Enter your email to reset your password.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Implement password reset logic here
                              // Send a password reset email or navigate to a reset password screen
                              Navigator.of(context).pop();
                            },
                            child: Text('Reset Password'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
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
    );
  }
}
