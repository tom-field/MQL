//+------------------------------------------------------------------+
//|                                                           01.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
#include <Trade\AccountInfo.mqh>
CAccountInfo AccountInfo;

void OnStart()
{
  //---
  const long loginAccount = AccountInfo.Login();
  printf("交易账号为:%d", loginAccount);

  ENUM_ACCOUNT_TRADE_MODE account_type = (ENUM_ACCOUNT_TRADE_MODE)AccountInfo.TradeMode();
  switch (account_type)
  {
  case ACCOUNT_TRADE_MODE_DEMO:
    printf("测试账号");
    break;
  case ACCOUNT_TRADE_MODE_CONTEST:
    printf("竞赛账号");
    break;
  default:
    printf("真实账号");
    break;
  }

  printf("AccountInfo.TradeModeDescription(): %s", AccountInfo.TradeModeDescription());

  printf("账户杠杆为AccountInfo.Leverage():%d", AccountInfo.Leverage());

  ENUM_ACCOUNT_STOPOUT_MODE stop_out_mode = (ENUM_ACCOUNT_STOPOUT_MODE)AccountInfo.StopoutMode();
  switch (stop_out_mode)
  {
  case ACCOUNT_STOPOUT_MODE_PERCENT:
    printf("账户爆仓模式百分比");
    break;
  case ACCOUNT_STOPOUT_MODE_MONEY:
    printf("账户爆仓模式货币");
  default:
    break;
  }

  printf("AccountInfo.TradeModeDescription(): %s", AccountInfo.StopoutModeDescription());

  ENUM_ACCOUNT_MARGIN_MODE account_margin_mode = AccountInfo.MarginMode();
  switch (account_margin_mode)
  {
  case ACCOUNT_MARGIN_MODE_RETAIL_NETTING:
    printf("零售网(一个交易品种只存在一个持仓):ACCOUNT_MARGIN_MODE_RETAIL_NETTING");
    break;
  case ACCOUNT_MARGIN_MODE_EXCHANGE:
    printf("保证金模式:ACCOUNT_MARGIN_MODE_EXCHANGE");
    break;
  case ACCOUNT_MARGIN_MODE_RETAIL_HEDGING:
    printf("零售对冲(一个交易品种可以存在多个持仓):ACCOUNT_MARGIN_MODE_RETAIL_HEDGING");
    break;
  default:
    break;
  }

  printf("Account.MarginModeDescription(): %s", AccountInfo.MarginModeDescription());

  printf("交易许可: %d", AccountInfo.TradeAllowed());

  // TODO 不论开关都是1
  printf("自动交易许可: %d", AccountInfo.TradeExpert());

  printf("最大挂单量: %d", AccountInfo.LimitOrders());

  printf("账户结余:%s", DoubleToString(AccountInfo.Balance(), 2));

  printf("账户给定的信用额度:%s", DoubleToString(AccountInfo.Credit(), 2));

  printf("账户盈利:%s", DoubleToString(AccountInfo.Profit(), 2));

  printf("账户净值:%s", DoubleToString(AccountInfo.Equity(), 2));

  printf("保证金(预付款):%s", DoubleToString(AccountInfo.Margin(), 2));

  printf("可用保证金(可用预付款):%s", DoubleToString(AccountInfo.FreeMargin(), 2));

  printf("保证金比率(预付款比率) 计算公式为:净值/保证金(预付款) :%s%%", DoubleToString(AccountInfo.MarginLevel(), 2));

  printf("入金的保证金比例:%s", DoubleToString(AccountInfo.MarginCall(), 2));

  printf("爆仓的保证金比例:%s", DoubleToString(AccountInfo.MarginStopOut(), 2));

  printf("客户名称:%s", AccountInfo.Name());

  printf("交易服务器名:%s", AccountInfo.Server());

  printf("货币名:%s", AccountInfo.Currency());

  printf("开户券商公司名称:%s", AccountInfo.Company());

  // 获取指定整数型属性的值
  Print("账户号 = ", AccountInfo.InfoInteger(ACCOUNT_LOGIN));
  Print("账户号 = ", AccountInfoInteger(ACCOUNT_LOGIN));

  // 获取指定双精度型属性的值
  Print("账户结余 = ", AccountInfo.InfoDouble(ACCOUNT_BALANCE));
  Print("账户结余 = ", AccountInfoDouble(ACCOUNT_BALANCE));

  // 获取指定双精度型属性的值
  Print("用户名 = ", AccountInfo.InfoString(ACCOUNT_NAME));
  Print("用户名 = ", AccountInfoString(ACCOUNT_NAME));

  double mayProfit = AccountInfo.OrderProfitCheck(_Symbol, ORDER_TYPE_BUY, 0.01, 1.03, 1.04);
  Print("根据开平仓价预估盈利: ", mayProfit);

  double needMargin = AccountInfo.MarginCheck(_Symbol, ORDER_TYPE_BUY, 0.01, 1.03);
  Print("执行交易操作所需的保证金额度: ", needMargin);

  double free_margin_check = AccountInfo.FreeMarginCheck(_Symbol,ORDER_TYPE_BUY,0.01,1.03);
  Print("执行交易操作之后剩余的可用保证金额度: ", free_margin_check);

  double max_lot_check = AccountInfo.MaxLotCheck(_Symbol,ORDER_TYPE_BUY,1.03,100);
  Print("交易操作的最大可能交易量: ", max_lot_check);
  
}
//+------------------------------------------------------------------+
