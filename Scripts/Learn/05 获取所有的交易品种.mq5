//+------------------------------------------------------------------+
//|                                                 05 获取所有的交易品种.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
    //删除所有的交易货币对
    for(int i=0;i<SymbolsTotal(true);i++)
      {
       string symbolName = SymbolName(i,true);
       SymbolSelect(symbolName,false);
      }  
    //删除
    //string 合约品种 = SymbolName(15,true);
    //printf(合约品种);
  }
//+------------------------------------------------------------------+
