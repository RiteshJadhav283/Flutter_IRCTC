import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:no_backend_frontend/app.dart';
import 'package:no_backend_frontend/providers/auth_provider.dart';
import 'package:no_backend_frontend/providers/train_provider.dart';
import 'package:no_backend_frontend/providers/booking_provider.dart';
import 'package:no_backend_frontend/providers/pnr_provider.dart';
import 'package:no_backend_frontend/providers/theme_provider.dart';
import 'package:no_backend_frontend/screens/auth/login_screen.dart';
import 'package:no_backend_frontend/utils/constants.dart';

void main() {
  setUp(() {
    Animate.restartOnHotReload = false;
  });

  testWidgets('RailGo Frontend Local Storage smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => TrainProvider()),
          ChangeNotifierProvider(create: (_) => BookingProvider()),
          ChangeNotifierProvider(create: (_) => PNRProvider()),
        ],
        child: const RailGoApp(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));

    // Verify RailGo branding is rendered on splash
    expect(find.text('Rail'), findsOneWidget);
    expect(find.text('Go'), findsOneWidget);
    expect(find.text(AppConstants.appTagline), findsOneWidget);

    // Settle splash timer and check navigation to login screen
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
