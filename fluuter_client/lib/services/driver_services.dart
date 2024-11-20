
import 'dart:convert';

import '../models/driver_model.dart';
import 'package:http/http.dart' as http;



class DriverServices{

  Map<String, String> cookies = {};
  final String url = 'http://kaveezcustombackendflutter.free.nf/drivers_api.php';

  // Helper method to update cookies
  void _updateCookies(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      String cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      List<String> parts = cookie.split('=');
      if (parts.length == 2) {
        cookies[parts[0]] = parts[1];
      }
    }
  }

  // Helper method to get cookie header
  String? _getCookieHeader() {
    return cookies.entries
        .map((e) => '${e.key}=${e.value}')
        .join('; ');
  }

  // Make initial request to get cookies
  Future<void> _initializeSession() async {
    try {
      final response = await http.get(Uri.parse(url));
      _updateCookies(response);

      // Wait a brief moment before the next request
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      print('Error initializing session: $e');
    }
  }

  // create driver
  Future<void> createDriver(Driver driver) async {
    try {

      await _initializeSession();

      final client = http.Client();

      // Add common browser headers to bypass protection
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.5',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1',
      };

      // First make a GET request to get any necessary cookies
      await client.get(Uri.parse(url), headers: headers);



      final response = await client.post(
          Uri.parse(url),
          headers: headers,
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
      // Create a custom client that will maintain cookies
      final client = http.Client();
      // Add necessary headers
      final headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        'Accept': 'application/json',
      };
      // First request to get the cookie
      final initialResponse = await client.get(
        Uri.parse('http://kaveezcustombackendflutter.free.nf/drivers_api.php'),
        headers: headers,
      );
      // Get cookies from the response
      String? rawCookie = initialResponse.headers['set-cookie'];
      if (rawCookie != null) {
        // Add the cookie to headers for the next request
        headers['Cookie'] = rawCookie;
      }
      // Make the actual API request with the cookie
      final response = await client.get(
        Uri.parse('http://kaveezcustombackendflutter.free.nf/drivers_api.php?i=1'),
        headers: headers,
      );
      // Clean up
      client.close();
      if (response.statusCode == 200) {
        // Parse the JSON response
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching drivers: $e');
      throw Exception('Failed to load data: $e');
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