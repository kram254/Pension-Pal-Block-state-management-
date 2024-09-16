import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/pension_bloc.dart';
import '../../data/models/pension.dart';
import '../../utils/routes.dart';

class AddPensionScreen extends StatefulWidget {
  @override
  _AddPensionScreenState createState() => _AddPensionScreenState();
}

class _AddPensionScreenState extends State<AddPensionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _providerController = TextEditingController();
  final _valueController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  void dispose() {
    _providerController.dispose();
    _valueController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Pension'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _providerController,
                decoration: InputDecoration(labelText: 'Provider'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a provider';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valueController,
                decoration: InputDecoration(labelText: 'Value'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _typeController,
                decoration: InputDecoration(labelText: 'Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newPension = Pension(
                      id: DateTime.now().toString(), 
                      schemeName: _providerController.text,
                      contributions: 0, // You might want to add a field for this
                      balance: double.parse(_valueController.text),
                      pensionType: _typeController.text,
                    );
                    
                    context.read<PensionBloc>().add(AddPensionData(newPension));
                    
                    Navigator.pop(context, true);
                  }
                },
                child: Text('Add Pension'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

