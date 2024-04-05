import 'package:flutter/material.dart';
import 'package:utangq_app/domain/entities/login_user.dart'; // Import the LoginUser class
import 'package:utangq_app/domain/entities/user_create.dart';
import 'package:utangq_app/domain/usecases/login_user.dart'; // Import the LoginUserUseCase class
import 'package:utangq_app/domain/usecases/register_user.dart';
import 'package:utangq_app/presentation/pages/login_page.dart';
import 'package:utangq_app/presentation/pages/users_page.dart'; // Import the UsersPage

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userFullNameController = TextEditingController();
  final TextEditingController _userPhoneNumberController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String userName = _usernameController.text;
    String userPassword = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String userEmail = _userEmailController.text;
    String userFullName = _userFullNameController.text;
    String userPhoneNumber = _userPhoneNumberController.text;

    var userCreate = UserCreate(
        username: userName,
        userPassword: userPassword,
        userConfirmPassword: confirmPassword,
        userEmail: userEmail,
        userFullName: userFullName,
        userPhoneNumber: userPhoneNumber
    );

    try {
      bool registrationResult = await Register().execute(userCreate);
      // Login successful, navigate to UsersPage
      if (registrationResult) {
        // Registration successful, navigate to LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        // Registration failed, show error message
        setState(() {
          _errorMessage = 'Failed to register user';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to register user: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 400,
                    height: 300,
                    child: Image.asset('asset/images/register.jpg'),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Register',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0, // Adjust the font size as needed
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter your username.'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your password.'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'Enter your password again.'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: _userEmailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter your email.'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: _userFullNameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Full Name',
                  hintText: 'Enter your full name.'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 15, bottom: 0),
            child: TextField(
              controller: _userPhoneNumberController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number.'),
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to RegisterPage
              );
            },
            child: Text(
              'Already have an account? Login here',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
