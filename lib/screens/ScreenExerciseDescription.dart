import 'dart:ui';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecttrainingflutter/api/ApiExercises.dart';
import 'package:projecttrainingflutter/api/ApiTrainingExercises.dart';
import 'package:projecttrainingflutter/models/Exercise.dart';
import 'package:projecttrainingflutter/models/Muscle.dart';
import 'package:projecttrainingflutter/models/Training.dart';
import 'package:projecttrainingflutter/models/pages/HomeExercise.dart';
import 'package:projecttrainingflutter/notifiers/NotifierSelectedTraining.dart';
import 'package:projecttrainingflutter/widgets/CustomAppBar.dart';
import 'package:projecttrainingflutter/widgets/CustomDrawer.dart';
import 'package:projecttrainingflutter/widgets/WidgetExerciseImage.dart';

class RouteScreenExerciseDescription extends StatelessWidget {
  final Exercise exerciseParam;

  RouteScreenExerciseDescription({Key key, this.exerciseParam})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            name: exerciseParam.name,
            builder: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
              },
            )),
        drawer: CustomDrawer(),
        body: ExerciseDescription(exerciseParam: exerciseParam));
  }
}

class ExerciseDescription extends StatefulWidget {
  final Exercise exerciseParam;

  ExerciseDescription({Key key, this.exerciseParam}) : super(key: key);

  @override
  _ExerciseDescriptionState createState() => _ExerciseDescriptionState();
}

class _ExerciseDescriptionState extends State<ExerciseDescription> {
  Future<PageExercise> _pageExercise;
  final notifier = NotifierSelectedTraining();

  Future<PageExercise> findAll() async {
    return await ApiExercises().findById(widget.exerciseParam.id);
  }

  Row _rowMuscles(List<Muscle> muscles) {
    return Row(
        children: muscles.map((Muscle muscle) {
      String text = muscle.name;
      text += muscles.last != muscle ? ", " : "";
      return Text(text, style: TextStyle(fontSize: 16.0));
    }).toList());
  }

  void _chooseTraining(Training training) {
    notifier.changeTrainingValue(training);
  }

  _saveExerciseInTraining(Training training, Exercise exercise) {
    ApiTrainingExercises().save(training.id, exercise.id).then((data) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(StringUtils.capitalize(
            "${exercise.name} a été ajouté à ${training.name}")),
      ));
    });
  }

  @override
  initState() {
    super.initState();
    _pageExercise = findAll();
  }

  @override
  void dispose() {
    super.dispose();
    notifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder(
      future: _pageExercise,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          PageExercise pageExercise = snapshot.data;
          Exercise exercise = pageExercise.exercise;

          if (notifier.training == null)
            notifier.training = pageExercise.trainingList[0];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              WidgetExerciseImage(image: exercise.image),
              Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      const Text("Ajouter au programme "),
                      DropdownButton<Training>(
                          value: notifier.training,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.blue),
                          underline: Container(
                            height: 2,
                            color: Colors.blue,
                          ),
                          onChanged: (Training newValue) {
                            setState(() {
                              _chooseTraining(newValue);
                            });
                          },
                          items: pageExercise.trainingList
                              .map((Training training) {
                            return DropdownMenuItem(
                              value: training,
                              child:
                                  Text(StringUtils.capitalize(training.name)),
                            );
                          }).toList()),
                      FlatButton(
                        child: const Text("Ajouter"),
                        onPressed: () {
                          _saveExerciseInTraining(
                              notifier.training, widget.exerciseParam);
                        },
                      )
                    ],
                  )),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                margin: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                padding:
                    const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
                child: const Text("Primary muscles",
                    style: TextStyle(fontSize: 20.0)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _rowMuscles(exercise.primaryMuscles),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 4.0),
                child: Text("Secondary muscles",
                    style: const TextStyle(fontSize: 20.0)),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _rowMuscles(exercise.secondaryMuscles)),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 4.0),
                child: Text("Description", style: TextStyle(fontSize: 20.0)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(exercise.description,
                    style: const TextStyle(fontSize: 16.0)),
              )
            ],
          );
        }
      },
    ));
  }
}
