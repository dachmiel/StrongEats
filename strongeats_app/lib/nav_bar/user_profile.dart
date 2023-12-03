import 'package:flutter/material.dart';
import 'package:strongeats/profile/user_details.dart';
import 'package:strongeats/profile/user_weight.dart';
import 'package:strongeats/profile/user_account.dart';

class UserProfile extends StatefulWidget {
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          // Use a Column to stack widgets vertically
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UserDetails();
                    },
                  ),
                );
              },
              icon: Icon(Icons.add),
              label: Text("User Info"),
              //color: Colors.black,
            ),
            SizedBox(height: 20), // Adding some space between buttons
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  UserWeight()));
              },
              icon: Icon(Icons.remove),
              label: Text("Update Goal Weight"),
            ),

            SizedBox(height: 20), // Adding some space between buttons
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WorkoutPreferencesPage()));
              },
              icon: Icon(Icons.history),
              label: Text("Workout Preferences"),
            ),

            SizedBox(height: 20), // Adding some space between buttons
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserAccount()));
              },
              icon: Icon(Icons.history),
              label: Text("Account Settings"),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateGoalWeightPage extends StatelessWidget {
  const UpdateGoalWeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Goal Weight"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
          // child: ElevatedButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   child: const Text('Go back!'),
          // ),
          ),
    );
  }
}

class WorkoutPreferencesPage extends StatelessWidget {
  const WorkoutPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Preferences"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Settings"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
