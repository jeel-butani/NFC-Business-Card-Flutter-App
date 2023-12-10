import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Dynamic variables
  bool sandboxMode = true;
  String clientId =
      "AR4N5p341zIc7azXwBya52hBjv1vldaSnAyg5O8LKM1UrNpZB3uufIyyvv0qwu9ZvqEP7oZvPMaAY_ar";
  String secretKey =
      "EFhY54PCoKjjPT9wrACIwxnlPhS3y0FVXDn3fIqDYfntr2ESeLQpJqBy4Au6V7Pj9dfPRdE2IHke5TIY";
  String returnURL = "success.snippetcoder.com";
  String cancelURL = "cancel.snippetcoder.com";
  String currency = "USD";
  double totalAmount = 1.0;
  String itemName = "NFC";
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextButton(
            onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => PaypalCheckout(
                  sandboxMode: sandboxMode,
                  clientId: clientId,
                  secretKey: secretKey,
                  returnURL: returnURL,
                  cancelURL: cancelURL,
                  transactions: [
                    {
                      "amount": {
                        "total": totalAmount.toString(),
                        "currency": currency,
                        "details": {
                          "subtotal": totalAmount.toString(),
                          "shipping": '0',
                          "shipping_discount": 0
                        }
                      },
                      "description": "The payment transaction description.",
                      "item_list": {
                        "items": [
                          {
                            "name": itemName,
                            "quantity": quantity,
                            "price": totalAmount.toString(),
                            "currency": currency
                          },
                        ],
                      }
                    }
                  ],
                  note: "Contact us for any questions on your order.",
                  onSuccess: (Map params) async {
                    print("onSuccess: $params");
                  },
                  onError: (error) {
                    print("onError: $error");
                    Navigator.pop(context);
                  },
                  onCancel: () {
                    print('cancelled:');
                  },
                ),
              ));
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith((states) => Colors.black),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/paypal.png'),
                  height: 40,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Pay with Paypal',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
