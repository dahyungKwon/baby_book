import 'package:uuid/uuid.dart';

var uuid = const Uuid();

String getUuid() {
  return uuid.v4();
}
