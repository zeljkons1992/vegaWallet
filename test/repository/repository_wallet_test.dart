// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:retrofit/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';
// import 'package:vegawallet/core/data_state/data_state.dart';
// import 'package:vegawallet/features/stores/data/data_sources/spreadsheet_downloader.dart';
// import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';
// import 'package:vegawallet/features/wallet/data/repository/wallet_repository_impl.dart';
// import 'package:vegawallet/core/services/auth_services.dart';
// import 'package:vegawallet/features/wallet/domain/utils/wallet_excel_parser.dart';
//
// class MockAuthServices extends Mock implements AuthService {}
// class MockSpreadsheetDownloader extends Mock implements SpreadsheetDownloader {}
// class MockWalletExcelParser extends Mock implements WalletExcelParser {}
//
// void main() {
//   setUpAll(() {
//     registerFallbackValue<List<int>>([]); // Registering an empty List<int> as fallback value
//   });
//
//   group('WalletRepositoryImpl Tests', () {
//     late WalletRepositoryImpl walletRepositoryImpl;
//     late MockAuthServices mockAuthServices;
//     late MockSpreadsheetDownloader mockSpreadsheetDownloader;
//     late MockWalletExcelParser mockWalletExcelParser;
//
//     setUp(() async {
//       mockAuthServices = MockAuthServices();
//       mockSpreadsheetDownloader = MockSpreadsheetDownloader();
//       mockWalletExcelParser = MockWalletExcelParser();
//
//       walletRepositoryImpl = WalletRepositoryImpl(
//         mockAuthServices,
//         mockSpreadsheetDownloader,
//         mockWalletExcelParser,
//       );
//
//       SharedPreferences.setMockInitialValues({});
//       await dotenv.load();
//     });
//
//     const walletCardInformation = WalletCardInformation(
//       name: "Nikola",
//       expireDate: '12/25',
//       cardNo: '111 111',
//     );
//
//     test('should return success with valid data from SharedPreferences', () async {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_name', 'Nikola');
//       await prefs.setString('card_number', '111 111');
//       await prefs.setString('expire_date', '12/25');
//
//       final result = await walletRepositoryImpl.getWalletCardInformation();
//
//       expect(result.status, equals(DataStateStatus.success));
//       expect(result.data?.name, equals(walletCardInformation.name));
//     });
//
//     test('should fetch data from external source when SharedPreferences is empty', () async {
//       when(() => mockAuthServices.getUserName())
//           .thenAnswer((_) async => "Nikola Tesla");
//       when(() => mockSpreadsheetDownloader.downloadExcelFile(any(), any()))
//           .thenAnswer((_) async => HttpResponse([1, 2, 3, 4], Response(requestOptions: RequestOptions(path: ''))));
//       when(() => mockWalletExcelParser.getCardNumber(any(), 'Nikola', 'Tesla'))
//           .thenReturn('111 111');
//
//       final result = await walletRepositoryImpl.getWalletCardInformation();
//
//       expect(result.status, equals(DataStateStatus.success));
//       expect(result.data?.name, equals('Nikola Tesla'));
//       expect(result.data?.cardNo, equals('111 111'));
//     });
//
//     test('should return error when user name is null', () async {
//       when(() => mockAuthServices.getUserName())
//           .thenAnswer((_) async => null);
//
//       final result = await walletRepositoryImpl.getWalletCardInformation();
//
//       expect(result.status, equals(DataStateStatus.error));
//       expect(result.message, equals("User not found"));
//     });
//
//     test('should return error when card number is not found', () async {
//       when(() => mockAuthServices.getUserName())
//           .thenAnswer((_) async => "Nikola Tesla");
//       when(() => mockSpreadsheetDownloader.downloadExcelFile(any(), any()))
//           .thenAnswer((_) async => HttpResponse([1, 2, 3, 4], Response(requestOptions: RequestOptions(path: ''))));
//       when(() => mockWalletExcelParser.getCardNumber(any(), 'Nikola', 'Tesla'))
//           .thenReturn(null);
//
//       final result = await walletRepositoryImpl.getWalletCardInformation();
//
//       expect(result.status, equals(DataStateStatus.error));
//       expect(result.message, equals("No matching card number found"));
//     });
//
//     test('should return error when download fails', () async {
//       when(() => mockAuthServices.getUserName())
//           .thenAnswer((_) async => "Nikola Tesla");
//       when(() => mockSpreadsheetDownloader.downloadExcelFile(any(), any()))
//           .thenThrow(Exception('Download failed'));
//
//       final result = await walletRepositoryImpl.getWalletCardInformation();
//
//       expect(result.status, equals(DataStateStatus.error));
//       expect(result.message, equals("Failed to fetch data: Exception: Download failed"));
//     });
//   });
// }
