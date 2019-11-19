//+------------------------------------------------------------------+
//|                                        CMoneyFixedMarginTest.mq5 |
//|                                                        tom-field |
//|                                          https://www.coderbb.com |
//+------------------------------------------------------------------+
#property copyright "tom-field"
#property link      "https://www.coderbb.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\AccountInfo.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Expert\Money\MoneyFixedMargin.mqh>
#include <Trade\Trade.mqh>
CAccountInfo m_account;
CSymbolInfo m_symbol;
CMoneyFixedMargin m_money;
CTrade m_trade;
//--- input parameters
ushort            InpStopLoss       = 50;       // Stop Loss, in pips (1.00045-1.00055=1 pips)
ushort            InpTakeProfit     = 140;      // Take Profit, in pips (1.00045-1.00055=1 pips)
ulong m_magic = 123456;    // magic number
//---
ulong  m_slippage=10;                        // slippage
double ExtStopLoss      = 0.0;               // Stop Loss -> double
double ExtTakeProfit    = 0.0;               // Take Profit -> doublr
double m_adjusted_point;                     // point value adjusted for 3 or 5 points
int OnInit()
  {
//---
//---
   if(!m_symbol.Name(_Symbol))  // sets symbol name
      return (INIT_FAILED);
//不RefreshRates() 还拿不到价格
   m_symbol.RefreshRates();
//---
   m_trade.SetExpertMagicNumber(m_magic);
   m_trade.SetMarginMode();
   m_trade.SetTypeFillingBySymbol(m_symbol.Name());
   m_trade.SetDeviationInPoints(m_slippage);
//--- tuning for 3 or 5 digits
   int digits_adjust = 1;
   if(m_symbol.Digits() == 3 || m_symbol.Digits() == 5)
      digits_adjust = 10;
   m_adjusted_point = m_symbol.Point() * digits_adjust;

   ExtStopLoss       = InpStopLoss        * m_adjusted_point;
//---
//--- 配置m_money
   m_money.Init(GetPointer(m_symbol), PERIOD_H4, _Digits);
   Print("设置风险百分比: 底层调用CAccountInfo的MaxLotCheck计算各种条件下最大购买的手数");
   m_money.Percent(50.0);
   Print("验证设置:", m_money.ValidationSettings());
////--- test start
//   double long_lot = m_money.CheckOpenLong(m_symbol.Ask(), 0);
//   Print("按设置的百分比下单量:", DoubleToString(long_lot, 2));
//   m_trade.Buy(long_lot, _Symbol, 0.0, 0.0, 0.0, "买入的交易量占用保证金比率");
//
//   double short_lot = m_money.CheckOpenLong(m_symbol.Bid(), 0);
//   Print("按设置的百分比下单量:", DoubleToString(long_lot, 2));
//   m_trade.Sell(short_lot, _Symbol, 0.0, 0.0, 0.0, "卖出的交易量占用保证金比率");
//---
//--- 取得建立买入仓位的手数大小 (CMoneyFixedMargin)
   double sl=0.0;
   double check_open_long_lot=0.0;
//--- 变数 #1: StopLoss=0.0
   sl=0.0;
   check_open_long_lot=m_money.CheckOpenLong(m_symbol.Ask(),sl);
   Print("sl=0.0",
         ", CheckOpenLong: ",DoubleToString(check_open_long_lot,2),
         ", 余额: ",    DoubleToString(m_account.Balance(),2),
         ", 净值: ",     DoubleToString(m_account.Equity(),2),
         ", 可用保证金: ", DoubleToString(m_account.FreeMargin(),2));
//--- 变数 #2: StopLoss!=0.0
   sl=m_symbol.Bid()-ExtStopLoss;
   check_open_long_lot=m_money.CheckOpenLong(m_symbol.Ask(),sl);
   Print("sl=",DoubleToString(sl,m_symbol.Digits()),
         ", CheckOpenLong: ",DoubleToString(check_open_long_lot,2),
         ", 余额: ",    DoubleToString(m_account.Balance(),2),
         ", 净值: ",     DoubleToString(m_account.Equity(),2),
         ", 可用保证金: ", DoubleToString(m_account.FreeMargin(),2));
   if(check_open_long_lot==0.0)
      Print("计算开单仓位失败");
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

  }
//+------------------------------------------------------------------+
