import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class BmiHomepage extends StatefulWidget {
  const BmiHomepage({super.key, required this.title});
  final String title;

  @override
  State<BmiHomepage> createState() => _BmiHomepageState();
}

class _BmiHomepageState extends State<BmiHomepage> {
  final TextEditingController weight = TextEditingController();
  final TextEditingController inCM = TextEditingController();
  final TextEditingController age = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double? result;
  double? bmiResult;
  String? category;
  Color col = Colors.blueGrey;

  void _calculateBMI() {
    final double? Iinch = double.tryParse(inCM.text);
    final double? Iweight = double.tryParse(weight.text);
    final int? Iage = int.tryParse(age.text);

    if (Iinch == null || Iweight == null || Iage == null) {
      setState(() {
        category = "Please enter valid numbers!";
        bmiResult = null;
      });
      return;
    }

    // Convert height from inches to meters
    double heightInMeters = Iinch / 100;
    double bmi = Iweight / pow(heightInMeters, 2);

    String resultCategory;

    setState(() {
      if (Iage < 20) {
        resultCategory = "Use BMI percentiles for children (<20)";
      } else if (Iage >= 65) {
        if (bmi < 23) {
          resultCategory = "Underweight (for seniors)";
          col = Colors.red.shade100;
        } else if (bmi < 27) {
          resultCategory = "Healthy weight (for seniors)";
          col = Colors.green.shade100;
        } else {
          resultCategory = "Overweight (for seniors)";
          col = Colors.orange.shade100;
        }
      } else {
        if (bmi < 18.5) {
          resultCategory = "Underweight";
          col = Colors.orange.shade100;
        } else if (bmi < 25) {
          resultCategory = "Normal";
          col = Colors.green.shade100;
        } else if (bmi < 30) {
          resultCategory = "Overweight";
          col = Colors.red.shade100;
        } else {
          resultCategory = "Obese";
          col = Colors.red.shade400;
        }
      }

      bmiResult = bmi;
      category = resultCategory;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    weight.dispose();
    age.dispose();
    inCM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue.shade100,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTextField(age, "Age (yrs)", Icons.timeline, 'AGE'),
                const SizedBox(height: 10),
                buildTextField(
                  weight,
                  "Weight (kg)",
                  Icons.line_weight,
                  'WEIGHT',
                ),
                const SizedBox(height: 10),
                buildTextField(
                  inCM,
                  "Height (cm)",
                  Icons.height,
                  'HEIGHT(in cm)',
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _calculateBMI();
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    'Calculate BMI',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (bmiResult != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: col,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Your BMI: ${bmiResult!.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          category ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ renamed helper method
  Widget buildTextField(
    TextEditingController controller,
    String hintText,
    IconData icon,
    String labeltxt,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        hintText: hintText,
        suffixIcon: Icon(icon),
        labelText: labeltxt,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter valid value';
        }
        if (double.tryParse(value) == null) {
          return 'Enter a number';
        }
        return null; // ✅ return null = valid
      },
    );
  }
}
