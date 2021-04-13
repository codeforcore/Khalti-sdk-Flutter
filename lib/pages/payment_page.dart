import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalti_sdk_flutter/common/constants.dart';
import 'package:khalti_sdk_flutter/cubit/khaltipayment_cubit.dart';
import 'package:khalti_sdk_flutter/model/khalti.dart';
import 'package:khalti_sdk_flutter/pages/wallet_page.dart';

import 'ebanking_page.dart';

class KhaltiPaymentPage extends StatelessWidget {
  final KhaltiConfig config;

  const KhaltiPaymentPage({Key key, @required this.config}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KhaltiPaymentCubit(config),
      child: KhaltiPaymentChild(),
    );
  }
}

class KhaltiPaymentChild extends StatefulWidget {
  @override
  _KhaltiPaymentChildState createState() => _KhaltiPaymentChildState();
}

class _KhaltiPaymentChildState extends State<KhaltiPaymentChild> {
  // int _tabIndex = 0;
  OverlayEntry _overlayEntry;
  @override
  void initState() {
    _overlayEntry = OverlayEntry(
        builder: (context) => Scaffold(
              backgroundColor: Colors.grey.withOpacity(0.4),
              body: Container(
                color: Colors.grey.withOpacity(0.7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Material(
                      elevation: 5,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: LinearProgressIndicator(
                          backgroundColor: primaryColor,
                        ),
                      ),
                    ),
                    Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Please Do Not Press Back Button',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ))
                  ],
                ),
              ),
            ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _cubit = context.read<KhaltiPaymentCubit>();
    return BlocListener<KhaltiPaymentCubit, KhaltiPaymentState>(
      listener: (context, state) {
        if (state is PaymenLoading) {
          Overlay.of(context)?.insert(_overlayEntry);
        } else {
          if (_overlayEntry.mounted) _overlayEntry?.remove();
          if (state is OtpVerificationFailed) {
            showSnakBar(context, state.msg);
          } else if (state is OtpSendError) {
            showSnakBar(context, state.msg);
          } else if (state is OtpSent) {
            showSnakBar(context, 'OTP was sent to your mobile number');
          } else if (state is OtpVerified) {
            Navigator.pop(context, state.response);
          }
        }
      },
      child: BlocBuilder<KhaltiPaymentCubit, KhaltiPaymentState>(
          builder: (context, state) {
        final cubit = context.read<KhaltiPaymentCubit>();
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(
              context,
              KhaltiResponse(
                  message: 'Cancelled by User', sucess: false, token: null),
            );
            return false;
          },
          child: Theme(
              data: ThemeData(
                primaryColor: primaryColor,
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: primaryColor,
                ),
              ),
              child: DefaultTabController(
                initialIndex: cubit.tabIndex,
                key: Key('khaltiKey'),
                length: 2,
                child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      elevation: 5,
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: primaryColor,
                        ),
                        onPressed: () => Navigator.pop(
                            context,
                            KhaltiResponse(
                                message: 'Cancelled by User',
                                sucess: false,
                                token: null)),
                      ),
                      bottom: TabBar(
                        indicatorColor: Colors.deepOrangeAccent,
                        indicatorWeight: 2.0,
                        labelColor: Colors.white,
                        onTap: cubit.isBusy == false
                            ? (index) {
                                setState(() {
                                  cubit.tabIndex = index;
                                });
                              }
                            : null,
                        tabs: [
                          Tab(
                            icon: Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: primaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'KAHLTI',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      letterSpacing: 1.2),
                                )
                              ],
                            ),
                          ),
                          Tab(
                            icon: Row(
                              children: [
                                Icon(
                                  Icons.account_balance_outlined,
                                  color: primaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'E-BANKING',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      letterSpacing: 1.2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        _cubit.config.publicKey.toString().contains('test_')
                            ? Center(
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'TEST API',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : Container()
                      ],
                      title: Text(
                        'Pay With Khalti',
                        style:
                            TextStyle(color: primaryColor, letterSpacing: 1.1),
                      ),
                    ),
                    body:
                        cubit.tabIndex == 0 ? WalletPayment() : EbankingPage()),
              )),
        );
      }),
    );
  }

  void showSnakBar(BuildContext context, String msg) {
    // ScaffoldMessenger.of(context).showSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.2,
          ),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
