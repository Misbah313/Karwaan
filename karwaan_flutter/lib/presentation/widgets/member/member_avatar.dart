import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';

class MemberAvatar extends StatelessWidget {
  final WorkspaceMemberDetail member;
  final MemberService memberService;
  final double? size; 

  const MemberAvatar({
    super.key,
    required this.member,
    required this.memberService,
    this.size, 
  });

  @override
  Widget build(BuildContext context) {
    final double avatarSize = size ?? 40.0; 

    return CircleAvatar(
      radius: avatarSize / 2,
      backgroundColor:
          Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
      child: member.avatarUrl != null && member.avatarUrl!.isNotEmpty
          ? _buildNetworkAvatar(avatarSize)
          : _buildFallbackAvatar(),
    );
  }

  Widget _buildNetworkAvatar(double avatarSize) {
    final imageBytes = memberService.base64ToImage(member.avatarUrl!);

    return ClipOval(
      child: Image.memory(
        imageBytes,
        width: avatarSize,
        height: avatarSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackAvatar();
        },
      ),
    );
  }

  Widget _buildFallbackAvatar() {
    return Text(
      member.userName.isNotEmpty ? member.userName[0].toUpperCase() : '?',
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}