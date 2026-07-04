import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/client/profile_image_service.dart';
import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';

class ProfileAvatar extends StatelessWidget {
  final AuthUser user;
  final ProfileImageService profileImageService;
  final double? size;
  const ProfileAvatar({
    super.key,
    required this.user,
    required this.profileImageService,
    this.size
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: profileImageService.getProfileImageUrl(user.profileImage),
      builder: (context, snapshot) {
        return _buildAvatar(context, snapshot);
      },
    );
  }

  Widget _buildAvatar(BuildContext context, AsyncSnapshot<String> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _buildLoadingAvatar(context);
    }

    if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
      return _buildDefaultAvatar(context);
    }

    return _buildNetworkAvatar(context, snapshot.data!);
  }

  Widget _buildLoadingAvatar(BuildContext context) {
    final double avatarSize = size ?? 40.0;
    return SizedBox(
      width: avatarSize,
      height: avatarSize,
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    final double avatarSize = size ?? 40.0;
    return SizedBox(
      width: avatarSize,
      height: avatarSize,
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.person,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }

  Widget _buildNetworkAvatar(BuildContext context, String imageData) {
    final double avatarSize = size ?? 40.0;
    try {
      return SizedBox(
        width: avatarSize,
        height: avatarSize,
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          backgroundImage: MemoryImage(_decodeImageData(imageData)),
        ),
      );
    } catch (e) {
      return _buildDefaultAvatar(context);
    }
  }

  dynamic _decodeImageData(String imageData) {
    return base64Decode(imageData.replaceFirst('data:image/jpeg;base64,', ''));
  }
}