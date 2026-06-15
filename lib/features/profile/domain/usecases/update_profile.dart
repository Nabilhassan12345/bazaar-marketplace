import 'package:bazaar/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfile {
  const UpdateProfile(this._repository);

  final ProfileRepository _repository;

  ProfileRepository get repository => _repository;
}
