import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto to Crypto Converter',
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => LoadPage(title: 'Crypto to Crypto Converter'),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/convert': (context) => ConvertPage(),
      },
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class LoadPage extends StatefulWidget {
  LoadPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _LoadPageState createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  bool loaded = false;
  bool connected = false;
  var jsonResponse;
  var response;
  @override
  void initState() {
    coins();
  }

  void coins() async {
    while (!connected) {
      try {
        var url = Uri.https("api.coingecko.com", "/api/v3/coins/list");
        response = await http.get(url);
        jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;
        connected = true;
      } catch (e) {
        print("Could not connect with API");
        connected = false;
      }
    }
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 300,
            color: Colors.amber,
          ),
          Expanded(
            child: loaded
                ?
                //set conditional with boolean isloading
                Text("loaded")
                : //on true
                SpinKitChasingDots(
                    color: Colors.white,
                    size: 150.0,
                  ), //on false
          ),
        ],
      ),
    );
  }
}

class ConvertPage extends StatefulWidget {
  @override
  _ConvertPageState createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }
}
