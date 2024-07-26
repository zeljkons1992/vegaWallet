import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:vegawallet/core/data_state/data_state.dart';
import 'package:vegawallet/features/profile/domain/entites/user_profile_information.dart';

import '../../../maps/domain/usecase/update_user_location_use_case.dart';
import '../../domain/usecases/get_user_information_use_case.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@Injectable()
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserInformationUseCase _getUserInformationUseCase;
  final UpdateUserLocationUseCase _updateUserLocationUseCase;
  ProfileBloc(this._getUserInformationUseCase, this._updateUserLocationUseCase) : super(ProfileInitial()) {
    on<GetUserInformation>(_getUserInformation);
    on<UpdateUserLocation>(_onUpdateUserLocation);
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
    print("UPDATE-OVAO USER LOCATION");
  }
}
