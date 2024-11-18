
import 'package:flutter/foundation.dart';
import 'package:fluuter_client/services/driver_services.dart';

import '../models/driver_model.dart';

class DriverProvider with ChangeNotifier {
  final DriverServices _driverServices = DriverServices();
  List<Driver> _drivers = [];

  List<Driver> get drivers => _drivers;

  // fetch drivers when the provider is initialized
  DriverProvider() {
    getDrivers();
  }

  //  get drivers
  Future<void> getDrivers() async {
    try {
      final drivers = await _driverServices.getDrivers();
      _drivers = drivers;
      notifyListeners();
    } catch (error) {
      print('Error in provider: $error');
      rethrow;
    }
  }


  //  create driver
  Future<void> createDriver(Driver driver) async {
    try {
      await _driverServices.createDriver(driver);
      _drivers.add(driver);
      notifyListeners();
    } catch (error) {
      print('Error in provider: $error');
      rethrow;
    }
  }

  // delete driver
  Future<void> deleteDriver(int id) async {
    try {
      await _driverServices.deleteDriver(id);
      _drivers.removeWhere((driver) => driver.id == id);
      notifyListeners();
    } catch (error) {
      print('Error in provider: $error');
      rethrow;
    }
  }
}