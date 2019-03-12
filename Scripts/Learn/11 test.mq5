//--- ORDER_MAGIC值
input long order_magic=55555;
//+------------------------------------------------------------------+
//| 启动函数的脚本程序                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- 确保账户是样本
   if(AccountInfoInteger(ACCOUNT_TRADE_MODE)==ACCOUNT_TRADE_MODE_REAL)
     {
      Alert("Script operation is not allowed on a live account!");
      return;
     }
//--- 下订单或者删除订单
   if(GetOrdersTotalByMagic(order_magic)==0)
     {
      //--- 无当前订单 - 下订单
      uint res=SendRandomPendingOrder(order_magic);
      Print("Return code of the trade server ",res);
     }
   else // 有订单 - 删除订单
     {
      DeleteAllOrdersByMagic(order_magic);
     }
//---
  }
//+------------------------------------------------------------------+
//| 接收当前带有指定的ORDER_MAGIC的订单号                                |
//+------------------------------------------------------------------+
int GetOrdersTotalByMagic(long const magic_number)
  {
   ulong order_ticket;
   int total=0;
//--- 检查通过所有挂单
   for(int i=0;i<OrdersTotal();i++)
      if((order_ticket=OrderGetTicket(i))>0)
         if(magic_number==OrderGetInteger(ORDER_MAGIC)) total++;
//---
   return(total);
  }
//+------------------------------------------------------------------+
//| 删除所有带有指定ORDER_MAGIC的挂单                                   |
//+------------------------------------------------------------------+
void DeleteAllOrdersByMagic(long const magic_number)
  {
   ulong order_ticket;
//--- 检查所有挂单
   for(int i=OrdersTotal()-1;i>=0;i--)
      if((order_ticket=OrderGetTicket(i))>0)
         //--- 带有恰当ORDER_MAGIC的订单
         if(magic_number==OrderGetInteger(ORDER_MAGIC))
           {
            MqlTradeResult result={0};
            MqlTradeRequest request={0};
            request.order=order_ticket;
            request.action=TRADE_ACTION_REMOVE;
            OrderSend(request,result);
            //--- 编写服务器回复到日志
            Print(__FUNCTION__,": ",result.comment," reply code ",result.retcode);
           }
//---
  }
//+------------------------------------------------------------------+
//| 随机设置挂单                                                       |
//+------------------------------------------------------------------+
uint SendRandomPendingOrder(long const magic_number)
  {
//--- 准备请求
   MqlTradeRequest request={0};
   request.action=TRADE_ACTION_PENDING;         // 设置挂单
   request.magic=magic_number;                  // ORDER_MAGIC
   request.symbol=_Symbol;                      // 交易品种
   request.volume=0.1;                          // 0.1为单位的交易量
   request.sl=0;                                // 没有指定止损价位
   request.tp=0;                                // 没有指定盈利价位
//--- 形成订单类型
   request.type=GetRandomType();                // 订单类型
//--- 形成挂单价格
   request.price=GetRandomPrice(request.type);  // 开盘价
//--- 发送交易请求
   MqlTradeResult result={0};
   OrderSend(request,result);
//--- 编写服务器回复到日志
   Print(__FUNCTION__,":",result.comment);
   if(result.retcode==10016) Print(result.bid,result.ask,result.price);
//--- 返回交易服务器回复的代码
   return result.retcode;
  }
//+------------------------------------------------------------------+
//| 返回随机挂单类型                                                   |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE GetRandomType()
  {
   int t=MathRand()%4;
//---   0<=t<4
   switch(t)
     {
      case(0):return(ORDER_TYPE_BUY_LIMIT);
      case(1):return(ORDER_TYPE_SELL_LIMIT);
      case(2):return(ORDER_TYPE_BUY_STOP);
      case(3):return(ORDER_TYPE_SELL_STOP);
     }
//--- 不正确值
   return(WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| 返回随机价格                                                       |
//+------------------------------------------------------------------+
double GetRandomPrice(ENUM_ORDER_TYPE type)
  {
   int t=(int)type;
//--- 交易品种止损水平
   int distance=(int)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL);
//--- 接收上一个订单号数据
   MqlTick last_tick={0};
   SymbolInfoTick(_Symbol,last_tick);
//--- 按照类型计算价格
   double price;
   if(t==2 || t==5) // ORDER_TYPE_BUY_LIMIT or ORDER_TYPE_SELL_STOP
     {
      price=last_tick.bid; // 不同于卖价
      price=price-(distance+(MathRand()%10)*5)*_Point;
     }
   else             // ORDER_TYPE_SELL_LIMIT or ORDER_TYPE_BUY_STOP
     {
      price=last_tick.ask; // 不同于买价
      price=price+(distance+(MathRand()%10)*5)*_Point;
     }
//---
   return(price);
  }