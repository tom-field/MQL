//+------------------------------------------------------------------+
//|                                                      01 基础学习.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_minimum 1
#property indicator_maximum 10
#property indicator_buffers 3
#property indicator_plots   3
//--- plot Label1
#property indicator_label1  "Label1"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Label2
#property indicator_label2  "Label2"
#property indicator_type2   DRAW_HISTOGRAM
#property indicator_color2  clrTeal
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- plot Label3
#property indicator_label3  "Label3"
#property indicator_type3   DRAW_ARROW
#property indicator_color3  clrBlue
#property indicator_style3  STYLE_SOLID
#property indicator_width3  1
//--- indicator buffers
double         Label1Buffer[];
double         Label2Buffer[];
double         Label3Buffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,Label1Buffer,INDICATOR_DATA);
   SetIndexBuffer(1,Label2Buffer,INDICATOR_DATA);
   SetIndexBuffer(2,Label3Buffer,INDICATOR_DATA);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(2,PLOT_ARROW,159);

   ArraySetAsSeries(Label1Buffer,true);
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
   for(int i=0;i<rates_total;i++)
     {
      Label1Buffer[i]=0.1;
   
     }
   int a1=0;
   printf("rates_total:%d",rates_total);
   printf("prev_calculated:%d",prev_calculated);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
