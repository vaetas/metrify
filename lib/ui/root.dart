import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:metrify/resources/config.dart';
import 'package:metrify/ui/home/home_screen.dart';
import 'package:metrify/ui/onboarding/onboarding_screen.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box(configBox).listenable(keys: [ConfigKeys.passedOnboarding]),
      builder: (context, value, _) {
        bool passedOnboarding = (value.get(ConfigKeys.passedOnboarding) as bool) ?? false;

        if (passedOnboarding) {
          return HomeScreen();
        } else {
          return OnboardingScreen();
        }
      },
    );
  }
}
