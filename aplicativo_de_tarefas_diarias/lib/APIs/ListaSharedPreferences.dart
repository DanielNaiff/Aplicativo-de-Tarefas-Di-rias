import 'dart:convert';

import 'package:aplicativo_de_tarefas_diarias/models/listaModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

const key = 'todo_list';

class shared_pref_api {
  Future<List<ListaModel>> getList() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    final jsonString = sf.getString(key) ?? '[]';
    final jsonDecoded = json.decode(jsonString) as List;

    return jsonDecoded
        .map(
          (e) => ListaModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  void salvarLista(List<ListaModel> todos) async {
    final stringJson = json.encode(todos);
    SharedPreferences sf = await SharedPreferences.getInstance();
    sf.setString(key, stringJson);
  }

  void atualizarLista(List<ListaModel> todos, int id, String titulo,
      String data, String descricao) async {
    for (var i in todos) {
      if (i.id == id) {
        i.titulo = titulo;
        i.data = data;
        i.descricao = descricao;
      }
    }
    salvarLista(todos);
  }
}
