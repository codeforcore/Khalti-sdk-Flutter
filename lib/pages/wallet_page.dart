import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalti_sdk_flutter/common/constants.dart';
import 'package:khalti_sdk_flutter/cubit/khaltipayment_cubit.dart';

class WalletPayment extends StatelessWidget {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KhaltiPaymentCubit, KhaltiPaymentState>(
        builder: (context, state) {
      KhaltiPaymentCubit cubit = context.read<KhaltiPaymentCubit>();
      if (state is OtpSent || state is OtpVerificationFailed) {
        return Container(
          padding: const EdgeInsets.all(30),
          color: Colors.white,
          child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.maxFinite,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty)
                            return 'OTP is Required';
                          else if (value.length == 6 &&
                              RegExp(r'\d').hasMatch(value))
                            return null;
                          else
                            return 'OTP is not valid';
                        } else
                          return 'OTP is Invalid';
                      },
                      onChanged: (value) => cubit.otp = value,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        counterText: "",
                        icon: const Icon(Icons.lock_outline_rounded),
                        labelText: 'Khalti Payment Code',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: MaterialButton(
                      padding: const EdgeInsets.all(15),
                      onPressed: () {
                        if (_formkey.currentState.validate())
                          cubit.confirmOtp();
                      },
                      color: primaryColor,
                      child: Text(
                        'CONFIRM',
                        style:
                            TextStyle(color: Colors.white, letterSpacing: 1.2),
                      ),
                      elevation: 4,
                      splashColor: Colors.deepPurple,
                    ),
                  ),
                ],
              )),
        );
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage(
                      'images/logo.png',
                      package: 'khalti_sdk_flutter',
                    ),
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  initialValue: cubit.config.mobile ?? '',
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty)
                        return 'Mobile Number is Required';
                      else if (value.length == 10 &&
                          RegExp(r'\d').hasMatch(value) &&
                          RegExp(r'^9[6,7,8][0-9]{8}').hasMatch(value))
                        return null;
                      else
                        return 'Please Enter a valid Mobile Number';
                    } else
                      return 'Mobile Number is Invalid';
                  },
                  onChanged: (value) => cubit.config.mobile = value,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    counterText: "",
                    icon: const Icon(Icons.phone_android_outlined),
                    labelText: 'Khalti Mobile Number',
                  ),
                ),
                TextFormField(
                  obscureText: true,
                  maxLength: 10,
                  initialValue: cubit.pin ?? '',
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty)
                        return 'Pin is Required';
                      else if (value.length >= 4 &&
                          RegExp(r'\d').hasMatch(value))
                        return null;
                      else
                        return '4 digit pin is required';
                    } else
                      return 'Invalid Pin';
                  },
                  onChanged: (value) => cubit.pin = value,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.lock_outline),
                    counterText: "",
                    labelText: 'Khalti Pin',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: MaterialButton(
                    padding: const EdgeInsets.all(15),
                    onPressed: () {
                      if (_formkey.currentState.validate())
                        cubit.processWalletPayment();
                    },
                    color: primaryColor,
                    child: Text(
                      'PAY RS ${cubit.config.amount / 100}',
                      style: TextStyle(color: Colors.white, letterSpacing: 1.2),
                    ),
                    elevation: 4,
                    splashColor: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
