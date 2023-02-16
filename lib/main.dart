import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_instagram/page/upload.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
// 위젯과 스타일
import 'package:flutter_instagram/widget/post.dart';
import 'package:image_picker/image_picker.dart';
import 'style.dart' as style;

void main() {
  runApp(MaterialApp(theme: style.theme, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int tab = 0;
  var data = [];
  var userImage;

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    setState(() {
      data = result2;
    });
  }

  // 게시물 등록
  insertPost(a) {
    setState(() {
      data.insert(0, a);
    });
  }

  // 게시물 더보기
  viewMorePost(a) {
    setState(() {
      data.add(a);
    });

    print(data);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('마이크로프로텍트'),
        actions: [
          IconButton(
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                print(image.name);
                setState(() {
                  userImage = File(image.path);
                });
              }

              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => Upload(
                          userImage: userImage,
                          insertPost: insertPost,
                          data: data)));
            },
            icon: Icon(Icons.add_box_outlined),
            iconSize: 30,
          )
        ],
      ),
      body: [
        HomeView(data: data, viewMorePost: viewMorePost),
        Text('shop')
      ][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined), label: 'shop'),
        ],
      ),
    );
  }
}

// ------------- 커스텀 위젯 ------------- //
class HomeView extends StatefulWidget {
  const HomeView({super.key, this.data, this.viewMorePost});
  final data;
  final viewMorePost;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 1;
  bool _hasNextPage = true; // 다음페이지
  bool _isLoading = false; // 로딩
  bool _isRequest = false; // 서버 요청

  var scroll = ScrollController(); // 스크롤 도구

  // 더보기 요청 => 1. 요청중(true), 2. 로딩(true)
  getMoreData() async {
    setState(() {
      _isRequest = true;
    });

    if (_hasNextPage == true && _isRequest == true && _isLoading == false) {
      try {
        // 요청 날리기
        final res = await http.get(
            Uri.parse('https://codingapple1.github.io/app/more${_page}.json'));

        if (res.statusCode == 200) {
          //  요청 성공 => 1. 로딩 완료, 2. 요청 완료
          setState(() {
            _isLoading = false;
            _isRequest = false;
          });

          final result = jsonDecode(res.body);
          _page++;

          // 요청도 성공했고 값도 있으면 => 다음페이지 있음
          if (result.isNotEmpty) {
            widget.viewMorePost(result);
            setState(() {
              _hasNextPage = true;
            });
          } else {
            setState(() {
              _hasNextPage = false;
            });
          }
        } else {
          throw Exception('서버 오류');
        }
      } catch (e) {
        print(e);
        setState(() {
          _hasNextPage = false;
        });
        if (_hasNextPage == false) {
          final scaffold = ScaffoldMessenger.of(context);
          scaffold.showSnackBar(SnackBar(
            content: Text('피드가 존재하지않습니다.'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: scaffold.hideCurrentSnackBar,
            ),
          ));
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        // 더보기
        getMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading) {
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // (widget.data[i]['image'].toString().contains('http://') ||
                //         widget.data[i]['image'].toString().contains('https://'))
                widget.data[i]['image'].runtimeType == String
                    ? Image.network(widget.data[i]['image'])
                    : Image.file(widget.data[i]['image']),
                Text('좋아요 ${widget.data[i]['likes'].toString()}'),
                Text(widget.data[i]['user']),
                Text(widget.data[i]['content']),
              ],
            );
          });
    } else {
      return CircularProgressIndicator();
    }
  }
}
