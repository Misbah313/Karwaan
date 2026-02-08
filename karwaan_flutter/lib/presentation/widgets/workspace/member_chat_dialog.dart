import 'package:flutter/material.dart';
import 'package:karwaan_flutter/core/services/workspace/workspace_member/member_service.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';
import 'package:karwaan_flutter/presentation/widgets/member/member_avatar.dart';

class MemberChatDialog extends StatelessWidget {
  final WorkspaceMemberDetail member;
  const MemberChatDialog({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withValues(alpha: 0.07)
                  : Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // chat header (user to chat profile image + options icon)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        MemberAvatar(
                            member: member,
                            memberService: MemberService(),
                            size: 40),
                        const SizedBox(width: 6),
                        Text(member.userName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white))
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ))
                  ],
                ),
                Divider(color: Theme.of(context).dividerColor),

                const SizedBox(height: 20),

                // chats (preview)
                _chatPrview(context,
                    color: Colors.blue.withValues(alpha: 0.3),
                    mainAlignment: MainAxisAlignment.start),

                const SizedBox(height: 8),

                _chatPrview(context,
                    color: Colors.green.withValues(alpha: 0.3),
                    mainAlignment: MainAxisAlignment.end),

                const SizedBox(height: 8),

                _chatPrview(context,
                    color: Colors.blue.withValues(alpha: 0.3),
                    mainAlignment: MainAxisAlignment.start),

                const SizedBox(height: 8),

                _chatPrview(context,
                    color: Colors.green.withValues(alpha: 0.3),
                    mainAlignment: MainAxisAlignment.end),

                const SizedBox(height: 8),

                _chatPrview(context,
                    color: Colors.blue.withValues(alpha: 0.3),
                    mainAlignment: MainAxisAlignment.start),

                const SizedBox(height: 8),

                _chatPrview(context,
                    color: Colors.green.withValues(alpha: 0.3),
                    mainAlignment: MainAxisAlignment.end),

                const SizedBox(height: 10),

                // recent date
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'OCT 27, 2027',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ]),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.17,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 9)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          'Coming Soon...',
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Container(
                      width: 70,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.5),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 9)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.send_sharp,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatPrview(BuildContext context,
      {required Color color, required MainAxisAlignment mainAlignment}) {
    return Row(
      mainAxisAlignment: mainAlignment,
      children: [
        Container(
          height: 40,
          padding: EdgeInsets.only(left: 10),
          width: MediaQuery.of(context).size.width * 0.15,
          decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(20)),
        )
      ],
    );
  }
}
