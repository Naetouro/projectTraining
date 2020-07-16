import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecttrainingflutter/constants/RouteName.dart';
import 'package:projecttrainingflutter/api/ApiExercises.dart';
import 'package:projecttrainingflutter/models/Exercise.dart';
import 'package:projecttrainingflutter/widgets/CustomAppBar.dart';
import 'package:projecttrainingflutter/widgets/CustomDrawer.dart';

class RouteScreenExercises extends StatelessWidget {
  final int idMuscle;

  const RouteScreenExercises({Key key, this.idMuscle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(name: "Exercises"),
        drawer: CustomDrawer(),
        body: Exercises(idMuscle: idMuscle));
  }
}

class Exercises extends StatefulWidget {
  final int idMuscle;

  Exercises({Key key, this.idMuscle}) : super(key: key);

  @override
  _ExercisesState createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  Future<List<Exercise>> exerciseList;

  Future<List<Exercise>> findAll() async {
    return await ApiExercises().findAll();
  }

  Future<List<Exercise>> findAllByPrimaryMuscleId(int idMuscle) async {
    return await ApiExercises().findAllByPrimaryMuscleId(idMuscle);
  }

  @override
  initState() {

    if (widget.idMuscle == null) {
      exerciseList = findAll();
    } else {
      exerciseList = findAllByPrimaryMuscleId(widget.idMuscle);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: exerciseList,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<Exercise> exerciseList = snapshot.data;
                return GridView.builder(
                    itemCount: exerciseList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 6.0,
                            crossAxisSpacing: 6.0),
                    itemBuilder: (context, int index) {
                      Exercise exercise = exerciseList[index];
                      return OutlineButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RouteExerciseDescription,
                                arguments: exercise);
                          },
                          borderSide: BorderSide(
                              color: Colors.black, style: BorderStyle.solid),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          child: Text(
                            StringUtils.capitalize(exercise.name),
                            textAlign: TextAlign.center,
                          ));
                    });
              }
            }));
  }
}
