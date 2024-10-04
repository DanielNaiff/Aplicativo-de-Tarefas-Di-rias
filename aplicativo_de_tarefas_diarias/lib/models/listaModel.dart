import 'dart:convert';

List<ListaModel> postModelFromJson(String palavra) => List<ListaModel>.from(
    json.decode(palavra).map((j) => ListaModel.fromJson(j)));

String postModelToJson(List<ListaModel> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

class ListaModel {
  ListaModel({
    required this.id,
    required this.descricao,
    required this.data,
    required this.titulo,
  });
  int id;
  String titulo;
  String descricao;
  String data;

  factory ListaModel.fromJson(Map<String, dynamic> json) => ListaModel(
      id: json['id'],
      descricao: json['descricao'],
      data: json['data'],
      titulo: json['titulo']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "descricao": descricao,
        "data": data,
        "titulo": titulo,
      };
}
