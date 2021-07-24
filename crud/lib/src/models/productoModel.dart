import 'dart:convert';

// recibe un json y y lo transforma a un string
ProductoModel productoModelFromJson(String str) =>
    ProductoModel.fromJson(json.decode(str));

// hace lo contrario
String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  String? id;
  String? titulo;
  double? valor;
  bool? disponible;
  String? fotoUrl;

  ProductoModel({
    this.id,
    this.titulo = '',
    this.valor = 0.0,
    this.disponible = true,
    this.fotoUrl,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) =>
      new ProductoModel(
        id: json["id"],
        titulo: json["titulo"],
        valor: json["valor"],
        disponible: json["disponible"],
        fotoUrl: json["fotoUrl"],
      );

  Map<String, dynamic> toJson() => {
        // "id"         : id,
        "titulo": titulo,
        "valor": valor,
        "disponible": disponible,
        "fotoUrl": fotoUrl,
      };
}
