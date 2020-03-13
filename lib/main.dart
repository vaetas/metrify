import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:metrify/models/activity.dart';
import 'package:metrify/models/category.dart';
import 'package:metrify/models/entry.dart';
import 'package:metrify/models/group.dart';
import 'package:metrify/models/type.dart';
import 'package:metrify/resources/routes.dart';
import 'package:metrify/resources/theme.dart';
import 'package:metrify/ui/activity/activity_list_screen.dart';
import 'package:metrify/ui/activity/create_activity_screen.dart';
import 'package:metrify/ui/category/category_list.dart';
import 'package:metrify/ui/category/create_category_screen.dart';
import 'package:metrify/ui/home/home_screen.dart';
import 'package:metrify/ui/root.dart';
import 'package:metrify/ui/settings/settings_screen.dart';
import 'package:metrify/ui/type/type_list_screen.dart';
import 'package:metrify/ui/widgets/splash_screen.dart';
import 'package:metrify/resources/config.dart';
import 'package:metrify/utils/generate.dart';

void main() async {
  runApp(SplashScreen());
  await _initHive();
  runApp(App());
  _initContent();
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metrify',
      initialRoute: Routes.root,
      routes: {
        Routes.root: (_) => Root(),
        Routes.home: (_) => HomeScreen(),
        Routes.settings: (_) => SettingsScreen(),
        Routes.activityList: (_) => ActivityListScreen(),
        Routes.activityCreate: (_) => CreateActivityScreen(),
        Routes.typeList: (_) => TypeListScreen(),
        Routes.categoryList: (_) => CategoryListScreen(),
        Routes.categoryCreate: (_) => CreateCategoryScreen(),
      },
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}

Future _initHive() async {
  await Hive.initFlutter();

  Hive
    ..registerAdapter(CategoryAdapter())
    ..registerAdapter(ActivityAdapter())
    ..registerAdapter(EntryAdapter())
    ..registerAdapter(TypeKindAdapter())
    ..registerAdapter(ActivityTypeAdapter())
    ..registerAdapter(NumericTypeAdapter())
    ..registerAdapter(EnumTypeAdapter())
    ..registerAdapter(EnumTypeValueAdapter())
    ..registerAdapter(RangeTypeAdapter())
    ..registerAdapter(EntryGroupingAdapter());

  await Hive.openBox(configBox);
  await Hive.openBox<Category>(categoryBox);
  await Hive.openBox<Entry>(entryBox);
  await Hive.openBox<Activity>(activityBox);
  await Hive.openBox<ActivityType>(typeBox);
}

Future _initContent() async {
  // Create 2 basic types: kilometers and boolean.
  final box = Hive.box(configBox);
  final createdBasicTypes = box.get(ConfigKeys.createdBasicTypes) as bool;
  if (createdBasicTypes == null || !createdBasicTypes) {
    createBasicTypes().whenComplete(() {
      box.put(ConfigKeys.createdBasicTypes, true);
    });
  }
}
