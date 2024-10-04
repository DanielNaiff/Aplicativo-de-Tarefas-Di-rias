import 'package:aplicativo_de_tarefas_diarias/APIs/ListaSharedPreferences.dart';
import 'package:aplicativo_de_tarefas_diarias/models/listaModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Creating_todo_screen extends StatefulWidget {
  final Function onToggleTheme;
  final bool isDarkTheme;

  const Creating_todo_screen({
    Key? key,
    required this.onToggleTheme,
    required this.isDarkTheme,
  }) : super(key: key);

  @override
  State<Creating_todo_screen> createState() => _Creating_todo_screenState();
}

class _Creating_todo_screenState extends State<Creating_todo_screen> {
  final TextEditingController descricao = TextEditingController();
  final TextEditingController titulo = TextEditingController();
  final TextEditingController data = TextEditingController();

  void _SalvarOuEditarTarefa() {
    if (_validacaoInputs()) {
      if (!editada) {
        // Adicionar nova tarefa
        tarefa.add(ListaModel(
          id: getid(),
          titulo: titulo.text,
          data: data.text,
          descricao: descricao.text,
        ));
        shared_pref_api().salvarLista(tarefa);
      } else {
        // Atualizar tarefa existente
        shared_pref_api().atualizarLista(
          tarefa,
          id,
          titulo.text,
          data.text,
          descricao.text,
        );
        setState(() {
          id = 0;
          editada = false;
        });
      }
      populateList();
      Navigator.pop(context);
    }
  }

  bool _validacaoInputs() {
    if (titulo.text.isEmpty) {
      _showSnackBar('Está faltando o título');
      return false;
    }
    if (data.text.isEmpty) {
      _showSnackBar('Está faltando a data');
      return false;
    }
    if (descricao.text.isEmpty) {
      _showSnackBar('Está faltando a descrição');
      return false;
    }
    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  List<ListaModel> tarefa = [];
  bool carregada = false;
  bool editada = false;
  int id = 0;

  @override
  void dispose() {
    titulo.dispose();
    data.dispose();
    descricao.dispose();
    super.dispose();
  }

  @override
  void initState() {
    populateList();
  }

  populateList() async {
    tarefa = await shared_pref_api().getList();
    if (tarefa != null) {
      setState(() {
        carregada = true;
      });
    }
  }

  getid() {
    int max = 0;
    List<int> ids = [];
    if (tarefa != null) {
      for (var i in tarefa) {
        ids.add(i.id.toInt());
      }
      for (int i in ids) {
        if (i > max) {
          max = i;
        }
      }
      return max + 1;
    } else {
      return 0;
    }
  }

  deleteTaks(int id) {
    for (var i in tarefa) {
      if (i.id == id) {
        tarefa.remove(i);
        break;
      }
    }
    shared_pref_api().salvarLista(tarefa);
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25, top: 25),
              child: Text(
                "Adicione uma tarefa",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: titulo,
              decoration: InputDecoration(
                hintText: 'Digite o título',
                labelText: 'Título',
                labelStyle: TextStyle(
                    color: widget.isDarkTheme ? Colors.white : Colors.black),
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.title, color: Colors.deepOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: data,
              decoration: InputDecoration(
                constraints: BoxConstraints(maxHeight: 50),
                hintText: 'Escolha uma data',
                labelText: 'Data',
                labelStyle: TextStyle(
                    color: widget.isDarkTheme ? Colors.white : Colors.black),
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon:
                    const Icon(Icons.calendar_month, color: Colors.deepOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    data.text = formattedDate;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data não selecionada!')));
                }
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: descricao,
              maxLines: 3,
              decoration: InputDecoration(
                constraints: const BoxConstraints(maxHeight: 150),
                hintText: 'Digite uma descrição',
                labelText: 'Descrição',
                labelStyle: TextStyle(
                    color: widget.isDarkTheme ? Colors.white : Colors.black),
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon:
                    const Icon(Icons.description, color: Colors.deepOrange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton.icon(
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.deepOrange),
                    ),
                    onPressed: _SalvarOuEditarTarefa,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton.icon(
                    style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.deepOrange),
                    ),
                    onPressed: () {
                      titulo.clear();
                      data.clear();
                      descricao.clear();
                    },
                    icon: const Icon(Icons.clear, color: Colors.white),
                    label: const Text(
                      'Limpar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
