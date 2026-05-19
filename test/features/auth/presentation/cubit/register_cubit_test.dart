import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/auth/domain/entities/register_outcome.dart';
import 'package:foodify_cooking/features/auth/domain/entities/user_entity.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/register_usecase.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/register_cubit.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/register_state.dart';

void main() {
  group('RegisterCubit', () {
    test('emits success when use case returns RegisterSignedIn', () async {
      const user = UserEntity(
        id: 'u',
        email: 'demo@example.com',
        name: 'Demo',
      );
      final cubit = RegisterCubit(
        _FakeRegisterUseCase(
          const Success<RegisterOutcome>(RegisterSignedIn(user)),
        ),
      );

      final emitted = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<RegisterState>((s) => s.status == RegisterStatus.loading),
          predicate<RegisterState>(
            (s) => s.status == RegisterStatus.success && s.user == user,
          ),
        ]),
      );

      await cubit.register(
        name: 'Demo',
        email: 'demo@example.com',
        password: 'super-secret',
      );

      await emitted;
      await cubit.close();
    });

    test(
      'emits confirmationRequired when use case returns RegisterNeedsConfirmation',
      () async {
        final cubit = RegisterCubit(
          _FakeRegisterUseCase(
            const Success<RegisterOutcome>(
              RegisterNeedsConfirmation('demo@example.com'),
            ),
          ),
        );

        final emitted = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<RegisterState>((s) => s.status == RegisterStatus.loading),
            predicate<RegisterState>(
              (s) =>
                  s.status == RegisterStatus.confirmationRequired &&
                  s.pendingConfirmationEmail == 'demo@example.com',
            ),
          ]),
        );

        await cubit.register(
          name: 'Demo',
          email: 'demo@example.com',
          password: 'super-secret',
        );

        await emitted;
        await cubit.close();
      },
    );

    test(
      'emits failure with mapped error key on use case Failure',
      () async {
        final cubit = RegisterCubit(
          _FakeRegisterUseCase(
            const Failure<RegisterOutcome>('auth_failure_register_failed'),
          ),
        );

        final emitted = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<RegisterState>((s) => s.status == RegisterStatus.loading),
            predicate<RegisterState>(
              (s) =>
                  s.status == RegisterStatus.failure &&
                  s.errorMessage == 'auth_failure_register_failed',
            ),
          ]),
        );

        await cubit.register(
          name: 'Demo',
          email: 'demo@example.com',
          password: 'super-secret',
        );

        await emitted;
        await cubit.close();
      },
    );
  });
}

class _FakeRegisterUseCase implements RegisterUseCase {
  _FakeRegisterUseCase(this._result);

  final Result<RegisterOutcome> _result;

  @override
  Future<Result<RegisterOutcome>> call(RegisterParams params) async => _result;
}
