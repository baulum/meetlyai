import 'package:flutter/material.dart';

import 'app_router.dart';
import 'theme/app_theme.dart';

class MeetlyAiApp extends StatelessWidget {
  const MeetlyAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MeetlyAI',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
