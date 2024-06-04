import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'Post.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _urlBase = "https://jsonplaceholder.typicode.com";
  var _urlPost = "/posts";
  var _paramId = "/1";

  Future<List<Post>> _getPosts() async {
    http.Response response = await http.get(Uri.parse(_urlBase + _urlPost));
    var dadosJson = json.decode(response.body);
    List<Post> _listaPost = [];

    for (var post in dadosJson) {
      Post p =
          Post(post["userId"], post["title"], post["body"], id: post["id"]);
      _listaPost.add(p);
    }
    return _listaPost;
  }

  _post() async {
    Post post = Post(1, "Título", "Corpo");
    var corpo = json.encode(post.toJson());

    http.Response response = await http.post(Uri.parse(_urlBase + _urlPost),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: corpo);
    if (response.statusCode == 201) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Salvo"),
              content: Text("Salvo como sucesso"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Fechar"))
              ],
            );
          });
    }
  }

  _put() async {
    Post post = Post(1, "Título", "Corpo", id: 1);
    var corpo = json.encode(post.toJson());

    http.Response response =
        await http.put(Uri.parse(_urlBase + _urlPost + _paramId),
            headers: {
              'Content-type': 'application/json; charset=UTF-8',
            },
            body: corpo);

    if (response.statusCode == 200) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Atualizado"),
              content: Text("Atualizado como sucesso"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Fechar"))
              ],
            );
          });
    }
  }

  _remover() async {
    http.Response response = await http.delete(
      Uri.parse(_urlBase + _urlPost + _paramId),
    );

    if (response.statusCode == 200) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Removido"),
              content: Text("Removido como sucesso"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Fechar"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Consumo API Placeholder"),
          backgroundColor: Colors.cyan[100],
        ),
        body: Container(
          padding: EdgeInsets.all(18),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        onPressed: _post,
                        label: Text("Salvar"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: ElevatedButton.icon(
                          icon: const Icon(Icons.update),
                          onPressed: _put,
                          label: Text("Atualizar")),
                    ),
                    ElevatedButton.icon(
                        icon: const Icon(Icons.delete),
                        onPressed: _remover,
                        label: Text("Remover"))
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Post>>(
                  future: _getPosts(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case (ConnectionState.none):
                      case (ConnectionState.active):
                      case (ConnectionState.waiting):
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                        break;
                      case (ConnectionState.done):
                        return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              List<Post> lista = snapshot.data as List<Post>;
                              Post post = lista[index];

                              return ListTile(
                                title: Text(post.title),
                                subtitle: Text(post.id.toString()),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(post.id.toString()),
                                          content: Text(post.title),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Fechar"))
                                          ],
                                        );
                                      });
                                },
                              );
                            });
                        break;
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }
}
