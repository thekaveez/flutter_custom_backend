
class Driver {
  final int id;
  final String name;
  final int age;
  final String phone;


  Driver({
    required this.id,
    required this.name,
    required this.age,
    required this.phone,
  });


  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['driver_id'],
      name: json['name'],
      age: json['age'],
      phone: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() => {
    'driver_id': id,
    'name': name,
    'age': age,
    'phone_number': phone,
  };
}

