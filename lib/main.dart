import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

String uri = 'https://api.hgbrasil.com/finance?key=4ddd356b';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(brightness: Brightness.dark),
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _dollar, _euro, _bitcoin;

  final _controllerReal = TextEditingController();
  final _controllerDolar = TextEditingController();
  final _controllerEuro = TextEditingController();
  final _controllerBtc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text('Erro'),
              );
            } else {
              _dollar = snapshot.data["results"]['currencies']['USD']['buy'];
              _euro = snapshot.data["results"]['currencies']['EUR']['buy'];
              _bitcoin = snapshot.data["results"]['currencies']['BTC']['buy'];
              return Scaffold(
                appBar: AppBar(
                  title: Text('Conversor de moedas'),
                  backgroundColor: Colors.amber,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 100, bottom: 40),
                        child: Icon(
                          Icons.monetization_on,
                          size: 150.0,
                          color: Colors.amber,
                        ),
                      ),
                      inputTextField('Real', 'R\$ ', _controllerReal, (value) {
                        onChangerInput(value, 'real');
                      }),
                      Divider(),
                      inputTextField('Dolar', 'US\$ ', _controllerDolar,
                          (value) {
                        onChangerInput(value, 'dollar');
                      }),
                      Divider(),
                      inputTextField('Euro', '€ ', _controllerEuro, (value) {
                        onChangerInput(value, 'euro');
                      }),
                      Divider(),
                      inputTextField('Bitcon', 'BTC ', _controllerBtc, (value) {
                        onChangerInput(value, 'btc');
                      }),
                    ],
                  ),
                ),
              );
            }
        }
      },
    );
  }

  Future<void> getData() async {
    try {
      Response response =
          await Dio().get('https://api.hgbrasil.com/finance?key=4ddd356b');
      return response.data;
    } catch (erro) {
      print(erro);
    }
  }

  Widget inputTextField(String label, String prefix,
      TextEditingController _controller, Function f) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
          prefix: Text(prefix),
        ),
        onChanged: f,
      ),
    );
  }

  void onChangerInput(String text, String type) {
    if (text.isEmpty) {
      cleanAll();
    } else {
      switch (type) {
        case 'real':
          _controllerDolar.text =
              (double.parse(_controllerReal.text.replaceAll(',', '.')) /
                      _dollar)
                  .toStringAsPrecision(2);
          _controllerEuro.text =
              (double.parse(_controllerReal.text.replaceAll(',', '.')) / _euro)
                  .toStringAsPrecision(2);
          _controllerBtc.text =
              (double.parse(_controllerReal.text.replaceAll(',', '.')) /
                      _bitcoin)
                  .toStringAsPrecision(2);
          break;
        case 'dollar':
          _controllerReal.text =
              (double.parse(_controllerDolar.text.replaceAll(',', '.')) *
                      _dollar)
                  .toStringAsPrecision(2);
          _controllerEuro.text =
              (double.parse(_controllerReal.text.replaceAll(',', '.')) / _euro)
                  .toStringAsPrecision(2);
          _controllerBtc.text =
              (double.parse(_controllerReal.text.replaceAll(',', '.')) /
                      _bitcoin)
                  .toStringAsPrecision(2);
          break;
        case 'euro':
          _controllerReal.text =
              (double.parse(_controllerEuro.text.replaceAll(',', '.')) * _euro)
                  .toStringAsPrecision(2);
          _controllerDolar.text =
              (double.parse(_controllerReal.text.replaceAll(',', '.')) /
                      _dollar)
                  .toStringAsPrecision(2);
          _controllerBtc.text =
              (double.parse(_controllerReal.text.replaceAll(',', '.')) /
                      _bitcoin)
                  .toStringAsPrecision(2);
          break;
        case 'btc':
          _controllerReal.text =
              (double.parse(_controllerBtc.text.replaceAll(',', '.')) *
                      _bitcoin)
                  .toStringAsPrecision(9);
          _controllerDolar.text =
              (double.parse(_controllerReal.text.replaceAll(',', '.')) /
                      _dollar)
                  .toStringAsPrecision(9);
          _controllerEuro.text =
              (double.parse(_controllerReal.text.replaceAll(',', '.')) / _euro)
                  .toStringAsPrecision(9);
          break;
      }
    }
  }

  void cleanAll() {
    _controllerBtc.text = '';
    _controllerDolar.text = '';
    _controllerEuro.text = '';
    _controllerReal.text = '';
  }
}
