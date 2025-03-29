import 'package:firebase_core/firebase_core.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC64JiIFzuKJcJPn4iNlFF_6ngKVV_HtOk',
      appId: '1:966698138855:android:fc38e05b22238fac02b642',
      messagingSenderId: '966698138855',
      projectId: 'poste-vv',
      storageBucket: 'poste-vv.firebasestorage.app',
      // Add these if using services:
      // databaseURL: 'https://poste-vv.firebaseio.com',
      // iosClientId: 'YOUR_IOS_CLIENT_ID', // if iOS
    ),
  );
}
