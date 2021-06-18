import 'package:flutter/material.dart';

class ErrorFieldLogin extends StatelessWidget {
  final Stream<String?> errorStream;
  const ErrorFieldLogin({
    Key? key,
    required this.errorStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
        stream: errorStream,
        initialData: null,
        builder: (context, snapshotErrorMessage) {
          if (snapshotErrorMessage.data == null) return Container();
          return Text(
            snapshotErrorMessage.data!,
            style: TextStyle(color: Colors.red),
          );
        });
  }
}
