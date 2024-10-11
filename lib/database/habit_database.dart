import 'package:flutter/material.dart';
import 'package:habbit_tracker/models/app_settings.dart';
import 'package:habbit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /*

    setup

  */

  //initialize database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  //save first date of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /*
    crud operations
  */

  //List of habits
  final List<Habit> currentHabits = [];

  //create
  Future<void> addHabit(String habitName) async {
    //create new habit
    final newHabit = Habit()..name = habitName;

    //save to database
    await isar.writeTxn(() => isar.habits.put(newHabit));

    //re- read from database
    readHabits();
  }

  //read
  Future<void> readHabits() async {
    //fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    //give to currend habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    //update ui
    notifyListeners();
  }

  //update habit date
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //find specific habit
    final habit = await isar.habits.get(id);

    //update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
        //if habit is completed -> add the current date to completedDays list;
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          //today
          final today = DateTime.now();

          //add current date if its not already in the list
          habit.completedDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        }

        //if habit is not complete -> remove current date from the list;
        else {
          //remove the current date if the habit is not completed
          habit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        //save updated habits back to the db
        await isar.habits.put(habit);
      });
    }

    //re- read from the db
    readHabits();
  }

  //update habit name
  Future<void> updateHabitName(int id, String newName) async {
    //find specific habit
    final habit = await isar.habits.get(id);

    //update the habit name
    if (habit != null) {
      //update name
      await isar.writeTxn(() async {
        habit.name = newName;

        //save updated habit back to the db
        await isar.habits.put(habit);
      });
    }

    //re-read from the database
    readHabits();
  }

  //delete
  Future<void> deleteHabit(int id) async {
    //perform the delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });

    //re-read from the db
    readHabits();
  }
}
