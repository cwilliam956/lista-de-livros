import 'package:flutter/material.dart';

class Pagina2 extends StatelessWidget {
  final Map<String, dynamic> book;

  const Pagina2({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    final volumeInfo = book['volumeInfo'];
    final title = volumeInfo['title'] ?? 'Sem título';
    final authors = volumeInfo['authors']?.join(', ') ?? 'Autor desconhecido';
    final description = volumeInfo['description'] ?? 'Sem descrição disponível';
    final categories =
        volumeInfo['categories']?.join(', ') ?? 'Categoria desconhecida';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (volumeInfo['imageLinks'] != null)
              Center(
                child: Image.network(
                  volumeInfo['imageLinks']['thumbnail'],
                  fit: BoxFit.cover,
                  height: 200,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              'Título: $title',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Autor(es): $authors',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Categoria(s): $categories',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Descrição:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(description),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
