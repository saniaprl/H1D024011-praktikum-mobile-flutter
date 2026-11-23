import 'package:flutter/material.dart';

class WarningDialog extends StatelessWidget {
  final String? description;
  final VoidCallback? okClick;

  const WarningDialog({
    super.key,
    this.description,
    this.okClick,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "GAGAL",
        style: TextStyle(color: Colors.red),
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
