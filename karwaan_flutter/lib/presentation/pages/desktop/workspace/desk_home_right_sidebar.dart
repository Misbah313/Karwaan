// import 'package:flutter/material.dart';

// class DeskHomeRightSidebar extends StatefulWidget {
//   const DeskHomeRightSidebar({super.key});

//   @override
//   State<DeskHomeRightSidebar> createState() => _DeskHomeRightSidebarState();
// }

// class _DeskHomeRightSidebarState extends State<DeskHomeRightSidebar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.25,
//       padding: EdgeInsets.all(16),
//       color: Theme.of(context).colorScheme.onPrimaryContainer,
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Profile section (fixed height)
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Theme.of(context)
//                     .colorScheme
//                     .primary
//                     .withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   _buildProfileAvatar(user),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           user.name,
//                           style:
//                               Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                         SizedBox(height: 2),
//                         Text(
//                           user.email,
//                           style:
//                               Theme.of(context).textTheme.bodySmall?.copyWith(
//                                     fontSize: 12,
//                                     color: Theme.of(context)
//                                         .textTheme
//                                         .bodySmall
//                                         ?.color
//                                         ?.withValues(alpha: 0.7),
//                                   ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   DropdownButton<String>(
//                     items: [
//                       DropdownMenuItem(
//                         value: 'profile',
//                         child: Row(
//                           children: [
//                             Icon(Icons.person, size: 16),
//                             SizedBox(width: 8),
//                             Text('Profile', style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                       ),
//                       DropdownMenuItem(
//                         value: 'settings',
//                         child: Row(
//                           children: [
//                             Icon(Icons.settings, size: 16),
//                             SizedBox(width: 8),
//                             Text('Settings', style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                       ),
//                       DropdownMenuItem(
//                         value: 'logout',
//                         child: Row(
//                           children: [
//                             Icon(Icons.logout, size: 16),
//                             SizedBox(width: 8),
//                             Text('Logout',
//                                 style:
//                                     TextStyle(fontSize: 12, color: Colors.red)),
//                           ],
//                         ),
//                         onTap: () => _logoutConfirmation(context),
//                       ),
//                     ],
//                     onChanged: (value) {
//                       if (value == 'logout') {
//                         _logoutConfirmation(context);
//                       } else {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AccountControlPage(),
//                             ));
//                       }
//                     },
//                     icon: Icon(
//                       Icons.arrow_drop_down,
//                       size: 20,
//                       color: Theme.of(context).iconTheme.color,
//                     ),
//                     underline: SizedBox(),
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodySmall
//                         ?.copyWith(fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: 20),

//             // Progress Chart
//             Flexible(
//               flex: 1,
//               child: SizedBox(
//                 width: double.infinity,
//                 child: BlocProvider(
//                   create: (context) =>
//                       OverallAnalyticsCubit(context.read<BoardRepo>()),
//                   child: const OverallProgressSection(),
//                 ),
//               ),
//             ),

//             SizedBox(height: 20),

//             // Calendar - Make it scrollable
//             Flexible(
//               flex: 2,
//               child: SizedBox(
//                 width: double.infinity,
//                 child: FocusTimeCalendar(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
