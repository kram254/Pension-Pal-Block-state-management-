    import 'package:flutter/material.dart';
    import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/withdrawal_bloc.dart';

    class WithdrawalScreen extends StatefulWidget {
      @override
      _WithdrawalScreenState createState() => _WithdrawalScreenState();
    }

    class _WithdrawalScreenState extends State<WithdrawalScreen> {
      final TextEditingController _amountController = TextEditingController();
      final TextEditingController _recipientController = TextEditingController();

      @override
      void dispose() {
        _amountController.dispose();
        _recipientController.dispose();
        super.dispose();
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Withdraw Funds',
              style: TextStyle(
                color: Color(0xFFFFDB58), // Mustard color
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            backgroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
          ),
          backgroundColor: Colors.grey.shade100,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _recipientController,
                  decoration: InputDecoration(
                    labelText: 'Recipient',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  child: Text('Withdraw'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFDB58), // Mustard color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    final amount = double.tryParse(_amountController.text);
                    final recipient = _recipientController.text;
                    if (amount != null && recipient.isNotEmpty) {
                      // Replace with your Bloc event
                          // Start of Selection
                          BlocProvider.of<WithdrawalBloc>(context).add(
                            RequestWithdrawal(amount: amount, recipient: recipient),
                          );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a valid amount and recipient')),
                      );
                    }
                  },
                ),
                // You can add more widgets here, such as a loading indicator
              ],
            ),
          ),
        );
      }
    }
