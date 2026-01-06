import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';

class RoleBadge extends StatelessWidget {
  final String role;
  final MemberService memberService;

  const RoleBadge({
    super.key,
    required this.role,
    required this.memberService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: memberService.getRoleColor(role).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: memberService.getRoleColor(role)),
      ),
      child: Text(
        memberService.capitalize(role),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: memberService.getRoleColor(role),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}