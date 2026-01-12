class CashWithdrawRule {
  /// 提现规则
  final String? ruleText;
  final String? ruleProxyText;

  /// 提现规则
  final String? ruleCoinsText;
  final num? incomeMoney;
  final String? withdrawAmount;
  final double? eventRate;
  final String? eventMoney;
  final double? incomeRate;
  final double? proxyRate;
  final String? proxyMoney;
  final String? scaleTip;
  final List<OrderModel>? orderList;

  CashWithdrawRule({
    this.ruleText,
    this.ruleProxyText,
    this.ruleCoinsText,
    this.incomeMoney,
    this.eventMoney,
    this.withdrawAmount,
    this.eventRate,
    this.incomeRate,
    this.proxyRate,
    this.proxyMoney,
    this.scaleTip,
    this.orderList,
  });

  factory CashWithdrawRule.fromJson(Map<String, dynamic> json) {
    return CashWithdrawRule(
        ruleText: json['rule_text'],
        eventRate: json['event_rate'],
        eventMoney: json['event_money'],
        ruleProxyText: json['rule_proxy_text'],
        ruleCoinsText: json['rule_coins_text'],
        incomeMoney: json['income_money'],
        withdrawAmount: json['withdraw_amount'],
        incomeRate: json['income_rate'],
        proxyRate: json['proxy_rate'],
        proxyMoney: json['proxy_money'],
        scaleTip: json['scale_tip'],
        orderList: List<OrderModel>.from(json['order']?.map((x) => OrderModel.fromJson(x)) ?? []),
    );
  }
}

class OrderModel {
  String name;
  String avatar;
  String tip;
  int price;

  OrderModel({
    this.name = '',
    this.avatar = '',
    this.tip = '',
    this.price = 0,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      tip: json['tip'] ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'avatar': avatar,
      'tip': tip,
      'price': price,
    };
  }
}
