import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'DatabaseHelper.dart';

class NativeBridge {
  static const platform = MethodChannel('com.example.channel');

  static void setupMethodChannel() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'getAllUsers') {
        print("inside getAllUsers method in flutter");
        List<Map<String, dynamic>> users =
        await DatabaseHelper.instance.getUsers();
        return users;
      }
      else if (call.method == 'storeDataInFlutter') {
        print("inside storeDataInFlutter method in flutter");
        Map<String, dynamic> data = Map<String, dynamic>.from(call.arguments);
        await DatabaseHelper.instance.insertUser(data['name'], data['age']);
      }
      else if (call.method == 'sendDataViaApi') {
        print("inside sendDataViaApi method in flutter");
        await sendDataToServer();
      }
      else {
        throw PlatformException(
            code: 'NOT_IMPLEMENTED', message: 'Method not implemented');
      }
    });
  }

  static Future<void> sendDataToServer() async {
    const apiUrl = "https://jsonplaceholder.typicode.com/posts";

    List<Map<String, dynamic>> users = await DatabaseHelper.instance.getUsers();
    final dataToSend = jsonEncode({"users": users});

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: dataToSend,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Data synced successfully: ${response.body}");
      } else {
        print("Failed to sync data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error syncing data: $e");
    }
  }
}
