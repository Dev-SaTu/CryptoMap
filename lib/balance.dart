class Balance {
  final String customerName; // 고객명
  final String customerId;   // 고객식별자
  final String accountNumber; // 계좌번호
  final String productName;  // 상품명
  final int balance;         // 잔액

  Balance({
    required this.customerName,
    required this.customerId,
    required this.accountNumber,
    required this.productName,
    required this.balance,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    var result = json['result'];
    var data = result['데이터부'][0]; // 첫 번째 데이터부 값을 가져옴

    return Balance(
      customerName: result['고객명'],
      customerId: result['고객식별자'],
      accountNumber: data['계좌번호'],
      productName: data['상품명'],
      balance: data['잔액'],
    );
  }
}
