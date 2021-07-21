// primero creo los string que me permitan controlar los string del form

import 'dart:async';

import 'package:formaulario_y_bloc/src/bloc/validator.dart';
import 'package:rxdart/rxdart.dart';

//  mesclo el loginBloc con el Validator
class LoginBloc with Validator {
  // tengo 2 string controller , email y pass
  // broadcast para que escuchen varios
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // recuperar los datos del stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  // voy a hacer el combine para validar que el email este y la contrase;a tambien
  Stream<bool> get fromValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (a, b) => true);

  // establesco los geter y seter
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //obtener el ultimo valor ingresado de la caja de texto
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
