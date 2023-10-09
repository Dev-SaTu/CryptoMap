import 'package:cryptomap/score_box.dart';
import 'package:cryptomap/synctree.dart';
import 'package:cryptomap/ticker.dart';
import 'package:flutter/material.dart';

import 'title_container.dart';

void main() {
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
  late ScrollController _scrollController;
  late List<Ticker> tickers;

  Future<void> _loadTickers() async {
    /*List<Ticker> loadedTickers = await requestTickerAll();
    setState(() {
      tickers = loadedTickers;
    });*/
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadTickers();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 18, 30, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        title: Image.asset('images/logo_orange.png', height: 32.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleContainer(
                title: '에디터의 코멘트',
                subtitle: '실시간으로 분석한 모든 가상화폐의 가격 추세를 알아보세요.',
                widget: Container(),
              ),
              const SizedBox(height: 16.0),
              TitleContainer(
                title: 'GPT 어드바이저',
                subtitle: 'Chat GPT의 도움을 받아 투자해보세요!',
                widget: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  height: 260.0,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(18, 18, 30, 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.separated(
                          itemCount: 30,
                          separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                          itemBuilder: (context, index) {
                            return const Text('텍스트', style: TextStyle(color: Colors.white));
                          },
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        height: 40.0,
                        child: TextField(
                          controller: _chatController,
                          style: const TextStyle(color: Colors.white, fontSize: 12.0),
                          decoration: const InputDecoration(
                            hintText: 'GPT 어드바이저에게 궁금한 점을 물어보세요.',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                            suffix: Icon(Icons.send, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TitleContainer(
                title: '추세 분석',
                subtitle: 'Crypto Map의 기술적 분석을 이용해 가상화폐의 가격 추세를 판단합니다.',
                widget: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: Container(
                    height: 260.0,
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ListView.separated(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => const ScoreBox(symbol: 'BTC', score: 3746600),
                      itemCount: 20,
                      /*itemBuilder: (context, index) {
                        final ticker = tickers[index];
                        return ScoreBox(symbol: ticker.symbol, score: double.parse(ticker.closingPrice));
                      },
                      itemCount: tickers.length,*/
                      separatorBuilder: (context, index) => const SizedBox(width: 8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TitleContainer(
                title: '기능 3',
                subtitle: '안녕하세용',
                widget: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
