import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:api/Item.dart';

void main() {
  runApp(MyApp());
}

Future<List<Item>> fetchAlbum() async {
  final response = await http.get('http://192.168.1.231/shop/getItem.php');

  if (response.statusCode == 200) {
    List<Item> list = Item.parseItems(response.body);
    return list;

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Item>> futurePhoto;

  @override
  void initState() {
    super.initState();
    futurePhoto = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder<List<Item>>(
            future: futurePhoto,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                print("nope");
                return Center(child: CircularProgressIndicator());
              } else {
                print(snapshot.data);
                return Container(child: _albumGridView(snapshot.data));
              }
            },
          )
      ),
    );
  }
}

GridView _albumGridView(List<Item> data) {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemCount: data.length,
    padding: EdgeInsets.all(2.0),
    itemBuilder: (BuildContext context, int index) {
      return _tile(data[index].id.toString(), data[index].itemname, data[index].itemimage);
    },
  );
}

GridTile _tile(String id, String title, String photoUrl) => GridTile(
    child: InkWell(
        onTap: () => print("click"),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ], borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.network(photoUrl, fit: BoxFit.contain),
                      ),
                      Container(
                        child: Text(title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            )),
                      ),
                    ])))));
