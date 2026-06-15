import 'package:flutter_riverpod/flutter_riverpod.dart';

class CityState {
  const CityState();
}

class CityCubit extends Notifier<CityState> {
  @override
  CityState build() => const CityState();
}

final cityCubitProvider =
    NotifierProvider<CityCubit, CityState>(CityCubit.new);
