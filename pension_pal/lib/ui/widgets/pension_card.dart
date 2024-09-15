   import 'package:flutter/material.dart';
   import '../../data/models/pension.dart';

   class PensionCard extends StatelessWidget {
     final Pension pension;

     PensionCard({required this.pension});

     @override
     Widget build(BuildContext context) {
       return Card(
         margin: EdgeInsets.all(8.0),
         child: ListTile(
           title: Text(pension.schemeName),
           subtitle: Text('Balance: KES ${pension.balance.toStringAsFixed(2)}'),
           trailing: Icon(Icons.arrow_forward),
           onTap: () {
             Navigator.pushNamed(
               context,
               '/pension_detail',
               arguments: pension.id,
             );
           },
         ),
       );
     }
   }