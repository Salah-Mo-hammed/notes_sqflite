import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:notes_local/clean_tasks/data/data_source/local/sql_db.dart';
import 'package:notes_local/clean_tasks/presintaion/bloc/task_bloc.dart';
import 'package:notes_local/clean_tasks/presintaion/pages/manual_weather_tasks.dart';
import 'package:notes_local/firebase_options.dart';
import 'package:notes_local/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initilaizedDependencies();
  SqlDb sqlDb = SqlDb();
  await sqlDb.db;
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isConnected = false;
  StreamSubscription? _internetConnectionStreamSubscription;
  @override
  void initState() {
    super.initState();
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected:
          setState(() {
            _isConnected = true;
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
            _isConnected = false;
          });
          break;
        default:
          setState(() {
            _isConnected = false;
          });
          break;
      }
    });
  }

  @override
  void dispose() {
    _internetConnectionStreamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskBloc>(
        child: MaterialApp(
          home: TasksPage(
            isConnected: _isConnected,
          ),
        ),
        create: (_) => sl<TaskBloc>());
  }
}
