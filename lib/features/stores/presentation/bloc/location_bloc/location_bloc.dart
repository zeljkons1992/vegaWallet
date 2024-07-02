import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/entities/position.dart';
import '../../../domain/usecases/get_current_location_use_case.dart';

part 'location_event.dart';
part 'location_state.dart';

@Injectable()
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final  GetCurrentLocationUseCase _getCurrentLocationUseCase;

  LocationBloc(this._getCurrentLocationUseCase) : super(LocationInitial()) {
    on<GetLocation>(_onGetLocation);
  }

  Future<void> _onGetLocation(GetLocation event, Emitter<LocationState> emit) async {
    try {
      final position = await _getCurrentLocationUseCase();
      emit(LocationLoaded(position));
    } catch (e) {
      emit(LocationError("e"));
    }
  }
}
