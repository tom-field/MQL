//--- 指标设置 
#property indicator_separate_window 
#property indicator_buffers 4 
#property indicator_plots   2 
#property indicator_type1   DRAW_LINE 
#property indicator_type2   DRAW_LINE 
#property indicator_color1  clrLightSeaGreen 
#property indicator_color2  clrRed 
//--- 输入参量 
extern int KPeriod=5; 
extern int DPeriod=3; 
extern int Slowing=3; 
//--- 指标缓冲区 
double MainBuffer[]; 
double SignalBuffer[]; 
double HighesBuffer[]; 
double LowesBuffer[]; 
//+------------------------------------------------------------------+ 
//| 自定义指标初始化函数                                                | 
//+------------------------------------------------------------------+ 
void OnInit() 
  { 
//--- 指标缓冲区绘图 
   SetIndexBuffer(0,MainBuffer,INDICATOR_DATA); 
   SetIndexBuffer(1,SignalBuffer,INDICATOR_DATA); 
   SetIndexBuffer(2,HighesBuffer,INDICATOR_CALCULATIONS); 
   SetIndexBuffer(3,LowesBuffer,INDICATOR_CALCULATIONS); 
//--- 设置精确性 
   IndicatorSetInteger(INDICATOR_DIGITS,2); 
//--- 设置水平 
   IndicatorSetInteger(INDICATOR_LEVELS,2); 
   IndicatorSetDouble(INDICATOR_LEVELVALUE,0,20); 
   IndicatorSetDouble(INDICATOR_LEVELVALUE,1,80); 
//--- 为子窗口设置最大最小值  
   IndicatorSetDouble(INDICATOR_MINIMUM,0); 
   IndicatorSetDouble(INDICATOR_MAXIMUM,100); 
//--- 设置第一条画指数的柱 
   PlotIndexSetInteger(0,PLOT_DRAW_BEGIN,KPeriod+Slowing-2); 
   PlotIndexSetInteger(1,PLOT_DRAW_BEGIN,KPeriod+Slowing+DPeriod); 
//--- 为第二行设置STYLE_DOT类型 
   PlotIndexSetInteger(1,PLOT_LINE_STYLE,STYLE_DOT); 
//--- 为DataWindow和指标子窗口标签命名 
   IndicatorSetString(INDICATOR_SHORTNAME,"Stoch("+KPeriod+","+DPeriod+","+Slowing+")"); 
   PlotIndexSetString(0,PLOT_LABEL,"Main"); 
   PlotIndexSetString(1,PLOT_LABEL,"Signal"); 
//--- 设置画线空值 
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0.0); 
   PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,0.0); 
//--- 完成初始化 
  }
void onCalculate()
{

}  
  