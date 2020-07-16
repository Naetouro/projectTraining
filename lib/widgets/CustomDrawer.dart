import 'package:flutter/material.dart';
import 'package:projecttrainingflutter/constants/RouteName.dart';
import 'package:projecttrainingflutter/widgets/ConsumerCustomAccountsDrawerHeader.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: <Widget>[
          ConsumerCustomAccountsDrawerHeader(),
          ListTile(
            title: const Text("Trainings"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.pushNamed(context, RouteTraining),
          ),
          ListTile(
            title: const Text("Muscles"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.pushNamed(context, RouteMuscles),
          ),
          ListTile(
            title: const Text("Exercises"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.pushNamed(context, RouteExercises),
          ),
          ListTile(
            title: const Text("Login"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.pushNamed(context, RouteLogin),
          ),
        ],
      ),
    );
  }
}
