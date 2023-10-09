import 'package:flutter/material.dart';
import 'login_register.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Define controllers for text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController PANnumbercontroller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginRegisterPage(),
                ),
              );
            });// Navigate back to the previous screen/page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(" Store Name", nameController),
            SizedBox(height: 10),
            _buildTextField("PAN Number", PANnumbercontroller),
            SizedBox(height: 10),
            _buildTextField("Password", passwordController),
            SizedBox(height: 10),
            _buildTextField("Confirm Password", confirmPasswordController),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Handle registration logic here
                print("Registration button pressed.");
                FocusScope.of(context).unfocus();
                Future.delayed(Duration(seconds: 4), () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginRegisterPage(),
                    ),
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Set button background color to green
              ),
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
