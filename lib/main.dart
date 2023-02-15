import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
// 위젯과 스타일
import 'package:flutter_instagram/widget/post.dart';
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

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    setState(() {
      data = result2;
    });
  }

  addData(a) {
    setState(() {
      data.add(a);
    });
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
            onPressed: () {},
            icon: Icon(Icons.add_box_outlined),
            iconSize: 30,
          )
        ],
      ),
      body: [HomeView(data: data, addData: addData), Text('shop')][tab],
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
  const HomeView({super.key, this.data, this.addData});
  final data;
  final addData;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 1;
  bool _hasNextPage = true;
  bool _isLoading = false;
  bool _isRequest = false;

  var scroll = ScrollController();

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
          //  요청 성공 => 1. 로딩 완료
          setState(() {
            _isLoading = false;
            _isRequest = false;
          });
        } else {
          print('서버 오류');
        }

        final result = jsonDecode(res.body);
        _page++;

        // 값이 있으면
        if (result.isNotEmpty) {
          widget.addData(result);
          setState(() {
            _hasNextPage = true;
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
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
    if (widget.data.isNotEmpty) {
      return ListView.builder(
          itemCount: widget.data.length,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(widget.data[i]['image']),
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
