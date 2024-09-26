import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'pagina1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Leitura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const Home(),
        '/reading-list': (context) => const ReadingListPage(),
        '/search-books': (context) => Pagina1(),
      },
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Leitura'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/reading-list');
              },
              child: const Text('Ver Lista de Leitura'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search-books');
              },
              child: const Text('Pesquisar Livros'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReadingListPage extends StatefulWidget {
  const ReadingListPage({super.key});

  @override
  _ReadingListPageState createState() => _ReadingListPageState();
}

class _ReadingListPageState extends State<ReadingListPage> {
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final data = await DatabaseHelper().getBooks();
    setState(() {
      books = data;
    });
  }

  Future<void> _removeBook(String id) async {
    await DatabaseHelper().removeBook(id);
    _loadBooks(); // Recarrega a lista de livros após a remoção
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Lista de Leitura'),
      ),
      body: books.isEmpty
          ? const Center(child: Text('Sua lista de leitura está vazia.'))
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(book['title'] ?? 'Sem título'),
                  subtitle: Text(book['authors'] ?? 'Autor desconhecido'),
                  leading: book['thumbnail'] != null
                      ? Image.network(book['thumbnail'], fit: BoxFit.cover)
                      : const Icon(Icons.book),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeBook(book['id']),
                  ),
                );
              },
            ),
    );
  }
}
