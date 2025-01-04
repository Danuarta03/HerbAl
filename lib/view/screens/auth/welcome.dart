import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herbal/view/screens/auth/login.dart';
import 'package:herbal/view/screens/auth/registrasi.dart';
import 'package:herbal/view/screens/home_screen.dart';


class WelcomeScreen extends StatefulWidget {
  static const routeName = '/WelcomeScreen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(initialTab: 0)),
      );
    }
  }

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
                    color: const Color.fromRGBO(6, 132, 0, 1),
                    height: 250,
                    alignment: Alignment.center,
                    child: const Text(
                      'Selamat Datang di',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 0),
                  Image.asset(
                    'assets/logonew.png',
                    width: 350,
                    height: 280,
                  ),
                  const SizedBox(height: 0),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          style: TextStyle(
                            fontSize: 35.0,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(6, 132, 0, 1),
                          ),
                        ),
                        TextSpan(
                          text: "\n\nJelajahi semua obat alami dari alam",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60.0),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          LoginScreen.routeName,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(6, 132, 0, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          minimumSize: const Size(150, 60),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          RegisterScreen.routeName,
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(6, 132, 0, 1),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color.fromRGBO(6, 132, 0, 1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          minimumSize: const Size(150, 60),
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
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
