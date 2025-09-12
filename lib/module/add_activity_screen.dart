import 'package:flutter/material.dart';
import 'package:piecotrack/shared/component/contasnt.dart';

import '../model/model_screen.dart';

class AddActivityScreen extends StatefulWidget {
  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedType;
  int quantity = 1;

  // أنشطة جاهزة + قيم CO₂ لكل وحدة
  final Map<String, double> activityImpact = {
    "Walking 1 km": 0.05,       // 0.05 kg CO₂
    "Recycling 1 kg Paper": 1.3,
    "Using Public Transport": 2.0,
    "Switch off lights (1h)": 0.15,
    "Reusable Bag": 0.1,
  };

  void _saveActivity() {
    if (_formKey.currentState!.validate() && selectedType != null) {
      double co2Saved = activityImpact[selectedType]! * quantity;
      dynamic piReward = (co2Saved * 10).round(); // مثال: 10 Pi لكل 1kg CO₂

      final activity = ActivityModel(
        type: selectedType!,
        description: "$quantity × $selectedType",
        co2Saved: co2Saved,
        piReward: piReward,
        date: DateTime.now(),
      );

      Navigator.pop(context, activity); // نرجعه للشاشة اللي قبل
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Activity"),
        flexibleSpace: Container(

          decoration: const BoxDecoration(

            gradient: LinearGradient(

              colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)], // أخضر فاتح وداكن

              begin: Alignment.topLeft,

              end: Alignment.bottomRight,

            ),

          ),

        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Activity Type",
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: activityImpact.keys
                    .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Choose an activity",
                ),
                validator: (value) =>
                value == null ? "Please select an activity" : null,
              ),
              SizedBox(height: 20),
              Text("Quantity", style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      if (quantity > 1) {
                        setState(() => quantity--);
                      }
                    },
                  ),
                  Text(quantity.toString(),
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() => quantity++);
                    },
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Save Activity",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
