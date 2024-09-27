import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/auth/domain/usecases/logout_user_use_case.dart';

import 'is_user_vega_use_case_test.dart';


void main(){
  late LogoutUserUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp((){
    mockAuthRepository = MockAuthRepository();
    useCase = LogoutUserUseCase(mockAuthRepository);
  });

  test('should returnt data state success', () async{
    when(() => mockAuthRepository.logoutUser()).thenAnswer((_) async => DataState.success());

    final result = await useCase.call();

    expect(result, equals(DataState.success()));
  });

  test('should return data state error', () async{
    when(() => mockAuthRepository.logoutUser()).thenAnswer((_) async => DataState.error("error"));
    final result = await useCase.call();
    expect(result, DataState.error("error"));
  });
}