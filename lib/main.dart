import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dizi Karakterleri Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic>? _characters = [];
  String _searchText = '';

  void fetchCharacters() async {
    var url =
    Uri.https('raw.githubusercontent.com', '/codermert/image-name-changer/main/palpitokarakter.json');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _characters = json.decode(response.body)['characters'];
      });
    } else {
      print('Veriler çekilemedi. Hata Kodu: ${response.statusCode}');
    }
  }

  List<dynamic> get filteredCharacters {
    if (_searchText.isEmpty) {
      return _characters ?? [];
    } else {
      return _characters!
          .where((char) => char['name'].toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pálpito Dizi Karakterleri'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Pálpito dizi oyuncusu arayın...',
                border: OutlineInputBorder(),
              ),
              onChanged: (text) {
                setState(() {
                  _searchText = text;
                });
              },
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              padding: const EdgeInsets.all(8),
              children: List.generate(filteredCharacters.length, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(character: filteredCharacters[index]),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          filteredCharacters[index]['img'],
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                filteredCharacters[index]['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final dynamic character;

  const DetailPage({required this.character, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character['name']),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(character['img']),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: CircleAvatar(
          radius: 110.0,
          backgroundImage: NetworkImage(character['img']),
        ),
      ),
    ),
    SizedBox(height: 16),
    ListTile(
    leading: Icon(Icons.person),
    title: Text('Karakter'),
    subtitle: Text(character['name']),
    ),
    Divider(),
    ListTile(
    leading: Icon(Icons.star),
    title: Text('Oyuncu'),
    subtitle: Text(character['actor']),
    ),
    Divider(),
    ListTile
      (
      leading: Icon(Icons.description),
      title: Text('Detaylı Sayfa'),
      subtitle: Text(character['summary']),
    ),
        SizedBox(height: 26),
      ],
      ),
      ),
    );
  }
}