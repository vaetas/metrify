import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:metrify/resources/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(title: Text('Settings')),
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
                title: Text('About this app'),
                subtitle: Text('Report issues & check source code'),
                leading: Icon(FeatherIcons.helpCircle),
                onTap: () async {
                  final url = r'https://github.com/vaetas/metrify';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}