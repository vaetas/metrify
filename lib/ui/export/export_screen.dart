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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:metrify/models/activity.dart';
import 'package:metrify/ui/widgets/appbar_submit_button.dart';
import 'package:metrify/utils/export.dart';
import 'package:permission_handler/permission_handler.dart';

const _storagePermission = PermissionGroup.storage;

class ExportScreen extends StatefulWidget {
  @override
  _ExportScreenState createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  final _activityBox = Hive.box<Activity>(activityBox);
  Activity _activity;
  Set<Activity> _selectedActivities = {};

  bool _storagePermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkStoragePermissionStatus();
  }

  bool _canSubmit() => _storagePermissionGranted;

  Widget _buildGranted(Box<Activity> box) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Export'),
        actions: <Widget>[
          Builder(
            builder: (context) {
              return AppBarSubmitButton(
                label: 'Export',
                onPressed: _canSubmit()
                    ? () async {
                        await exportFile(
                          box.values.map((a) => a.toJson()).toList().toString(),
                        );

                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Export successful!'),
                        ));
                      }
                    : null,
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder<Directory>(
          future: getExportDirectory(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 15, top: 20),
                    child: Text('Exported file will be saved into following directory. If the file already exists, it '
                        'will be overwritten.'),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    // margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      snapshot.data.path,
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ],
              );
            } else {
              return Text('');
            }
          },
        ),
      ),
    );
  }

  Widget _buildNotGranted() {
    return Scaffold(
      appBar: AppBar(title: Text('Export')),
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text('Allow permissions'),
            onPressed: () => _requestStoragePermission(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Activity>>(
      valueListenable: _activityBox.listenable(),
      builder: (context, box, _) {
        return _storagePermissionGranted ? _buildGranted(box) : _buildNotGranted();
      },
    );
  }

  Future _requestStoragePermission() async {
    final Map<PermissionGroup, PermissionStatus> result =
        await PermissionHandler().requestPermissions([_storagePermission]);

    if (result[_storagePermission] == PermissionStatus.granted) {
      setState(() {
        _storagePermissionGranted = true;
      });
    }
  }

  Future _checkStoragePermissionStatus() async {
    final permissionStatus = await PermissionHandler().checkPermissionStatus(_storagePermission);
    print(permissionStatus);

    if (permissionStatus == PermissionStatus.granted) {
      setState(() {
        _storagePermissionGranted = true;
      });
    } else {
      _requestStoragePermission();
    }
  }
}
