import 'package:flutter/material.dart';
import 'package:herbal/core/theme/app_colors.dart';
import 'package:herbal/core/utility/SharedPreferences.dart';
import 'package:herbal/view/screens/cart/Keranjang.dart';
import 'package:herbal/view/screens/notifikasi.dart';
import 'package:iconsax/iconsax.dart';

class SearchBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController controller;

  const SearchBarWidget({Key? key, required this.controller}) : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    try {
      final id = await SharedPreferencesHelper.getUserId();
      setState(() {
        userId = id;
      });
    } catch (e) {
      print('Error loading user ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: AppBar(
        backgroundColor: AppColors.lightPrimary,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 15.0, right: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: widget.controller,
                      decoration: InputDecoration(
                        hintText: "Ayo cari obatnya di sini",
                        prefixIcon: Icon(Icons.search, color: AppColors.lightPrimary),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                CartIcon(
                  onPressed: () async {
                    if (userId != null && userId!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Keranjang(id: userId!),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Keranjang(id: null), // Kirim null jika userId tidak ditemukan
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(width: 10),
                NotificationIcon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Notifikasi()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        elevation: 0,
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class CartIcon extends StatelessWidget {
  final VoidCallback onPressed;

  const CartIcon({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.shopping_cart, color: Colors.white),
      onPressed: onPressed,
    );
  }
}

class NotificationIcon extends StatelessWidget {
  final VoidCallback onPressed;

  const NotificationIcon({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Iconsax.notification5, color: Colors.white),
      onPressed: onPressed,
    );
  }
}