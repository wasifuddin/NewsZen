import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;

  void _validateLogin() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      if (email == "user@example.com" && password == "password") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Login Successful!"),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid credentials"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/newszen_logo_small.png',
                width: 300,
              ),
              Container(
                width: 330, // Set the desired width
                height: 60, // Set the desired height
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                        r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z]+$")
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),

              Container(
                width: 330, // Set the desired width
                height: 60, // Set the desired height
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // Set the desired border radius
                      borderSide: BorderSide(color: Colors.grey), // Border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // Same radius for the enabled border
                      borderSide: BorderSide(color: Colors.grey, width: 1), // Border color when enabled
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // Same radius for the focused border
                      borderSide: BorderSide(color: Colors.blue, width: 2), // Border color when focused
                    ),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: 30),

              ElevatedButton(
                onPressed: _validateLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Background color
                  foregroundColor: Colors.white, // Text color
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
                  child: Text('Login', style: TextStyle(fontSize: 18)),
                ),
              ),

              SizedBox(height: 30),
              Container(
                width: 200, // Set the desired width of the divider
                child: Divider(
                  thickness: 1, // Thickness of the line
                  color: Colors.grey, // Color of the line
                  height: 20, // Space above and below the line
                ),
              ),

              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                },
                child: Text(
                  'Don\'t have an account? ',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Text(
                'Sign up!',
                style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline), // Blue color and underline to mimic hyperlink
              ),

              SizedBox(height: 40),
            ],
          ),
        ),
      ),
      ),
    );
  }
}