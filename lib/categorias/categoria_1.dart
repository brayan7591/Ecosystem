import 'package:flutter/material.dart';

class RedSocialScreen extends StatefulWidget {
  @override
  _RedSocialScreenState createState() => _RedSocialScreenState();
}

class _RedSocialScreenState extends State<RedSocialScreen> {
  // Lista de publicaciones (puedes reemplazar con datos reales)
  List<Post> posts = [
    Post(
      id: 1,
      title: 'Publicación 1',
      content: 'Contenido de la publicación 1...',
      user: 'Usuario A',
      date: '1 de enero de 2024',
      likes: 0,
    ),
    Post(
      id: 2,
      title: 'Publicación 2',
      content: 'Contenido de la publicación 2...',
      user: 'Usuario B',
      date: '2 de enero de 2024',
      likes: 0,
    ),
    // Agrega más publicaciones según sea necesario
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Red Social'),
      ),
      body: _buildSocialFeed(),
    );
  }

  Widget _buildSocialFeed() {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildPostCard(posts[index]);
      },
    );
  }

  Widget _buildPostCard(Post post) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              post.content,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Publicado por ${post.user}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'Fecha ${post.date}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      post.likes++; // Incrementa el conteo de likes
                    });
                  },
                  icon: Icon(Icons.thumb_up),
                  label: Text('${post.likes}'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Modelo de datos para las publicaciones
class Post {
  final int id;
  final String title;
  final String content;
  final String user;
  final String date;
  int likes;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.user,
    required this.date,
    required this.likes,
  });
}
