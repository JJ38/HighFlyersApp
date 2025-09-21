class Validator {

  final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegExp digitRegex = RegExp(r'^\d+$');
  String validationErrorMessage = "";

  bool isValidString(String? value){

    if(value == null || value == ""){
      validationErrorMessage = "Please enter a value";
      return false;
    }

    return true;

  }

  
  bool isValidPositiveNumber(String? number){


    if(number == null || number == ""){
      validationErrorMessage = "Please enter a value";
      return false;
    }

    if(int.parse(number) < 0){
      validationErrorMessage = "Please enter a value greater than 0";
      return false;
    }

    return true;

  }

  
  bool isValidEmail(String? email){

    if(email == null){
      validationErrorMessage = "Please enter an email address";
      return false;
    }
 
    if(!emailRegex.hasMatch(email)){
      validationErrorMessage = "Invalid Email";
      return false;
    }
    
    
    return true;
  }

  bool isValidPhoneNumber(String? phoneNumberInput){

    if(phoneNumberInput == null){
      validationErrorMessage = "Please enter a phone number";
      return false;
    }

    if(phoneNumberInput.length != 11 || !digitRegex.hasMatch(phoneNumberInput)){
      validationErrorMessage = "Invalid Phone Number";
      return false;
    }

    return true;

  }

  bool isValidPostcode(String? postcodeInput){

    if(postcodeInput == null){
      validationErrorMessage = "Please enter a postcode";
      return false;
    }

    postcodeInput = postcodeInput.replaceAll(" ", "");

    if(postcodeInput.length < 2 || postcodeInput.length > 7){
      validationErrorMessage = "Invalid Postcode";
      return false;
    }

    return true;
  }

  bool isValidValueInList(String? value, List<dynamic> list){

    if(value == null){
      print("isValidValueInList - null");
      validationErrorMessage = "Please select a value";
      return false;
    }

    if(!list.contains(value)){
      validationErrorMessage = "Please select a valid value";
      return false;
    }

    return true;

  }

}