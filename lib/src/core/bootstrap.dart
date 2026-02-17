import 'package:flutter_ioc/flutter_ioc.dart';


// import 'repositories/repositories.dart';
// import 'services/services.dart';

/// Bootstraps the `core` layer.
///
/// Services are registered here, and the repositories are injected into the
/// services. Because the `data` layer is bootstrapped before the `core`layer,
/// all repository implementations are available here for injection into the
/// services.
///
/// In cases where a service does more than host business logic, and is used
/// for managing a global object like a shopping cart for instance, the service
/// should be registered as a singleton.
Future<void> bootstrap() async {
  final IocContainer ioc = IocContainer.container;
  print("very nice");

}