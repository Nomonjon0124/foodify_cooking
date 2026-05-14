import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection_container.dart';
import '../core/services/supabase_service.dart';
import 'observer.dart';

Future<void> bootstrap(Widget Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  await configureDependencies();
  Bloc.observer = const AppBlocObserver();
  runApp(builder());
}
