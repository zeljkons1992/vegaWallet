import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://docs.google.com/spreadsheets/d")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/{spreadsheetId}/export")
  @DioResponseType(ResponseType.bytes) // Ensure the response is treated as bytes
  Future<HttpResponse<List<int>>> downloadExcelFile(
      @Query("format") String format,
      @Path("spreadsheetId") String spreadsheetId,
      );
}
