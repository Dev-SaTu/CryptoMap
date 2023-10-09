class Ticker {
  final String symbol;
  final String openingPrice;
  final String closingPrice;
  final String minPrice;
  final String maxPrice;
  final String unitsTraded;
  final String accTradeValue;
  final String prevClosingPrice;
  final String unitsTraded24H;
  final String accTradeValue24H;
  final String fluctate24H;
  final String fluctateRate24H;

  Ticker({
    required this.symbol,
    required this.openingPrice,
    required this.closingPrice,
    required this.minPrice,
    required this.maxPrice,
    required this.unitsTraded,
    required this.accTradeValue,
    required this.prevClosingPrice,
    required this.unitsTraded24H,
    required this.accTradeValue24H,
    required this.fluctate24H,
    required this.fluctateRate24H,
  });

  factory Ticker.fromJson(String symbol, Map<String, dynamic> json) {
    return Ticker(
      symbol: symbol,
      openingPrice: json['opening_price'],
      closingPrice: json['closing_price'],
      minPrice: json['min_price'],
      maxPrice: json['max_price'],
      unitsTraded: json['units_traded'],
      accTradeValue: json['acc_trade_value'],
      prevClosingPrice: json['prev_closing_price'],
      unitsTraded24H: json['units_traded_24H'],
      accTradeValue24H: json['acc_trade_value_24H'],
      fluctate24H: json['fluctate_24H'],
      fluctateRate24H: json['fluctate_rate_24H'],
    );
  }

  @override
  String toString() {
    return 'Ticker(symbol: $symbol, openingPrice: $openingPrice, closingPrice: $closingPrice, minPrice: $minPrice, maxPrice: $maxPrice, unitsTraded: $unitsTraded, accTradeValue: $accTradeValue, prevClosingPrice: $prevClosingPrice, unitsTraded24H: $unitsTraded24H, accTradeValue24H: $accTradeValue24H, fluctate24H: $fluctate24H, fluctateRate24H: $fluctateRate24H)';
  }
}
