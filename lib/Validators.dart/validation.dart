String? validatePhone(String? value) {
  if (value!.isEmpty) {
    return 'Mobile number is required';
  }
  if (value.length != 10) {
    return 'Please enter a valid mobile number';
  }
  if (RegExp(r'^[0-5]').hasMatch(value)) {
    return 'Invalid format';
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'Special characters not allowed';
  }
  return null;
}

String? validatePincode(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a Pincode';
  } else if (value.length != 6) {
    return 'Pincode must be 6 digits';
  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'Pincode must contain only digits';
  }
  return null;
}

String? validatecity(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your City';
  } 
  return null;
}

String? validatestate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your State';
  } 
  return null;
}
String? validateStreet(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a Street name';
  } else if (value.length < 10) {
    return 'Street must be 10 characters';
  } 
  return null;
}

String? validateName(String? value) {
  if (value!.isEmpty) {
    return 'Name is required';
  }
  if (!RegExp(r'^[A-Za-z ]+$').hasMatch(value)) {
    return ' Enter Alphabetic characters only';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value!.isEmpty) {
    return 'Email is required';
  }

  if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value)) {
    return 'Enter a valid email address';
  }

  return null;
}

String? validateAccountNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your account number';
  } else if (!RegExp(r'^[0-9]{10,16}$').hasMatch(value)) {
    return 'Please enter a valid account number (10-16 digits)';
  }
  return null;
}
