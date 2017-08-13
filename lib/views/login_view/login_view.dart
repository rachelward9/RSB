import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';

import 'package:RSB/services/logger_service.dart';
import 'package:RSB/services/firebase_service.dart';

@Component(
  selector: 'login-view',
  templateUrl: 'login_view.html',
  directives: const [materialDirectives],
  providers: const []
)
class LoginView {
  final LoggerService _log;
  final FirebaseService fbService;

  LoginView(LoggerService this._log, FirebaseService this.fbService) {
    _log.info("$runtimeType()");
  }
}

