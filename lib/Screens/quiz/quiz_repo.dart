import '../../Models/quiz_model.dart';
import '../../base/Api_end_point/api_endpoints.dart';
import '../../base/Dio_services/dio_base_repository.dart';

class GetQuizRepository extends BaseRepository {
  Future<QuestionsResponseModel> getQuiz() async {
    final response = await getDataFromServer(
      ApiEndpoint.getQuestions,
      needsAuthorization: false,
      params: {},
    );
    return QuestionsResponseModel.fromJson(response.data);
  }
}
GetQuizRepository getQuizRepository = GetQuizRepository();
