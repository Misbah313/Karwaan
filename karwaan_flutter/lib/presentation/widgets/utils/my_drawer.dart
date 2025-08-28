import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
        title: Text('Logout', style: Theme.of(context).textTheme.bodyLarge),
        content: Text('Are you sure want to logout?',
            style: Theme.of(context).textTheme.bodyMedium),
        actionsPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: Theme.of(context).textTheme.titleSmall)),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary),
              onPressed: () {
                Navigator.pop(context);
                cubit.logout();
              },
              child: Text(
                'Logout',
                style: Theme.of(context).textTheme.bodySmall,
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(child: Image.asset('asset/images/karwaan.png')),
          const SizedBox(height: 25),
          ListTile(
            leading: Icon(
              Icons.home_filled,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(
              'Dashboard',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.book,
              color: Theme.of(context).iconTheme.color,
            ),
            title:
                Text('Boards', style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.task,
              color: Theme.of(context).iconTheme.color,
            ),
            title:
                Text('Columns', style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.show_chart_outlined,
              color: Theme.of(context).iconTheme.color,
            ),
            title:
                Text('Status', style: Theme.of(context).textTheme.bodyMedium),
            onTap: () {},
          ),
          ListTile(
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).iconTheme.color,
              ),
              title:
                  Text('Logout', style: Theme.of(context).textTheme.bodyMedium),
              onTap: () => _showLogoutDialog(context)),
        ],
      ),
    );
  }
}
