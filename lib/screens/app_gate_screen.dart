import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:la_dinamica_app/providers/user_provider.dart';
import 'package:la_dinamica_app/screens/main_screen.dart';
import 'package:la_dinamica_app/screens/payment_not_complete_screen.dart';
import 'package:la_dinamica_app/screens/register_gym_screen.dart';

class AppGate extends ConsumerWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),

      error: (e, _) => Scaffold(
        body: Center(
          child: Text('Error loading user: $e'),
        ),
      ),

      data: (user) {

        // USER DOES NOT HAVE A GYM
        if (user.tenant == null) {
          return const RegisterGymScreen();
        }

        // USER HAS GYM BUT PAYMENT INACTIVE
        if (user.tenant?.status != true) {
          return const UpdatePaymentStatusScreen();
        }

        // EVERYTHING OK
        return const MainScreen();
      },
    );
  }
}