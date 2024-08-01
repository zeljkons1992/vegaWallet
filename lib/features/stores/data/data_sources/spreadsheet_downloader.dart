import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'spreadsheet_downloader.g.dart';

@RestApi()
abstract class SpreadsheetDownloader {
  factory SpreadsheetDownloader(Dio dio, {String baseUrl}) = _SpreadsheetDownloader;

  @GET("/{spreadsheetId}/export")
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> downloadExcelFile(
      @Query("format") String format,
      @Path("spreadsheetId") String spreadsheetId,
      );

  @GET("/{spreadsheetId}/export")
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse<List<int>>> downloadExcelFile2(
      @Header("Authorization") String token,
      @Query("format") String format,
      @Path("spreadsheetId") String spreadsheetId,
      );
}
