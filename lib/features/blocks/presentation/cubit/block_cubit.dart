import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockState {
  const BlockState();
}

class BlockCubit extends Notifier<BlockState> {
  @override
  BlockState build() => const BlockState();
}

final blockCubitProvider =
    NotifierProvider<BlockCubit, BlockState>(BlockCubit.new);
