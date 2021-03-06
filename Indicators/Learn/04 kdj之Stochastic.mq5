//+------------------------------------------------------------------+ 
//|                                             Demo_iStochastic.mq5 | 
//|                        Copyright 2011, MetaQuotes Software Corp. | 
//|                                             https://www.mql5.com | 
//+------------------------------------------------------------------+ 
#property copyright "Copyright 2011, MetaQuotes Software Corp." 
#property link      "https://www.mql5.com" 
#property version   "1.00" 
#property description "The indicator demonstrates how to obtain data" 
#property description "of indicator buffers for the iStochastic technical indicator." 
#property description "A symbol and timeframe used for calculation of the indicator," 
#property description "are set by the symbol and period parameters." 
#property description "The method of creation of the handle is set through the 'type' parameter (function type)." 
#property description "All the other parameters are similar to the standard Stochastic Oscillator." 
  
#property indicator_separate_window 
#property indicator_buffers 2 
#property indicator_plots   2 
//--- 随机标图 
#property indicator_label1  "Stochastic" 
#property indicator_type1   DRAW_LINE 
#property indicator_color1  clrLightSeaGreen 
#property indicator_style1  STYLE_SOLID 
#property indicator_width1  1 
//--- 信号标图 
#property indicator_label2  "Signal" 
#property indicator_type2   DRAW_LINE 
#property indicator_color2  clrRed 
#property indicator_style2  STYLE_SOLID 
#property indicator_width2  1 
//--- 设置指标值的限制 
#property indicator_minimum 0 
#property indicator_maximum 100 
//--- 指标窗口的横向水平 
#property indicator_level1  -100.0 
#property indicator_level2  100.0 
//+------------------------------------------------------------------+ 
//| 枚举处理创建方法                                                   | 
//+------------------------------------------------------------------+ 
enum Creation 
  { 
   Call_iStochastic,       // 使用iStochastic 
   Call_IndicatorCreate    // 使用IndicatorCreate 
  }; 
//--- 输入参数 
input Creation             type=Call_iStochastic;     // 函数类型 
input int                  Kperiod=5;                 // K 线周期 (用于计算的柱数) 
input int                  Dperiod=3;                 // D 线周期(主要平滑周期) 
input int                  slowing=3;                 // 最后平滑周期       
input ENUM_MA_METHOD       ma_method=MODE_SMA;        // 平滑类型  
input ENUM_STO_PRICE       price_field=STO_LOWHIGH;   // 随机计算方法 
input string               symbol=" ";                // 交易品种  
input ENUM_TIMEFRAMES      period=PERIOD_CURRENT;     // 时间帧 
//--- 指标缓冲区 
double         StochasticBuffer[]; 
double         SignalBuffer[]; 
//--- 存储iStochastic指标处理程序的变量 
int    handle; 
//--- 存储变量 
string name=symbol; 
//--- 图表上的指标名称 
string short_name; 
//--- 我们将在随机震荡指标中保持值的数量 
int    bars_calculated=0; 
//+------------------------------------------------------------------+ 
//| 自定义指标初始化函数                                                | 
//+------------------------------------------------------------------+ 
int OnInit() 
  { 
//--- 分配指标缓冲区数组 
   SetIndexBuffer(0,StochasticBuffer,INDICATOR_DATA); 
   SetIndexBuffer(1,SignalBuffer,INDICATOR_DATA); 
//--- 定义绘制指标的交易品种 
   name=symbol; 
//--- 删除向左和向右的空格 
   StringTrimRight(name); 
   StringTrimLeft(name); 
//--- 如果它返回 'name' 字符串的零长度 
   if(StringLen(name)==0) 
     { 
      //--- 获得指标附属的图表交易品种 
      name=_Symbol; 
     } 
//--- 创建指标处理程序 
   if(type==Call_iStochastic) 
      handle=iStochastic(name,period,Kperiod,Dperiod,slowing,ma_method,price_field); 
   else 
     { 
      //--- 以指标参数填充结构    
      MqlParam pars[5]; 
      //--- 用于计算的K线周期 
      pars[0].type=TYPE_INT; 
      pars[0].integer_value=Kperiod; 
      //--- 用于主要平滑的D线周期 
      pars[1].type=TYPE_INT; 
      pars[1].integer_value=Dperiod; 
      //--- 最后平滑的K线周期 
      pars[2].type=TYPE_INT; 
      pars[2].integer_value=slowing; 
      //--- 平滑类型 
      pars[3].type=TYPE_INT; 
      pars[3].integer_value=ma_method; 
      //--- 随机计算方法 
      pars[4].type=TYPE_INT; 
      pars[4].integer_value=price_field; 
      handle=IndicatorCreate(name,period,IND_STOCHASTIC,5,pars); 
     } 
//--- 如果没有创建处理程序 
   if(handle==INVALID_HANDLE) 
     { 
      //--- 叙述失败和输出错误代码 
      PrintFormat("Failed to create handle of the iStochastic indicator for the symbol %s/%s, error code %d", 
                  name, 
                  EnumToString(period), 
                  GetLastError()); 
      //--- 指标提前停止 
      return(INIT_FAILED); 
     } 
//--- 显示随机震荡指标计算的交易品种/时间帧 
   short_name=StringFormat("iStochastic(%s/%s, %d, %d, %d, %s, %s)",name,EnumToString(period), 
                           Kperiod,Dperiod,slowing,EnumToString(ma_method),EnumToString(price_field)); 
   IndicatorSetString(INDICATOR_SHORTNAME,short_name); 
//--- 指标正常初始化 
   return(INIT_SUCCEEDED); 
  } 
//+------------------------------------------------------------------+ 
//| 自定义指标迭代函数                                                 | 
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
//--- 从iStochastic指标复制的值数 
   int values_to_copy; 
//--- 确定指标计算的数量值 
   int calculated=BarsCalculated(handle); 
   if(calculated<=0) 
     { 
      PrintFormat("BarsCalculated() returned %d, error code %d",calculated,GetLastError()); 
      return(0); 
     } 
//--- 如果它是指标计算的最初起点或如果iStochastic指标数量值更改 
//---或如果需要计算两个或多个柱形的指标（这意味着价格历史中有些内容会发生变化） 
   if(prev_calculated==0 || calculated!=bars_calculated || rates_total>prev_calculated+1) 
     { 
      //--- 如果StochasticBuffer数组大于交易品种/周期iStochastic 指标的数量值，那么我们不会复制任何内容 
      //--- 否则，我们复制小于指标缓冲区的大小 
      if(calculated>rates_total) values_to_copy=rates_total; 
      else                       values_to_copy=calculated; 
     } 
   else 
     { 
      //--- 它意味着这不是初次指标计算，因为 OnCalculate())最近调用 
      //--- 为了计算，添加不超过一柱 
      values_to_copy=(rates_total-prev_calculated)+1; 
     } 
//--- 以iStochastic 指标的值填充数组 
//--- 如果FillArraysFromBuffer返回false，它表示信息还未准备，退出操作 
   if(!FillArraysFromBuffers(StochasticBuffer,SignalBuffer,handle,values_to_copy)) return(0); 
//--- 形成信息 
   string comm=StringFormat("%s ==>  Updated value in the indicator %s: %d", 
                            TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS), 
                            short_name, 
                            values_to_copy); 
//--- 在图表上展示服务信息 
   Comment(comm); 
//--- 记住随机震荡指标的数量值 
   bars_calculated=calculated; 
//--- 返回prev_calculated值以便下次调用 
   return(rates_total); 
  } 
//+------------------------------------------------------------------+ 
//| 填充iStochastic指标的指标缓冲区                                     | 
//+------------------------------------------------------------------+ 
bool FillArraysFromBuffers(double &main_buffer[],    // 随机震荡值的指标缓冲区 
                           double &signal_buffer[],  // 信号线的指标缓冲区 
                           int ind_handle,           // iStochastic 指标的处理程序 
                           int amount                // 复制值的数量 
                           ) 
  { 
//--- 重置错误代码 
   ResetLastError(); 
//--- 以0标引指标缓冲区的值填充部分StochasticBuffer数组 
   if(CopyBuffer(ind_handle,MAIN_LINE,0,amount,main_buffer)<0) 
     { 
      //--- 如果复制失败，显示错误代码 
      PrintFormat("Failed to copy data from the iStochastic indicator, error code %d",GetLastError()); 
      //--- 退出零结果 - 它表示被认为是不计算的指标 
      return(false); 
     } 
//--- 以1标引指标缓冲区的值填充部分SignalBuffer数组 
   if(CopyBuffer(ind_handle,SIGNAL_LINE,0,amount,signal_buffer)<0) 
     { 
      //--- 如果复制失败，显示错误代码 
      PrintFormat("Failed to copy data from the iStochastic indicator, error code %d",GetLastError()); 
      //--- 退出零结果 - 它表示被认为是不计算的指标 
      return(false); 
     } 
//--- 一切顺利 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| 指标去初始化函数                                                   | 
//+------------------------------------------------------------------+ 
void OnDeinit(const int reason) 
  { 
//--- 删除指标后清空图表 
   Comment(""); 
  }