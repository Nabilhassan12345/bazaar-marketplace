import 'package:bazaar/features/blocks/domain/repositories/block_repository.dart';

class GetBlockedUsers {
  const GetBlockedUsers(this._repository);

  final BlockRepository _repository;

  BlockRepository get repository => _repository;
}
