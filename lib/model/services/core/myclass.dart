// Helper functions for JSON conversion
import 'package:flutter/material.dart';

String jsonToString(dynamic value) {
  if (value == null) return '';
  return value.toString();
}

double jsonToDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

int jsonToInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}

DateTime jsonToDateTime(dynamic value) {
  if (value == null) return DateTime.now();
  if (value is DateTime) return value;
  try {
    return DateTime.parse(value.toString());
  } catch (e) {
    return DateTime.now();
  }
}

class ClientProfileData {
  String id;
  String firstName;
  String lastName;
  String emailAddress;
  String branch;
  double height;
  double weight;
  int isOldCustomer;
  String phoneNumber;
  String gender;
  DateTime dateJoined;
  DateTime dateOfBirth;

  ClientProfileData({
    this.id = '',
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.branch,
    required this.height,
    required this.weight,
    required this.isOldCustomer,
    required this.phoneNumber,
    required this.gender,
    required this.dateJoined,
    required this.dateOfBirth,
  });

  factory ClientProfileData.fromJson(Map<String, dynamic> json) {
    return ClientProfileData(
      id: jsonToString(json['id']),
      firstName: jsonToString(json['firstName']),
      lastName: jsonToString(json['lastName']),
      emailAddress: jsonToString(json['emailAddress']),
      branch: jsonToString(json['branch']),
      height: jsonToDouble(json['height']),
      weight: jsonToDouble(json['weight']),
      isOldCustomer: jsonToInt(json['isOldCustomer']),
      phoneNumber: jsonToString(json['phoneNumber']),
      gender: jsonToString(json['gender']),
      dateJoined: jsonToDateTime(json['dateJoined']),
      dateOfBirth: jsonToDateTime(json['dateOfBirth']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'emailAddress': emailAddress,
      'branch': branch,
      'height': height,
      'weight': weight,
      'isOldCustomer': isOldCustomer,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'dateJoined': dateJoined.toIso8601String(),
      'dateOfBirth': dateOfBirth.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ClientProfileData(id: $id, firstName: $firstName, lastName: $lastName, emailAddress: $emailAddress, branch: $branch, height: $height, weight: $weight, isOldCustomer: $isOldCustomer, phoneNumber: $phoneNumber, gender: $gender, dateJoined: $dateJoined, dateOfBirth: $dateOfBirth)';
  }
}

class ClientPaymentData {
  String? id; // Add primary key for payments
  String clientId;
  String firstName;
  String lastName;
  DateTime datePaid;
  DateTime expirationDate;
  String durationType;
  int duration;
  int amountPaid;
  String branch;

  ClientPaymentData({
    this.id,
    required this.clientId,
    required this.firstName,
    required this.lastName,
    required this.datePaid,
    required this.expirationDate,
    required this.duration,
    required this.amountPaid,
    required this.branch,
    required this.durationType,
  });

  factory ClientPaymentData.fromJson(Map<String, dynamic> json) {
    return ClientPaymentData(
      id: jsonToString(json['id']),
      clientId: jsonToString(json['clientId']),
      firstName: jsonToString(json['firstName']),
      durationType: jsonToString(json['durationType']),
      lastName: jsonToString(json['lastName']),
      datePaid: jsonToDateTime(json['datePaid']),
      expirationDate: jsonToDateTime(json['expirationDate']),
      duration: jsonToInt(json['duration']),
      amountPaid: jsonToInt(json['amountPaid']),
      branch: jsonToString(json['branch']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'clientId': clientId,
      'firstName': firstName,
      'lastName': lastName,
      'durationType': durationType,
      'datePaid': datePaid.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
      'duration': duration,
      'amountPaid': amountPaid,
      'branch': branch,
    };
  }

  @override
  String toString() {
    return 'ClientPaymentData(id: $id, clientId: $clientId, firstName: $firstName, lastName: $lastName, datePaid: $datePaid, expirationDate: $expirationDate, duration: $duration, amountPaid: $amountPaid, branch: $branch)';
  }
}

class BottomNavData {
  IconData icon;
  int index;
  String title;
  BottomNavData({required this.index, required this.icon, this.title = ''});
}
