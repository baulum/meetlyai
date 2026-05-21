import 'package:go_router/go_router.dart';

import 'presentation/onboarding/onboarding_view.dart';
import 'presentation/shell/desktop_shell.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const DesktopShell()),
  ],
);

final onboardingRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingView()),
  ],
);
