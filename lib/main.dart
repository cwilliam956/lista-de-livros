import 'package:flutter/material.dart';
import 'pagina1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prova Douglas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Olá,",
                          style: TextStyle(fontSize: 25, color: Colors.black45),
                        ),
                        Text(
                          "Visitante",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 35,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: TextField(
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: CircleAvatar(
                          child: Icon(Icons.search),
                        ),
                      ),
                      hintText: "Pesquisar Livros",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (query) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Pagina1(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Widget vermelho que leva para a Pagina1
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Pagina1(),
                    ),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
