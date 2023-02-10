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
        title: Text('Instagram'),
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
  int _page = 0;
  bool _hasNextPage = true;
  bool _isLoadMoreRunning = false;
  var isLoading = false;
  var scroll = ScrollController();

  getMoreData() async {
    if (_hasNextPage == true && _isLoadMoreRunning == false) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      setState(() {
        _page++;
      });

      print(_page);

      try {
        var res = await http.get(
            Uri.parse('https://codingapple1.github.io/app/more${_page}.json'));
        var result = jsonDecode(res.body);
        if (result.isNotEmpty) {
          widget.addData(result);
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (e) {
        print('서버 통신 실패');
      }
    } else {
      print('피드가 더이상 존재하지 않습니다.');
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
    } else if (_hasNextPage == false) {
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('피드를 모두 로드했습니다.')));
    } else {
      return CircularProgressIndicator();
    }
  }
}
