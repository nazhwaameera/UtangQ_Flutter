import 'package:flutter/material.dart';
import 'package:utangq_app/domain/entities/login_user.dart'; // Import the LoginUser class
import 'package:utangq_app/domain/usecases/login_user.dart'; // Import the LoginUserUseCase class
import 'package:utangq_app/presentation/pages/register_page.dart';
import 'package:utangq_app/presentation/pages/users_page.dart'; // Import the UsersPage

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    try {
      LoginUser loginUser = await Login().execute(username, password);
      // Login successful, navigate to UsersPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => UserListPage(userId: loginUser.userId ?? 0,)), // Navigate to UsersPage
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to login: $e';
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
                    child: Image.asset('asset/images/login.jpg'),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Login',
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
                onPressed: _isLoading ? null : _login,
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
                        'Sign In',
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
                MaterialPageRoute(builder: (context) => RegisterPage()), // Navigate to RegisterPage
              );
            },
            child: Text(
              'Don\'t have an account? Register here',
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
