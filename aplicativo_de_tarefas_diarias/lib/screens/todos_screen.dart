import 'package:flutter/material.dart';
import 'creating_todo_screen.dart';
import 'package:aplicativo_de_tarefas_diarias/APIs/ListaSharedPreferences.dart';
import 'package:aplicativo_de_tarefas_diarias/models/listaModel.dart';

class Todos_screen extends StatefulWidget {
  final Function onToggleTheme; // Função para alternar o tema
  final bool isDarkTheme; // Variável para verificar se o tema é escuro

  // Construtor para as variáveis que mudam o tema
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
    _carregarTarefas(); // Carrega as tarefas ao iniciar o estado
  }

  // A criação dessa função foi necessária para carregar os dados das tarefas, após a mudança entre telas
  void _carregarTarefas() async {
    List<ListaModel> tarefasRecuperadas = await shared_pref_api()
        .getList(); // Recupera a lista de tarefas do SharedPreferences
    tarefa = tarefasRecuperadas.map((t) {
      return ListaModel(
        id: t.id,
        titulo: t.titulo,
        data: t.data,
        descricao: t.descricao,
        concluida: t.concluida ?? false, // Define um padrão se for null
      );
    }).toList();
    setState(() {}); // Atualiza a interface com as tarefas carregadas
  }

  // Função responsável por mostrar a descrição ao clicar em um card
  void _mostrarDescricao(ListaModel tarefa) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            tarefa.titulo,
            style: TextStyle(
              fontSize: 24 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.bold,
              color: widget.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          content: Text(tarefa.descricao),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
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
          // Ícone de mudança de tema
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => widget.onToggleTheme(),
          ),
        ],
      ),
      body: Container(
        color: widget.isDarkTheme ? Colors.grey[850] : Colors.white,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Lista de tarefas',
                        style: TextStyle(
                          fontSize: 26 * MediaQuery.of(context).textScaleFactor,
                          fontWeight: FontWeight.bold,
                          color:
                              widget.isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: tarefa.length, // Conta o número de tarefas
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        // Botão para mostrar a descrição
                        onTap: () => _mostrarDescricao(tarefa[
                            index]), // Mostra a descrição da tarefa ao clicar
                        child: Card(
                          elevation: 10,
                          color: widget.isDarkTheme
                              ? Colors.grey[800]
                              : Colors.white,
                          margin: const EdgeInsets.all(5),
                          child: SizedBox(
                            height: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tarefa[index]
                                              .titulo, // Título da tarefa
                                          style: TextStyle(
                                            fontSize: 20 *
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
                                            color: widget.isDarkTheme
                                                ? Colors.white
                                                : Colors.black,
                                            decoration: tarefa[index].concluida
                                                ? TextDecoration.lineThrough
                                                : null,
                                          ),
                                        ),
                                        Text(
                                          'Prazo final: ${tarefa[index].data}', // Prazo da tarefa
                                          style: TextStyle(
                                            fontSize: 16 *
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
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
                                  tarefa[index].concluida
                                      ? "Concluída"
                                      : "Pendente",
                                  style: TextStyle(
                                    fontSize: 14 *
                                        MediaQuery.of(context).textScaleFactor,
                                    fontWeight: FontWeight.bold,
                                    color: tarefa[index].concluida
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                Checkbox(
                                  value: tarefa[index]
                                      .concluida, // Checkbox para marcar a tarefa como concluída
                                  onChanged: (bool? value) {
                                    setState(() {
                                      tarefa[index].concluida =
                                          value!; // Atualiza o status da tarefa
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
                                      final tarefaRemovida = tarefa[
                                          index]; // Armazena a tarefa que será removida

                                      // Imprimir antes da remoção
                                      print('Antes da remoção: $tarefa');

                                      // Remove a tarefa da lista local
                                      setState(() {
                                        tarefa.removeAt(index);
                                      });

                                      // Remove a tarefa da lista persistente
                                      shared_pref_api().deletarLista(
                                          tarefa, tarefaRemovida.id);

                                      // Imprimir depois da remoção
                                      print('Depois da remoção: $tarefa');

                                      // Mostrar mensagem de confirmação
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Tarefa deletada!')), // Mensagem de feedback
                                      );
                                    } else {
                                      print(
                                          'A lista de tarefas está vazia.'); // Mensagem de log se a lista estiver vazia
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Botão que leva para a página de edição
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Creating_todo_screen(
                onToggleTheme:
                    widget.onToggleTheme, // Passa a função de alternar tema
                isDarkTheme: widget.isDarkTheme, // Passa o estado do tema
              ),
            ),
          ).then((_) {
            _carregarTarefas(); // Atualiza a lista de tarefas ao retornar
          });
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add, color: Colors.white), // Ícone de adicionar
      ),
    );
  }
}
