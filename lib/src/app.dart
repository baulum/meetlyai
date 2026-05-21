import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/providers.dart';
import 'app_router.dart';
import 'theme/app_theme.dart';

class MeetlyAiApp extends ConsumerWidget {
  const MeetlyAiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingComplete = ref.watch(onboardingCompleteProvider);
    return MaterialApp.router(
      title: 'MeetlyAI',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: onboardingComplete.maybeWhen(
        data: (complete) => complete ? appRouter : onboardingRouter,
        orElse: () => onboardingRouter,
      ),
    );
  }
}
