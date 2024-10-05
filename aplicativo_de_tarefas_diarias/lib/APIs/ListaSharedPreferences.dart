import 'dart:convert'; // mporta a biblioteca para manipulação de JSON
import 'package:aplicativo_de_tarefas_diarias/models/listaModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

const key =
    'tarefa_lista'; // Define uma constante para a chave de armazenamento

// Classe que encapsula a lógica de interação com SharedPreferences
class shared_pref_api {
  // Método assíncrono para recuperar a lista de tarefas
  Future<List<ListaModel>> getList() async {
    SharedPreferences sf = await SharedPreferences
        .getInstance(); // Obtém a instância de SharedPreferences
    final jsonString = sf.getString(key) ??
        '[]'; // Obtém a string JSON armazenada ou retorna uma lista vazia
    final jsonDecoded = json.decode(jsonString)
        as List; // Decodifica a string JSON em uma lista

    // Converte a lista decodificada em uma lista de objetos ListaModel
    return jsonDecoded
        .map((e) => ListaModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // método para salvar a lista de tarefas
  void salvarLista(List<ListaModel> todos) async {
    final stringJson = json.encode(todos); // Codfica a lista de tarefas em JSON
    SharedPreferences sf = await SharedPreferences
        .getInstance(); // Obtém a instância de SharedPreferences
    sf.setString(key, stringJson); // Armazena a string JSON
    print(
        "Tarefas salvas: $todos"); // Print para verificar se as tarefas estão sendo salvas
  }

  // metodo para atualizar uma tarefa específica na lista
  void atualizarLista(List<ListaModel> todos, int id, String titulo,
      String data, String descricao) async {
    // itera sobre as tarefas para encontrar a que precisa ser atualizada
    for (var i in todos) {
      if (i.id == id) {
        i.titulo = titulo; // Atualiza o título
        i.data = data; // Atualiza a data
        i.descricao = descricao; // Atualiza a descrição
      }
    }
    salvarLista(todos); // Salva a lista atualizada
  }

  // Método para deletar uma tarefa da lista
  void deletarLista(List<ListaModel> todos, int id) {
    // Remove a tarefa da lista com base no ID
    todos.removeWhere((tarefa) => tarefa.id == id);
    salvarLista(todos); // Atualiza a persistência
  }
}
