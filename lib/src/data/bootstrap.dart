import 'package:flutter_ioc/flutter_ioc.dart';
import '../../core.dart';

/// Bootstraps the `data` layer.
///
/// Clients and repository implementations are registered here along with any
/// providers. The `core` layer is bootstrapped after the `data` layer, so the
/// repositories are available for injection into the services.
Future<void> bootstrap() async {
  final IocContainer ioc = IocContainer.container;

  ioc.currentScope;
}