import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strongeats/custom_classes/customTextField.dart';
import 'package:strongeats/custom_classes/exercise_tile.dart';
import 'package:strongeats/objects/exercise.dart';
import 'package:strongeats/database/workout_history_db.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;

  const WorkoutPage({Key? key, required this.workoutName}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late Stream<QuerySnapshot> _exercisesStream;
  bool _isFirstTime = true;

  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option'),
          content: _isFirstTime
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Implement functionality to pick a suggested workout
                        Navigator.pop(context);
                        _isFirstTime = true; // Set the flag to false
                        _showSuggestedWorkoutsDialog(); // Show dialog for suggested workouts
                      },
                      child: Text('Pick a suggested workout'),
                    ),
                    TextButton(
                      onPressed: () {
                        // Implement functionality to start a custom workout
                        Navigator.pop(context);
                        _isFirstTime = false;
                        createNewExercise(); // Set the flag to false
                        // ... additional logic for custom workout
                        _isFirstTime = true;
                      },
                      child: Text('Start Custom Workout'),
                    ),
                  ],
                )
              : Container(), // Empty container for no additional options
        );
      },
    );
  }

  void _showSuggestedWorkoutsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose a suggested workout'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //_buildSuggestedWorkoutButton('Cardio'),
              _buildSuggestedWorkoutButton('Chest/Shoulders/Triceps (Push)'),
              _buildSuggestedWorkoutButton('Back/Biceps (Pull)'),
              _buildSuggestedWorkoutButton('Legs'),
              _buildSuggestedWorkoutButton('Abs/Core'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuggestedWorkoutButton(String workoutName) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        _showSuggestedWorkoutContent(workoutName);
      },
      child: Text(workoutName),
    );
  }

  void _showSuggestedWorkoutContent(String workoutName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$workoutName Workout'),
          content: _buildWorkoutContent(workoutName),
        );
      },
    );
  }

  Widget _buildWorkoutContent(String workoutName) {
    // Use a switch statement to handle different suggested workouts
    switch (workoutName) {
      case 'Legs':
        return _buildLegsWorkoutContent();
      // Add cases for other suggested workouts
      // case 'Cardio':
      //   return _buildCardioWorkoutContent();
      case 'Chest/Shoulders/Triceps (Push)':
        return _buildPushDayWorkoutContent();
      case 'Back/Biceps (Pull)':
        return _buildPullDayWorkoutContent();
      case 'Abs/Core':
        return _buildAbsDayWorkoutContent();
      default:
        return Text('Workout content for $workoutName');
    }
  }

  Widget _buildLegsWorkoutContent() {
    TextEditingController squatSetsController = TextEditingController();
    TextEditingController squatRepsController = TextEditingController();
    TextEditingController squatWeightController = TextEditingController();
    bool isSquatCompleted = false;

    TextEditingController calfRaiseSetsController = TextEditingController();
    TextEditingController calfRaiseRepsController = TextEditingController();
    TextEditingController calfRaiseWeightController = TextEditingController();
    bool isCalfRaiseCompleted = false;

    TextEditingController hackSquatSetsController = TextEditingController();
    TextEditingController hackSquatRepsController = TextEditingController();
    TextEditingController hackSquatWeightController = TextEditingController();
    bool isHackSquatCompleted = false;

    TextEditingController lyingLegCurlSetsController = TextEditingController();
    TextEditingController lyingLegCurlRepsController = TextEditingController();
    TextEditingController lyingLegCurlWeightController =
        TextEditingController();
    bool isLyingLegCurlCompleted = false;

    TextEditingController legExtensionSetsController = TextEditingController();
    TextEditingController legExtensionRepsController = TextEditingController();
    TextEditingController legExtensionWeightController =
        TextEditingController();
    bool isLegExtensionCompleted = false;

    return AlertDialog(
      title: Text('Legs Workout'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildExerciseTile(
              'Squat',
              squatSetsController,
              squatRepsController,
              squatWeightController,
              isSquatCompleted,
            ),
            _buildExerciseTile(
              'Calf Raise',
              calfRaiseSetsController,
              calfRaiseRepsController,
              calfRaiseWeightController,
              isCalfRaiseCompleted,
            ),
            _buildExerciseTile(
              'Hack Squat',
              hackSquatSetsController,
              hackSquatRepsController,
              hackSquatWeightController,
              isHackSquatCompleted,
            ),
            _buildExerciseTile(
              'Lying Leg Curl (Machine)',
              lyingLegCurlSetsController,
              lyingLegCurlRepsController,
              lyingLegCurlWeightController,
              isLyingLegCurlCompleted,
            ),
            _buildExerciseTile(
              'Leg Extension (Machine)',
              legExtensionSetsController,
              legExtensionRepsController,
              legExtensionWeightController,
              isLegExtensionCompleted,
            ),
            // ... (similar calls for other exercises)
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Validate and save each exercise
            _saveExercise(
              'Squat',
              squatSetsController,
              squatRepsController,
              squatWeightController,
              isSquatCompleted,
            );
            _saveExercise(
              'Calf Raise',
              calfRaiseSetsController,
              calfRaiseRepsController,
              calfRaiseWeightController,
              isCalfRaiseCompleted,
            );
            _saveExercise(
              'Hack Squat',
              hackSquatSetsController,
              hackSquatRepsController,
              hackSquatWeightController,
              isHackSquatCompleted,
            );
            _saveExercise(
              'Lying Leg Curl (Machine)',
              lyingLegCurlSetsController,
              lyingLegCurlRepsController,
              lyingLegCurlWeightController,
              isLyingLegCurlCompleted,
            );
            _saveExercise(
              'Leg Extension (Machine)',
              legExtensionSetsController,
              legExtensionRepsController,
              legExtensionWeightController,
              isLegExtensionCompleted,
            );
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  Widget _buildPushDayWorkoutContent() {
    TextEditingController benchPressSetsController = TextEditingController();
    TextEditingController benchPressRepsController = TextEditingController();
    TextEditingController benchPressWeightController = TextEditingController();
    bool isBenchPressCompleted = false;

    TextEditingController tricepExtensionSetsController =
        TextEditingController();
    TextEditingController tricepExtensionRepsController =
        TextEditingController();
    TextEditingController tricepExtensionWeightController =
        TextEditingController();
    bool isTricepExtensionCompleted = false;

    TextEditingController arnoldPressSetsController = TextEditingController();
    TextEditingController arnoldPressRepsController = TextEditingController();
    TextEditingController arnoldPressWeightController = TextEditingController();
    bool isArnoldPressCompleted = false;

    TextEditingController shoulderShrugSetsController = TextEditingController();
    TextEditingController shoulderShrugRepsController = TextEditingController();
    TextEditingController shoulderShrugWeightController =
        TextEditingController();
    bool isShoulderShrugCompleted = false;

    TextEditingController lateralRaiseSetsController = TextEditingController();
    TextEditingController lateralRaiseRepsController = TextEditingController();
    TextEditingController lateralRaiseWeightController =
        TextEditingController();
    bool isLateralRaiseCompleted = false;

    TextEditingController inclineBenchPressSetsController =
        TextEditingController();
    TextEditingController inclineBenchPressRepsController =
        TextEditingController();
    TextEditingController inclineBenchPressWeightController =
        TextEditingController();
    bool isInclineBenchPressCompleted = false;

    TextEditingController inclineChestFlySetsController =
        TextEditingController();
    TextEditingController inclineChestFlyRepsController =
        TextEditingController();
    TextEditingController inclineChestFlyWeightController =
        TextEditingController();
    bool isInclineChestFlyCompleted = false;

    return AlertDialog(
      title: Text('Chest/Shoulders/Triceps (Push) Workout'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildExerciseTile(
              'Bench Press',
              benchPressSetsController,
              benchPressRepsController,
              benchPressWeightController,
              isBenchPressCompleted,
            ),
            _buildExerciseTile(
              'Tricep Extension',
              tricepExtensionSetsController,
              tricepExtensionRepsController,
              tricepExtensionWeightController,
              isTricepExtensionCompleted,
            ),
            _buildExerciseTile(
              'Arnold Press',
              arnoldPressSetsController,
              arnoldPressRepsController,
              arnoldPressWeightController,
              isArnoldPressCompleted,
            ),
            _buildExerciseTile(
              'Shoulder Shrug',
              shoulderShrugSetsController,
              shoulderShrugRepsController,
              shoulderShrugWeightController,
              isShoulderShrugCompleted,
            ),
            _buildExerciseTile(
              'Lateral Raise',
              lateralRaiseSetsController,
              lateralRaiseRepsController,
              lateralRaiseWeightController,
              isLateralRaiseCompleted,
            ),
            _buildExerciseTile(
              'Incline Bench Press',
              inclineBenchPressSetsController,
              inclineBenchPressRepsController,
              inclineBenchPressWeightController,
              isInclineBenchPressCompleted,
            ),
            _buildExerciseTile(
              'Incline Chest Fly',
              inclineChestFlySetsController,
              inclineChestFlyRepsController,
              inclineChestFlyWeightController,
              isInclineChestFlyCompleted,
            ),
            // ... (similar calls for other exercises)
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Validate and save each exercise
            _saveExercise(
              'Bench Press',
              benchPressSetsController,
              benchPressRepsController,
              benchPressWeightController,
              isBenchPressCompleted,
            );
            _saveExercise(
              'Tricep Extension',
              tricepExtensionSetsController,
              tricepExtensionRepsController,
              tricepExtensionWeightController,
              isTricepExtensionCompleted,
            );
            _saveExercise(
              'Arnold Press',
              arnoldPressSetsController,
              arnoldPressRepsController,
              arnoldPressWeightController,
              isArnoldPressCompleted,
            );
            _saveExercise(
              'Shoulder Shrug',
              shoulderShrugSetsController,
              shoulderShrugRepsController,
              shoulderShrugWeightController,
              isShoulderShrugCompleted,
            );
            _saveExercise(
              'Lateral Raise',
              lateralRaiseSetsController,
              lateralRaiseRepsController,
              lateralRaiseWeightController,
              isLateralRaiseCompleted,
            );
            _saveExercise(
              'Incline Bench Press',
              inclineBenchPressSetsController,
              inclineBenchPressRepsController,
              inclineBenchPressWeightController,
              isInclineBenchPressCompleted,
            );
            _saveExercise(
              'Incline Chest Fly',
              inclineChestFlySetsController,
              inclineChestFlyRepsController,
              inclineChestFlyWeightController,
              isInclineChestFlyCompleted,
            );
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  void _saveExercise(
    String exerciseName,
    TextEditingController setsController,
    TextEditingController repsController,
    TextEditingController weightController,
    bool isCompleted,
  ) {
    // Validate and save the exercise
    if (setsController.text.isNotEmpty &&
        repsController.text.isNotEmpty &&
        weightController.text.isNotEmpty) {
      suggestedSave(
        exerciseName,
        weightController.text,
        repsController.text,
        setsController.text,
      );
    }
  }

  Widget _buildPullDayWorkoutContent() {
    TextEditingController bicepCurlDumbbellSetsController =
        TextEditingController();
    TextEditingController bicepCurlDumbbellRepsController =
        TextEditingController();
    TextEditingController bicepCurlDumbbellWeightController =
        TextEditingController();
    bool isBicepCurlDumbbellCompleted = false;

    TextEditingController hammerCurlDumbbellSetsController =
        TextEditingController();
    TextEditingController hammerCurlDumbbellRepsController =
        TextEditingController();
    TextEditingController hammerCurlDumbbellWeightController =
        TextEditingController();
    bool isHammerCurlDumbbellCompleted = false;

    TextEditingController bicepCurlBarbellSetsController =
        TextEditingController();
    TextEditingController bicepCurlBarbellRepsController =
        TextEditingController();
    TextEditingController bicepCurlBarbellWeightController =
        TextEditingController();
    bool isBicepCurlBarbellCompleted = false;

    TextEditingController uprightRowSetsController = TextEditingController();
    TextEditingController uprightRowRepsController = TextEditingController();
    TextEditingController uprightRowWeightController = TextEditingController();
    bool isUprightRowCompleted = false;

    TextEditingController latPulldownSetsController = TextEditingController();
    TextEditingController latPulldownRepsController = TextEditingController();
    TextEditingController latPulldownWeightController = TextEditingController();
    bool isLatPulldownCompleted = false;

    TextEditingController seatedRowSetsController = TextEditingController();
    TextEditingController seatedRowRepsController = TextEditingController();
    TextEditingController seatedRowWeightController = TextEditingController();
    bool isSeatedRowCompleted = false;

    TextEditingController pullUpsSetsController = TextEditingController();
    TextEditingController pullUpsRepsController = TextEditingController();
    TextEditingController pullUpsWeightController = TextEditingController();
    bool isPullUpsCompleted = false;

    return AlertDialog(
      title: Text('Back/Biceps (Pull) Workout'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildExerciseTile(
              'Bicep Curl (Dumbbell)',
              bicepCurlDumbbellSetsController,
              bicepCurlDumbbellRepsController,
              bicepCurlDumbbellWeightController,
              isBicepCurlDumbbellCompleted,
            ),
            _buildExerciseTile(
              'Hammer Curl (Dumbbell)',
              hammerCurlDumbbellSetsController,
              hammerCurlDumbbellRepsController,
              hammerCurlDumbbellWeightController,
              isHammerCurlDumbbellCompleted,
            ),
            _buildExerciseTile(
              'Bicep Curl (Barbell)',
              bicepCurlBarbellSetsController,
              bicepCurlBarbellRepsController,
              bicepCurlBarbellWeightController,
              isBicepCurlBarbellCompleted,
            ),
            _buildExerciseTile(
              'Upright Row',
              uprightRowSetsController,
              uprightRowRepsController,
              uprightRowWeightController,
              isUprightRowCompleted,
            ),
            _buildExerciseTile(
              'Lat Pulldown (Cable)',
              latPulldownSetsController,
              latPulldownRepsController,
              latPulldownWeightController,
              isLatPulldownCompleted,
            ),
            _buildExerciseTile(
              'Seated Row (Cable)',
              seatedRowSetsController,
              seatedRowRepsController,
              seatedRowWeightController,
              isSeatedRowCompleted,
            ),
            _buildExerciseTile(
              'Pull Ups',
              pullUpsSetsController,
              pullUpsRepsController,
              pullUpsWeightController,
              isPullUpsCompleted,
            ),
            // ... (similar calls for other exercises)
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Validate and save each exercise
            _saveExercise(
              'Bicep Curl (Dumbbell)',
              bicepCurlDumbbellSetsController,
              bicepCurlDumbbellRepsController,
              bicepCurlDumbbellWeightController,
              isBicepCurlDumbbellCompleted,
            );
            _saveExercise(
              'Hammer Curl (Dumbbell)',
              hammerCurlDumbbellSetsController,
              hammerCurlDumbbellRepsController,
              hammerCurlDumbbellWeightController,
              isHammerCurlDumbbellCompleted,
            );
            _saveExercise(
              'Bicep Curl (Barbell)',
              bicepCurlBarbellSetsController,
              bicepCurlBarbellRepsController,
              bicepCurlBarbellWeightController,
              isBicepCurlBarbellCompleted,
            );
            _saveExercise(
              'Upright Row',
              uprightRowSetsController,
              uprightRowRepsController,
              uprightRowWeightController,
              isUprightRowCompleted,
            );
            _saveExercise(
              'Lat Pulldown (Cable)',
              latPulldownSetsController,
              latPulldownRepsController,
              latPulldownWeightController,
              isLatPulldownCompleted,
            );
            _saveExercise(
              'Seated Row (Cable)',
              seatedRowSetsController,
              seatedRowRepsController,
              seatedRowWeightController,
              isSeatedRowCompleted,
            );
            _saveExercise(
              'Pull Ups',
              pullUpsSetsController,
              pullUpsRepsController,
              pullUpsWeightController,
              isPullUpsCompleted,
            );
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  Widget _buildAbsDayWorkoutContent() {
    TextEditingController bicycleCrunchesSetsController =
        TextEditingController();
    TextEditingController bicycleCrunchesRepsController =
        TextEditingController();
    TextEditingController bicycleCrunchesWeightController =
        TextEditingController();
    bool isBicycleCrunchesCompleted = false;

    TextEditingController sitUpsSetsController = TextEditingController();
    TextEditingController sitUpsRepsController = TextEditingController();
    TextEditingController sitUpsWeightController = TextEditingController();
    bool isSitUpsCompleted = false;

    TextEditingController legRaisesSetsController = TextEditingController();
    TextEditingController legRaisesRepsController = TextEditingController();
    TextEditingController legRaisesWeightController = TextEditingController();
    bool isLegRaisesCompleted = false;

    TextEditingController russianTwistsSetsController = TextEditingController();
    TextEditingController russianTwistsRepsController = TextEditingController();
    TextEditingController russianTwistsWeightController =
        TextEditingController();
    bool isRussianTwistsCompleted = false;

    TextEditingController vUpsSetsController = TextEditingController();
    TextEditingController vUpsRepsController = TextEditingController();
    TextEditingController vUpsWeightController = TextEditingController();
    bool isVUpsCompleted = false;

    return AlertDialog(
      title: Text('Abs/Core Workout'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildExerciseTile(
              'Bicycle Crunches',
              bicycleCrunchesSetsController,
              bicycleCrunchesRepsController,
              bicycleCrunchesWeightController,
              isBicycleCrunchesCompleted,
            ),
            _buildExerciseTile(
              'Sit Ups',
              sitUpsSetsController,
              sitUpsRepsController,
              sitUpsWeightController,
              isSitUpsCompleted,
            ),
            _buildExerciseTile(
              'Leg Raises',
              legRaisesSetsController,
              legRaisesRepsController,
              legRaisesWeightController,
              isLegRaisesCompleted,
            ),
            _buildExerciseTile(
              'Russian Twists',
              russianTwistsSetsController,
              russianTwistsRepsController,
              russianTwistsWeightController,
              isRussianTwistsCompleted,
            ),
            _buildExerciseTile(
              'V-Ups',
              vUpsSetsController,
              vUpsRepsController,
              vUpsWeightController,
              isVUpsCompleted,
            ),
            // ... (similar calls for other exercises)
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Validate and save each exercise
            _saveExercise(
              'Bicycle Crunches',
              bicycleCrunchesSetsController,
              bicycleCrunchesRepsController,
              bicycleCrunchesWeightController,
              isBicycleCrunchesCompleted,
            );
            _saveExercise(
              'Sit Ups',
              sitUpsSetsController,
              sitUpsRepsController,
              sitUpsWeightController,
              isSitUpsCompleted,
            );
            _saveExercise(
              'Leg Raises',
              legRaisesSetsController,
              legRaisesRepsController,
              legRaisesWeightController,
              isLegRaisesCompleted,
            );
            _saveExercise(
              'Russian Twists',
              russianTwistsSetsController,
              russianTwistsRepsController,
              russianTwistsWeightController,
              isRussianTwistsCompleted,
            );
            _saveExercise(
              'V-Ups',
              vUpsSetsController,
              vUpsRepsController,
              vUpsWeightController,
              isVUpsCompleted,
            );
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  Widget _buildExerciseTile(
    String exerciseName,
    TextEditingController setsController,
    TextEditingController repsController,
    TextEditingController weightController,
    bool isCompleted,
  ) {
    return ListTile(
      title: Text(exerciseName),
      subtitle: Column(
        children: [
          TextField(
            controller: setsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Sets'),
          ),
          TextField(
            controller: repsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Reps'),
          ),
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Weight (lbs)'),
          ),
          CheckboxListTile(
            title: Text('Completed'),
            value: isCompleted,
            activeColor: isCompleted ? Colors.green : Colors.grey,
            onChanged: (bool? value) {
              if (setsController.text.isNotEmpty &&
                  repsController.text.isNotEmpty &&
                  weightController.text.isNotEmpty) {
                setState(() {
                  isCompleted = value ?? false;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _exercisesStream = FirebaseFirestore.instance
        .collection('workoutHistory')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('userWorkouts')
        .doc(widget.workoutName)
        .collection('userExercises')
        .snapshots();
    //_showOptionsDialog;
    //_buildWorkoutContent;
  }

  // text controllers
  final _newExerciseNameController = TextEditingController();
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _setsController = TextEditingController();

  // collect new exercise info from the user
  void createNewExercise() {
    // Show the options dialog only the first time the page is loaded
    //_isFirstTime = true;
    if (_isFirstTime) {
      _showOptionsDialog();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Add a new exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // exercise name
              CustomTextField(
                controller: _newExerciseNameController,
                text: 'Exercise Name',
                obscureText: false,
                fillColor: Colors.white,
                borderColor: Colors.grey,
                textColor: Colors.black,
              ),

              // weight
              CustomTextField(
                controller: _weightController,
                text: 'Weight (lbs)',
                obscureText: false,
                fillColor: Colors.white,
                borderColor: Colors.grey,
                textColor: Colors.black,
              ),

              // reps
              CustomTextField(
                controller: _repsController,
                text: 'Reps',
                obscureText: false,
                fillColor: Colors.white,
                borderColor: Colors.grey,
                textColor: Colors.black,
              ),

              // sets
              CustomTextField(
                controller: _setsController,
                text: 'Sets',
                obscureText: false,
                fillColor: Colors.white,
                borderColor: Colors.grey,
                textColor: Colors.black,
              )
            ],
          ),
          actions: [
            // save button
            MaterialButton(
              onPressed: save,
              child: Text('Save'),
            ),

            // cancel button
            MaterialButton(
              onPressed: cancel,
              child: Text('Cancel'),
            ),
          ],
        ),
      );
    }
  }

  // save exercise
  void save() {
    // get exercise name from text controller
    String newExerciseName = _newExerciseNameController.text;
    String weight = _weightController.text;
    String reps = _repsController.text;
    String sets = _setsController.text;

    Exercise newExercise =
        Exercise(name: newExerciseName, weight: weight, reps: reps, sets: sets);

    // add exercise to the database based on workout name and the new exercise
    WorkoutHistoryDB().addExercise(widget.workoutName, newExercise);

    Navigator.pop(context);
    clear();
  }

  void suggestedSave(
      String exerciseName, String weight, String reps, String sets) {
    Exercise newExercise =
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets);
    // Add exercise to the database based on workout name and the new exercise
    WorkoutHistoryDB().addExercise(widget.workoutName, newExercise);
    Navigator.pop(context);
    clear();
  }

  // cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // clear
  void clear() {
    _newExerciseNameController.clear();
    _weightController.clear();
    _repsController.clear();
    _setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workoutName),
        backgroundColor: Colors.black,
        actions: [
          // Button to show the options dialog
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: _showOptionsDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[900],
        onPressed: createNewExercise,
        child: Icon(Icons.add),
      ),

      body: StreamBuilder(
        stream: _exercisesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Connection error');
          }
          // stream is connected but data is not coming yet
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            // User has no workouts, display a message
            return Center(
              child: Text(
                'Add an exercise to your workout!',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  //_buildWorkoutContent('Legs'),
                  ExerciseTile(
                    exerciseName: docs[index]['name'],
                    weight: docs[index]['weight'],
                    reps: docs[index]['reps'],
                    sets: docs[index]['sets'],
                  ),
                ],
              );
            },
          );
        },
      ),
      // Display workout content directly on the WorkoutPage
    );
  }
}
