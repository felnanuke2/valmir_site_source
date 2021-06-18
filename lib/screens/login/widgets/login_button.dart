import 'dart:async';

import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final void Function() function;
  final Stream<bool> passwordController;
  final Stream<bool> userController;
  final Stream<bool> loginController;
  const LoginButton({
    Key? key,
    required this.function,
    required this.passwordController,
    required this.userController,
    required this.loginController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 35,
      child: StreamBuilder<bool>(
        stream: passwordController,
        initialData: false,
        builder: (context, snapshotPassword) => StreamBuilder<bool>(
          stream: userController,
          initialData: false,
          builder: (context, snapshotUser) {
            var isValid = snapshotPassword.data! && snapshotUser.data!;
            return StreamBuilder<bool>(
                stream: loginController,
                initialData: false,
                builder: (context, snapshotLoginState) {
                  if (snapshotLoginState.data == true)
                    return ElevatedButton(
                        onPressed: () => null,
                        child: Container(
                          width: 15,
                          height: 15,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        ));
                  return ElevatedButton(
                      onPressed: !isValid ? null : function,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Acessar',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ));
                });
          },
        ),
      ),
    );
  }
}
