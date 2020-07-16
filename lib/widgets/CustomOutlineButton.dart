import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecttrainingflutter/constants/RouteName.dart';
import 'package:projecttrainingflutter/models/Training.dart';

class CustomOutlineButton extends StatelessWidget {
  final Training training;
  final Function onLongPress;

  const CustomOutlineButton({Key key, this.training, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: RaisedButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteTrainingExercises,
              arguments: training);
        },
        onLongPress: onLongPress,
        //borderSide: const BorderSide(color: Colors.grey),
        child: Text(StringUtils.capitalize(training.name),
            style: const TextStyle(fontSize: 16.0),
            textAlign: TextAlign.center),
      ),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 15,
              offset: Offset(5.0, 10.0)),
        ],
      ),
    );
  }
}
