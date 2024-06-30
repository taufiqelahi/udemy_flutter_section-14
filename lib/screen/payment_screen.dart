import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final data = await createPaymentIntent("200", "USD");
      print(data);

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          // Extra options
          // applePay: const PaymentSheetApplePay(
          //   merchantCountryCode: 'US',
          // ),
          // googlePay: const PaymentSheetGooglePay(
          //   merchantCountryCode: 'US',
          //   testEnv: true,
          // ),
          style: ThemeMode.dark,
        ),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: ()async {

              await initPaymentSheet();
              try{
                await Stripe.instance.presentPaymentSheet();
              }catch(e){
                print("Error${e}");
              }
            }, child: Text("Create Payment"))
          ],
        ),
      ),
    );
  }
}

createPaymentIntent(String amount, String currency) async {
  final url = 'https://api.stripe.com/v1/payment_intents';
  final secret_key = dotenv.env["STRIPE_SECRET_KEY"];
  try {
    Map<String, dynamic> body = {
      "amount": amount,
      "currency": currency,

    };

    final response = await http.post(Uri.parse(url), body: body, headers: {
      "Authorization": "Bearer $secret_key",
      "Content-Type": "application/x-www-form-urlencoded"
    });

    if (response.statusCode == 200) {
      print(response.body.toString());
      print("ssssssssssssssssssss");
      return jsonDecode(response.body.toString());
    } else {
      print("Failed${response.statusCode}");
    }
  } catch (e) {
    print(e.toString());
  }
}
