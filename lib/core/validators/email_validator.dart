String? emailValidator(String? input){

  if(input == null || input.isEmpty){
    return "Please insert something";
  }

  if(!input.contains('@') && !input.contains('.')){
    return "Not a valid email address";
  }

  return null;

}