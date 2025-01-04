import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:herbal/core/API/userApi.dart';
import 'package:herbal/core/providers/my_app_functions.dart';
import 'package:herbal/core/services/loading_manager.dart';
import 'package:herbal/core/services/validator.dart';
import 'package:herbal/core/utility/SharedPreferences.dart';
import 'package:herbal/root_screen.dart';
import 'package:herbal/view/screens/auth/forgot_password.dart';
import 'package:herbal/view/screens/auth/registrasi.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ValueNotifier<bool> _isObscure = ValueNotifier<bool>(true);
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
      _passwordController.dispose();
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _loginFct() async {
  final isValid = _formkey.currentState!.validate();
  FocusScope.of(context).unfocus();

  if (isValid) {
    try {
      setState(() {
        _isLoading = true;
      });

      final UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Fluttertoast.showToast(
        msg: "Login berhasil!",
        backgroundColor: const Color.fromRGBO(6, 132, 0, 1),
        textColor: Colors.white,
      );

      final String firebaseUid = userCredential.user!.uid;

      final apiResponse = await sendUIDToAPI(firebaseUid);
      if (apiResponse.success && apiResponse.data != null) {
        try {
          await SharedPreferencesHelper.saveUserIdFromAPIResponse(apiResponse.data!);
          print('ID berhasil disimpan di SharedPreferences.');
        } catch (e) {
          print('Gagal menyimpan ID dari respons API: $e');
        }
      } else {
        print('Gagal mengambil ID dari API: ${apiResponse.message}');
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => RootScreen(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      String errorMessage;
      switch (error.code) {
        case 'invalid-email':
          errorMessage = 'Email tidak valid.';
          break;
        case 'user-disabled':
          errorMessage = 'Pengguna ini telah dinonaktifkan.';
          break;
        case 'user-not-found':
          errorMessage = 'Pengguna tidak ditemukan.';
          break;
        case 'wrong-password':
          errorMessage = 'Password salah.';
          break;
        default:
          errorMessage = 'Terjadi kesalahan. Silakan coba lagi.';
          break;
      }
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: errorMessage,
        fct: () {},
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                "Terjadi kesalahan: ${error.toString()}",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: SingleChildScrollView(
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
                            'Login disini',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 10,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.chevron_left, color: Colors.white),
                          iconSize: 40,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          const Text(
                            'Selamat datang Kembali Silahkan Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              filled: true, 
                              fillColor: Colors.white, 
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(color: Color.fromRGBO(6, 132, 0, 1)),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            ),
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                            validator: (value) {
                              return MyValidators.emailValidator(value);
                            },
                          ),
                          const SizedBox(height: 20),
                          ValueListenableBuilder<bool>(
                            valueListenable: _isObscure,
                            builder: (context, value, child) {
                              return TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                obscureText: value,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  filled: true, 
                                    fillColor: Colors.white, 
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(color: Color.fromRGBO(6, 132, 0, 1)),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),

                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isObscure.value = !_isObscure.value;
                                      });
                                    },
                                    icon: Icon(
                                      value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                onFieldSubmitted: (value) async {
                                  await _loginFct();
                                },
                                validator: (value) {
                                  return MyValidators.passwordValidator(value);
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Lupa password?',
                                style: TextStyle(
                                  color: Color.fromRGBO(6, 132, 0, 1),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          MaterialButton(
                            onPressed: () async {
                              final email = _emailController.text;
                              final password = _passwordController.text;

                              // Periksa apakah email dan password kosong
                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.error,
                                            color: Colors.white),
                                        const SizedBox(width: 10),
                                        const Text(
                                            'Harap masukkan email dan password'),
                                      ],
                                    ),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                );
                                return; // Keluar dari metode onPressed jika email atau password kosong
                              }

                            await _loginFct();
                            },
                            color: const Color.fromRGBO(6, 132, 0, 1),
                            minWidth: double.infinity,
                            height: 50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              'Belum memiliki akun? Daftar disini',
                              style: TextStyle(
                                color: Color.fromRGBO(6, 132, 0, 1),
                                fontSize: 16,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 150),
                          const Text(
                            'Atau lanjut menggunakan',
                            style: TextStyle(
                              color: Color.fromRGBO(6, 132, 0, 1),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  // Implementasikan login Google
                                },
                                child: Image.asset(
                                  'assets/google.png',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              InkWell(
                                onTap: () {
                                  // Implementasikan login Facebook
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