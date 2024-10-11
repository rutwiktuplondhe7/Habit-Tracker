import 'package:isar/isar.dart';

//run this cmd : dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit {
  //Habit id
  Id id = Isar.autoIncrement;

  //habit name
  late String name;

  // completed days
  List<DateTime> completedDays = [
    //(yyyy/mm/dd)
  ];
}
