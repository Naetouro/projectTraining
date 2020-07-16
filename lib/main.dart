import 'package:flutter/material.dart';
import 'package:projecttrainingflutter/screens/FlutterSplashScreen.dart';
import 'package:projecttrainingflutter/models/User.dart';
import 'package:projecttrainingflutter/screens/ScreenExerciseDescription.dart';
import 'package:projecttrainingflutter/screens/ScreenExercises.dart';
import 'package:projecttrainingflutter/screens/ScreenMuscles.dart';
import 'package:projecttrainingflutter/screens/ScreenProgressions.dart';
import 'package:projecttrainingflutter/screens/ScreenLogin.dart';
import 'package:provider/provider.dart';

import 'constants/RouteName.dart';
import 'screens/ScreenTrainingExercises.dart';
import 'screens/ScreenTrainings.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => User.fetch(),
        child: MaterialApp(
          title: "ProjectTraining",
          initialRoute: RouteSplashScreen,
          onUnknownRoute: (RouteSettings settings) => onUnknownRoute(settings),
          onGenerateRoute: (RouteSettings settings) => onGenerateRoute(settings),
          theme: ThemeData(
            primaryTextTheme: TextTheme(
              headline1: const TextStyle(color: Colors.red, fontSize: 24.0, fontWeight: FontWeight.normal),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.green),
            accentColor: Colors.redAccent,
            buttonTheme: const ButtonThemeData(
              buttonColor: Colors.blue,
              shape: const OutlineInputBorder(),
              textTheme: ButtonTextTheme.accent,
            )
          ),
        ),
      ),
    );

MaterialPageRoute onUnknownRoute(RouteSettings settings){
  return MaterialPageRoute<void>(
    settings: settings,
    builder: (BuildContext context) =>
        Scaffold(body: Center(child: Text('Not Found'))),
  );
}

MaterialPageRoute onGenerateRoute(RouteSettings settings){
  switch (settings.name) {
    case RouteTraining:
      return MaterialPageRoute(
          builder: (context) => new RouteScreenTrainings());
    case RouteTrainingExercises:
      return MaterialPageRoute(
          builder: (context) =>
              RouteScreenTrainingExercises(
                  training: settings.arguments));
    case RouteMuscles:
      return MaterialPageRoute(
          builder: (context) => RouteScreenMuscles());
    case RouteExercises:
      return MaterialPageRoute(
          builder: (context) =>
              RouteScreenExercises(idMuscle: settings.arguments));
    case RouteExerciseDescription:
      return MaterialPageRoute(
          builder: (context) =>
              RouteScreenExerciseDescription(
                  exerciseParam: settings.arguments));
    case RouteProgressions:
      return MaterialPageRoute(
          builder: (context) =>
              RouteScreenProgressions(params: settings.arguments));
    case RouteLogin:
      return MaterialPageRoute(builder: (context) => ScreenLogin());
    case RouteSplashScreen:
      return MaterialPageRoute(builder: (context) => SplashScreen());
    default:
      return MaterialPageRoute(
          builder: (context) => RouteScreenTrainings());
  }
}