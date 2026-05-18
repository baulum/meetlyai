import 'package:go_router/go_router.dart';

import 'presentation/shell/desktop_shell.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const DesktopShell()),
  ],
);
