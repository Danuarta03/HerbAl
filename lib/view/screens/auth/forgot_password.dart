import 'package:flutter/material.dart';
import 'package:herbal/view/screens/auth/login.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ValueNotifier<bool> _isObscure = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: [
                ClipPath(
                  clipper: GreenClipper(),
                  child: Container(
                    color: Color.fromRGBO(6, 132, 0, 1),
                    height: 250,
                    alignment: Alignment.center,
                    child: Text(
                      "Lupa Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 10,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.chevron_left, color: Colors.white),
                    iconSize: 40,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    "Buatlah password baru kuat dengan minimal 8 karakter dengan huruf kapital dan karakter unik",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isObscure,
                    builder: (context, value, child) {
                      return TextField(
                        obscureText: value,
                        decoration: InputDecoration(
                          labelText: "Password Baru",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _isObscure.value = !_isObscure.value;
                            },
                            icon: Icon(
                              value ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isObscure,
                    builder: (context, value, child) {
                      return TextField(
                        obscureText: value,
                        decoration: InputDecoration(
                          labelText: "Konfirmasi Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _isObscure.value = !_isObscure.value;
                            },
                            icon: Icon(
                              value ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: () {},
                    color: Color.fromRGBO(6, 132, 0, 1),
                    minWidth: double.infinity,
                    height: 50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Ubah Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Login disini",
                      style: TextStyle(
                        color: Color.fromRGBO(6, 132, 0, 1),
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          // Implement Google sign-in
                        },
                        child: Image.asset(
                          'assets/google.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      SizedBox(width: 20.0),
                      InkWell(
                        onTap: () {
                          // Implement Facebook sign-in
                        },
                        child: Image.asset(
                          'assets/facebook.png',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GreenClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

