import 'package:flutter/foundation.dart';

class ApiEndpoint {
  static const String baseUrl = kDebugMode ? 'http://192.168.1.76:3000' : 'http://192.168.1.76:3000';
  static const String imagebaseUrl = kDebugMode ? 'http://192.168.101.2:8080' : 'http://192.168.101.2:8080';

  static const String getCustomer= '/users/getUsers';
  static const String getQuestions= '/quiz/questions';

}
