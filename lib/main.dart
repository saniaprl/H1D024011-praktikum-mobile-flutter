import 'package:flutter/material.dart';
import 'package:belajarflutter/hello_world.dart';
import 'package:belajarflutter/column_widget.dart';
import 'package:belajarflutter/row_widget.dart';
import 'package:belajarflutter/ui/produk_form.dart';
import 'package:belajarflutter/ui/produk_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Aplikasi Flutter Pertama",
      home: HelloWorld(),
      // Ganti sesuai langkah yang dikerjakan:
      //home: ColumnWidget(),
      // home: RowWidget(),
      // home: ProdukForm(),
      // home: ProdukPage(),
    );
  }
}