import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final String? description;
  final VoidCallback? okClick;

  const SuccessDialog({
    super.key,
    this.description,
    this.okClick,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "SUKSES",
        style: TextStyle(color: Colors.green),
      ),
      content: Text(description ?? ""),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            okClick?.call();
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
