library my_prj.globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// final FirebaseAuth auth = FirebaseAuth.instance;
// final User? user = auth.currentUser;
final currentUser = FirebaseAuth.instance.currentUser!;
final uid = currentUser.email;
final usersCollection = FirebaseFirestore.instance.collection('users');
