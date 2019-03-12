//+------------------------------------------------------------------+
//|                                                    03 struct.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
struct CustomMqlTick
     {
      double            open;
      double            close;
      double            high;
      double            low;
      datetime          time;
     };
int OnInit()
  {
//---
   CustomMqlTick ct1,ct2;
   ct1.open = 1;
   ct2.open = 2;
   printf(ct1.open);
//---
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
