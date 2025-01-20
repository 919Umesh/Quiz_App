import '../../Models/user_model.dart';
import '../../base/Api_end_point/api_endpoints.dart';
import '../../base/Dio_services/dio_base_repository.dart';

class GetCustomerRepository extends BaseRepository {
  Future<UserResponseModel> getCustomer() async {
    final response =  await getDataFromServer(
      ApiEndpoint.getCustomer,
      needsAuthorization: false,
      params: {},
    );
    return UserResponseModel.fromJson(response.data);
  }
}
GetCustomerRepository getCustomerRepository = GetCustomerRepository();
