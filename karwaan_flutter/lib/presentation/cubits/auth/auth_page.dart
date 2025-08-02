import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/repository/auth/auth_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/auth/auth_cubit.dart';
import 'package:karwaan_flutter/presentation/pages/mobile/auth/intro_page.dart';

class AuthPage extends StatelessWidget {
  final AuthRepo authRepo;
  const AuthPage({super.key, required this.authRepo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<AuthCubit>(),
      child: IntroPage(),
    );
  }
}





 

