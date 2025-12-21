class AppFormValidator {
  AppFormValidator._();

  static String? validateNameField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the value.';
    }
    if (value.length < 2) {
      return 'The name is too short';
    }
    return null;
  }

  static String? validateWeightField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the value.';
    }
    final double? parsedValue = double.tryParse(value);
    if (parsedValue == null) {
      return 'Incorrect value';
    }
    return null;
  }

  static String? validateRepetitionsField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the value.';
    }
    final int? parsedValue = int.tryParse(value);
    if (parsedValue == null) {
      return 'Incorrect value';
    }
    return null;
  }

  static String? validateSetsField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the weight.';
    }
    final int? parsedValue = int.tryParse(value);
    if (parsedValue == null) {
      return 'Incorrect value';
    }
    return null;
  }
}
