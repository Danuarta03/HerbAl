import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herbal/core/models/user_model.dart';
import 'package:herbal/core/models/favorit_model.dart';
import 'package:herbal/core/providers/theme_provider.dart';
import 'package:herbal/core/utility/SharedPreferences.dart';
import 'package:herbal/root_screen.dart';
import 'package:herbal/view/widgets/layout/favorit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String? userId;
  late Future<UserModel?> _userDataFuture;
  late Future<List<FavoritModel>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
    _favoritesFuture = _getFavorites();
  }

  Future<UserModel?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        userId = user.uid;
        return UserModel.fromFirestore(doc);
      }
    }
    return null;
  }

  Future<List<FavoritModel>> _getFavorites() async {
    if (userId == null) return [];
    final querySnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('id', isEqualTo: userId)
        .get();

    return querySnapshot.docs.map((doc) {
      return FavoritModel.fromJson(doc.data());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: FutureBuilder<UserModel?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          return LoadingManager(
            isLoading: snapshot.connectionState == ConnectionState.waiting,
            child: _buildBody(context, snapshot, themeProvider),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot<UserModel?> snapshot, ThemeProvider themeProvider) {
    if (snapshot.hasError) {
      return const Center(child: Text('Error loading user data'));
    }
    final user = snapshot.data;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context, themeProvider, user),
          _buildOrderMenu(context),
          _buildFavoritesAndHistory(context),
          const Divider(),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeProvider themeProvider, UserModel? user) {
    return Container(
      color: const Color.fromRGBO(6, 132, 0, 1),
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () {
                    themeProvider.setDarkTheme(
                      themeValue: !themeProvider.getIsDarkTheme,
                    );
                  },
                  icon: Icon(
                    themeProvider.getIsDarkTheme
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(Iconsax.user, color: Colors.grey, size: 30),
                ),
                const SizedBox(width: 15),
                Text(
                  user?.userName ?? 'Username',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderMenu(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              const Icon(Icons.format_line_spacing, color: Colors.grey),
              const SizedBox(width: 20),
              const Text('Pesanan Saya'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Lihat Riwayat Pesanan'),
              SizedBox(width: 5),
              Icon(CupertinoIcons.chevron_right, size: 18),
            ],
          ),
          onTap: () {
            // Navigasi ke halaman riwayat pesanan
          },
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              OrderStatusWidget(Iconsax.money_add, "Belum Bayar"),
              OrderStatusWidget(Iconsax.repeat, "Diproses"),
              OrderStatusWidget(Iconsax.box, "Dikemas"),
              OrderStatusWidget(Iconsax.truck, "Dikirim"),
              OrderStatusWidget(Iconsax.tick_circle, "Selesai"),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

Widget _buildFavoritesAndHistory(BuildContext context) {
  return Column(
    children: [
      ListTile(
        leading: const Icon(UniconsLine.heart),
        title: const Text('Favorit Saya'),
        trailing: const Icon(CupertinoIcons.chevron_right, size: 18),
        onTap: () async {
          if (userId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritScreen(idUser: userId!),
              ),
            );
          }
        },

      ),
      // ListTile(
      //   leading: const Icon(IconlyLight.timeCircle),
      //   title: const Text('Riwayat Pencarian'),
      //   trailing: const Icon(CupertinoIcons.chevron_right, size: 18),
      //   onTap: () {
      //     // Navigasi ke halaman Riwayat Pencarian
      //   },
      // ),
    ],
  );
}
  Widget _buildLogoutButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Iconsax.logout),
      title: const Text('Keluar'),
      trailing: const Icon(CupertinoIcons.chevron_right, size: 18),
      onTap: () async {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => RootScreen()),
            (route) => false,
          );
        } else {
          await _showLogoutDialog(context);
        }
      },
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Batal', style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await SharedPreferencesHelper.clearUserData();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => RootScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(6, 132, 0, 1),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class OrderStatusWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const OrderStatusWidget(this.icon, this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.grey),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class LoadingManager extends StatelessWidget {
  const LoadingManager({Key? key, required this.child, required this.isLoading}) : super(key: key);
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          const Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(6, 132, 0, 1),
            ),
          ),
        ]
      ],
    );
  }
}
