import 'package:flutter/material.dart';
import 'package:flutter_firebase/provider/auth_provider.dart';
import 'package:flutter_firebase/view/home_page.dart';
import 'package:flutter_firebase/view/signup_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusPage extends ConsumerWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final authData = ref.watch(authStream);
    return Scaffold(
        body: authData.when(
            data: (data) {
              return data == null ? SignUp() : HomePage();
            },
            error: (err, stack) => Center(child: Text('$err')),
            loading: () => Center(child: CircularProgressIndicator())));
  }
}
