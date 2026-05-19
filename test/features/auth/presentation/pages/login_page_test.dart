import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/core/di/injection_container.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/auth/domain/auth_failure_messages.dart';
import 'package:foodify_cooking/features/auth/domain/entities/register_outcome.dart';
import 'package:foodify_cooking/features/auth/domain/entities/user_entity.dart';
import 'package:foodify_cooking/features/auth/domain/repositories/auth_repository.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/login_usecase.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/login_cubit.dart';
import 'package:foodify_cooking/features/auth/presentation/pages/login_page.dart';
import 'package:foodify_cooking/l10n/generated/app_localizations.dart';

void main() {
  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('email login failure shows the mapped error message', (
    tester,
  ) async {
    getIt.registerFactory<LoginCubit>(
      () => LoginCubit(LoginUseCase(_FailingAuthRepository())),
    );

    await tester.pumpWidget(const _LocalizedHarness(child: LoginPage()));

    await tester.enterText(find.byType(TextFormField).at(0), 'bad@test.local');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrong-pass');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('Invalid email or password'), findsOneWidget);
    expect(find.text('Login failed'), findsNothing);
  });
}

class _LocalizedHarness extends StatelessWidget {
  const _LocalizedHarness({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        );
      },
    );
  }
}

class _FailingAuthRepository implements AuthRepository {
  @override
  Stream<UserEntity?> authStateChanges() => const Stream<UserEntity?>.empty();

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    return const Success<UserEntity?>(null);
  }

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    return const Failure<UserEntity>(AuthFailureMessages.invalidCredentials);
  }

  @override
  Future<Result<void>> logout() async {
    return const Success<void>(null);
  }

  @override
  Future<Result<RegisterOutcome>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return const Failure<RegisterOutcome>(AuthFailureMessages.registerFailed);
  }

  @override
  Future<Result<void>> resendConfirmation({required String email}) async {
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> signInWithGoogle({required String redirectTo}) async {
    return const Failure<void>(AuthFailureMessages.googleSignInFailed);
  }
}
