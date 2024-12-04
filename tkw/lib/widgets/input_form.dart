// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class InputForm extends StatefulWidget {
  final Function(double, double) onCalculate;

  const InputForm({super.key, required this.onCalculate});

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final _formKey = GlobalKey<FormState>();
  double _roofArea = 0;
  double _efficiency = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Döşeme Alanı (m²)'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen döşeme alanını girin';
              }
              return null;
            },
            onSaved: (value) {
              _roofArea = double.parse(value!);
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Güneş Paneli Verimliliği (%)'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen güneş panel verimliliğini girin';
              }
              return null;
            },
            onSaved: (value) {
              _efficiency = double.parse(value!) / 100;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.onCalculate(_roofArea, _efficiency);
              }
            },
            child: const Text('Hesapla'),
          ),
        ],
      ),
    );
  }
}

