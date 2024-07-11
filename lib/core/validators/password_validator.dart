String? passwordValidator(String? input){

  if(input == null || input.isEmpty){
    return "Please insert something";
  }

  RegExp sonderzeichenRegex = RegExp(r'[!@#$%^&*()_+{}\[\]:;<>,.?~\\-]');
  
  if(input.length <= 8){
    return "Password has to be longer than 8 characters";
  }

  if(!sonderzeichenRegex.hasMatch(input)){
    return "Please type at least one special character";
  }


  return null;

}