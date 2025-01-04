import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyTest extends StatefulWidget {
  const CurrencyTest({super.key});

  @override
  State<CurrencyTest> createState() => _CurrencyTestState();
}

class _CurrencyTestState extends State<CurrencyTest> {
  final NumberFormat _dollarCurrency =
      NumberFormat.simpleCurrency(locale: 'en_US', decimalDigits: 2);
  final NumberFormat _euroCurrency =
      NumberFormat.simpleCurrency(locale: 'de-DE', decimalDigits: 2);

  final _dollar = TextEditingController();
  final _euro = TextEditingController();

  double _dollarValue = 0.00;
  double _euroValue = 0.00;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'roboto',
        fontFamilyFallback: const [
          'lato',
          'montserrat',
          'roboto-condensed',
          'noto-sans',
          'merriweather'
        ],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Currency Test'),
        ),
        body: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_dollarCurrency.format(_dollarValue)),
            TextFormField(
              controller: _dollar,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _dollarValue = double.parse(_dollar.text);
                    debugPrint(
                        'Dollar: ${_dollarCurrency.format(_dollarValue).replaceAll('\$', '')}'); // using of replaceAll
                    debugPrint(
                        'Dollar: ${_dollarCurrency.format(_dollarValue).substring(1)}'); // using of substring for dollar
                  });
                },
                child: Text('Format Dollar')),
            SizedBox(
              height: 8.0,
            ),
            Divider(),
            SizedBox(
              height: 8.0,
            ),
            Text(_euroCurrency.format(_euroValue)),
            TextFormField(
              controller: _euro,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _euroValue = double.parse(_euro.text);
                    debugPrint(
                        'Euro: ${_euroCurrency.format(_euroValue).replaceAll('€', '')}'); // using of replaceAll
                    debugPrint(
                        'Euro: ${_euroCurrency.format(_euroValue).substring(0, _euroCurrency.format(_euroValue).length - 1)}'); // using of substring for euro
                  });
                },
                child: Text('Format Euro')),
          ],
        )),
      ),
    );
  }
}
