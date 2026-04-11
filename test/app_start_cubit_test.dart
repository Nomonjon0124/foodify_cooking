import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/app/cubit/app_start_cubit.dart';
import 'package:foodify_cooking/app/cubit/app_start_state.dart';
import 'package:foodify_cooking/core/services/storage_service.dart';

void main() {
  test('AppStartCubit emits loading then ready', () async {
    final cubit = AppStartCubit(StorageService());
    final emitted = <AppStartStatus>[];

    final sub = cubit.stream.listen((state) {
      emitted.add(state.status);
    });

    await cubit.initialize();
    await Future<void>.delayed(Duration.zero);

    expect(emitted, [AppStartStatus.loading, AppStartStatus.ready]);

    await sub.cancel();
    await cubit.close();
  });
}
