import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_instagram/style.dart';

class AvatarComponent extends StatefulWidget {
  const AvatarComponent({super.key, this.url});
  final url;

  @override
  State<AvatarComponent> createState() => _AvatarComponentState();
}

class _AvatarComponentState extends State<AvatarComponent> {
  @override
  _renderType() {
    if (widget.url == String) {
      return Image.network(widget.url);
    } else {
      return Image.asset(widget.url);
    }
  }

  Widget build(BuildContext context) {
    return _renderType();
  }
}
