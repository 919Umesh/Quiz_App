import 'package:get/get.dart';

import '../../Screens/get_customer/get_customer_getX.dart';
import '../../Screens/quiz/quiz_getx.dart';


class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetCustomerController>(() => GetCustomerController(), fenix: true);
    Get.lazyPut<GetQuizController>(() => GetQuizController(), fenix: true);
  }
}
