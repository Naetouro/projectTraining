import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projecttrainingflutter/notifiers/NotifierTimer.dart';
import 'package:projecttrainingflutter/api/ApiProgression.dart';
import 'package:projecttrainingflutter/models/ProgressionRecord.dart';
import 'package:projecttrainingflutter/arguments/TrainingExercisesToProgression.dart';
import 'package:projecttrainingflutter/models/Progression.dart';
import 'package:projecttrainingflutter/widgets/CustomAppBar.dart';
import 'package:projecttrainingflutter/widgets/CustomDrawer.dart';

class RouteScreenProgressions extends StatelessWidget {
  final TrainingExercisesToProgression params;

  RouteScreenProgressions({Key key, this.params}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            name: params.exercise.name,
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
        body: Progressions(params: params));
  }
}

class Progressions extends StatefulWidget {
  final TrainingExercisesToProgression params;

  Progressions({Key key, this.params}) : super(key: key);

  @override
  _ProgressionState createState() => _ProgressionState();
}

class _ProgressionState extends State<Progressions> {
  Timer _timer;
  var times = [30, 60, 90, 120, 180, 240, 300];
  final notifier = NotifierTimer();
  final controllerReps = TextEditingController();
  final controllerWeight = TextEditingController();
  final controllerUpdateReps = TextEditingController();
  final controllerUpdateWeight = TextEditingController();
  int nbMonths = 3;

  Future<List<Progression>> progressionList;

  Future<List<Progression>> findAll(int nbMonths) async {
    return await ApiProgression()
        .findAll(widget.params.idTraining, widget.params.exercise.id, nbMonths);
  }

  Future<void> save(int idTraining, int idExercise,
      ProgressionRecord progressionRecord) async {
    await ApiProgression().save(idTraining, idExercise, progressionRecord);
    setState(() {
      findAll(nbMonths);
    });
  }

  Future<void> update(int idTraining, int idExercise, int idProgression,
      int reps, double weight) async {
    await ApiProgression()
        .update(idTraining, idExercise, idProgression, reps, weight);
    setState(() {
      findAll(nbMonths);
    });
  }

  Future<void> delete(int idTraining, int idExercise, int idProgression) async {
    await ApiProgression().delete(idTraining, idExercise, idProgression);
    setState(() {
      findAll(nbMonths);
    });
  }

  void openUpdateDialog(ProgressionRecord progressionRecord) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Modifier la progression"),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration.collapsed(
                        hintText: "Reps", border: OutlineInputBorder()),
                    controller: controllerUpdateReps
                      ..text = progressionRecord.reps.toString(),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    //initialValue: weight.toString(),
                    decoration: InputDecoration.collapsed(
                      border: OutlineInputBorder(),
                      hintText: "Weight",
                    ),
                    controller: controllerUpdateWeight
                      ..text = progressionRecord.weight.toString(),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Annuler")),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    update(
                        widget.params.idTraining,
                        widget.params.exercise.id,
                        progressionRecord.id,
                        int.parse(controllerUpdateReps.text),
                        double.parse(controllerUpdateWeight.text));
                  },
                  child: const Text("Valider"))
            ],
          );
        });
  }

  void openDeleteDialog(int idProgression) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Supprimer cette progression?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Annuler")),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    delete(widget.params.idTraining, widget.params.exercise.id,
                        idProgression);
                  },
                  child: const Text("Valider"))
            ],
          );
        });
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (notifier.start < 1) {
            timer.cancel();
            notifier.start = notifier.time;
          } else {
            notifier.minusOne();
          }
        },
      ),
    );
  }

  void _chooseTime(int newValue) {
    notifier.changeTimeValue(newValue);
  }

  String timeFormat(value) {
    String time;
    var duration = Duration(seconds: value);

    time = duration.toString().split(".")[0];
    time = time.split(":")[1] + ":" + time.split(":")[2];

    return time;
  }

  @override
  initState() {
    notifier.changeTimeValue(times[0]);
    progressionList = findAll(3);
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20/2),
        child: Column(
          children: <Widget>[

            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              height: 160,
              child:
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      height: 136,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.lightBlue,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0,15),
                                blurRadius: 27,
                                color: Colors.black12
                            )
                          ]
                      ),
                      child: Container(
                        margin: EdgeInsets.only(right: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        width: 180,

                        child: Image.asset("assets/google_logo.png",
                          fit: BoxFit.cover,),
                      ),
                    ),

                    Positioned(
                        bottom: 0,
                      left: 0,
                      child: SizedBox(
                        height: 136,
                        width: size.width-200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text("Logo Google"),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20/3, horizontal: 20),
                              child: Text("Price"),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(22),
                                  topRight: Radius.circular(22),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    )
                  ],
                ),
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(timeFormat(notifier.start)),
                Expanded(
                  child: Container(
                    height: 10,
                    child: LinearProgressIndicator(
                        value: notifier.start.toDouble() /
                            notifier.time.toDouble()),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  width: 75,
                  child: DropdownButton<int>(
                    value: notifier.time,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.blue),
                    underline: Container(
                      height: 2,
                      color: Colors.blue,
                    ),
                    onChanged: (int newValue) {
                      setState(
                        () {
                          _chooseTime(newValue);
                        },
                      );
                    },
                    items: times.map(
                      (value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(timeFormat(value)),
                        );
                      },
                    ).toList(),
                  ),
                  /*
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                        width: 1.0,
                        color: Colors.blue
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.1,
                        blurRadius: 5,
                        offset: Offset(3, 7), // changes position of shadow
                      ),
                    ],
                  ),*/
                ),
                FlatButton(
                  child: Text("Repos"),
                  onPressed: () {
                    startTimer();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration.collapsed(
                        hintText: "Reps", border: OutlineInputBorder()),
                    controller: controllerReps,
                  ),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration.collapsed(
                      border: OutlineInputBorder(),
                      hintText: "Weight",
                    ),
                    controller: controllerWeight,
                  ),
                ),
                FlatButton(
                    child: Text("Ajouter"),
                    onPressed: () {
                      ProgressionRecord progressionRecord =
                          new ProgressionRecord(
                              reps: int.parse(controllerReps.text.toString()),
                              weight: double.parse(
                                  controllerWeight.text.toString()));
                      controllerWeight.text = "";
                      controllerReps.text = "";
                      save(widget.params.idTraining, widget.params.exercise.id,
                          progressionRecord);
                    })
              ],
            ),

            Expanded(
              child: FutureBuilder(
                future: progressionList,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Progression> progressionList = snapshot.data;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: progressionList.length,
                        itemBuilder: (context, int index) {
                          Progression progression = progressionList[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Center(
                                child: Text(progression.date),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: const Text("Reps",
                                        textAlign: TextAlign.center),
                                    margin: EdgeInsets.only(right: 6.0),
                                  ),
                                  const Text("Weight",
                                      textAlign: TextAlign.center),
                                ],
                              ),
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: progression.progressions.length,
                                  itemBuilder: (context, int index) {
                                    ProgressionRecord progressionRecord =
                                        progression.progressions[index];

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                  progressionRecord.reps
                                                      .toString(),
                                                  textAlign: TextAlign.center),
                                              margin:
                                                  EdgeInsets.only(right: 10.0),
                                            ),
                                            Text(
                                                progressionRecord.weight
                                                        .toString() +
                                                    "kg",
                                                textAlign: TextAlign.center),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.border_color),
                                              onPressed: () {
                                                openUpdateDialog(
                                                    progressionRecord);
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                openDeleteDialog(
                                                    progressionRecord.id);
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  }),
                            ],
                          );
                        });
                  }

                  return const Center(child: const CircularProgressIndicator());
                },
              ),
            )
          ],
        ));
  }
}
