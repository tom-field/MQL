//+------------------------------------------------------------------+
//|                                                04 kdj之调用内置方法.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_minimum 0
#property indicator_maximum 100
#property indicator_buffers 2
#property indicator_plots   2
//--- plot k线
#property indicator_label1  "k线"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot d线
#property indicator_label2  "d线"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrBlue
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- indicator buffers
double         k线Buffer[];
double         d线Buffer[];

int handle;

input int Kperiod = 5;
input int Dperiod = 3;
input int Slowing = 3;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,k线Buffer,INDICATOR_DATA);
   SetIndexBuffer(1,d线Buffer,INDICATOR_DATA);
   
   IndicatorSetString(INDICATOR_SHORTNAME,"调用iStoch方法");
   IndicatorSetString(INDICATOR_LEVELTEXT,"测试");
   IndicatorSetInteger(INDICATOR_LEVELS,2);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,0,20);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,1,80);
   handle = iStochastic(_Symbol,PERIOD_CURRENT,Kperiod,Dperiod,Slowing,MODE_SMA,STO_LOWHIGH);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   CopyBuffer(handle,0,0,rates_total,k线Buffer);
   CopyBuffer(handle,1,0,rates_total,d线Buffer);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
