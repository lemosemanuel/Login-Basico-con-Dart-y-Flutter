import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formaulario_y_bloc/src/models/productoModel.dart';
import 'package:formaulario_y_bloc/src/providers/producto_provider.dart';
import 'package:formaulario_y_bloc/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productosProvider = new ProductosProvider();

  bool _guardando = false;

  File? foto;

  ProductoModel producto = ProductoModel();

  @override
  Widget build(BuildContext context) {
    // agarro el argumento que me tira cuando apreto alguno de los item en la pagina home
    // que es toda la info del producto
    final prodData = ModalRoute.of(context)!.settings.arguments;
    if (prodData != null) {
      producto = prodData as ProductoModel;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
              onPressed: () {
                _seleccionarFoto();
              },
              icon: Icon(Icons.photo_size_select_actual)),
          IconButton(
              onPressed: () {
                _tomarFoto();
              },
              icon: Icon(Icons.camera_alt)),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  _mostrarFoto(),
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton(),
                ],
              )),
        ),
      ),
    );
  }

  _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: "Producto"),
      onSaved: (value) => producto.titulo = value!,
      validator: (value) {
        if (value!.length < 3) {
          return 'ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: "Precio"),
      onSaved: (value) => producto.valor = double.parse(value!),
      validator: (value) {
        if (esNumero(value!)) {
          return null;
        } else {
          return "Solo se pueden numeros";
        }
      },
    );
  }

  _crearDisponible() {
    return SwitchListTile(
        value: producto.disponible!,
        title: Text('Disponible'),
        activeColor: Colors.deepPurple,
        onChanged: (value) => setState(() {
              producto.disponible = value;
            }));
  }

  _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      icon: Icon(Icons.save),
      label: Text("Guardar"),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  Future<void> _submit() async {
    // valido el formulario
    if (!formKey.currentState!.validate()) return;

    // leugo que esta validado disparo el save del formulario
    formKey.currentState!.save();

    print(producto.titulo);
    print(producto.valor);
    print(producto.disponible);

    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      producto.fotoUrl = await productosProvider.subirImagen(foto!);
    }

    // llamo al provider que hice para subir un producto a la nube
    // lo llamo arriba mejor para usarlo en todos lados
    // final productosProvider = new ProductosProvider();
    // productosProvider.crearProducto(producto);
    // pero necesitamos poner una condicion (si ya esta creado lo modifico , sino creo el id)

    // print(producto.id);
    if (producto.id == null) {
      productosProvider.crearProducto(producto);
    } else {
      productosProvider.editarProducto(producto);
    }
    // setState(() {
    //   _guardando = false;
    // });
    setState(() {});

    mostrarSnakbar("registro guardado");
    Navigator.pop(context);
  }

  void mostrarSnakbar(String mensae) {
    final snackbar = SnackBar(
      content: Text(mensae),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  // si no tenemos foto url
  _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'),
        image: NetworkImage(producto.fotoUrl.toString()),
        height: 300,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        return Image.file(
          foto!,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final picker = ImagePicker();
    foto = File(await ImagePicker()
        .getImage(source: origen)
        .then((foto) => foto!.path));
    print(foto);
    if (foto != null) {
      producto.fotoUrl = null;
    }
    print('object');
    setState(() {});
  }
}
