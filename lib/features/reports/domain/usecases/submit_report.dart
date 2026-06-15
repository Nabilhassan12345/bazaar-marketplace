import 'package:bazaar/features/reports/domain/repositories/report_repository.dart';

class SubmitReport {
  const SubmitReport(this._repository);

  final ReportRepository _repository;

  ReportRepository get repository => _repository;
}
