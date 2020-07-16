import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecttrainingflutter/constants/RouteName.dart';

class CustomAppBar extends PreferredSize {
  final String name;
  final Builder builder;

  CustomAppBar({this.name, this.builder});

  @override
  final Size preferredSize = Size.fromHeight(kToolbarHeight); // default is 56.0

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(StringUtils.capitalize(name), style: Theme.of(context).primaryTextTheme.headline1),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushNamed(context, RouteTraining),
          )
        ],
        leading: builder);
  }
}
