import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecttrainingflutter/constants/RouteName.dart';
import 'package:projecttrainingflutter/api/ApiTraining.dart';
import 'package:projecttrainingflutter/models/Training.dart';
import 'package:projecttrainingflutter/models/User.dart';
import 'package:projecttrainingflutter/widgets/CustomAppBar.dart';
import 'package:projecttrainingflutter/widgets/CustomDrawer.dart';
import 'package:projecttrainingflutter/widgets/CustomOutlineButton.dart';
import 'package:provider/provider.dart';

class RouteScreenTrainings extends StatelessWidget {
  RouteScreenTrainings({Key key}) : super(key: key);

  final GlobalKey<_TrainingsState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(name: "Training"),
      drawer: CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          globalKey.currentState._showCreateTrainingDialog();
        },
      ),
      body: Trainings(key: globalKey),
    );
  }
}

class Trainings extends StatefulWidget {
  Trainings({Key key}) : super(key: key);

  @override
  _TrainingsState createState() => _TrainingsState();
}

class _TrainingsState extends State<Trainings> {
  final controller = TextEditingController();
  Future<List<Training>> trainingList;

  Future<List<Training>> _findAllTraining() async {
    return ApiTraining().findAll();
  }

  void _saveAndRefresh() async {
    await ApiTraining().save(controller.text);
    setState(() {
      trainingList = _findAllTraining();
    });
  }

  void _deleteAndRefresh(idTraining) async {
    await ApiTraining().delete(idTraining);
    setState(() {
      trainingList = _findAllTraining();
    });
  }

  void _showCreateTrainingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Entrez le nom du nouveau programme"),
          content: TextField(
            controller: controller,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                _saveAndRefresh();
                controller.text = "";
              },
              child: const Text("Valider"),
            )
          ],
        );
      },
    );
  }

  _showDeleteTrainingDialog(name, idTraining) {
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
              child: const Text("Annuler"),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteAndRefresh(idTraining);
              },
              child: const Text("Valider"),
            )
          ],
        );
      },
    );
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  initState() {
    super.initState();
    trainingList = _findAllTraining();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: trainingList,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Training> trainingList = snapshot.data;
            return GridView.builder(
              itemCount: trainingList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15.0,
                  crossAxisSpacing: 15.0),
              itemBuilder: (BuildContext context, int index) {
                Training training = trainingList[index];
                return CustomOutlineButton(
                  training: training,
                  onLongPress: () {
                    //print(Provider.of<User>(context, listen: false).name);
                    _showDeleteTrainingDialog(training.name, training.id);
                  },
                );
              },
            );
          }

          return const Center(child: const CircularProgressIndicator());
        },
      ),
    );
  }
}
