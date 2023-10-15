import 'dart:convert';

import 'package:cryptomap/score_box.dart';
import 'package:cryptomap/synctree.dart';
import 'package:cryptomap/ticker.dart';
import 'package:flutter/material.dart';

import 'title_container.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto Map',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(18, 18, 30, 1.0)),
          thickness: MaterialStateProperty.all<double>(8.0),
        ),
      ),
      home: const MyHomePage(title: 'Crypto Map'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _chatController = TextEditingController();
  final _focusNode = FocusNode();
  late ScrollController _scrollController;
  late List<Ticker> tickers = [];
  List<String> chatHistory = [];
  bool _chatEnabled = true;

  Future<void> _loadTickers() async {
    List<Ticker> loadedTickers = await requestTickerAll();
    setState(() {
      tickers = loadedTickers;
    });
  }

  Future<void> _requestAdvise() async {
    String message = _chatController.text;
    if (message.isNotEmpty) {
      _chatController.clear();
      setState(() {
        chatHistory.add(message);
        _chatEnabled = false;
      });
      final answer = await requestAdvise(message);
      setState(() {
        chatHistory.add(answer);
        _chatEnabled = true;
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _loadTickers();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(11, 11, 13, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(24, 24, 26, 1.0),
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        title: Image.asset('assets/images/logo_orange.png', height: 24.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: 50.0, color: Colors.white, child: Center(child: Image.asset('assets/images/synctree.jpg'))),
            const TitleContainer(
              title: '에디터의 코멘트',
              subtitle: '가상화폐 시장 상황을 한 눈에 알아보세요!',
              widget: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Comment 1 : 내용은 이렇게 출력됩니다.', style: TextStyle(color: Colors.white)),
                  Text('Comment 2 : 내용은 이렇게 출력됩니다.', style: TextStyle(color: Colors.white)),
                  Text('Comment 3 : 내용은 이렇게 출력됩니다.', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TitleContainer(
              title: '추세 분석',
              subtitle: '기술적 분석을 이용해 가상화폐의 가격 추세를 판단합니다.',
              widget: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: Container(
                  height: 250.0,
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final ticker = tickers[index];
                      return ScoreBox(
                        symbol: ticker.symbol,
                        score: double.parse(ticker.closingPrice),
                      );
                    },
                    itemCount: tickers.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TitleContainer(
              title: 'GPT 어드바이저',
              subtitle: 'GPT 어드바이저의 도움을 받아 투자해보세요!',
              widget: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                height: 200.0,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.separated(
                        itemCount: chatHistory.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                        itemBuilder: (context, index) {
                          return Text(
                            chatHistory[index],
                            style: const TextStyle(color: Colors.white, fontSize: 9.0),
                            textAlign: index % 2 == 0 ? TextAlign.right : TextAlign.left,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      height: 40.0,
                      child: TextField(
                        enabled: _chatEnabled,
                        controller: _chatController,
                        focusNode: _focusNode,
                        onSubmitted: (value) => _requestAdvise(),
                        style: const TextStyle(color: Colors.white, fontSize: 12.0),
                        decoration: InputDecoration(
                          hintText: _chatEnabled ? '궁금한 점을 물어보세요.' : '답변을 생각하고 있어요.',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12.0),
                          suffix: IconButton(onPressed: () => _requestAdvise(), icon: const Icon(Icons.send, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TitleContainer(
              title: '시장 보고서 판매',
              subtitle: '안녕하세용',
              widget: Container(),
            ),
            const SizedBox(height: 16.0),
            TitleContainer(
              title: 'API 제공',
              subtitle: '안녕하세용',
              widget: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
