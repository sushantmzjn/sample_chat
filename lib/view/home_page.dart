import 'package:flutter/material.dart';
import 'package:flutter_firebase/view/login.dart';
import 'package:flutter_firebase/view/signup_login.dart';
import 'package:flutter_firebase/view/status.dart';
import 'package:flutter_firebase/view/widgets/button.dart';
import 'package:flutter_firebase/view/widgets/text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../provider/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final logout = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample Chat'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                ref.read(authProvider.notifier).userLogOut();
              },
              icon: Icon(Icons.login_outlined))
        ],
      ),
      drawer: Drawer(),
      body: Text('home page'),
    );
  }
}
