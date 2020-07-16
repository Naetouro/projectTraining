import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecttrainingflutter/constants/RouteName.dart';
import 'package:projecttrainingflutter/api/ApiMuscles.dart';
import 'package:projecttrainingflutter/models/Muscle.dart';
import 'package:projecttrainingflutter/widgets/CustomAppBar.dart';
import 'package:projecttrainingflutter/widgets/CustomDrawer.dart';

class RouteScreenMuscles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(name: "Muscles"),
        drawer: CustomDrawer(),
        body: Muscles());
  }
}

class Muscles extends StatefulWidget {
  Muscles({Key key}) : super(key: key);

  @override
  _MusclesState createState() => _MusclesState();
}

class _MusclesState extends State<Muscles> {
  Future<List<Muscle>> _findAll() async {
    return await ApiMuscles().findAll();
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _findAll(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<Muscle> muscleList = snapshot.data;
              return GridView.builder(
                  itemCount: muscleList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0),
                  itemBuilder: (context, int index) {
                    Muscle muscle = muscleList[index];
                    return OutlineButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteExercises, arguments: muscle.id);
                        },
                        borderSide: BorderSide(
                            color: Colors.black, style: BorderStyle.solid),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        child: new Text(StringUtils.capitalize(muscle.name),
                            style: TextStyle(fontSize: 12.0),
                            textAlign: TextAlign.center));
                  });
            }
          },
        ));
  }
}
