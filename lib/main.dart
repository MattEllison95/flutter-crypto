import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:api_test/Crypto.dart';

String _data = '';
List<Crypto> _crypto = <Crypto>[];


Future<List<Crypto>> getData() async {
  //_cryptoList.clear();
  List<Crypto> _cryptoList = <Crypto>[];
  Uri uri = Uri.parse(
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false');
  Response response = await get(uri);
  _data = response.body;

  // create crypto list from json response body
  var cryptoJson = jsonDecode(response.body);
  if (_cryptoList.length >= 0)
    _cryptoList.clear(); // clear the list if it already has items

  for (var cryptoJson in cryptoJson) {
    _cryptoList.add(Crypto.fromJson(cryptoJson));
  }

  print(
      '${_cryptoList[0].name} - \$${_cryptoList[0].price} - array size: ${_cryptoList.length}');

  return _cryptoList;
}

Future<void> main() async{
  await getData().then((value) => _crypto = value); // Populate crypto array before app is rendered
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShowData(),
    );
  }
}

class ShowData extends StatefulWidget {
  const ShowData({Key? key}) : super(key: key);

  @override
  State<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crypto Prices'), actions: [
        IconButton(onPressed: _refreshData, icon: const Icon(Icons.refresh)),
        IconButton(onPressed: _about, icon: const Icon(Icons.info))
      ]),
      body: Column(
        children: [
          _buildList(),
          Text('Last updated at ${DateFormat('hh:mm:ss').format(DateTime.now())}')
        ],
      ),
    );
  }

  Widget _buildList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();
          final index = i ~/ 2;
          return _buildRow(_crypto[index]);
        },
        physics: const AlwaysScrollableScrollPhysics(),
      ),
    );
  }

  Widget _buildRow(Crypto crypto) {
    return ListTile(
      title: Text(crypto.name),
      subtitle: Text('${crypto.symbol.toUpperCase()}'),
      leading: ClipOval(
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: crypto.image,
          height: 50,
          width: 50,
        ),
      ),
      trailing: Text('\$${crypto.price}'),
    );
  }

  Future<void> _refreshData() async {
    await getData().then((value) => _crypto = value);
    setState(()  {
      print('await');
    });
  }

  void _about() {
    Navigator.of(context).push(
     MaterialPageRoute<void>(builder: (context){
       return Scaffold(
         appBar: AppBar(
           title: const Text('About'),
         ),
         body: Center(
           child: const Text(
             '© Matt Ellison 2021\n',
             textAlign: TextAlign.center,
           ),
         )
       );
     })
    );
  }
}


