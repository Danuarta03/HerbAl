import 'dart:developer'; 
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:herbal/core/theme/app_colors.dart';
import 'package:herbal/core/providers/user_provider.dart';
import 'package:herbal/view/screens/beli_screen.dart';
import 'package:herbal/view/screens/home_screen.dart';
import 'package:herbal/view/screens/infoSehat_screen.dart';
import 'package:herbal/view/screens/profil_screen.dart';
import 'package:herbal/view/screens/chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicons/unicons.dart';

class RootScreen extends StatefulWidget {
  static const routeName = '/RootScreen';
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late List<Widget> screens;
  int currentScreen = 0;
  late PageController controller;
  bool isLoadingProd = false;

  @override
  void initState() {
    super.initState();
    screens = const [
      HomeScreen(),
      BeliObatScreen(),
      Chat(),
      InfoSehatScreen(),
      ProfilScreen(),
    ];
    controller = PageController(initialPage: currentScreen);
  }

  Future<void> fetchFCT() async {
    final prefs = await SharedPreferences.getInstance();
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      isLoadingProd = prefs.getBool('isLoggedIn') ?? false;

      if (isLoadingProd) {
        await userProvider.fetchUserInfo();
      }
    } catch (error) {
      log(error.toString());  
    }
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    if (isLoadingProd) {
      fetchFCT();
    }
    super.didChangeDependencies();
  }

  void onTabTapped(int index) {
    setState(() {
      currentScreen = index;
      controller.jumpToPage(currentScreen); 
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: BottomNavBarClipper(),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: 80,
              child: BottomNavigationBar(
                currentIndex: currentScreen,
                onTap: onTabTapped, 
                type: BottomNavigationBarType.fixed,
                selectedItemColor: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                unselectedItemColor: Colors.grey,
                showUnselectedLabels: true,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(IconlyLight.home),
                    activeIcon: Icon(IconlyBold.home),
                    label: "Beranda",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconlyLight.bag2),
                    activeIcon: Icon(IconlyBold.bag),
                    label: "Beli Obat",
                  ),
                  BottomNavigationBarItem(
                    icon: SizedBox.shrink(),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(UniconsLine.book_open),
                    activeIcon: Icon(UniconsLine.book_medical),
                    label: "Info Sehat",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconlyLight.profile),
                    activeIcon: Icon(IconlyBold.profile),
                    label: "Profil",
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -30,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  currentScreen = 2;
                  controller.jumpToPage(currentScreen);
                });
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentScreen == 2
                      ? (isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary)
                      : Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(
                    color: isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icon.png',
                      width: 30,
                      height: 30,
                      color: currentScreen == 2
                          ? Colors.white
                          : (isDarkMode
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary),
                    ),
                    Text(
                      "Asisstant",
                      style: TextStyle(
                        color: currentScreen == 2
                            ? Colors.white
                            : (isDarkMode
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double curveHeight = 40.0;

    path.lineTo(size.width * 0.35, 0);
    path.quadraticBezierTo(
      size.width * 0.5,
      -curveHeight,
      size.width * 0.65,
      0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; 
  }
}

//mengatur status login, misalnya saat login berhasil
Future<void> onLoginSuccess(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLoggedIn', true);
  Provider.of<UserProvider>(context, listen: false).fetchUserInfo();
  Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
}

// mengatur status logout, misalnya saat logout berhasil
Future<void> onLogout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLoggedIn', false);
  Provider.of<UserProvider>(context, listen: false).userModel = null;
  Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
}
