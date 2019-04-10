//+------------------------------------------------------------------+
//|                                                 27 亏损加仓马丁格EA.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
CTrade Trade;

input double 开仓手数 = 0.01;
input double 加仓手数倍数 = 2; 
input int 止盈点 = 600;
input int 总加仓次数 = 5;
//--- 布林带参数
input int                  bands_period=20;           // 平均移动周期 
input int                  bands_shift=0;             // 移动 
const ulong                deviation=2.0;             //标准偏差数
//--- 存储 iBands 指标处理程序的变量 
int    handle; 
//--- 多单止盈价格
int 魔术号 = 123456;
double 多单止盈价格 = 0;
string 多单开单备注 = _Symbol + "_多_";
string 空单开单备注 = _Symbol + "_空_";

int OnInit()
  {
//---

   Trade.SetExpertMagicNumber(魔术号);
   Trade.SetMarginMode();
   Trade.SetTypeFillingBySymbol(Symbol());
   
   handle = iBands(_Symbol,PERIOD_CURRENT,bands_period,bands_shift,deviation,handle);
   
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
   OpenFirstBuy();
  }
//+------------------------------------------------------------------+
void OpenFirstBuy()
{
   MqlRates rates[3];
   CopyRates(_Symbol,PERIOD_CURRENT,0,4,rates);
   
   double 布林带中轨[3];
   double 布林带上轨[3];
   double 布林带下轨[3];
   CopyBuffer(handle,0,0,3,布林带中轨);
   CopyBuffer(handle,1,0,3,布林带上轨);
   CopyBuffer(handle,2,0,3,布林带下轨);
   
   if(NormalizeDouble(rates[1].close,_Digits) > 布林带下轨[1] && rates[2].open > 布林带下轨[2])
   {
      double 开盘价 = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID),_Digits);
      double 多单止盈价格 = 开盘价 - SymbolInfoDouble(_Symbol, SYMBOL_POINT) * 止盈点;
      
      //TODO优化
      bool 已经开过第一单 = false;
      //获取所有订单
      PositionSelect(_Symbol);
      for(int i = 0; i < PositionsTotal(); i++)
      {
         ulong ticket = PositionGetTicket(i);
         if(PositionGetString(POSITION_COMMENT) == 多单开单备注 + "1")
         {
            已经开过第一单 = true;
         }
      }
      if(!已经开过第一单)
      {
         Trade.Buy(开仓手数,_Symbol,开盘价,0,多单止盈价格,多单开单备注 + "1");
      }
   }
}