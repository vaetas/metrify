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

import 'package:path_provider/path_provider.dart';

const _fileName = 'export.json';

Future<Directory> getExportDirectory() async {
  return await getExternalStorageDirectory();
}

Future exportFile(String content, {String fileName = _fileName}) async {
  final directory = await getExportDirectory();
  await File('${directory.path}/$fileName').writeAsString(content);
}

Future<String> importFile({String fileName = _fileName}) async {
  final directory = await getExportDirectory();
  return File('${directory.path}/$fileName').readAsString();
}
