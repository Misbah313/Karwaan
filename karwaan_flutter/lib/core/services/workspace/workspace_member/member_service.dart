import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';

class MemberService {
  Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'owner':
        return Colors.orange;
      case 'admin':
        return Colors.blue;
      case 'member':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String formatJoinDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'today';
    if (difference.inDays == 1) return 'yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
    return '${(difference.inDays / 30).floor()} months ago';
  }

  Uint8List base64ToImage(String base64String) {
    try {
      final String data = base64String.split(',').last;
      return base64.decode(data);
    } catch (e) {
      return Uint8List(0);
    }
  }

  bool isCurrentUser(WorkspaceMemberDetail member, String currentUserEmail) {
    return member.email == currentUserEmail;
  }
}