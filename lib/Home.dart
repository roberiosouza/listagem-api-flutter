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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo API Placeholder"),
      ),
      body: FutureBuilder<List<Post>>(
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
                    );
                  });
              break;
          }
        },
      ),
    );
  }
}
