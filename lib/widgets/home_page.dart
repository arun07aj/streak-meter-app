import 'package:flutter/material.dart';
import 'package:streak_meter/widgets/task_widget.dart';
import '../models/frequency.dart';
import '../models/task.dart';
import '../utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double taskPadding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Task Tracker'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: taskPadding),
        child: SizedBox(
            height: screenHeight,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskWidget(task: tasks[index]);
              },
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.blueAccent.shade100,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog() {
    // Create a key for the form
    final _formKey = GlobalKey<FormState>();

    // Show a dialog to add a new task
    showDialog(
      context: context,
      builder: (context) {
        // Define controllers for the form fields
        TextEditingController taskNameController = TextEditingController();
        TextEditingController hoursController = TextEditingController();
        TextEditingController minutesController = TextEditingController();
        TextEditingController dateController = TextEditingController();

        // Define variables to hold the selected frequency & day
        Frequency selectedFrequency = Frequency.daily;
        String selectedDay = daysOfWeek[0];

        DateTime currentDateTime = DateTime.now();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Center(child: Text('Add a New Task')),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Task name input field
                      TextFormField(
                        controller: taskNameController,
                        decoration: const InputDecoration(labelText: 'Task Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a task name';
                          }
                          return null;
                        },
                      ),
                      // Dropdown button for selecting frequency
                      DropdownButtonFormField<Frequency>(
                        value: selectedFrequency,
                        items: Frequency.values.map((Frequency frequency) {
                          return DropdownMenuItem<Frequency>(
                            value: frequency,
                            child: Text(frequency.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (Frequency? newValue) {
                          // Update the selected frequency
                          if (newValue != null) {
                            setState(() {
                              selectedFrequency = newValue;
                            });
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Frequency'),
                      ),
                      if (selectedFrequency == Frequency.weekly) ...[
                        // Form field for day of the week
                        DropdownButtonFormField<String>(
                          value: selectedDay,
                          items: daysOfWeek.map((String day) {
                            return DropdownMenuItem<String>(
                              value: day,
                              child: Text(day),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            // Update the selected day
                            if (newValue != null) {
                              setState(() {
                                selectedDay = newValue;
                              });
                            }
                          },
                          decoration: const InputDecoration(labelText: 'Day of the Week'),
                        ),
                      ],
                      if (selectedFrequency == Frequency.monthly ||
                          selectedFrequency == Frequency.yearly) ...[
                        // Form field for date of the month/year
                        TextFormField(
                          controller: dateController,
                          decoration: const InputDecoration(
                              labelText: 'Date of the Month/Year'),
                          keyboardType: TextInputType.none,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: currentDateTime,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a date';
                            }
                            return null;
                          },
                        ),
                      ],
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Hour input field
                              Expanded(
                                child: TextFormField(
                                  controller: hoursController,
                                  decoration: const InputDecoration(labelText: 'Hour'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter an hour';
                                    }
                                    int? hour = int.tryParse(value);
                                    if (hour == null || hour < minHour || hour > maxHour) {
                                      return 'Enter $minHour - $maxHour';
                                    }
                                    if (hour == 0 && (minutesController.text.isEmpty || minutesController.text == '0')) {
                                      return 'Either hr/min >0';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Minute input field
                              Expanded(
                                child: TextFormField(
                                  controller: minutesController,
                                  decoration: const InputDecoration(labelText: 'Minute'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter a minute';
                                    }
                                    int? minute = int.tryParse(value);
                                    if (minute == null || minute < minMinute || minute > maxMinute) {
                                      return 'Enter $minMinute - $maxMinute';
                                    }
                                    if (minute == 0 && (hoursController.text.isEmpty || hoursController.text == '0')) {
                                      return 'Either hr/min >0';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                // Cancel button
                TextButton(
                  onPressed: () {
                    // Close the dialog without doing anything
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                // Add button
                TextButton(
                  onPressed: () {
                    // Validate the form fields
                    if (_formKey.currentState!.validate()) {
                      // Get the input values
                      String taskName = taskNameController.text;
                      int hours = int.tryParse(hoursController.text) ?? 0;
                      int minutes = int.tryParse(minutesController.text) ?? 0;
                      String? selectedDayOptional = selectedFrequency == Frequency.weekly ? selectedDay : null;
                      String? selectedDateOptional = selectedFrequency == Frequency.monthly || selectedFrequency == Frequency.yearly ? dateController.text : null;

                      DateTime startDateTime = Task.findStartDateTime(currentDateTime, selectedFrequency, hours, minutes, day: selectedDayOptional, date: selectedDateOptional);

                      // Create a new Task instance
                      Task newTask = Task(
                        name: taskName,
                        frequency: selectedFrequency,
                        startDateTime: startDateTime
                      );

                      // Add the task to the list of tasks
                      setState(() {
                        tasks.add(newTask);
                      });

                      // Close the dialog
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}