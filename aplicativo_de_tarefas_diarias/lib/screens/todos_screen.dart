import 'package:flutter/material.dart';
import 'creating_todo_screen.dart';
import 'package:aplicativo_de_tarefas_diarias/APIs/ListaSharedPreferences.dart';
import 'package:aplicativo_de_tarefas_diarias/models/listaModel.dart';

class Todos_screen extends StatefulWidget {
  final Function onToggleTheme;
  final bool isDarkTheme;

  const Todos_screen({
    Key? key,
    required this.onToggleTheme,
    required this.isDarkTheme,
  }) : super(key: key);

  @override
  State<Todos_screen> createState() => _Todos_screenState();
}

class _Todos_screenState extends State<Todos_screen> {
  List<ListaModel> tarefa = []; // Lista de tarefas

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  void _carregarTarefas() async {
    List<ListaModel> tarefasRecuperadas = await shared_pref_api().getList();
    tarefa = tarefasRecuperadas.map((t) {
      return ListaModel(
        id: t.id,
        titulo: t.titulo,
        data: t.data,
        descricao: t.descricao,
        concluida: t.concluida ?? false, // Define um padrão se for null
      );
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Center(
          child: Text(
            'Aplicativo de Tarefas Diárias',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => widget.onToggleTheme(),
          ),
        ],
      ),
      body: Container(
        color: widget.isDarkTheme ? Colors.grey[850] : Colors.white,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Lista de tarefas',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tarefa.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10,
                    color: widget.isDarkTheme ? Colors.grey[800] : Colors.white,
                    margin: const EdgeInsets.all(5),
                    child: Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tarefa[index].titulo,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: widget.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                      decoration: tarefa[index].concluida
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    'Prazo final: ' + tarefa[index].data,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: widget.isDarkTheme
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            tarefa[index].concluida ? "Concluída" : "Pendente",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: tarefa[index].concluida
                                    ? Colors.green
                                    : Colors.red),
                          ),
                          Checkbox(
                            value: tarefa[index].concluida,
                            onChanged: (bool? value) {
                              setState(() {
                                tarefa[index].concluida = value!;
                              });
                              shared_pref_api().salvarLista(
                                  tarefa); // Atualiza a lista persistente
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.deepOrange),
                            onPressed: () {
                              if (tarefa.isNotEmpty) {
                                final tarefaRemovida = tarefa[index];

                                // Imprimir antes da remoção
                                print('Antes da remoção: $tarefa');

                                // Remover a tarefa da lista local
                                setState(() {
                                  tarefa.removeAt(index);
                                });

                                // Remover a tarefa da lista persistente
                                shared_pref_api()
                                    .deletarLista(tarefa, tarefaRemovida.id);

                                // Imprimir depois da remoção
                                print('Depois da remoção: $tarefa');

                                // Mostrar mensagem de confirmação
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Tarefa deletada!')),
                                );
                              } else {
                                print('A lista de tarefas está vazia.');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Creating_todo_screen(
                onToggleTheme: widget.onToggleTheme,
                isDarkTheme: widget.isDarkTheme,
              ),
            ),
          ).then((_) {
            _carregarTarefas(); // Atualiza a lista de tarefas ao retornar
          });
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
