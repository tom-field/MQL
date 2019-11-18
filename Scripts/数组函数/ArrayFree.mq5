//+------------------------------------------------------------------+
//|                                                    ArrayFree.mq5 |
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
   //---释放动态数组
   int size;
   double test[];
   ArrayResize(test,10000);
   size = ArraySize(test);
   printf(size);
   ArrayFree(test);
   size = ArraySize(test);
   printf(size);
  }
//+------------------------------------------------------------------+
