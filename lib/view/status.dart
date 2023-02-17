import 'package:flutter/material.dart';
import 'package:flutter_firebase/view/signup_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusPage extends ConsumerWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return SignUp();
  }
}
