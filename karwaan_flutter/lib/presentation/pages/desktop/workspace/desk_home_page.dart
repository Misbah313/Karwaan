import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';

class DeskHomePage extends StatelessWidget {
  const DeskHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary
          ),
            onPressed: () {
              final cubit = context.read<AuthCubit>();
              cubit.logout();
            },
            child: Text("Logout"))),

           const SizedBox(height: 20),

           Center(
            child: Text("welcome"),
           ) 
      ],
    );
  }
}
