// lib/nutrition.dart

import 'package:flutter/material.dart';

class NutritionPage extends StatefulWidget {
  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final List<Nutrition> _nutritions = [
    Nutrition(name: '비타민 C', dosage: '1000mg'),
    Nutrition(name: '오메가 3', dosage: '2000mg'),
    Nutrition(name: '프로바이오틱스', dosage: '10억 CFU'),
  ];

  final TextEditingController _nutritionController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  bool _isAddNutritionOpen = false;

  void _addNutrition() {
    if (_nutritionController.text.isNotEmpty && _dosageController.text.isNotEmpty) {
      setState(() {
        _nutritions.add(Nutrition(
          name: _nutritionController.text,
          dosage: _dosageController.text,
        ));
        _nutritionController.clear();
        _dosageController.clear();
        _isAddNutritionOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('영양제'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _nutritions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_nutritions[index].name),
                  subtitle: Text(_nutritions[index].dosage),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isAddNutritionOpen = true;
              });
            },
            child: Text("영양제 추가"),
          ),
          if (_isAddNutritionOpen) _buildAddNutritionDialog(),
        ],
      ),
    );
  }

  Widget _buildAddNutritionDialog() {
    return AlertDialog(
      title: Text("새 영양제 추가"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nutritionController,
            decoration: InputDecoration(labelText: "영양제 이름 입력"),
          ),
          TextField(
            controller: _dosageController,
            decoration: InputDecoration(labelText: "복용량 입력"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _addNutrition();
            Navigator.of(context).pop();
          },
          child: Text("추가"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("취소"),
        ),
      ],
    );
  }
}

class Nutrition {
  String name;
  String dosage;

  Nutrition({required this.name, required this.dosage});
}
