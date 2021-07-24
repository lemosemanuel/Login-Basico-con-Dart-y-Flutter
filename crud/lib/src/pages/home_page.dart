import 'package:flutter/material.dart';
// import 'package:formaulario_y_bloc/src/bloc/provider.dart';
import 'package:formaulario_y_bloc/src/models/productoModel.dart';
import 'package:formaulario_y_bloc/src/providers/producto_provider.dart';

class HomePage extends StatelessWidget {
  final productoProvider = ProductosProvider();

  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto'),
    );
  }

  _crearListado() {
    return FutureBuilder<List<ProductoModel>>(
      future: ProductosProvider().cargarProductos(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, i) =>
                  _crearItem(context, snapshot.data![i]));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _crearItem(BuildContext context, ProductoModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: (direccion) {
          // print(producto.id);
          ProductosProvider().eliminarProductos(producto.id.toString());
        },
        child: Card(
          child: Column(
            children: [
              (producto.fotoUrl == null)
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      image: NetworkImage(producto.fotoUrl.toString()),
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text('${producto.id}'),
                onTap: () => Navigator.pushNamed(context, 'producto',
                    arguments: producto),
              ),
            ],
          ),
        ));
    // ListTile(
    //     title: Text('${producto.titulo} - ${[producto.valor]}'),
    //     subtitle: Text(producto.id.toString()),
    //     onTap: () =>
    //         Navigator.pushNamed(context, 'producto', arguments: producto),
    //   ),
  }
}
