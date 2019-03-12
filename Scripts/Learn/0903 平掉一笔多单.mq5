//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#define EXPERT_MAGIC 123456  // EA交易的幻数
//允许的价格偏差
int deviation=10;
//+------------------------------------------------------------------+
//| 关闭所有反向持仓                                                   |
//+------------------------------------------------------------------+
void OnStart()
  {
   int position_ticket=PositionGetTicket(0);
   string position_symbol=PositionGetString(POSITION_SYMBOL);                      // 持仓编号
   int    digits=(int)SymbolInfoInteger(position_symbol,SYMBOL_DIGITS);            // 持仓价格
   int  magic=PositionGetInteger(POSITION_MAGIC);                                  // 持仓的幻数
   double volume=PositionGetDouble(POSITION_VOLUME);                               // 持仓交易量
   double sl=PositionGetDouble(POSITION_SL);                                       // 持仓的止损
   double tp=PositionGetDouble(POSITION_TP);                                       // 持仓的止赢
   ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);  // 持仓类型

   MqlTradeRequest request={0};
   MqlTradeResult result={0};

//--- 设置操作参数
   request.action=TRADE_ACTION_DEAL;                                  // immediate order execution
   request.position=position_ticket;
   request.symbol=_Symbol;                                            // currency pair
   request.volume=volume;                                                 // number of lots to trade
   request.magic=magic;                                             // Order Magic Number
   request.deviation=deviation;
   request.type_filling=ORDER_FILLING_IOC;

//设置价格和订单类型
   request.type=ORDER_TYPE_SELL;
   request.price=SymbolInfoDouble(position_symbol,SYMBOL_BID);

//--- 发送请求
   if(!OrderSend(request,result))
      PrintFormat("OrderSend error %d",GetLastError());  // 如果不能发送请求，输出错误代码
//--- 操作信息   
   PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
//---

   DebugBreak();
  }
//+------------------------------------------------------------------+
