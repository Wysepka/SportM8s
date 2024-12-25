import 'package:get_it/get_it.dart';
import '../platform/platform_service.dart';

final GetIt locator = GetIt.instance;

void setupDependencies() {
  // Platform services
  locator.registerLazySingleton<PlatformService>(() => PlatformServiceImpl());
  
  // Other dependencies...
} 