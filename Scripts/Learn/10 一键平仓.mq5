//+------------------------------------------------------------------+
//|                                                      10 一键平仓.mq5 |
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
   int total = PositionsTotal();
   for(int i = total - 1; i >= 0; i--)
     {
      if(PositionGetTicket(i) > 0 )
      {
         
      }
     }
  }
//+------------------------------------------------------------------+
