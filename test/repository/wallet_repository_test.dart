import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:retrofit/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/core/services/auth_services.dart';
import 'package:vegawallet/features/stores/data/data_sources/spreadsheet_downloader.dart';
import 'package:vegawallet/features/wallet/data/models/wallet_card_information.dart';
import 'package:vegawallet/features/wallet/data/repository/wallet_repository_impl.dart';
import 'package:vegawallet/features/wallet/domain/utils/wallet_excel_parser.dart';

class MockAuthService extends Mock implements AuthService {}

class MockSpreadsheetDownloader extends Mock implements SpreadsheetDownloader {}

class MockWalletExcelParser extends Mock implements WalletExcelParser {}

class FakeHttpResponse<T> extends Fake implements HttpResponse<T> {
  @override
  T data;
  FakeHttpResponse(this.data);
}

void main() {
  late MockAuthService mockAuthService;
  late MockSpreadsheetDownloader mockSpreadsheetDownloader;
  late MockWalletExcelParser mockWalletExcelParser;
  late WalletRepositoryImpl walletRepository;

  setUp(() {
    mockAuthService = MockAuthService();
    mockSpreadsheetDownloader = MockSpreadsheetDownloader();
    mockWalletExcelParser = MockWalletExcelParser();
    walletRepository = WalletRepositoryImpl(
      mockAuthService,
      mockSpreadsheetDownloader,
      mockWalletExcelParser,
    );
  });

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(FakeHttpResponse<List<int>>([]));
    dotenv.testLoad(fileInput: '''EXCEL_FORMAT=xlsx
EXCEL_URL2=https://example.com/file.xlsx''');
  });

  group('WalletRepositoryImpl', () {
    test('getWalletCardInformation returns DataState.success with valid data from shared preferences', () async {
      SharedPreferences.setMockInitialValues({
        'user_name': 'John Doe',
        'card_number': '1234567890',
        'expire_date': '12/25',
      });

      final result = await walletRepository.getWalletCardInformation();

      expect(result, isA<DataState<WalletCardInformation>>());
      expect(result.data!.name, 'John Doe');
      expect(result.data!.cardNo, '1234567890');
      expect(result.data!.expireDate, '12/25');
    });

    test('getWalletCardInformation fetches data and saves to shared preferences when preferences are empty', () async {
      SharedPreferences.setMockInitialValues({});
      when(() => mockAuthService.getUserName()).thenAnswer((_) async => 'John Doe');
      final fakeResponse = FakeHttpResponse<List<int>>([]);
      when(() => mockSpreadsheetDownloader.downloadExcelFile(any(), any())).thenAnswer((_) async => fakeResponse);
      when(() => mockWalletExcelParser.getCardNumber(any(), any(), any())).thenReturn('1234567890');

      final result = await walletRepository.getWalletCardInformation();

      expect(result, isA<DataState<WalletCardInformation>>());
      expect(result.data!.name, 'John Doe');
      expect(result.data!.cardNo, '1234567890');
      expect(result.data!.expireDate, '12/25');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_name'), 'John Doe');
      expect(prefs.getString('card_number'), '1234567890');
      expect(prefs.getString('expire_date'), '12/25');
    });

    test('getWalletCardInformation returns error when user name format is invalid', () async {
      SharedPreferences.setMockInitialValues({});
      when(() => mockAuthService.getUserName()).thenAnswer((_) async => 'John');

      final result = await walletRepository.getWalletCardInformation();

      expect(result, isA<DataState<WalletCardInformation>>());
    });

    test('getWalletCardInformation returns error when no matching card number found', () async {
      SharedPreferences.setMockInitialValues({});
      when(() => mockAuthService.getUserName()).thenAnswer((_) async => 'John Doe');
      final fakeResponse = FakeHttpResponse<List<int>>([]);
      when(() => mockSpreadsheetDownloader.downloadExcelFile(any(), any())).thenAnswer((_) async => fakeResponse);
      when(() => mockWalletExcelParser.getCardNumber(any(), any(), any())).thenReturn(null);

      final result = await walletRepository.getWalletCardInformation();

      expect(result, isA<DataState<WalletCardInformation>>());
    });

    test('getWalletCardInformation returns error when an exception is thrown', () async {
      SharedPreferences.setMockInitialValues({});
      when(() => mockAuthService.getUserName()).thenThrow(Exception('User not found'));

      final result = await walletRepository.getWalletCardInformation();

      expect(result, isA<DataState<WalletCardInformation>>());
    });

    test('getWalletCardInformation returns error when user is null', () async {
      SharedPreferences.setMockInitialValues({});
      when(() => mockAuthService.getUserName()).thenAnswer((_) async => null);

      final result = await walletRepository.getWalletCardInformation();

      expect(result, isA<DataState<WalletCardInformation>>());
    });
  });
}
