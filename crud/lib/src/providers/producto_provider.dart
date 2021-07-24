import 'dart:convert';
import 'dart:io';

// import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:formaulario_y_bloc/src/models/productoModel.dart';
import 'package:mime_type/mime_type.dart';

class ProductosProvider {
  final String _url =
      'https://flutter-productos-e0a42-default-rtdb.firebaseio.com/';

  get id => null;

  // ya puedo hacer GET POST PUT ... todas las peticiones que quiero

  // creo un producto con un POST
  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json';

    // en el body mando todo lo que qquiero mandar
    final resp =
        await http.post(Uri.parse(url), body: productoModelToJson(producto));

    // puedo resivir un error o algo, asi que me fijo que tiene
    final decodeData = json.decode(resp.body);
    print(decodeData);
    return true;
  }
  // Me traigo un producto con un GET

  Future<List<ProductoModel>> cargarProductos() async {
    final url = "$_url/productos.json";
    List<ProductoModel> productos = [];
    final resp = await http.get(Uri.parse(url));

    Map<String, dynamic> decodeData = json.decode(resp.body);

    if (decodeData == null) {
      return [];
    } else {
      decodeData.forEach((id, prod) {
        final prodTemp = ProductoModel.fromJson(prod);
        prodTemp.id = id;
        productos.add(prodTemp);

        // return productos;
      });
      // print(productos);
      return productos;
    }
  }

// edito con PUT
  Future<bool> editarProducto(ProductoModel producto) async {
    final url = "$_url/productos/${producto.id}.json";

    final resp =
        await http.put(Uri.parse(url), body: productoModelToJson(producto));

    // puedo resivir un error o algo, asi que me fijo que tiene
    final decodeData = json.decode(resp.body);
    print(decodeData);
    return true;
  }

// borro con DELETE
  Future<int> eliminarProductos(String id) async {
    final url = "$_url/productos/$id.json";
    final resp = await http.delete(Uri.parse(url));

    print(json.decode(resp.body));
    return 1;
  }

  // subo la imagen y me responde una url donde se aloja , con POST FORM (osea me responde un string)
  Future<String?> subirImagen(File imagen) async {
    // le paso la url
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dxfyhgbhj/image/upload?upload_preset=e1j7ed8e');

    // necesito saber que formato tiene (si jpg, png...etc) lo hago con la libreria mime_type: ^1.0.0
    final mimeType = mime(imagen.path)!.split('/');
    print(mimeType);

    // hago un Multipart Request ya que voy a tener que usar un form un post y varias cosas
    final imageUploadRequest = http.MultipartRequest('POST', url);
    // 'file' es la key ...
    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    // uno las dos cosas
    imageUploadRequest.files.add(file);

    // ahora envio todo
    final stramRequest = await imageUploadRequest.send();
    // recibo la respuesta
    final resp = await http.Response.fromStream(stramRequest);

    // veo si la respuesta me devuelve error lo imprimo sino
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }
    // tomo la respuesta y la decodifico en json
    final respData = json.decode(resp.body);

    print(respData);
    // solo tomo lo que me importa que es el sercure_url (la url de la foto)
    return respData['secure_url'];
  }
}
