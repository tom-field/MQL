//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
int OnInit()
  {
//+------------------------------------------------------------------+
//| 存储TICKS(时钟周期周期K线数据                     |
//+------------------------------------------------------------------+
   printf("========存Ticks==========");
   MqlTick a[];
//
   ArraySetAsSeries(a,true);
   CopyTicks(NULL,a,COPY_TICKS_ALL,0,5);
   for(int i=0; i<ArraySize(a);i++)
     {
      printf(DoubleToString(a[i].ask,Digits()));
     }
//存储图表K线交易数据
   printf("========存MqlRates==========");
   MqlRates b[];
   ArraySetAsSeries(b,true);
//TODO 感觉复制数据是从过去到现在,参考书上确实从现在到过去
   CopyRates(NULL,PERIOD_H1,0,5,b);
   for(int i=0; i<ArraySize(b);i++)
     {
      printf(DoubleToString(b[i].open));
     }
//存储指标缓冲区数据MA
   printf("========存指标缓冲区数据==========");
   double c[];
   ArraySetAsSeries(c,true);
   int ma_handle=iMA(Symbol(),PERIOD_H1,26,0,MODE_SMA,PRICE_CLOSE);
   printf("ma指标句柄为: s%",IntegerToString(ma_handle));
   CopyBuffer(ma_handle,0,0,10,c);
   for(int i=0; i<ArraySize(c);i++)
     {
      printf(DoubleToString(c[i]));
     }
// 当时间序列上的指标有多个数据时,比如ADX 三条线 buffer_num标志索引
   printf("========存指标缓冲区数据单个时间序列多个数据==========");
   double d1[];
   double d2[];
   double d3[];
   ArraySetAsSeries(d1,true);
   ArraySetAsSeries(d2,true);

   ArraySetAsSeries(d3,true);
   int adx_handle=iADX(Symbol(),PERIOD_H1,14);
   printf("adx指标句柄为: s%",IntegerToString(ma_handle));
   CopyBuffer(adx_handle,0,0,10,d1);
   CopyBuffer(adx_handle,1,0,10,d2);
   CopyBuffer(adx_handle,2,0,10,d3);
   printf("============d1===========");
   for(int i=0; i<ArraySize(d1);i++)
     {
      printf(DoubleToString(d1[i]));
     }
   printf("============d2===========");
   for(int i=0; i<ArraySize(d2);i++)
     {
      printf(DoubleToString(d2[i]));
     }
   printf("============d3===========");
   for(int i=0; i<ArraySize(d3);i++)
     {
      printf(DoubleToString(d3[i]));
     }
//--- 返回交易服务器回复的代码 
//+------------------------------------------------------------------+
//| 市价单操作 position 英语中有仓位的意思 1.循环获取 2直接获取                      |
//+------------------------------------------------------------------+
//1 获取持仓订单总数(不包括挂单)
   int pt=PositionsTotal();
   for(int i=0; i<pt; i++)
     {
      //获取订单号 int 返回 失败返回0
      if(PositionGetTicket(i)>0)
        {
         // 获取double类型的开仓价
         double 持仓开仓价=PositionGetDouble(POSITION_PRICE_OPEN);

        }

     }
//2. 直接获取
   if(PositionSelect(Symbol()))
     {
      double 持仓开仓价=PositionGetDouble(POSITION_PRICE_OPEN);
     }
//+------------------------------------------------------------------+
//| 获取挂单信息                      |
//+------------------------------------------------------------------+
   //int 挂单总数=OrdersTotal();
   //for(int i=0; i<挂单总数; i++)
   //  {
   //   if(OrderGetTicket(i)>0)
   //     {
   //         double 挂单价 = OrderGetDouble(ORDER_PRICE_OPEN);
   //         printf("挂单价为",DoubleToString(挂单价));
   //     }
   //  }
   //if(OrderSelect(Symbol())
   //{
   //   double guadanjia = OrderGetDouble(ORDER_PRICE_OPEN);
   //   printf("挂单价为",DoubleToString(guadanjia));
   //}
//+------------------------------------------------------------------+
//| 历史记录操作                      |
//+------------------------------------------------------------------+   
  int 历史订单数 = HistoryDealsTotal();
  printf(IntegerToString(历史订单数));
  for(int i=0;i<历史订单数;i++)
    {
     
    }

   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
//| Deinitialization function of the expert                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//| "Tick" event handler function                                    |
//+------------------------------------------------------------------+
void OnTick()

  {
// 
// 下单函数  
   MqlTradeRequest request={0};
   MqlTradeResult result={0};
   request.action=TRADE_ACTION_DEAL;            // 即时交易 
   request.symbol=Symbol();                      // 交易品种 
   request.price=SymbolInfoDouble(Symbol(),SYMBOL_ASK);  // 开盘价 
   request.volume=0.1;                          // 0.1为单位的交易量 
   request.sl=0;                                // 没有指定止损价位 
   request.tp=0;                                // 没有指定盈利价位 
   request.deviation=5;                         // 价格偏差
   request.magic=123456;
//--- 形成订单类型 
   request.type=ORDER_TYPE_BUY;                // 订单类型

   OrderSend(request,result);
   int ticket=result.deal;
  }
//+------------------------------------------------------------------+
//| "Trade" event handler function                                   |




//+------------------------------------------------------------------+

void OnTrade()

  {

  }
//+------------------------------------------------------------------+
//| "Timer" event handler function                                   |



//+------------------------------------------------------------------+
void OnTimer()
  {

  }
//+------------------------------------------------------------------+
