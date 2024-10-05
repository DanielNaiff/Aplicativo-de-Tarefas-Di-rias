import 'package:aplicativo_de_tarefas_diarias/APIs/ListaSharedPreferences.dart';
import 'package:aplicativo_de_tarefas_diarias/models/listaModel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Creating_todo_screen extends StatefulWidget {
  final Function onToggleTheme; // Função para alternar o tema
  final bool isDarkTheme; // Variável para verificar se o tema é escuro

  // Construtor para as variáveis que mudam o tema
  const Creating_todo_screen({
    Key? key,
    required this.onToggleTheme,
    required this.isDarkTheme,
  }) : super(key: key);

  @override
  State<Creating_todo_screen> createState() => _Creating_todo_screenState();
}

class _Creating_todo_screenState extends State<Creating_todo_screen> {
  // Variáveis que controlam as variáveis do formulário
  final TextEditingController descricao = TextEditingController();
  final TextEditingController titulo = TextEditingController();
  final TextEditingController data = TextEditingController();

  List<ListaModel> tarefa = []; // Lista de tarefas

  @override
  void dispose() {
    titulo.dispose(); // Libera o controlador do título
    data.dispose(); // Libera o controlador da data
    descricao.dispose(); // Libera o controlador da descrição
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _carregarTarefas(); // Carrega as tarefas quando o estado é inicializado
  }

  void _carregarTarefas() async {
    tarefa = await shared_pref_api()
        .getList(); // Carrega a lista de tarefas do SharedPreferences
    print(
        "Tarefas carregadas: $tarefa"); // Log para verificar se as tarefas foram carregadas
    setState(() {}); // Atualiza a interface
  }

  void _SalvarTarefa() {
    if (_validacaoInputs()) {
      // Valida os inputs
      // Adiciona nova tarefa
      tarefa.add(ListaModel(
        id: _getId(),
        titulo: titulo.text,
        data: data.text,
        descricao: descricao.text,
      ));
      shared_pref_api()
          .salvarLista(tarefa); // Salva a lista de tarefas no SharedPreferences
      print(
          "Nova tarefa adicionada: $tarefa"); // Log para verificar se a tarefa foi salva
      setState(() {});
      Navigator.pop(context); // Fecha a tela de criação de tarefas
    }
  }

  // Função que valida as diversas possibilidades do usuário errar no formulário
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
    return true; // Retorna true se todos os campos forem preenchidos
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Obtém o ID
  int _getId() {
    int max = 0; // Variável para armazenar o maior ID
    for (var tarefa in tarefa) {
      if (tarefa.id > max) {
        max = tarefa.id; // Atualiza o maior ID
      }
    }
    return max + 1; // Retorna o próximo ID disponível
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
            onPressed: () =>
                widget.onToggleTheme(), // Alterna o tema ao clicar no botão
          ),
        ],
      ),
      body: Container(
        color: widget.isDarkTheme
            ? Colors.grey[850]
            : Colors.white, // Define a cor do fundo de acordo com o tema
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 25),
              child: Text(
                "Adicione uma tarefa",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: widget.isDarkTheme
                      ? Colors.white
                      : Colors.black, // Cor do texto de acordo com o tema
                ),
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
                  borderSide: const BorderSide(color: Colors.deepOrange),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: data, // Controlador para o campo de data
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
                  borderSide: const BorderSide(color: Colors.deepOrange),
                ),
              ),
              readOnly: true, // Campo somente leitura
              onTap: () async {
                // Calendário para escolher a data
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(), // Data inicial
                  firstDate: DateTime.now(), // Data mínima
                  lastDate: DateTime(DateTime.now().year + 1), // Data máxima
                );
                if (pickedDate != null) {
                  String formattedDate = DateFormat('yyyy-MM-dd')
                      .format(pickedDate); // Formata a data
                  setState(() {
                    data.text = formattedDate; // Atualiza o campo de data
                  });
                } else {
                  _showSnackBar('Data não selecionada!');
                }
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: descricao, // Controlador para o campo de descrição
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
                  borderSide: const BorderSide(color: Colors.deepOrange),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
