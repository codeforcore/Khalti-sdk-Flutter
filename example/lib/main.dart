import 'package:flutter/material.dart';
import 'package:khalti_sdk_flutter/khalti.dart';
import 'package:khalti_sdk_flutter/model/khalti.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khalti Payment Example App',
      home: KhalitExample(),
    );
  }
}

class KhalitExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material App Bar'),
      ),
      body: Center(
        child: Container(
          child: OutlinedButton(
            onPressed: () async {
              KhaltiConfig _config = KhaltiConfig(
                amount: 1000,
                productIdentity: 'productCode',
                mobile: '9851150186',
                productName: 'iPhone X',
                productUrl: 'https://codeforcore.com',
                publicKey: 'test_public_key_11927f4ef6a649ca9e8c44d2c779dba3',
              );
              KhaltiResponse result =
                  await Khalti(config: _config).makePayment(context);
              print(result.toString());
            },
            child: Text('Pay Rs. 10 with Khalti'),
          ),
        ),
      ),
    );
  }
}
