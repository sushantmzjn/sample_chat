import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/constant/firebase_instances.dart';
import 'package:flutter_firebase/view/login.dart';
import 'package:flutter_firebase/view/signup_login.dart';
import 'package:flutter_firebase/view/status.dart';
import 'package:flutter_firebase/view/widgets/button.dart';
import 'package:flutter_firebase/view/widgets/text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../provider/auth_provider.dart';
import '../services/auth_service.dart';

class HomePage extends ConsumerWidget {
  HomePage({Key? key}) : super(key: key);

  final userId = FirebaseInstances.firebaseAuth.currentUser!.uid;

  @override
  Widget build(BuildContext context, ref) {
    final userData = ref.watch(userStream(userId));
    final logout = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample Chat'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                    title: 'Alert',
                    content: const Text('Are You Sure ?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ref.read(authProvider.notifier).userLogOut();
                          },
                          child: Text('Confirm'))
                    ]);
              },
              icon: Icon(Icons.login_outlined))
        ],
      ),
      drawer: Drawer(
        child: userData.when(
            data: (data) {
              return SafeArea(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(100.0)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: CachedNetworkImage(
                          width: 110,
                          height: 110,
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, err) =>
                              Center(child: Text('$err')),
                          placeholder: (context, url) =>
                              Center(child: Text('loading...')),
                          imageUrl: data.imageUrl!,
                        ),
                      ),
                    ),
                    Center(
                        child: Text(
                      data.firstName!,
                      style: TextStyle(fontSize: 16.sp, letterSpacing: 1.5),
                    )),
                    Center(
                        child: Text(data.metadata!['email']!,
                            style: TextStyle(
                                fontSize: 12.sp,
                                letterSpacing: 1.5,
                                color: Colors.lightBlue))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Expanded(child: Divider(color: Colors.green)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            error: (error, stack) => Center(child: Text('$error')),
            loading: () => const Center(child: CircularProgressIndicator())),
      ),
      body: Text('home page'),
    );
  }
}
