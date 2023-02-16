import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_instagram/main.dart';
import 'package:flutter_instagram/widget/avatar.component.dart';
import 'package:flutter_instagram/widget/profile/header.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<Store1>().getProfileImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<Store2>().name),
      ),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: ProfileHeader()),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
              (c, i) => Image.network(context.watch<Store1>().profileImage[i]),
              childCount: context.watch<Store1>().profileImage.length),
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        ),
      ]),
    );
  }
}
