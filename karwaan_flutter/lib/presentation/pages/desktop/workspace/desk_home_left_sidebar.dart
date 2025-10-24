import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';

class DeskHomeLeftSidebar extends StatefulWidget {
  const DeskHomeLeftSidebar({super.key});

  @override
  State<DeskHomeLeftSidebar> createState() => _DeskHomeLeftSidebarState();
}

class _DeskHomeLeftSidebarState extends State<DeskHomeLeftSidebar> {
  void _logoutConfirmation(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Logout', style: Theme.of(context).textTheme.bodyLarge),
        content: Text('Are you sure want to logout?',
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child:
                Text('Cancel', style: Theme.of(context).textTheme.titleSmall),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              context.read()<AuthCubit>().logout();
            },
            child: Text(
              'Logout',
              style: GoogleFonts.alef(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(10),
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section
          Column(
            children: [
              // Karwaan logo
              Image.asset('asset/images/logo.png', fit: BoxFit.scaleDown),
              const SizedBox(height: 10),

              // Dashboard
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.dashboard, color: Colors.blue),
                    ),
                    const SizedBox(width: 8),
                    Text('DashBoard',
                        style: GoogleFonts.alef(color: Colors.blue)),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Board
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.space_dashboard_rounded,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Board',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Analysis
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.analytics_outlined,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Analysis',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Teams
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.people_alt_outlined,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Teams',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Settings
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.settings,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),

          // Logout
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => _logoutConfirmation(context),
                icon: Icon(
                  Icons.logout_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Logout',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
