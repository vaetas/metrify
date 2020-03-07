import 'package:hive/hive.dart';

part 'category.g.dart';

const String categoryBox = 'categories';

@HiveType(typeId: 11)
class Category extends HiveObject {
  @HiveField(0)
  String name;

  Category(this.name);

  @override
  String toString() => 'Category{name: $name}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Category && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
