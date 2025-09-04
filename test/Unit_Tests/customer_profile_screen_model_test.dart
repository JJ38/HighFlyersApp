import 'package:flutter_test/flutter_test.dart';
import 'package:high_flyers_app/models/customer_profile_screen_model.dart';
import 'package:high_flyers_app/screens/customer/customer_profile_screen.dart';


void main() {

  CustomerProfileScreenModel model =  CustomerProfileScreenModel();

  final bool Function(String?) isValidEmail = model.isValidEmail;
  final bool Function(String?) isValidPostcode = model.isValidPostcode;
  final bool Function(String?) isValidPhoneNumber = model.isValidPhoneNumber;


  group('model.isValidEmail', () {
    test('should return true for a valid email address', () {
      expect(isValidEmail('test@example.com'), isTrue);
    });

    test('should return false for a valid email address', () {
      expect(isValidEmail('testexample.com'), isFalse);
    });

    test('should return false for a valid email address', () {
      expect(isValidEmail('test@example'), isFalse);
    });

    test('should return false for a valid email address', () {
      expect(isValidEmail('test@example.'), isFalse);
    });

    test('should return false for an invalid email address and set error message', () {
      expect(isValidEmail('invalid-email'), isFalse);
    });

    test('should return false for a null email and set error message', () {
      expect(isValidEmail(null), isFalse);
    });

    test('should return false for an empty string and set error message', () {
      expect(isValidEmail(''), isFalse);
    });
  });

  group('model.isValidPhoneNumber', () {
    test('should return true for a valid 11-digit phone number', () {
      expect(isValidPhoneNumber('07712345678'), isTrue);
    });

    test('should return false for a phone number with letters and set error message', () {
      expect(isValidPhoneNumber('077abc45678'), isFalse);
    });

    test('should return false for a number that is not 11 digits long', () {
      expect(isValidPhoneNumber('0771234567'), isFalse);
    });

    test('should return false for a null phone number and set error message', () {
      expect(isValidPhoneNumber(null), isFalse);
    });

    test('should return false for an empty string and set error message', () {
      expect(isValidPhoneNumber(''), isFalse);
    });
  });

  group('model.isValidPostcode', () {

    test('should return false for a postcode with less than 2 characters', () {
      expect(isValidPostcode('A'), isFalse);
    });

    test('should return false for a postcode with 7 or more characters', () {
      expect(isValidPostcode('SW1A0AAX'), isFalse);
    });

    test('should return false for a postcode with 7 or more characters', () {
      expect(isValidPostcode('SW1A 0AAX'), isFalse);
    });

    test('Postcode 5 in length without space', () {
      expect(isValidPostcode('L10AA'), isTrue);
    });

    test('Postcode 5 in length with space', () {
      expect(isValidPostcode('L1 0AA'), isTrue);
    });

    test('Postcode 6 in length without space', () {
      expect(isValidPostcode('DE53GY'), isTrue);
    });

    test('Postcode 6 in length with space', () {
      expect(isValidPostcode('DE5 3GY'), isTrue);
    });

    test('Postcode 7 in length without space', () {
      expect(isValidPostcode('DE561TP'), isTrue);
    });

    test('Postcode 7 in length with space', () {
      expect(isValidPostcode('DE56 1TP'), isTrue);
    });

    test('should return false for a null postcode and set error message', () {
      expect(isValidPostcode(null), isFalse);
    });

    test('should return false for an empty string and set error message', () {
      expect(isValidPostcode(''), isFalse);
    });
  });

}