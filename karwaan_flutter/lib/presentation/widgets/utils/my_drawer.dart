import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  // show logout cofirm dialog
  void _showLogoutDialog(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.grey.shade300,
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure want to logout?',
          style: GoogleFonts.alef(fontSize: 20),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.grey.shade400
            ),
              onPressed: () {
                Navigator.pop(context);
                cubit.logout();
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade300,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(child: Image.asset('asset/images/karwaan.png')),
          const SizedBox(height: 25),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Boards'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.task),
            title: Text('Columns'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.show_chart_outlined),
            title: Text('Status'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => _showLogoutDialog(context)
          ),
        ],
      ),
    );
  }
}
