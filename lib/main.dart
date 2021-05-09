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
  final TextEditingController _textControllerLeft = new TextEditingController();
  final TextEditingController _textControllerRight =
      new TextEditingController();
  var first_coin = [];
  var names = [];
  var coins_l = [];
  var ids = [];
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
        print('API Response: $jsonResponse');
      } catch (e) {
        print("Could not connect with API");
        connected = false;
      }
    }
    setState(() {
      for (var symbol in jsonResponse) {
        coins_l.add(symbol["symbol"]);
        ids.add(symbol["id"]);
        names.add(symbol["name"]);
      }
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
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [Colors.green, Colors.greenAccent]),
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: text_input(context),
            ),
          ),
          Expanded(
            child: loaded
                ?
                //set conditional with boolean isloading
                coin_selecection(context)
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

  Widget text_input(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(25.0),
              child: TextFormField(
                controller: _textControllerLeft,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: 'Bitcoin'),
                keyboardType: TextInputType.number,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(25.0),
              child: TextFormField(
                controller: _textControllerRight,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: 'Ethereum'),
                keyboardType: TextInputType.number,
              ),
            ),
          )
        ]),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    print("First Coin Selection");
                  },
                  icon: Icon(Icons.arrow_drop_down),
                  label: Text("First Coin"),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    print("Second Coin Selection");
                  },
                  icon: Icon(Icons.arrow_drop_down),
                  label: Text("Second Coin"),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget coin_selecection(BuildContext context) {
    return ListView.builder(
        itemCount: coins_l.length,
        itemBuilder: (BuildContext ctxt, int Index) {
          return RadioListTile(
            title: Text(coins_l[Index] + ' | ' + names[Index]),
            value: Index,
            groupValue: first_coin,
            onChanged: (value){
              print(value);
            }
          );
          //return Text(coins_l[Index] + names[Index]);
        });
  }
}
