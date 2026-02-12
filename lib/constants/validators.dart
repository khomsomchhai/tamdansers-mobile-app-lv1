class Validators {
  static String? email(value){
    if(value!.isEmpty){
      return "សូមបញ្ចូលអ៊ីម៉ែល";
    }else if(!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)){
      return "អ៊ីម៉ែលមិនត្រឹមត្រូវ";
    }
    return null;
  }
  static String? emailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return "សូមបញ្ចូលអ៊ីម៉ែល ឬ លេខទូរស័ព្ទ";
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final phoneRegex = RegExp(r'^(0[0-9]{8,9}|\+855[0-9]{8,9})$');

    if (emailRegex.hasMatch(value) || phoneRegex.hasMatch(value)) {
      return null;
    }
    return "អ៊ីម៉ែល ឬ លេខទូរស័ព្ទមិនត្រឹមត្រូវ";
  }

  static String? password(value){
    if(value!.isEmpty){
      return "សូមបញ្ចូលពាក្យសម្ងាត់";
    }else if(!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\-])(.{8,})$').hasMatch(value)){
      return "ពាក្យសម្ងាត់មិនត្រឹមត្រូវ";
    }
    return null;
  }
  static String? cnfPassword(value, String password){
    if(value!.isEmpty){
      return "សូមបញ្ចូលពាក្យសម្ងាត់";
    }else if(value! != password){
      return "ពាក្យសម្ងាត់មិនត្រឹមត្រូវ";
    }
    return null;
  }
  static String? inputData(value){
    if(value!.isEmpty){
      return "សូមបញ្ចូលទិន្នន័យ";
    }
    return null;
  }
}