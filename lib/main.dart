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
      candlesticks = List.generate(tickers.length, (index) => List.generate(10, (index) => List.generate(6, (index) => 0.0)));
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
                title: '계좌',
                subtitle: '현재 계좌 잔고와 투자 추천 금액을 알아보세요.',
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (balance == null)
                      const Center(child: SizedBox(width: 40.0, child: CircularProgressIndicator()))
                    else ...[
                      Text(balance!.productName, style: const TextStyle(color: Colors.grey)),
                      Text(NumberFormat('#,### 원').format(balance?.balance), style: const TextStyle(color: Colors.white, fontSize: 18.0)),
                      const SizedBox(height: 8.0),
                      const Text('투자 추천 금액', style: TextStyle(color: Colors.grey)),
                      Text(NumberFormat('#,### 원').format(balance!.balance * 0.1), style: const TextStyle(color: Colors.white, fontSize: 18.0)),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              TitleContainer(
                title: '실시간 코멘트',
                subtitle: 'CryptoMap 에디터가 자산 분배 코멘트를 제공해드려요.',
                widget: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    PieChartSample2(data: <PieChartSectionData>[
                      PieChartSectionData(color: Colors.redAccent, title: 'BTC', value: 0.4, showTitle: false),
                      PieChartSectionData(color: Colors.orangeAccent, title: 'ETH', value: 0.2, showTitle: false),
                      PieChartSectionData(color: Colors.yellowAccent, title: 'XRP', value: 0.2, showTitle: false),
                      PieChartSectionData(color: Colors.greenAccent, title: 'BCH', value: 0.1, showTitle: false),
                      PieChartSectionData(color: Colors.blueAccent, title: 'TRX', value: 0.1, showTitle: false),
                    ]),
                    Text('BTC 40.0% | ${NumberFormat("#,### 원").format((balance?.balance ?? 0.0) * 0.1 * 0.4)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('ETH 20.0% | ${NumberFormat("#,### 원").format(balance?.balance ?? 0.0 * 0.1 * 0.2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('XRP 20.0% | ${NumberFormat("#,### 원").format(balance?.balance ?? 0.0 * 0.1 * 0.2)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('BCH 10.0% | ${NumberFormat("#,### 원").format(balance?.balance ?? 0.0 * 0.1 * 0.1)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('TRX 10.0% | ${NumberFormat("#,### 원").format(balance?.balance ?? 0.0 * 0.1 * 0.1)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              TitleContainer(
                title: '추세 분석',
                subtitle: '기술적 분석을 이용한 가상화폐 가격 추이를 알아보세요.\n1.0 이상',
                widget: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: Container(
                    height: 300.0,
                    decoration: BoxDecoration(
                      // color: const Color.fromRGBO(0, 0, 0, 1.0),
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
                                Text(NumberFormat('#.##').format(scores[index]), style: const TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 16.0),
                                Expanded(child: LineChartSample2(data: candlesticks[index])),
                              ],
                            ),
                          ],
                          onExpansionChanged: (value) async {
                            if (value) {
                              final scoreData = await requestSymbolScore(ticker.symbol);
                              setState(() {
                                scores[index] = scoreData['score'];
                                candlesticks[index] = (scoreData['candlestick'] as List<dynamic>).cast<List<dynamic>>();
                              });
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
