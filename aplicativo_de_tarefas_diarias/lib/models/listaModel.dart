import 'dart:convert'; // importa a biblioteca para manipulação de JSON

// Funcão que converte uma string JSON em uma lsta de objetos ListaModel
List<ListaModel> postModelFromJson(String palavra) => List<ListaModel>.from(
    json.decode(palavra).map((j) => ListaModel.fromJson(j)));

// Função que converte uma lista de objetos ListaModel em uma string JSON
String postModelToJson(List<ListaModel> data) =>
    json.encode(List<dynamic>.from(data.map((e) => e.toJson())));

// Classe que representa um modelo de tarefa
class ListaModel {
  // Construtor da classe, onde todos os parâmetros são obrigatórios, exceto 'concluida', que tem um valor padrão
  ListaModel({
    required this.id,
    required this.descricao,
    required this.data,
    required this.titulo,
    this.concluida = false, // Inicializa como falsa se não for especificado
  });

  int id;
  String titulo;
  String descricao;
  String data;
  bool concluida;

  // Método que cria uma instância de ListaModel a partir de um objeto JSON
  factory ListaModel.fromJson(Map<String, dynamic> json) => ListaModel(
        id: json['id'],
        descricao: json['descricao'],
        data: json['data'],
        titulo: json['titulo'],
        concluida: json['concluida'] ?? false,
      );

  // Método que converte a instância de ListaModel em um objeto JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "descricao": descricao,
        "data": data,
        "titulo": titulo,
        "concluida": concluida,
      };
}
