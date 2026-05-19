import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/resend_confirmation_email_usecase.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/verify_email_cubit.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/verify_email_state.dart';

void main() {
  group('VerifyEmailCubit', () {
    test('emits loading then success when use case succeeds', () async {
      final cubit = VerifyEmailCubit(
        _FakeResendUseCase(const Success<void>(null)),
      );

      final emitted = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<VerifyEmailState>(
            (s) => s.status == VerifyEmailStatus.loading,
          ),
          predicate<VerifyEmailState>(
            (s) => s.status == VerifyEmailStatus.success,
          ),
        ]),
      );

      await cubit.resend(email: 'demo@example.com');

      await emitted;
      await cubit.close();
    });

    test(
      'emits loading then failure with mapped error on use case Failure',
      () async {
        final cubit = VerifyEmailCubit(
          _FakeResendUseCase(
            const Failure<void>('auth_failure_resend_rate_limited'),
          ),
        );

        final emitted = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<VerifyEmailState>(
              (s) => s.status == VerifyEmailStatus.loading,
            ),
            predicate<VerifyEmailState>(
              (s) =>
                  s.status == VerifyEmailStatus.failure &&
                  s.errorMessage == 'auth_failure_resend_rate_limited',
            ),
          ]),
        );

        await cubit.resend(email: 'demo@example.com');

        await emitted;
        await cubit.close();
      },
    );

    test('ignores empty email', () async {
      final useCase = _FakeResendUseCase(const Success<void>(null));
      final cubit = VerifyEmailCubit(useCase);

      await cubit.resend(email: '   ');

      expect(useCase.callCount, 0);
      expect(cubit.state.status, VerifyEmailStatus.initial);
      await cubit.close();
    });
  });
}

class _FakeResendUseCase implements ResendConfirmationEmailUseCase {
  _FakeResendUseCase(this._result);

  final Result<void> _result;
  int callCount = 0;

  @override
  Future<Result<void>> call(ResendConfirmationEmailParams params) async {
    callCount++;
    return _result;
  }
}
