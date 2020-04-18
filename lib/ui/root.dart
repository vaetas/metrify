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
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:metrify/resources/config.dart';
import 'package:metrify/resources/theme.dart';
import 'package:metrify/ui/home/home_screen.dart';
import 'package:metrify/ui/onboarding/onboarding_screen.dart';
import 'package:metrify/ui/settings/settings_screen.dart';
import 'package:metrify/ui/view/view_screen.dart';

class Root extends StatefulWidget {
  static const routeName = '/';

  final int screen;

  Root({Key key, this.screen = 0}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  int currentScreenIndex;

  @override
  void initState() {
    super.initState();
    currentScreenIndex = widget.screen;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable:
          Hive.box(configBox).listenable(keys: [ConfigKeys.passedOnboarding]),
      builder: (context, value, _) {
        bool passedOnboarding =
            (value.get(ConfigKeys.passedOnboarding) as bool) ?? false;

        if (passedOnboarding) {
          return Scaffold(
            body: IndexedStack(
              index: currentScreenIndex,
              children: <Widget>[
                HomeScreen(),
                ViewScreen(),
                SettingsScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentScreenIndex,
              onTap: (index) {
                setState(() {
                  currentScreenIndex = index;
                });
              },
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
              ),
              selectedItemColor: Theme.of(context).primaryColor,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  title: Text('Home'),
                  icon: Icon(
                    FeatherIcons.home,
                    size: AppTheme.bottomBarIconSize,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text('Views'),
                  icon: Icon(
                    FeatherIcons.trendingUp,
                    size: AppTheme.bottomBarIconSize,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text('Settings'),
                  icon: Icon(
                    FeatherIcons.settings,
                    size: AppTheme.bottomBarIconSize,
                  ),
                ),
              ],
            ),
          );
        } else {
          return OnboardingScreen();
        }
      },
    );
  }
}
