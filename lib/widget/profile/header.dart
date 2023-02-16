import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/post1.png'),
          radius: 30,
        ),
        Text('팔로워 ${context.watch<Store1>().follower}'),
        ElevatedButton(
            onPressed: () {
              context.read<Store1>().changeFollower();
            },
            child: Text(context.watch<Store1>().friend ? '언팔하기' : '팔로우'))
      ],
    );
  }
}
