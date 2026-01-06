import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';

class BoardMemberAvatar extends StatelessWidget {
  final BoardMemberDetails member;
  final MemberService memberService;

  const BoardMemberAvatar({
    super.key,
    required this.member,
    required this.memberService,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 20,
        backgroundColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        child: member.avatarUrl != null && member.avatarUrl!.isNotEmpty
            ? _buildNetworkAvatar()
            : _buildFallbackAvatar());
  }

  Widget _buildNetworkAvatar() {
    final imageBytes = memberService.base64ToImage(member.avatarUrl!);

    return ClipOval(
      child: Image.memory(
        imageBytes,
        width: 40,
        height: 40,
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
