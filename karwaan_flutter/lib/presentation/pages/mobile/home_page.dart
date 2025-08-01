import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/core/services/auth_token_storage_helper.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_gate.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_state_check.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final lowBlue = Colors.blue.shade300;
  final heightBlue = Colors.amber.shade400;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: BlocBuilder<AuthCubit, AuthStateCheck>(
        builder: (context, state) {
          if (state is AuthLoading || state is AuthInitial) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is AuthAuthenticated) {
            final name = state.user.name;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // heading
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.amber.shade400,
                                child: Icon(
                                  Icons.person_2_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                  
                          // menu icon
                          IconButton(
                              // In HomeMobile's logout button
                              onPressed: () async {
                                try {
                                  debugPrint('UI: Phase 1 - Preparing logout');
                  
                                  // Get token BEFORE any state changes
                                  final preLogoutToken =
                                      await AuthTokenStorageHelper().getToken();
                                  debugPrint(
                                      'UI: Pre-logout token: ${preLogoutToken?.substring(0, 6) ?? "NULL"}');
                  
                                  // Start logout process
                                  await context.read<AuthCubit>().logout();
                  
                                  // Final verification
                                  final postLogoutToken =
                                      await AuthTokenStorageHelper().getToken();
                                  debugPrint(
                                      'UI: Post-logout token: ${postLogoutToken?.substring(0, 6) ?? "NULL"}');
                  
                                  if (preLogoutToken == null) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text('No active sesion!')));
                                      return;
                                    }
                                  }
                  
                                  if (postLogoutToken != null) {
                                    throw StateError(
                                        'FATAL: Token survived logout process!');
                                  }
                  
                                  if (!mounted) return;
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => AuthGate(
                                            authRepo: context.read<AuthRepo>())),
                                    (route) => false,
                                  );
                                } catch (e) {
                                  debugPrint('UI: CRITICAL ERROR: $e');
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Failed to logout!')));
                                  }
                                  // Emergency cleanup
                                  await AuthTokenStorageHelper().deleteToken();
                                }
                              },
                              icon: Icon(Icons.logout))
                        ],
                      ),
                  
                      const SizedBox(height: 25),
                  
                      // greetings
                      ListTile(
                        title: Row(
                          children: [
                            Text(
                              'Hello, ',
                              style: TextStyle(
                                color: Colors.amber.shade600,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                            Text(
                              '$name!',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          'A great day to get better.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                          ),
                        ),
                      ),
                  
                      // divider
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Divider(thickness: 1, color: Colors.grey.shade400),
                      ),
                  
                      const SizedBox(height: 20),
                  
                      // courses
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My workspaces',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.add, color: Colors.amber.shade500),
                                Text('Add'),
                              ],
                            ),
                          ],
                        ),
                      ),
                  
                      const SizedBox(height: 20),
                  
                      // courses container
                      Container(
                        height: MediaQuery.of(context).size.width * 0.75,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [lowBlue, heightBlue]),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  // title
                                  Row(
                                    children: [
                                      Text(
                                        'PROGRESS 18%',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'The Psychology of Sport Victories!',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 19,
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                  
                              // bottom container
                              Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [heightBlue, lowBlue],
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    Colors.amber.shade100,
                                                child: Icon(
                                                  Icons.ac_unit_outlined,
                                                  color: Colors.amber.shade500,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                'N.Hardmain',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '4.8',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Icon(Icons.star,
                                                  color: Colors.amber),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  
                      const SizedBox(height: 10),
                  
                      // swipe
                      Text(
                        'SWIPE CARDS',
                        style:
                            TextStyle(color: Colors.grey.shade400, fontSize: 15),
                      ),
                  
                      const SizedBox(height: 40),
                  
                      // list of icons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.person_add_alt,
                                color: Colors.grey.shade500),
                            const SizedBox(height: 5),
                            Icon(Icons.add_task_outlined,
                                color: Colors.grey.shade500),
                            const SizedBox(height: 5),
                            Icon(
                              Icons.fact_check_outlined,
                              color: Colors.blue.shade500,
                            ),
                            const SizedBox(height: 5),
                            Icon(Icons.message_outlined,
                                color: Colors.grey.shade500),
                            const SizedBox(height: 5),
                            Icon(Icons.insights, color: Colors.grey.shade500),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Text('Something went wrong. Please login!'),
            );
          }
        },
      ),
    );
  }
}
