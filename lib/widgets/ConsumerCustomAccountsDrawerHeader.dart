import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projecttrainingflutter/models/User.dart';
import 'package:provider/provider.dart';

class ConsumerCustomAccountsDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        if (user.id != null) {
          return UserAccountsDrawerHeader(
            accountName: Text(user.name),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.blue
                      : Colors.white,
              backgroundImage: NetworkImage(user.image),
            ),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }
}
