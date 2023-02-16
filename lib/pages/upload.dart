import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Upload extends StatefulWidget {
  const Upload({super.key, this.data, this.userImage, this.insertPost});
  final data;
  final userImage;
  final insertPost;

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  var contentInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: SafeArea(
            child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        )),
        appBar: AppBar(actions: [
          IconButton(
              onPressed: () {
                widget.insertPost({
                  'id': widget.data.length,
                  'image': widget.userImage,
                  'likes': 100,
                  'liked': false,
                  'content': contentInput.text,
                  'date': 'July 25',
                  'user': 'heesong'
                });
                Navigator.pop(context);
              },
              icon: Icon(Icons.send))
        ]),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.file(
                widget.userImage,
                width: double.infinity,
                fit: BoxFit.contain,
                height: 200,
              ),
              Text('이미지업로드화면'),
              TextField(
                controller: contentInput,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close))
            ],
          ),
        ));
  }
}
