import 'package:flutter/foundation.dart';

class ApiEndpoint {
  static const String baseUrl = kDebugMode ? 'mongodb+srv://globaltechumesh11:hwkEuf3!QvLGxxb@projectmanage.an17y.mongodb.net' : 'mongodb+srv://globaltechumesh11:hwkEuf3!QvLGxxb@projectmanage.an17y.mongodb.net';
  static const String imagebaseUrl = kDebugMode ? 'http://192.168.101.2:8080' : 'http://192.168.101.2:8080';

  static const String getCustomer= '/users/getUsers';
  static const String getQuestions= '/quiz/questions';

}
