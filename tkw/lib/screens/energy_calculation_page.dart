import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/input_form.dart';

class EnergyCalculationPage extends StatelessWidget {
  const EnergyCalculationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Enerji Hesabı'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Güneş Paneli Detaylarınızı Girin',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            InputForm(
              onCalculate: (roofArea, efficiency) {
                // Perform calculations and navigate to result summary
                Navigator.pushNamed(context, '/result_summary');
              },
            ),
          ],
        ),
      ),
    );
  }
}

