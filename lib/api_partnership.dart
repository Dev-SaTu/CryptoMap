import 'package:cryptomap/api_box.dart';
import 'package:cryptomap/title_container.dart';
import 'package:flutter/material.dart';

class APIPartnershipPage extends StatelessWidget {
  const APIPartnershipPage({super.key});

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
          child: const Column(
            children: <Widget>[
              TitleContainer(
                title: 'KB BizUnit',
                subtitle: '잔고의 상태를 조회합니다.',
                widget: APIBox(),
              ),
              SizedBox(height: 16.0),
              TitleContainer(
                title: 'GPT Adviser',
                subtitle: 'GPT 어드바이저에게 조언을 요청합니다.',
                widget: APIBox(),
              ),
              SizedBox(height: 16.0),
              TitleContainer(
                title: 'Get Symbol All',
                subtitle: '모든 심볼에 대한 가격 정보를 불러옵니다.',
                widget: APIBox(),
              ),
              SizedBox(height: 16.0),
              TitleContainer(
                title: 'Get Symbol Score',
                subtitle: '심볼의 차트 데이터와 기술적 분석 점수를 조회합니다.',
                widget: APIBox(),
              ),
              SizedBox(height: 16.0),
              TitleContainer(
                title: 'Get Balance Pie',
                subtitle: '추천 자산 분배 비율을 조회합니다.',
                widget: APIBox(),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
