//--- 用于处理颜色的宏 
#define XRGB(r,g,b)    (0xFF000000|(uchar(r)<<16)|(uchar(g)<<8)|uchar(b)) 
#define GETRGB(clr)    ((clr)&0xFFFFFF) 
//+------------------------------------------------------------------+ 
//| 脚本程序起始函数                                                   | 
//+------------------------------------------------------------------+ 
int time = 100000;
void OnStart() 
  { 
//--- 设置一个下行的蜡烛图颜色 
   Comment("Set a downward candle color");  
   ChartSetInteger(0,CHART_MODE,CHART_LINE);
   ChartRedraw(); // 无需等候新报价，立即更新图表 
   Sleep(time);   // 暂停1秒，查看所有的变化
////--- 设置一个上行的蜡烛图颜色
//   Comment("Set an upward candle color");
//   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,GetRandomColor());
//   ChartRedraw();
//   Sleep(time);    
////--- 设置背景颜色
//   Comment("Set the background color");
//   ChartSetInteger(0,CHART_COLOR_BACKGROUND,GetRandomColor());
//   ChartRedraw();
//   Sleep(time);
////--- 设置买价线的颜色
//   Comment("Set color of Ask line");
//   ChartSetInteger(0,CHART_COLOR_ASK,GetRandomColor());
//   ChartRedraw();
//   Sleep(time);
////--- 设置卖价线的颜色
//   Comment("Set color of Bid line");
//   ChartSetInteger(0,CHART_COLOR_BID,GetRandomColor());
//   ChartRedraw();
//   Sleep(time);
////--- 设置下行柱形图和下行蜡烛图框架的颜色
//   Comment("Set color of a downward bar and a downward candle frame");
//   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,GetRandomColor());
//   ChartRedraw();
//   Sleep(time);
////--- 设置图表线和Doji蜡烛图的颜色
//   Comment("Set color of a chart line and Doji candlesticks");
//   ChartSetInteger(0,CHART_COLOR_CHART_LINE,GetRandomColor());
//   ChartRedraw();
//   Sleep(time);
////--- 设置上行柱形图和上行蜡烛图框架的颜色
//   Comment("Set color of an upward bar and an upward candle frame");
//   ChartSetInteger(0,CHART_COLOR_CHART_UP,GetRandomColor());
//   ChartRedraw();
//   Sleep(time);
////--- 设置坐标轴、比例和OHLC线的颜色
//   Comment("Set color of axes, scale and OHLC line");
//   ChartSetInteger(0,CHART_COLOR_FOREGROUND,GetRandomColor());
//   ChartRedraw();
//   Sleep(time);
////--- 设置一个网格颜色
//   Comment("Set a grid color");
//   ChartSetInteger(0,CHART_COLOR_GRID,GetRandomColor());
//   ChartRedraw();
//   Sleep(time);
////--- 设置最后价格线
//   Comment("Set Last price color");
//   ChartSetInteger(0,CHART_COLOR_LAST,GetRandomColor());
//   ChartRedraw();
//   Sleep(time);
////--- 设置止损和获利水平的颜色
//   Comment("Set color of Stop Loss and Take Profit order levels");
//   ChartSetInteger(0,CHART_COLOR_STOP_LEVEL,GetRandomColor());
//   ChartRedraw();
//   Sleep(time);
////--- 设置交易量的颜色和市场进入水平
//   Comment("Set color of volumes and market entry levels");
//   ChartSetInteger(0,CHART_COLOR_VOLUME,GetRandomColor());
//   ChartRedraw();
  } 
//+------------------------------------------------------------------+ 
//| 返回一个随机生成的颜色                                              | 
//+------------------------------------------------------------------+ 
color GetRandomColor() 
  { 
   color clr=(color)GETRGB(XRGB(rand()%255,rand()%255,rand()%255)); 
   return clr; 
  }