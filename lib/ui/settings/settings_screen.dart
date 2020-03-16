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
import 'package:metrify/resources/routes.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Settings'),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                title: Text('Activities'),
                leading: Icon(FeatherIcons.activity),
                onTap: () {
                  Navigator.pushNamed(context, Routes.activityList);
                },
              ),
              ListTile(
                title: Text('Types'),
                leading: Icon(FeatherIcons.code),
                onTap: () {
                  Navigator.pushNamed(context, Routes.typeList);
                },
              ),
//              ListTile(
//                title: Text('Categories'),
//                leading: Icon(FeatherIcons.tag),
//                onTap: () {
//                  Navigator.pushNamed(context, Routes.categoryList);
//                },
//              ),
              Divider(),
              ListTile(
                title: Text('Export'),
                leading: Icon(FeatherIcons.arrowDown, size: 28),
                onTap: () {
                  Navigator.pushNamed(context, Routes.export);
                },
              ),
              Divider(),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  return ListTile(
                    title: Text('About'),
                    subtitle: Text(snapshot.hasData ? 'v' + snapshot.data.version : ''),
                    leading: Icon(FeatherIcons.helpCircle),
                    onTap: () async {
                      final url = r'https://github.com/vaetas/metrify';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  );
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
