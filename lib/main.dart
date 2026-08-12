import 'package:flutter/foundation.dart';
import 'app/bootstrap.dart';
import 'app/app.dart';

void main() {
  BindingBase.debugZoneErrorsAreFatal = true;
  bootstrap(() async {
    return const App();
  });
}
