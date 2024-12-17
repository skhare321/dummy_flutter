import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'DatabaseHelper.dart';
import 'NativeBridge.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NativeBridge.setupMethodChannel();
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
      "age": {"label": "Age", "type": "TEXT", "required": false},
    }
  };

  @override
  void initState() {
    super.initState();
    for (var key in formJson['formFields'].keys) {
      controllers[key] = TextEditingController();
    }
  }

  void submitForm() async {
    final formData = <String, dynamic>{};
    formJson['formFields'].forEach((key, value) {
      formData[key] = controllers[key]?.text;
    });

    await DatabaseHelper.instance.insertUser(
        formData['firstName'], formData['age']); // Save to database
    try {
      await platform.invokeMethod("submitFormJson", formData);
    } catch (e) {
      print("Error invoking method: $e");
    }
  }

  void sendDataViaApi() async {
    try {
      await NativeBridge.sendDataToServer();
    } catch (e) {
      print("Error sending data: $e");
    }
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
                keyboardType: TextInputType.text,
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
