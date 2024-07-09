import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/auth/domain/repository/auth_repository.dart';
import 'package:vegawallet/features/auth/domain/usecases/is_user_vega_use_case.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
void main(){
  late IsUserVegaUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    useCase = IsUserVegaUseCase(mockAuthRepository);
  });

  test('should returnt data state success', () async{
    when(() => mockAuthRepository.isUserVega()).thenAnswer((_) async => DataState.success());

    final result = await useCase.call();

    expect(result, equals(DataState.success()));
  });

  test('should return data state error', () async{
    when(() => mockAuthRepository.isUserVega()).thenAnswer((_) async => DataState.error("error"));
    final result = await useCase.call();
    expect(result, DataState.error("error"));
  });
}