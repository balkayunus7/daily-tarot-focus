import 'package:daily_tarot_focus/firebase_options.dart';
import 'package:mobile_boilerplate/infrastructure_dependencies.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
