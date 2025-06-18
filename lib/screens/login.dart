import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';


class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.state,
    required this.body,
    this.footer,
  });

  final AuthenticatorState state;
  final Widget body;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/f=ma18.png',
                  height: 300,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                Text(
                  'Bienvenido a La Dinámica App',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: body,
              ), 
              ],
            ),
          ),
        ),
      ),
      persistentFooterButtons: footer != null ? [footer!] : null,
    );
  }
}
