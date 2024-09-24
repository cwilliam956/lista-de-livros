import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Pagina1 extends StatefulWidget {
  @override
  _Pagina1State createState() => _Pagina1State();
}

class _Pagina1State extends State<Pagina1> {
  List books = [];
  TextEditingController _searchController = TextEditingController();
  bool isLoading = true; // Para mostrar um indicador de carregamento
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchBooks(); // Carregar todos os livros ao inicializar a página
  }

  // Função para buscar livros pela API do Google Books
  Future<void> fetchBooks([String query = ""]) async {
    setState(() {
      isLoading = true; // Mostra o indicador de carregamento
      errorMessage = ''; // Limpa mensagens de erro
    });

    // URL para buscar todos os livros disponíveis (usando um termo mais abrangente, como 'books')
    final String url = 'https://www.googleapis.com/books/v1/volumes?q=${query.isEmpty ? 'books' : query}';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          books = data['items'] ?? [];
        });
      } else {
        setState(() {
          errorMessage = 'Erro ao buscar dados: ${response.reasonPhrase}';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Erro ao conectar: $error';
      });
    } finally {
      setState(() {
        isLoading = false; // Para de mostrar o indicador de carregamento
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros - Google Books'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            // Campo de pesquisa
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Pesquisar livros ou autores",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    fetchBooks(); // Limpa o campo e recarrega todos os livros
                  },
                ),
              ),
              onSubmitted: (query) {
                fetchBooks(query); // Busca com base no texto inserido
              },
            ),
            const SizedBox(height: 20),
            // Verifica se está carregando ou se há erros
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (errorMessage.isNotEmpty)
              Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
            else if (books.isEmpty)
              const Center(child: Text('Nenhum livro encontrado.')),
            // Lista de livros
            if (books.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index]['volumeInfo'];
                    return ListTile(
                      title: Text(book['title'] ?? 'Sem título'),
                      subtitle: Text(book['authors'] != null
                          ? book['authors'].join(', ')
                          : 'Autor desconhecido'),
                      leading: book['imageLinks'] != null
                          ? Image.network(
                              book['imageLinks']['thumbnail'],
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            )
                          : const Icon(Icons.book),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
