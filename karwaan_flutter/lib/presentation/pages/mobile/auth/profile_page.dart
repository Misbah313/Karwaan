import 'dart:io';
import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/core/services/image_picker_service.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/core/theme/theme_notifier.dart';
import 'package:karwaan_flutter/core/theme/theme_service.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isDarkMode = false;
  bool notify = false;
  final ImagePickerService _imagePickerService = ImagePickerService();
  // ignore: unused_field
  File? _selectedImage;

  // logout confirmation dialog
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
              context.read<AuthCubit>().logout();
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

  // delete account confirmaion dialog
  void _deleteAccount(BuildContext context, int userID) async {
    await showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Delete Account',
            style: Theme.of(context).textTheme.bodyLarge),
        content: Text(
            'Are you sure want to delete your account? This cannot be undone!!',
            style: Theme.of(context).textTheme.bodySmall),
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
              context.read<AuthCubit>().deleteUser(userID);
            },
            child: Text(
              'Delete',
              style: GoogleFonts.alef(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }

  // Pick image from gallery and upload
  Future<void> _pickAndUploadImage(int userId) async {
    try {
      final imageFile = await _imagePickerService.pickImageFromGallery();
      if (imageFile != null) {
        setState(() {
          _selectedImage = imageFile;
        });

        final serverpodService = context.read<ServerpodClientService>();

        // Refresh user data to get updated profile image
        final newFileName =
            await serverpodService.uploadProfilePicture(imageFile, userId);
        context.read<AuthCubit>().updateProfileImage(newFileName);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
    }
  }

  // get profile image
  Future<String> _getProfileImageUrl(String? filename) async {
    final serverpodService = context.read<ServerpodClientService>();
    return await serverpodService.getProfilePictureUrl(filename);
  }

  // profile image avatars
  Widget _buildProfileAvatar(AuthUser user) {
    return FutureBuilder<String>(
      future: _getProfileImageUrl(user.profileImage),
      builder: (context, snapshot) {
        // Show loading indicator while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: CircularProgressIndicator(
              color: Theme.of(context).iconTheme.color,
            ),
          );
        }

        // Handle errors
        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.person,
              size: 40,
              color: Theme.of(context).iconTheme.color,
            ),
          );
        }

        // Success - display the image
        final imageData = snapshot.data!;
        return CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.primary,
          backgroundImage: MemoryImage(base64Decode(
              imageData.replaceFirst('data:image/jpeg;base64,', ''))),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: BlocConsumer<AuthCubit, AuthStateCheck>(
        listener: (context, state) {
          if (state is AuthUnAuthenticated || state is DeleteSuccessfully) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            });
          }
        },
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final user = state.user;

            return Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () => _pickAndUploadImage(user.id),
                          child: _buildProfileAvatar(user)),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text('Tap to change profile picture',
                    style: Theme.of(context).textTheme.bodySmall),
                SizedBox(height: 20),

                // Personal info
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Personal info',
                              style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('User Name',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text(user.name,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('User Email',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Text(user.email,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: Theme.of(context).dividerColor,
                      ),
                    ],
                  ),
                ),

                // application apperiance(theme mode, notification(later))
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Application apperiance',
                              style: Theme.of(context).textTheme.bodyLarge)
                        ],
                      ),
                      SwitchListTile(
                        title: Text('Dark Mode',
                            style: Theme.of(context).textTheme.bodyMedium),
                        value: themeNotifier.themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          themeNotifier.setThemeMode(
                              value ? ThemeMode.dark : ThemeMode.light);
                          final user = (state).user;
                          final themeService = ThemeService(
                              context.read<ServerpodClientService>());
                          themeService.saveUserTheme(user.id, value);
                        },
                      ),
                      SwitchListTile(
                        title: Text('Notifications',
                            style: Theme.of(context).textTheme.bodyMedium),
                        value: notify,
                        onChanged: (value) {
                          setState(() {
                            notify = value;
                          });
                        },
                      ),
                      Divider(
                        color: Theme.of(context).dividerColor,
                      )
                    ],
                  ),
                ),

                // Account actions
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Account',
                              style: Theme.of(context).textTheme.bodyLarge)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Logout',
                              style: Theme.of(context).textTheme.bodyMedium),
                          IconButton(
                            onPressed: () {
                              _logoutConfirmation(context);
                            },
                            icon: Icon(
                              Icons.logout_outlined,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delete Account',
                              style: Theme.of(context).textTheme.bodyMedium),
                          IconButton(
                            onPressed: () {
                              _deleteAccount(context, user.id);
                            },
                            icon: Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // Loading or not authenticated
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
