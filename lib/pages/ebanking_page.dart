import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalti_sdk_flutter/common/constants.dart';
import 'package:khalti_sdk_flutter/cubit/khaltipayment_cubit.dart';

class EbankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KhaltiPaymentCubit, KhaltiPaymentState>(
      builder: (context, state) {
        final cubit = context.read<KhaltiPaymentCubit>();
        if (state is KhaltiPaymentInitial && cubit.banks.isEmpty) {
          cubit.loadBanks();
        }
        if (state is ErrorLoadingBanks) {
          return Center(
            child: Text('Bank Payment will be available in next release'),
            // child: Text(
            //     'There was an error getting banks\n Please try again later'),
          );
        } else if (state is BanksLoading) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: primaryColor,
            ),
          );
        } else if (state is BanksLoaded) {
          return GridView.builder(
            // itemCount: 2,
            itemCount: state.banks.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Card();
            },
          );
        }
        return Container();
      },
    );
  }
}
