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

  List<ListaModel> tarefa = [];

  @override
  void dispose() {
    titulo.dispose();
    data.dispose();
    descricao.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  void _carregarTarefas() async {
    tarefa = await shared_pref_api().getList();
    print(
        "Tarefas carregadas: $tarefa"); // log para verificar se tarefa foi carregada
    setState(() {});
  }

  void _SalvarTarefa() {
    if (_validacaoInputs()) {
      // Adiciona nova tarefa
      tarefa.add(ListaModel(
        id: _getId(),
        titulo: titulo.text,
        data: data.text,
        descricao: descricao.text,
      ));
      shared_pref_api().salvarLista(tarefa);
      print(
          "Nova tarefa adicionada: $tarefa"); //log para verificar se a tarefa esta sendo salva
      setState(() {});
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

  int _getId() {
    int max = 0;
    for (var tarefa in tarefa) {
      if (tarefa.id > max) {
        max = tarefa.id;
      }
    }
    return max + 1;
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
                  _showSnackBar('Data não selecionada!');
                }
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: descricao,
              maxLines: 3,
              decoration: InputDecoration(
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
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    onPressed: _SalvarTarefa,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Salvar',
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
