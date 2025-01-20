import 'package:get/get.dart';

import '../Screens/get_customer/get_customer_page.dart';
import '../Screens/quiz/quiz_page.dart';


class Routes {
  Routes._();

  static const String getCustomerPage = '/getCustomer';
  static const String getQuestionPage = '/getQuestionPage';

  static final routes = [
    GetPage(name: getCustomerPage, page: () =>  const GetCustomerPage()),
    GetPage(name: getQuestionPage, page: () =>  const GetQuizPage()),
  ];
}
