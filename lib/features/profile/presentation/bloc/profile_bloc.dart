import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/profile/domain/entites/user_profile_information.dart';
import 'package:vegawallet/features/profile/domain/usecases/get_remote_user_information_use_case.dart';

import '../../../maps/domain/usecase/update_user_location_use_case.dart';
import '../../domain/usecases/get_user_information_use_case.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@Injectable()
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserInformationUseCase _getUserInformationUseCase;
  final UpdateUserLocationUseCase _updateUserLocationUseCase;
  final GetRemoteUserInformationUseCase _getRemoteUserInformationUseCase;
  ProfileBloc(this._getUserInformationUseCase, this._updateUserLocationUseCase, this._getRemoteUserInformationUseCase) : super(ProfileInitial()) {
    on<GetUserInformation>(_getUserInformation);
    on<UpdateUserLocation>(_onUpdateUserLocation);
    on<GetRemoteUserInformation>(_onGetRemoteUserInformation);
  }
  Future<void> _getUserInformation(GetUserInformation event, Emitter<ProfileState> emit) async {
    final result = await _getUserInformationUseCase();
    if(result.status == DataStateStatus.success){
      emit(ProfileInformationSuccess(result.data));
    }else{
      emit(ProfileInformationError());
    }
  }

  Future<FutureOr<void>> _onUpdateUserLocation(UpdateUserLocation event, Emitter<ProfileState> emit) async {
    await _updateUserLocationUseCase(params: event.user);
  }

  Future<FutureOr<void>> _onGetRemoteUserInformation(GetRemoteUserInformation event, Emitter<ProfileState> emit) async {
    final userResult = await _getUserInformationUseCase();

    if (userResult.status == DataStateStatus.success) {
      final UserProfileInformation user = userResult.data;
      final result = await _getRemoteUserInformationUseCase(params: user.uid);
      if(result.status == DataStateStatus.success){
        emit(ProfileInformationSuccess(result.data));
      } else{
        emit(ProfileInformationError());
      }
    } else{
      emit(ProfileInformationError());
    }
  }
}
