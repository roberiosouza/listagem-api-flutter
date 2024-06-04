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

  Future<List<Post>> _getPosts() async {
    http.Response response = await http.get(Uri.parse(_urlBase + _urlPost));
    var dadosJson = json.decode(response.body);
    List<Post> _listaPost = [];

    for (var post in dadosJson) {
      Post p = Post(post["id"], post["userId"], post["title"], post["body"]);
      _listaPost.add(p);
    }
    return _listaPost;
  }

  Future _post() async {
    var corpo = json.encode({
      "title": "Título",
      "body": "Corpo",
      "userId": 1,
    });

    http.Response response = await http.post(Uri.parse(_urlBase + _urlPost),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: corpo);

    print("resposta: " + response.statusCode.toString());
    print("resposta: " + response.body);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: _post, child: Text("Salvar")),
                  ElevatedButton(onPressed: () {}, child: Text("Atualizar")),
                  ElevatedButton(onPressed: () {}, child: Text("Remover"))
                ],
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
