import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'database_helper.dart';
import 'pagina2.dart';

class Pagina1 extends StatefulWidget {
  const Pagina1({super.key});

  @override
  _Pagina1State createState() => _Pagina1State();
}

class _Pagina1State extends State<Pagina1> {
  List books = [];
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;
  String errorMessage = '';


  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchBooks([String query = ""]) async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final String url =
        'https://www.googleapis.com/books/v1/volumes?q=${query.isEmpty ? 'books' : query}';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            books = data['items'] ?? [];
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Erro ao buscar dados: ${response.reasonPhrase}';
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMessage = 'Erro ao conectar: $error';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _addBookToReadingList(Map<String, dynamic> book) async {
    final bookToSave = {
      'id': book['id'],
      'title': book['volumeInfo']['title'] ?? 'Sem título',
      'authors':
          book['volumeInfo']['authors']?.join(', ') ?? 'Autor desconhecido',
      'thumbnail': book['volumeInfo']['imageLinks']?['thumbnail']
    };
    await DatabaseHelper().addBook(bookToSave);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livro adicionado à lista de leitura!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar Livros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Pesquisar livros ou autores",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    fetchBooks();
                  },
                ),
              ),
              onSubmitted: (query) {
                fetchBooks(query);
              },
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage.isNotEmpty)
              Center(
                  child: Text(errorMessage,
                      style: const TextStyle(color: Colors.red)))
            else if (books.isEmpty)
              const Center(child: Text('Nenhum livro encontrado.')),
            if (books.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index]['volumeInfo'];
                    return ListTile(
                      title: Text(book['title'] ?? 'Sem título'),
                      subtitle: Text(
                          book['authors']?.join(', ') ?? 'Autor desconhecido'),
                      leading: book['imageLinks'] != null
                          ? Image.network(book['imageLinks']['thumbnail'],
                              fit: BoxFit.cover, width: 50)
                          : const Icon(Icons.book, size: 50),
                      trailing: IconButton(
                        icon: const Icon(Icons.add, color: Colors.green),
                        onPressed: () {
                          _addBookToReadingList(books[index]);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Pagina2(book: books[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
