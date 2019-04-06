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
#include <MQLsyntax.mqh>
#include <Trade\AccountInfo.mqh>
CAccountInfo AccountInfo;

void OnStart()
{
  //---
  const long loginAccount = AccountInfo.Login();

  const ENUM_ACCOUNT_TRADE_MODE account_trade_mode = AccountInfo.TradeMode();

  const string trademodedescription = AccountInfo.TradeModeDescription();

  const long leverage = AccountInfo.Leverage();

  MqlTradeRequest request;

  HistoryDealGetDouble()

      Print(leverage);
}
//+------------------------------------------------------------------+
