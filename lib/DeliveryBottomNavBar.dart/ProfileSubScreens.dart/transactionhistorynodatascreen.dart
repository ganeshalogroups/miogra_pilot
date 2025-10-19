import 'package:flutter/cupertino.dart';

class TransactionHistoryNodata extends StatefulWidget {
  const TransactionHistoryNodata({super.key});

  @override
  State<TransactionHistoryNodata> createState() =>
      _TransactionHistoryNodataState();
}

class _TransactionHistoryNodataState extends State<TransactionHistoryNodata> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2.2,
        width: MediaQuery.of(context).size.width / 1.5,
        child: Image.asset('assets/images/notransactions.png'),
      ),
    );
  }
}
