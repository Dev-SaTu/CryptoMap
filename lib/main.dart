import 'package:cryptomap/api_partnership.dart';
import 'package:cryptomap/line_chart_sample.dart';
import 'package:cryptomap/pie_chart_sample.dart';
import 'package:cryptomap/report.dart';
import 'package:cryptomap/svg_icon.dart';
import 'package:cryptomap/synctree.dart';
import 'package:cryptomap/ticker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'balance.dart';
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
          thumbColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(15, 15, 17, 1.0)),
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
  late List<Ticker> tickers = [];
  late List<double> scores = [];
  late List<List<List<dynamic>>> candlesticks = [];
  final ScrollController _scrollController = ScrollController();
  Balance? balance;
  List<String> chatHistory = [];
  bool _chatEnabled = true;

  Future<void> _loadTickers() async {
    final List<Ticker> loadedTickers = await requestTickerAll();
    setState(() {
      tickers = loadedTickers;
      scores = List.generate(tickers.length, (index) => 1.0);
      candlesticks = List.generate(tickers.length, (index) => List.generate(10, (index) => List.generate(6, (index) => 5.0)));
    });
  }

  Future<void> _loadBalance() async {
    final response = await requestKB();
    setState(() {
      balance = response;
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
    super.initState();
    _loadTickers();
    _loadBalance();
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
      backgroundColor: const Color.fromRGBO(15, 15, 17, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        title: Image.asset('assets/images/logo_orange.png', height: 24.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(height: 50.0, color: Colors.black, child: Center(child: Image.asset('assets/images/synctree_black.png'))),
              const SizedBox(height: 16.0),
              TitleContainer(
                title: '나의 자산',
                subtitle: '현재 나의 자산별 투자 추천 금액을 알려드려요.',
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (balance == null)
                      const Center(child: SizedBox(width: 40.0, child: CircularProgressIndicator()))
                    else ...[
                      Text(balance!.productName, style: const TextStyle(color: Colors.grey)),
                      Text(NumberFormat('#,### 원').format(balance?.balance), style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8.0),
                      const Text('투자 추천 금액 (10%)', style: TextStyle(color: Colors.grey)),
                      Text(NumberFormat('#,### 원').format(balance!.balance * 0.1), style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              TitleContainer(
                title: '실시간 코멘트',
                subtitle: 'CryptoMap 에디터가 실시간 추천 종목을 알려드려요.',
                widget: FutureBuilder(
                  future: requestBalancePie(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      Map<String, dynamic>? result = snapshot.data;
                      final data = result?['result'] as List<dynamic>;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          PieChartSample2(data: <PieChartSectionData>[
                            PieChartSectionData(color: Colors.redAccent, title: (data[0] as Map).keys.first, value: (data[0][(data[0] as Map).keys.first]), showTitle: false),
                            PieChartSectionData(color: Colors.orangeAccent, title: (data[1] as Map).keys.first, value: (data[1][(data[1] as Map).keys.first]), showTitle: false),
                            PieChartSectionData(color: Colors.yellowAccent, title: (data[2] as Map).keys.first, value: (data[2][(data[2] as Map).keys.first]), showTitle: false),
                            PieChartSectionData(color: Colors.greenAccent, title: (data[3] as Map).keys.first, value: (data[3][(data[3] as Map).keys.first]), showTitle: false),
                            PieChartSectionData(color: Colors.blueAccent, title: (data[4] as Map).keys.first, value: (data[4][(data[4] as Map).keys.first]), showTitle: false),
                          ]),
                          Text('현재 가장 추천드리는 종목은 ${(data[0] as Map).keys.first} 입니다.', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('${(data[0] as Map).keys.first} ${NumberFormat('#0.0').format(100.0 * (data[0][(data[0] as Map).keys.first]))}% | ${NumberFormat("#,### 원").format((balance?.balance ?? 0.0) * 0.1 * 0.4)}',
                              style: const TextStyle(color: Colors.white)),
                          Text('${(data[1] as Map).keys.first} ${NumberFormat('#0.0').format(100.0 * (data[1][(data[1] as Map).keys.first]))}% | ${NumberFormat("#,### 원").format((balance?.balance ?? 0.0) * 0.1 * 0.2)}',
                              style: const TextStyle(color: Colors.white)),
                          Text('${(data[2] as Map).keys.first} ${NumberFormat('#0.0').format(100.0 * (data[2][(data[2] as Map).keys.first]))}% | ${NumberFormat("#,### 원").format((balance?.balance ?? 0.0) * 0.1 * 0.2)}',
                              style: const TextStyle(color: Colors.white)),
                          Text('${(data[3] as Map).keys.first} ${NumberFormat('#0.0').format(100.0 * (data[3][(data[3] as Map).keys.first]))}% | ${NumberFormat("#,### 원").format((balance?.balance ?? 0.0) * 0.1 * 0.1)}',
                              style: const TextStyle(color: Colors.white)),
                          Text('${(data[4] as Map).keys.first} ${NumberFormat('#0.0').format(100.0 * (data[4][(data[4] as Map).keys.first]))}% | ${NumberFormat("#,### 원").format((balance?.balance ?? 0.0) * 0.1 * 0.1)}',
                              style: const TextStyle(color: Colors.white)),
                        ],
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              TitleContainer(
                title: 'CryptoMap 스코어',
                subtitle: 'AI 기반 분석으로 종목별 점수를 알려드려요.\n(1.0 < 스코어) 면 상승, (1.0 > 스코어) 면 하락',
                widget: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: Container(
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    //padding: const EdgeInsets.only(bottom: 16.0),
                    child: ListView.builder(
                      controller: _scrollController,
                      // scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final ticker = tickers[index];
                        return ExpansionTile(
                          title: Text(ticker.symbol, style: const TextStyle(color: Colors.white)),
                          subtitle: Text(NumberFormat('#,###.#### 원').format(double.parse(ticker.closingPrice)), style: const TextStyle(color: Colors.white70)),
                          leading: Container(
                            padding: const EdgeInsets.all(6.0),
                            width: 32.0,
                            height: 32.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32.0),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: SvgTile(url: 'https://raw.githubusercontent.com/Cryptofonts/cryptoicons/master/SVG/${ticker.symbol.toLowerCase()}.svg'),
                          ),
                          collapsedIconColor: Colors.white,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(NumberFormat('0.0000').format(scores[index]), style: const TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold)),
                                    Text(
                                      scores[index] > 1.0
                                          ? '상승'
                                          : scores[index] < 1.0
                                              ? '하락'
                                              : '횡보',
                                      style: TextStyle(
                                          color: scores[index] > 1.0
                                              ? Colors.lightGreenAccent
                                              : scores[index] < 1.0
                                                  ? Colors.redAccent
                                                  : Colors.grey,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(child: LineChartSample2(data: candlesticks[index])),
                              ],
                            ),
                          ],
                          onExpansionChanged: (value) async {
                            if (value) {
                              if (scores[index] == 1.0) {
                                // Temporal
                                final scoreData = await requestSymbolScore(ticker.symbol);
                                setState(() {
                                  scores[index] = scoreData['score'];
                                  candlesticks[index] = (scoreData['candlestick'] as List<dynamic>).cast<List<dynamic>>();
                                });
                              }
                            }
                          },
                        );
                      },
                      itemCount: tickers.length,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TitleContainer(
                title: 'GPT 어드바이저',
                subtitle: 'ChatGPT 어드바이저에게 도움을 구해 보세요.',
                widget: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  height: 240.0,
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
                            icon: _chatEnabled ? null : const CircularProgressIndicator(),
                            hintText: _chatEnabled ? '어드바이저에게 무엇이든 물어보세요.' : '답변을 생각하고 있어요.',
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
                title: '시장 보고서',
                subtitle: '매일 새롭게 작성되는 보고서를 읽어보세요!',
                widget: Row(
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportPage())),
                      icon: const Icon(Icons.newspaper, color: Color.fromRGBO(253, 111, 34, 1.0)),
                      label: const Text('오늘의 시장 보고서 읽어보기', style: TextStyle(color: Color.fromRGBO(253, 111, 34, 1.0))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              TitleContainer(
                title: 'API 제공',
                subtitle: '제휴를 맺고 CryptoMap의 API를 사용해보세요!',
                widget: Row(
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const APIPartnershipPage())),
                      icon: const Icon(Icons.read_more, color: Color.fromRGBO(253, 111, 34, 1.0)),
                      label: const Text('자세히 알아보기', style: TextStyle(color: Color.fromRGBO(253, 111, 34, 1.0))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
