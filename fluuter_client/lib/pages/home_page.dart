import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/driver_model.dart';
import '../providers/driver_provider.dart';


class HomePage extends StatelessWidget {
   HomePage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();


  void formPopup(BuildContext context) {
    showDialog(context: context,
        builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Create Driver',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                children: [

                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: 'Age',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter age';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // create driver
                        try {
                        final driver = Driver(
                          id: 0,
                          name: _nameController.text,
                          age: int.parse(_ageController.text),
                          phone: _phoneController.text,
                        );

                          await Provider.of<DriverProvider>(context, listen: false).createDriver(driver);
                          print('Driver created successfully');

                          _nameController.clear();
                          _ageController.clear();
                          _phoneController.clear();

                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to create driver: $error'),
                            ),
                          );
                        }
                        // await Provider.of<DriverProvider>(context, listen: false).createDriver(driver);
                        Navigator.of(context).pop();
                      }

                    },
                    child: Text('Create Driver'),
                  ),
                ],
              ),
              ),
            ],
          ),


        );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Drivers')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          formPopup(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Consumer<DriverProvider>(
          builder: (context, driverProvider, child) {
            final drivers = driverProvider.drivers;
            if (drivers.isEmpty) {
              return const Center(
                child: Text('No drivers added yet'),
              );
            }
            return ListView.builder(
              itemCount: drivers.length,
              itemBuilder: (context, index) {
                final driver = drivers[index];
                return _listItem(driver, driverProvider);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _listItem(Driver driver, DriverProvider driverProvider) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${driver.name}'),
              Text('Age: ${driver.age}'),
              Text('Phone: ${driver.phone}'),
            ],
          ),
          const Spacer(),
          IconButton(
              onPressed: (){
                driverProvider.deleteDriver(driver.id);
              },
              icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

}
