import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mollie/mollie.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
    initialRoute: "home",
    routes: {"home": (context) => MyApp(), "done": (context) => Testy()}));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  MollieOrderRequest o = new MollieOrderRequest(
      amount: MollieAmount(value: "1396.00", currency: "EUR"),
      orderNumber: "900",
      redirectUrl: "molli://payment-return",
      locale: "de_DE",
      webhookUrl: 'https://example.org/webhook',
      billingAddress: new MollieAddress(
        organizationName: 'Mollie B.V.',
        streetAndNumber: 'Keizersgracht 313',
        city: 'Amsterdam',
        region: 'Noord-Holland',
        postalCode: '1234AB',
        country: 'DE',
        title: 'Dhr.',
        givenName: 'Piet',
        familyName: 'Mondriaan',
        email: 'piet@mondriaan.com',
        phone: '+31309202070',
      ),
      shippingAddress: new MollieAddress(
        organizationName: 'Mollie B.V.',
        streetAndNumber: 'Keizersgracht 313',
        city: 'Amsterdam',
        region: 'Noord-Holland',
        postalCode: '1234AB',
        country: 'DE',
        title: 'Dhr.',
        givenName: 'Piet',
        familyName: 'Mondriaan',
        email: 'piet@mondriaan.com',
        phone: '+31309202070',
      ),
      products: [
        MollieProductRequest(
          type: 'physical',
          sku: '5702016116977',
          name: 'LEGO 42083 Bugatti Chiron',
          productUrl: 'https://shop.lego.com/nl-NL/Bugatti-Chiron-42083',
          imageUrl:
              'https://sh-s7-live-s.legocdn.com/is/image//LEGO/42083_alt1?',
          quantity: 2,
          vatRate: '21.00',
          unitPrice: MollieAmount(
            currency: 'EUR',
            value: '399.00',
          ),
          totalAmount: MollieAmount(
            currency: 'EUR',
            value: '698.00',
          ),
          discountAmount: MollieAmount(
            currency: 'EUR',
            value: '100.00',
          ),
          vatAmount: MollieAmount(
            currency: 'EUR',
            value: '121.14',
          ),
        ),
        MollieProductRequest(
          type: 'physical',
          sku: '5702016116977',
          name: 'LEGO 42083 Bugatti Chiron',
          productUrl: 'https://shop.lego.com/nl-NL/Bugatti-Chiron-42083',
          imageUrl:
              'https://sh-s7-live-s.legocdn.com/is/image//LEGO/42083_alt1?',
          quantity: 2,
          vatRate: '21.00',
          unitPrice: MollieAmount(
            currency: 'EUR',
            value: '399.00',
          ),
          totalAmount: MollieAmount(
            currency: 'EUR',
            value: '698.00',
          ),
          discountAmount: MollieAmount(
            currency: 'EUR',
            value: '100.00',
          ),
          vatAmount: MollieAmount(
            currency: 'EUR',
            value: '121.14',
          ),
        )
      ]);


  Future<void> createOrder(MollieOrderRequest order) async{

    var res = await Mollie.createOrder("http://blackboxshisha.herokuapp.com/mollie/create/order", order);

    // Open the browser
    Mollie.startPayment(res.checkoutUrl);

  }

  @override
  Widget build(BuildContext context) {
    return MollieCheckout(
      order: o,
      onMethodSelected: (order) {

        createOrder(order);

      },
      useCredit: true,
      usePaypal: true,
      useSepa: true,
      useSofort: true,
    );
  }
}

class Testy extends StatelessWidget {
  final String id;

  Testy({this.id});

  Future<String> orderStatus() async {
    var res = await http
        .get("http://blackboxshisha.herokuapp.com/mollie/create/order/" + id);

    print(res.body);
    dynamic d = json.decode(res.body);
    return d["status"];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(
      child: Text("Bestätigen und mit" + Mollie.currentMollieOrder.getMethodFormatted() + " bezahlen"),
    ));
  }
}

//FutureBuilder(
//future: auth(),
//builder: (context,snapshot){
//
//if(snapshot.hasData){
//return Center(
//child: RaisedButton(onPressed: () {auth();}),
////child: WebView(
////  key: key,
////  javascriptMode: JavascriptMode.unrestricted,
////  initialUrl: snapshot.data,
////)  //RaisedButton(onPressed: () { auth(); })
//);
//}
//else {
//return Center(
//child: CircularProgressIndicator(),
//);
//}
//
//}
//)
