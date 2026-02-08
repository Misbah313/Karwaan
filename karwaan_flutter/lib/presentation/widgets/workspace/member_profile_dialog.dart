import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';
import 'package:karwaan_flutter/presentation/widgets/member/member_avatar.dart';
import 'package:karwaan_flutter/presentation/widgets/workspace/member_chat_dialog.dart';

class MemberProfileDialog extends StatelessWidget {
  final WorkspaceMemberDetail member;
  const MemberProfileDialog({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 30,
                spreadRadius: 1,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Section
                Column(
                  children: [
                    // Profile Avatar
                    MemberAvatar(
                      member: member,
                      memberService: MemberService(),
                      size: 80,
                    ),
                    const SizedBox(height: 16),

                    // Name and Role
                    Column(
                      children: [
                        Text(
                          member.userName,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getRoleColor(member.role, context),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            member.role.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Divider
                Divider(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  height: 1,
                ),

                const SizedBox(height: 24),

                // Stats Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Joined Date
                    _buildStatItem(
                      context,
                      icon: Icons.calendar_today_rounded,
                      label: 'Joined',
                      value: _formatDate(member.joinedAt),
                    ),

                    // Optional: Activity level
                    _buildStatItem(
                      context,
                      icon: Icons.insights,
                      label: 'Activity',
                      value: 'High',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(
                          Icons.message_outlined,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        label: Text(
                          'Message',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Future.delayed(Duration.zero, () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  MemberChatDialog(member: member),
                            );
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Close'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  Color _getRoleColor(String role, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (role.toLowerCase()) {
      case 'admin':
        return colorScheme.error;
      case 'manager':
        return colorScheme.secondary;
      case 'owner':
        return colorScheme.tertiary;
      default:
        return colorScheme.primary;
    }
  }
}
