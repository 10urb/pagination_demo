import 'package:flutter/material.dart';
import 'package:pagination_demo/model/user_model.dart';

class ListItem extends StatelessWidget {
  final UserModel user;
  final int index;

  const ListItem(this.user, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        foregroundImage: NetworkImage(user.imageUrl),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Text(index.toString()),
    );
  }
}
