
import 'dart:convert';

import '../models/driver_model.dart';
import 'package:http/http.dart' as http;

const String url = 'http://192.168.8.164/flutter_backend/drivers_api.php';

class DriverServices{

  // create driver
  Future<void> createDriver(Driver driver) async {
    try {
      final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
      },
          body: jsonEncode(driver.toJson())
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] != null) {
          throw Exception(responseData['error']);
        }
        print('Driver created successfully: ${response.body}');
      } else {
        throw Exception('Failed to create driver. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
      throw Exception('Failed to create driver: $e');
    }
  }

  // get drivers
  Future<List<Driver>> getDrivers() async {
    try {
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        final List<Driver> drivers = responseData.map((e) => Driver.fromJson(e)).toList();
        return drivers;
      } else {
        throw Exception('Failed to get drivers. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
      throw Exception('Failed to get drivers: $e');
    }
  }

  // delete driver
  Future<void> deleteDriver(int id) async {
    try {
      final response = await http.delete(Uri.parse('$url?driver_id=$id'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['error'] != null) {
          throw Exception(responseData['error']);
        }
        print('Driver deleted successfully: ${response.body}');
      } else {
        throw Exception('Failed to delete driver. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during API call: $e');
      throw Exception('Failed to delete driver: $e');
    }
  }

}