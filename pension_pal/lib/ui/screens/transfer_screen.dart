import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/transfer_bloc.dart';
import '../../data/repositories/transfer_repository.dart';

const Color mustard = Color(0xFFFFDB58);
const Color mustardDark = Color(0xFFD4A017);
const Color black = Colors.black;
const Color yellow = Colors.yellow;
const Color grey = Colors.grey;

class TransferScreen extends StatefulWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeInAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transfer',
          style: TextStyle(color: mustard, fontWeight: FontWeight.bold),
        ),
        backgroundColor: black,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: grey,
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: BlocProvider(
          create: (context) => TransferBloc(TransferRepository()),
          child: BlocConsumer<TransferBloc, TransferState>(
            listener: (context, state) {
              if (state is TransferSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Transfer successful!'), backgroundColor: Colors.green),
                );
              } else if (state is TransferError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Transfer failed: ${state.errorMessage}'), backgroundColor: Colors.red),
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _recipientController,
                      decoration: InputDecoration(
                        labelText: 'Recipient',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      child: Text('Transfer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mustard,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: state is TransferInProgress
                          ? null
                          : () {
                              final amount = double.tryParse(_amountController.text);
                              final recipient = _recipientController.text;
                              if (amount != null && recipient.isNotEmpty) {
                                BlocProvider.of<TransferBloc>(context).add(
                                  TransferRequested(amount: amount, recipient: recipient),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please enter valid amount and recipient')),
                                );
                              }
                            },
                    ),
                    if (state is TransferInProgress)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(mustard),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}





