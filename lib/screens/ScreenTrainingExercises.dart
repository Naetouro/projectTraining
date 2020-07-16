import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:projecttrainingflutter/constants/RouteName.dart';
import 'package:projecttrainingflutter/api/ApiTrainingExercises.dart';
import 'package:projecttrainingflutter/arguments/TrainingExercisesToProgression.dart';
import 'package:projecttrainingflutter/models/Exercise.dart';
import 'package:projecttrainingflutter/models/Training.dart';
import 'package:projecttrainingflutter/widgets/CustomAppBar.dart';
import 'package:projecttrainingflutter/widgets/CustomDrawer.dart';

class RouteScreenTrainingExercises extends StatelessWidget {
  final Training training;

  RouteScreenTrainingExercises({Key key, this.training}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            name: training.name,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteExercises);
          },
          child: Icon(Icons.add),
        ),
        body: TrainingExercises(training: training));
  }
}

class TrainingExercises extends StatefulWidget {
  final Training training;

  TrainingExercises({Key key, this.training}) : super(key: key);

  @override
  _TrainingExercisesState createState() => _TrainingExercisesState();
}

class _TrainingExercisesState extends State<TrainingExercises> {
  final controller = TextEditingController();

  Future<List<Exercise>> _findAllExercises() async {
    return await ApiTrainingExercises().findAllByTrainingId(widget.training.id);
  }

  void _deleteAndRefresh(int idTraining, int idExercise) async {
    await ApiTrainingExercises().delete(idTraining, idExercise);
    setState(() {
      _findAllExercises();
    });
  }

  void _showDeleteExerciseDialog(name, idTraining, idExercise) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Voulez vous supprimer l'entrainement $name?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Annuler")),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteAndRefresh(idTraining, idExercise);
                  },
                  child: const Text("Valider"))
            ],
          );
        });
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _findAllExercises(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: const CircularProgressIndicator());
            } else {
              List<Exercise> exercisesList = snapshot.data;
              return GridView.builder(
                  itemCount: exercisesList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0),
                  itemBuilder: (BuildContext context, int index) {
                    Exercise exercise = exercisesList[index];
                    return OutlineButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteProgressions,
                              arguments: TrainingExercisesToProgression(
                                  exercise, widget.training.id));
                        },
                        onLongPress: () {
                          _showDeleteExerciseDialog(
                              exercise.name, widget.training.id, exercise.id);
                        },
                        borderSide: BorderSide(
                            color: Colors.black, style: BorderStyle.solid),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        child: new Text(StringUtils.capitalize(exercise.name),
                            style: TextStyle(fontSize: 16.0),
                            textAlign: TextAlign.center));
                  });
            }
          },
        ));
  }
}
