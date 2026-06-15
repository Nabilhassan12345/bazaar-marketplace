import 'package:bazaar/features/blocks/domain/repositories/block_repository.dart';

class UnblockUser {
  const UnblockUser(this._repository);

  final BlockRepository _repository;

  BlockRepository get repository => _repository;
}
