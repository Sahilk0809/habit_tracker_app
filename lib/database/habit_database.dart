import 'package:flutter/material.dart';
import 'package:habbit_tracker_app/modal/app_settings.dart';
import 'package:habbit_tracker_app/modal/habit_modal.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // setup

  // initialize database

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitModalSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

// save first date of startup

  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();

    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(
        () => isar.appSettings.put(settings),
      );
    }
  }

// get first date of startup

  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

// CRUD operation

// List habits

  final List<HabitModal> currentHabits = [];

// create habit - add habit

  Future<void> addHabit(String habitName) async {
    // create habit
    final newHabit = HabitModal()..name = habitName;

    // save to db
    await isar.writeTxn(
      () => isar.habitModals.put(newHabit),
    );

    // re- read rom db
    readHabits();
  }

// read - read saved habit from db

  Future<void> readHabits() async {
    // fetch all habits from the db
    List<HabitModal> fetchedHabits = await isar.habitModals.where().findAll();

    //give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    // update ui
    notifyListeners();
  }

// update - check habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // find the specific habit
    final habit = await isar.habitModals.get(id);

    // update completion status
    if (habit != null) {
      await isar.writeTxn(
        () async {
          // if habit is completed -> add the current date to the completedDays list
          if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
            // today
            final today = DateTime.now();

            // add the current date if it's not already in the list

            habit.completedDays.add(DateTime(
              today.year,
              today.month,
              today.day,
            ));
          }

          // if habit is not completed -> remove the current date from the list
          else {
            // remove current date if the habit is marked as not completed
            habit.completedDays.removeWhere(
              (date) =>
                  date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day,
            );
          }
          // save the updated habits back to the db
          await isar.habitModals.put(habit);
        },
      );
    }

    // re-read from db
    readHabits();
  }

// update - edit habit
  Future<void> updateHabitName(int id, String newName) async{
    // find the specific habit
    final habit = await isar.habitModals.get(id);

    // update habit name
    if(habit != null){
      // update name
      await isar.writeTxn(() async{
        habit.name = newName;

        // save updated habit back to the db

        await isar.habitModals.put(habit);
      },);
    }

    // re-read from db
    readHabits();
  }

// delete - delete habit

  Future<void> deleteHabit(int id)async{
    // perform the delete operation
    await isar.writeTxn(()async {
      await isar.habitModals.delete(id);
    },);

    // re-read from db
    readHabits();
  }
}
