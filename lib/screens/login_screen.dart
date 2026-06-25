import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web;
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await GoogleSignIn.instance.initialize(
      clientId: '1024503649608-ecfd198ljpkshi2udo0q79s1t0ca7hti.apps.googleusercontent.com',
    );

    GoogleSignIn.instance.authenticationEvents
        .listen((GoogleSignInAuthenticationEvent event) {
      switch (event) {
        case GoogleSignInAuthenticationEventSignIn():
          userNotifier.value = event.user;
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainShell()),
            );
          }
        case GoogleSignInAuthenticationEventSignOut():
          userNotifier.value = null;
      }
    });

    // Only auto-login if user was not manually logged out
    if (userNotifier.value != null) {
      await GoogleSignIn.instance.attemptLightweightAuthentication();
    }

    if (mounted) setState(() => _initialized = true);
  }

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.campaign_rounded, size: 80, color: accent),
                const SizedBox(height: 16),
                Text('Smart Marketing',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: accent)),
                const SizedBox(height: 8),
                Text('Find leads. Grow faster.',
                    style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                const SizedBox(height: 48),
                if (!_initialized)
                  const CircularProgressIndicator()
                else if (kIsWeb)
                  (GoogleSignInPlatform.instance as web.GoogleSignInPlugin)
                      .renderButton()
                else
                  ElevatedButton.icon(
                    onPressed: () async {
                      await GoogleSignIn.instance.authenticate();
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in with Google'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}