import 'package:flutter/material.dart';
import 'package:formaulario_y_bloc/src/bloc/provider.dart';
import 'package:formaulario_y_bloc/src/pages/home_page.dart';
import 'package:formaulario_y_bloc/src/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        child: MaterialApp(
      title: 'Form_Bloc',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'home': (BuildContext context) => HomePage(),
      },
      theme: ThemeData(primaryColor: Colors.deepPurple),
    ));
  }
}
