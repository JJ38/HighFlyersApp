class Validator {

  final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final RegExp digitRegex = RegExp(r'^\d+$');
  String validationErrorMessage = "";
  
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

}