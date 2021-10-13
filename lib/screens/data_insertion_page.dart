import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GraphQL Insert')),
      body: Center(child: Text('Demo Page', style: Theme.of(context).textTheme.headline5,)),
    );
  }
}