/*
 * Metrify: Track Your Metrics
 * Copyright (C) 2020  Vojtech Pavlovsky
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

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
