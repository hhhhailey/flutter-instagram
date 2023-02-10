import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/post1.png'),
        Text('좋아요 100'),
        Text('글쓴이'),
        Text('글내용'),
      ],
    );
  }
}
