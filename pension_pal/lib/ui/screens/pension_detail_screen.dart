   import 'package:flutter/material.dart';
   import 'package:flutter_bloc/flutter_bloc.dart';
   import '../../bloc/pension_detail_bloc.dart';
   import '../../data/models/pension_detail.dart';
   import '../widgets/fade_transition_widget.dart';

   const Color mustard = Color(0xFFFFDB58);
   const Color mustardDark = Color(0xFFD4A017);
   const Color black = Colors.black;
   const Color yellow = Colors.yellow;
   const Color grey = Colors.grey;

   class PensionDetailScreen extends StatelessWidget {
     final String pensionId;

     const PensionDetailScreen({Key? key, required this.pensionId}) : super(key: key);

     @override
     Widget build(BuildContext context) {
       // Trigger loading of pension details
       context.read<PensionDetailBloc>().add(LoadPensionDetail(pensionId));

       return Scaffold(
         appBar: AppBar(
           title: const Text(
             'Pension Details',
             style: TextStyle(
               color: mustard,
               fontWeight: FontWeight.bold,
               fontSize: 20,
             ),
           ),
           backgroundColor: black,
           elevation: 0,
           centerTitle: true,
         ),
             // Start of Selection
             backgroundColor: Colors.grey.shade100,
         body: FadeTransitionWidget(
           child: BlocBuilder<PensionDetailBloc, PensionDetailState>(
             builder: (context, state) {
               if (state is PensionDetailLoading) {
                 return const Center(
                   child: CircularProgressIndicator(
                     valueColor: AlwaysStoppedAnimation<Color>(yellow),
                   ),
                 );
               } else if (state is PensionDetailLoaded) {
                 return SingleChildScrollView(
                   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
                   child: AnimatedOpacity(
                     opacity: 1.0,
                     duration: const Duration(milliseconds: 800),
                     curve: Curves.easeIn,
                     child: Card(
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(16),
                       ),
                       elevation: 4,
                       shadowColor: black.withOpacity(0.2),
                       color: Colors.white,
                       child: Padding(
                         padding: const EdgeInsets.all(24.0),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               state.pensionDetail.schemeName,
                               style: TextStyle(
                                 fontSize: 28,
                                 fontWeight: FontWeight.bold,
                                 color: black,
                               ),
                             ),
                             const SizedBox(height: 24),
                             _DetailRow(
                               label: 'Total Contributions',
                               value: 'KES ${state.pensionDetail.totalContributions.toStringAsFixed(2)}',
                               color: mustardDark,
                             ),
                             const SizedBox(height: 16),
                             _DetailRow(
                               label: 'Current Balance',
                               value: 'KES ${state.pensionDetail.currentBalance.toStringAsFixed(2)}',
                               color: yellow,
                             ),
                             const SizedBox(height: 16),
                             _DetailRow(
                               label: 'Last Contribution Date',
                               value: '${state.pensionDetail.lastContributionDate.toLocal().toString().split(' ')[0]}',
                               color: mustard,
                             ),
                             const SizedBox(height: 16),
                             _DetailRow(
                               label: 'Withdrawal Limit',
                               value: 'KES ${state.pensionDetail.withdrawalLimit.toStringAsFixed(2)}',
                               color: black,
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 );
               } else if (state is PensionDetailError) {
                 return Center(
                   child: Text(
                     state.message,
                     style: TextStyle(
                       color: Colors.redAccent,
                       fontSize: 16,
                       fontWeight: FontWeight.w600,
                     ),
                   ),
                 );
               }
               return Container();
             },
           ),
         ),
       );
     }
   }

   class _DetailRow extends StatelessWidget {
     final String label;
     final String value;
     final Color color;

     const _DetailRow({
       Key? key,
       required this.label,
       required this.value,
       required this.color,
     }) : super(key: key);

     @override
     Widget build(BuildContext context) {
       return Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text(
             label,
             style: TextStyle(
               fontSize: 16,
               color: Colors.grey.shade700,
             ),
           ),
           Text(
             value,
             style: TextStyle(
               fontSize: 16,
               fontWeight: FontWeight.bold,
               color: color,
             ),
           ),
         ],
       );
     }
   }