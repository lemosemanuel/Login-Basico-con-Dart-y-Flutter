import 'package:flutter/material.dart';
import 'package:formaulario_y_bloc/src/bloc/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(63, 63, 156, 1),
          Color.fromRGBO(90, 70, 178, 1),
        ]),
      ),
    );
    final circulo = Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.05),
      ),
    );

    return Stack(
      children: [
        fondoMorado,
        Positioned(child: circulo, top: 90.0, left: 30),
        Positioned(child: circulo, top: -40.0, right: -30),
        Positioned(child: circulo, bottom: -50.0, right: -30),
        Positioned(child: circulo, bottom: 120.0, right: 20),
        Positioned(child: circulo, bottom: -50.0, left: -20),
        Container(
          padding: EdgeInsets.only(top: 80),
          child: Column(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white, size: 100),
              SizedBox(height: 10, width: double.infinity),
              Text("Buenos Aires Shop",
                  style: TextStyle(color: Colors.white, fontSize: 25))
            ],
          ),
        ),
      ],
    );
  }

  _loginForm(BuildContext context) {
    // hago esto para sacar las dimensiones de la pantalla
    final size = MediaQuery.of(context).size;

    final bloc = Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(
            height: 220,
          )),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                    spreadRadius: 3,
                  )
                ]),
            child: Column(
              children: [
                Text("Ingreso", style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                _crearEmail(bloc),
                SizedBox(height: 20),
                _crearPass(bloc),
                SizedBox(height: 20),
                _crearBoton(bloc),
              ],
            ),
          ),
          Text("¿Olvidó su contraseña?"),
          SizedBox(height: 100)
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
                hintText: "ejemplo@gmail.com",
                labelText: "Correo electronico",
                counterText: snapshot.data,
                errorText: snapshot.error?.toString(),
              ),
              onChanged: (value) => bloc.changeEmail(value),
            ),
          );
        });
  }

  _crearPass(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.deepPurple),
              hintText: "Password",
              labelText: "Paswword",
              counterText: snapshot.data,
              errorText: snapshot.error?.toString(),
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.fromValidStream,
        builder: (context, snapshot) {
          return RaisedButton(
            onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text('Ingresar'),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
            color: Colors.deepPurple,
            textColor: Colors.white,
          );
        });
  }

  _login(LoginBloc bloc, BuildContext context) {
    print('email :${bloc.email}');
    print('pass :${bloc.password}');

    // el replacement es para que no pueda volver para atras una vez navegado
    Navigator.pushReplacementNamed(context, 'home');
  }
}
