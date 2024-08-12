import 'package:equatable/equatable.dart';

class PositionSimple extends Equatable{
  final double latitude;
  final double longitude;

  const PositionSimple({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude,longitude];
}