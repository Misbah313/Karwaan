import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:karwaan_flutter/core/services/image_picker_service.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/core/theme/theme_notifier.dart';
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
  bool _isImageLoadingError = false;
  final int _retryCount = 0;
  /*final int _maxRetries = 3; */
  final ImagePickerService _imagePickerService = ImagePickerService();
  File? _selectedImage;

  // logout confirmation dialog
  void _logoutConfirmation(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Logout',
          style: Theme.of(context).textTheme.bodyLarge
        ),
        content: Text(
          'Are you sure want to logout?',
          style: Theme.of(context).textTheme.bodyMedium
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleSmall
            ),
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
        title: Text(
          'Delete Account',
          style: Theme.of(context).textTheme.bodyLarge
        ),
        content: Text(
          'Are you sure want to delete your account? This cannot be undone!!',
          style: Theme.of(context).textTheme.bodySmall
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text(
              'Cancel',
              style: Theme.of(context).textTheme.titleSmall
            ),
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
          _isImageLoadingError = false; // Reset error state
        });

        final serverpodService = context.read<ServerpodClientService>();
        await serverpodService.uploadProfilePicture(imageFile, userId);

        // Refresh user data to get updated profile image
        context.read<AuthCubit>().checkAuth();

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

  // Get profile image with error handling
  ImageProvider? _getProfileImage(String? profileImage) {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    } else if (profileImage != null && !_isImageLoadingError) {
      final serverpodService = context.read<ServerpodClientService>();
      final imageUrl = serverpodService.getProfilePictureUrl(profileImage);

      // Add cache busting to avoid cached errors
      final cacheBuster = _retryCount > 0 ? '?retry=$_retryCount' : '';
      return NetworkImage('$imageUrl$cacheBuster');
    }
    return null;
  }

  /*
  // Add a method to retry loading the image
  void _retryImageLoading() {
    if (_retryCount < _maxRetries) {
      setState(() {
        _retryCount++;
        _isImageLoadingError = false;
      });
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(backgroundColor: Theme.of(context).appBarTheme.backgroundColor, iconTheme: Theme.of(context).iconTheme,),
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
                        child: _getProfileImage(user.profileImage) != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                backgroundImage:
                                    _getProfileImage(user.profileImage),
                                onBackgroundImageError:
                                    (exception, stackTrace) {
                                  // This will be called when the image fails to load
                                  setState(() {
                                    _isImageLoadingError = true;
                                  });
                                },
                              )
                            : CircleAvatar(
                                radius: 50,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                child: Icon(Icons.person,
                                    size: 40, color: Theme.of(context).iconTheme.color),
                              ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tap to change profile picture',
                  style: Theme.of(context).textTheme.bodySmall
                ),
                SizedBox(height: 20),

                // Personal info
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Personal info',
                            style: Theme.of(context).textTheme.bodyLarge
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'User Name',
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
                          Text(
                            user.name,
                            style:Theme.of(context).textTheme.bodySmall
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'User Email',
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodySmall
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(color: Theme.of(context).dividerColor,),
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
                          Text(
                            'Application apperiance',
                            style: Theme.of(context).textTheme.bodyLarge
                          )
                        ],
                      ),
                      SwitchListTile(
                        title: Text(
                          'Dark Mode',
                          style: Theme.of(context).textTheme.bodyMedium
                        ),
                        value: themeNotifier.themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          themeNotifier.setThemeMode(
                              value ? ThemeMode.dark : ThemeMode.light);
                        },
                      ),
                      SwitchListTile(
                        title: Text(
                          'Notifications',
                          style: Theme.of(context).textTheme.bodyMedium
                        ),
                        value: notify,
                        onChanged: (value) {
                          setState(() {
                            notify = value;
                          });
                        },
                      ),
                      Divider(color: Theme.of(context).dividerColor,)
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
                          Text(
                            'Account',
                            style: Theme.of(context).textTheme.bodyLarge
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Logout',
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
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
                          Text(
                            'Delete Account',
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
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
