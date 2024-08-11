import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habbit_tracker_app/components/habit_tile.dart';
import 'package:habbit_tracker_app/components/heat_map.dart';
import 'package:habbit_tracker_app/database/habit_database.dart';
import 'package:habbit_tracker_app/modal/habit_modal.dart';
import 'package:habbit_tracker_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import '../utils/habit_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  final txtController = TextEditingController();

  // create new habit
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: txtController,
          decoration: const InputDecoration(
            hintText: 'Create new habits',
          ),
        ),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controller
              txtController.clear();
            },
            child: const Text('Cancel'),
          ),

          MaterialButton(
            onPressed: () {
              // get new habit name
              String newHabitName = txtController.text;

              // save to db
              context.read<HabitDatabase>().addHabit(newHabitName);

              // pop box
              Navigator.pop(context);

              // clear controller
              txtController.clear();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void checkHabitOnOff(bool? value, HabitModal habit) {
    // update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // edit box
  void editHabitBox(HabitModal habit) {
    // set the controller text to the habit's current name
    txtController.text = habit.name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: txtController,
        ),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);

              // clear controller
              txtController.clear();
            },
            child: const Text('Cancel'),
          ),

          MaterialButton(
            onPressed: () {
              // get new habit name
              String newHabitName = txtController.text;

              // save to db
              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, newHabitName);

              // pop box
              Navigator.pop(context);

              // clear controller
              txtController.clear();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // delete box
  void deleteHabitBox(HabitModal habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Are you sure you want to delete'),
        actions: [
          // cancel button
          MaterialButton(
            onPressed: () {
              // pop box
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),

          // delete button
          MaterialButton(
            onPressed: () {
              // get new habit name
              String newHabitName = txtController.text;

              // save to db
              context.read<HabitDatabase>().deleteHabit(habit.id);

              // pop box
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProviderTrue = Provider.of<ThemeProvider>(context);
    var themeProviderFalse = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: const Icon(Icons.account_circle_outlined),
        title: const Text('Habit Tracker'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
              child: (themeProviderTrue.isDark)
                  ? Icon(
                      Icons.dark_mode,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )
                  : const Icon(Icons.sunny),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildHeatMap(),
          _buildHabitList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  // build heat map

  Widget _buildHeatMap() {
    // habit database
    final habitDataBase = context.watch<HabitDatabase>();

    // current habits
    List<HabitModal> currentHabit = habitDataBase.currentHabits;

    // return heatmap ui
    return FutureBuilder<DateTime?>(
      future: habitDataBase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        // once the date is available -> build heatmap
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepareHeatMapDataset(currentHabit),
          );
        }
        // handle case where no data is returned
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // build habit list
  Widget _buildHabitList() {
    // habit db
    final habitDataBase = context.watch<HabitDatabase>();

    // current habits
    List<HabitModal> currentHabits = habitDataBase.currentHabits;

    // return list of habits ui
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        // get each individual habit
        final habit = currentHabits[index];

        // check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        // return habit tile ui
        return HabitTile(
          isCompleted: isCompletedToday,
          text: habit.name,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
