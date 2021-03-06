//+------------------------------------------------------------------+
//|                                                   1001 个性化图表.mq5 |
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
//--- 获得当前图表处理权 
   long handle=ChartID(); 
   if(handle>0) // 如果成功，加上自定义 
     { 
      //--- 禁止自动滚动 
      ChartSetInteger(handle,CHART_AUTOSCROLL,false); 
      //--- 设置图表右缩进 
      ChartSetInteger(handle,CHART_SHIFT,true); 
      //--- 显示蜡烛图 
      ChartSetInteger(handle,CHART_MODE,CHART_CANDLES); 
      //--- 从历史记录起始位置按100柱为一页滚动 
      ChartNavigate(handle,CHART_CURRENT_POS,100); 
      //--- 设置订单交易量显示模式 
      ChartSetInteger(handle,CHART_SHOW_VOLUMES,CHART_VOLUME_REAL); 
     }
  }
//+------------------------------------------------------------------+
