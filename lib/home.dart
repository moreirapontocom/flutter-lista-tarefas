import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List tarefas = [];

  TextEditingController _novoItemController = TextEditingController();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File( diretorio.path + "/dados.json" );
  }

  _salvarArquivo() async {

    var arquivo = await _getFile();

    Map<String, dynamic> tarefa = Map();

    tarefa['titulo'] = _novoItemController.text;
    tarefa['concluido'] = false;
    tarefas.add(tarefa);

    String dados = json.encode(tarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {

    try {
      
      var arquivo = await _getFile();
      return arquivo.readAsString();

    } catch (e) {
      return null;
    }

  }

  @override
  void initState() {
    super.initState();

    _lerArquivo().then((dados) {
      setState(() {
        tarefas = json.decode(dados);
      });
    });

    // Não dá pra usar da forma abaixo pois o await só pode ser utilizado dentro de uma função async que retorne algum Future<>
    // Aqui é o initState, não pode esperar
    // var itens = await _lerArquivo();
  }

  @override
  Widget build(BuildContext context) {

    // _salvarArquivo();
    print(tarefas.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.purple,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {

          showDialog(
            context: context,
            builder: (context) {

              return AlertDialog(
                title: Text("Adicionar"),
                content: TextField(
                  controller: _novoItemController,
                  decoration: InputDecoration(
                    labelText: "Descrição da tarefa"
                  ),
                ),
                actions: <Widget>[
                  RaisedButton(
                    color: Colors.purple,
                    child: Text("Adicionar", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _salvarArquivo();
                      Navigator.pop(context);
                    },
                  )
                ],
              );

            }
          );

        },
      ),

      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[

            Expanded(
              child: ListView.builder(
                itemCount: tarefas.length,
                itemBuilder: (context, index) {

                  return ListTile(
                    title: Text( tarefas[index]['titulo'] )
                  );

                },
              ),
            )

          ],
        ),
      ),

    );
  }
}

/*
ListView.builder(
  itemCount: tarefas.length,
  itemBuilder: (context, index) {

    return ListTile(
      title: Text( tarefas[index] ),
      trailing: Checkbox(
        value: _valor,
        onChanged: (bool value) {
          print("Checkbox ID " + index.toString() + ". VALUE: " + value.toString());
          setState(() {
            _valor = value;
          });
        },
      ),
    );

  },
)
*/