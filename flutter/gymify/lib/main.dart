
import 'package:flutter/material.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/routes/route_config.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorkoutProvider()),
        ChangeNotifierProvider(create: (context) => ExerciseProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Gymify',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerConfig: router,
        // routes: {
        //   '/register': (context) => const RegisterScreen(),
        //   '/login': (context) => LoginScreen(),
        //   '/home': (context) => const HomePage(),
        //   '/workouts': (context) =>  const WorkoutListScreen(),
        //   '/exercises': (context) =>const ExerciseScreen(),
        // },
        
      ),
    );
  }
}
