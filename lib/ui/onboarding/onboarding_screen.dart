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
import 'package:metrify/resources/config.dart';
import 'package:metrify/ui/home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageViewController = PageController();

  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController.addListener(() {
      final page = _pageViewController.page.round();
      if (_page != page) {
        setState(() {
          _page = page;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Metrify',
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        Container(
                          child: Text(
                            'Track all your metrics',
                            style: Theme.of(context).textTheme.subhead,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    child: PageView(
                      controller: _pageViewController,
                      children: <Widget>[
                        _FeaturesView(),
                        _AboutView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: _Button(
                  child: Text(
                    _page == 0 ? 'Continue' : 'Begin',
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                  onPressed: () async {
                    if (_page == 0) {
                      _pageViewController.animateToPage(
                        1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.fastOutSlowIn,
                      );
                    } else {
                      await Hive.box(configBox).put(
                        ConfigKeys.passedOnboarding,
                        true,
                      );
                      Navigator.pushReplacementNamed(
                        context,
                        HomeScreen.routeName,
                      );
                    }
                  },
                ),
              ),
              alignment: Alignment.bottomCenter,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }
}

class _FeaturesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _InfoItem(
            icon: const Icon(FeatherIcons.code),
            text: const Text(
                'Define your custom data types. Numbers, enumerations, ranges.'),
          ),
          _InfoItem(
            text: const Text(
                'Create activities and assign types to them. Everything from running to weight can be activity'),
            icon: const Icon(FeatherIcons.activity),
          ),
          _InfoItem(
            icon: const Icon(FeatherIcons.edit),
            text: const Text('Add entries to your activities. Track progress.'),
          ),
        ],
      ),
    );
  }
}

class _AboutView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _InfoItem(
        icon: const Icon(FeatherIcons.alertCircle),
        text: Text.rich(TextSpan(children: [
          WidgetSpan(
              child: Text(
            'Warning',
            style: TextStyle(fontWeight: FontWeight.w600),
          )),
          WidgetSpan(
              child: Text(
            'This app is in very initial stage of development. Many features are missing and'
            ' bugs might appear. Be careful.',
          ))
        ])),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  _Button({Key key, this.child, this.onPressed}) : super(key: key);

  final _borderRadius = BorderRadius.circular(30);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
      ),
      child: Material(
        color: Theme.of(context).accentColor,
        borderRadius: _borderRadius,
        child: InkWell(
          borderRadius: _borderRadius,
          onTap: onPressed,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final Widget icon;
  final Widget text;

  _InfoItem({Key key, this.icon, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Container(
              padding: const EdgeInsets.only(right: 15),
              child: icon,
            ),
          ),
          Flexible(
            flex: 2,
            child: text,
          ),
        ],
      ),
    );
  }
}
