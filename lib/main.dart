import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterFormScreen(),
    );
  }
}

class FlutterFormScreen extends StatefulWidget {
  @override
  _FlutterFormScreenState createState() => _FlutterFormScreenState();
}

class _FlutterFormScreenState extends State<FlutterFormScreen> {
  final Map<String, TextEditingController> controllers = {};
  static const platform = MethodChannel("com.example.channel");

  // Form definition
  final Map<String, dynamic> formJson = {
    "formFields": {
      "firstName": {"label": "First Name", "type": "TEXT", "required": true},
      "age": {"label": "Age", "type": "NUMBER", "required": false},
    }
  };

  @override
  void initState() {
    super.initState();
    for (var key in formJson['formFields'].keys) {
      controllers[key] = TextEditingController();
    }
  }

  void submitForm() {
    final formData = <String, dynamic>{};
    formJson['formFields'].forEach((key, value) {
      formData[key] = controllers[key]?.text;
    });

    // Send data back to Android via MethodChannel
    platform.invokeMethod("submitFormJson", formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dynamic Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (var key in formJson['formFields'].keys) ...[
              TextField(
                controller: controllers[key],
                decoration: InputDecoration(
                  labelText: formJson['formFields'][key]['label'],
                ),
                keyboardType: formJson['formFields'][key]['type'] == "NUMBER"
                    ? TextInputType.number
                    : TextInputType.text,
              ),
              SizedBox(height: 16),
            ],
            ElevatedButton(
              onPressed: submitForm,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
