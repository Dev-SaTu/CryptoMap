import 'package:cryptomap/title_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(15, 15, 17, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        title: Image.asset('assets/images/logo_orange.png', height: 24.0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Column(
            children: <Widget>[
              TitleContainer(
                title: '시장 보고서',
                subtitle: '${DateFormat('y년 M월 d일').format(DateTime.now())}, CryptoMap',
                widget: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('마스터카드', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                    Text('코인베이스 이용자가 NFT 구매 시 마스터카드의 신용/직불카드 사용 가능. 구매 과정 간소화 및 선택 폭 확대 기대.', style: TextStyle(color: Colors.white)),
                    SizedBox(height: 16.0),
                    Text('BBVA & 코먼웰스은행', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                    Text('스페인의 BBVA와 호주의 코먼웰스은행, 가상화폐 보관 및 거래 서비스 출시. 코먼웰스은행은 가상화폐 거래소 제미니와 제휴.', style: TextStyle(color: Colors.white)),
                    SizedBox(height: 16.0),
                    Text('터키', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                    Text('리라화 변동성에 따른 암호화폐 보유 증가. 바이낸스 등 거래소의 리라화 기반 암호화폐 거래 하루 평균 18억달러로 급증.', style: TextStyle(color: Colors.white)),
                    SizedBox(height: 16.0),
                    Text('FTX', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                    Text('20억 달러 규모 펀드 \'FTX 벤처스\' 조성 예정. 웹3.0, 블록체인, 결제 애플리케이션 등에 투자 계획.', style: TextStyle(color: Colors.white)),
                    SizedBox(height: 16.0),
                    Text('IMF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                    Text('팬데믹 이전 가상자산과 주식의 연관성 낮았으나, 코로나19 이후 상호연관성 증가.', style: TextStyle(color: Colors.white)),
                    SizedBox(height: 16.0),
                    Text('구글', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                    Text('가상화폐 및 메타버스 투자에서 상대적으로 조용했던 구글이 블록체인 전담 조직을 신설, 업계 주목.', style: TextStyle(color: Colors.white)),
                    SizedBox(height: 16.0),
                    Text('인텔', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                    Text('가상자산 채굴 전용 ASIC(주문형 반도체) 출시 예정. 현재 해당 시장은 중국의 비트메인이 장악 중. 인텔은 과거 2018년 가상자산 채굴 프로세서 특허 획득.', style: TextStyle(color: Colors.white)),
                    SizedBox(height: 16.0),
                    Text('소프트뱅크', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                    Text('FTX US가 최근 4억 달러 투자를 조달, 회사 가치 80억 달러로 평가. 소프트뱅크, 테마섹 등 큰 투자자들 참여. FTX US는 투자금을 신규 사업 및 사용자 확대에 사용 예정.', style: TextStyle(color: Colors.white)),
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
