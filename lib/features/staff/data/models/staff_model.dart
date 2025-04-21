import '../../domain/entities/staff.dart';

class StaffModel extends Staff {
  final String? password;
  final int? age;
  final int? height;
  final String? phone;
  final String? uid;

  StaffModel({
    required int id,
    String? username,
    String? email,
    String? roleName,
    this.password,
    this.age,
    this.height,
    this.phone,
    this.uid,
  }) : super(
          id: id,
          username: username,
          email: email,
          roleName: roleName,
        );

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      age: json['age'],
      height: json['height'],
      phone: json['phone'],
      uid: json['uid'],
      roleName: json['role_name'],
    );
  }
}
