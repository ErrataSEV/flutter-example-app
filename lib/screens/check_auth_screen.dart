import 'package:flutter/material.dart';
import 'package:form_validation/screens/screens.dart';
import 'package:form_validation/services/services.dart';
import 'package:provider/provider.dart';

class CheAuthScreen extends StatelessWidget {
  const CheAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readToken(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('Wait...');
            }
            
            Future.microtask(() {
              // Navigator.of(context).pushReplacementNamed('home');
              Navigator.pushReplacement(context, PageRouteBuilder(
                pageBuilder: (_, __, ___) => snapshot.data==''
                  ? const LoginScreen()
                  : const HomeScreen(),
                transitionDuration: const Duration(seconds: 0),
              ));
            });

            return Container();
          },
        ),
      ),
    );
  }
}
