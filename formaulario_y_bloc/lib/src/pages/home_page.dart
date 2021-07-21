import 'package:flutter/material.dart';
import 'package:formaulario_y_bloc/src/bloc/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Email:${bloc.email}'),
            Text('Pass:${bloc.password}'),
          ],
        ),
      ),
    );
  }
}
