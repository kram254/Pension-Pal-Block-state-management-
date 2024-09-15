    // Start Generation Here
    import 'package:flutter/material.dart';
    import 'package:flutter_bloc/flutter_bloc.dart';
    import '../../bloc/contribution_bloc.dart';
    
    const Color mustard = Color(0xFFFFDB58);
    
    class ContributionScreen extends StatelessWidget {
      const ContributionScreen({Key? key}) : super(key: key);
    
      @override
      Widget build(BuildContext context) {
        return BlocProvider(
          create: (context) => ContributionBloc(ContributionRepository()),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Contributions'),
              backgroundColor: Colors.black,
            ),
            body: BlocBuilder<ContributionBloc, ContributionState>(
              builder: (context, state) {
                if (state is ContributionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ContributionLoaded) {
                  final contributions = state.contributions;
                  if (contributions.isEmpty) {
                    return const Center(child: Text('No contributions found.'));
                  }
                  return ListView.builder(
                    itemCount: contributions.length,
                    itemBuilder: (context, index) {
                      final contribution = contributions[index];
                      return Card(
                        color: Colors.grey[200],
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(
                            'KES ${contribution.amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text('Scheme ID: ${contribution.schemeId}'),
                        ),
                      );
                    },
                  );
                } else if (state is ContributionError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('Unexpected state'));
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.yellow,
              onPressed: () {
                _showAddContributionDialog(context);
              },
              child: const Icon(Icons.add, color: Colors.black),
            ),
          ),
        );
      }
    
      void _showAddContributionDialog(BuildContext context) {
        final _amountController = TextEditingController();
        final _schemeIdController = TextEditingController();
    
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Add Contribution'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount (KES)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _schemeIdController,
                    decoration: const InputDecoration(
                      labelText: 'Scheme ID',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    final amount = double.tryParse(_amountController.text);
                    final schemeId = _schemeIdController.text;
                    if (amount != null && schemeId.isNotEmpty) {
                      BlocProvider.of<ContributionBloc>(context).add(
                        SubmitContribution(amount: amount, schemeId: schemeId),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit', style: TextStyle(color: mustard)),
                ),
              ],
            );
          },
        );
      }
    }
