import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportState {
  const ReportState();
}

class ReportCubit extends Notifier<ReportState> {
  @override
  ReportState build() => const ReportState();
}

final reportCubitProvider =
    NotifierProvider<ReportCubit, ReportState>(ReportCubit.new);
