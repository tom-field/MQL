#define EXPERT_MAGIC 123456  // EA交易的幻数
//+------------------------------------------------------------------+
//| 关闭所有反向持仓                                                   |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- 声明并初始化交易请求和交易请求结果
   MqlTradeRequest request;
   MqlTradeResult  result;
   int total=PositionsTotal(); // 持仓数   
//--- 重做所有持仓
   for(int i=total-1; i>=0; i--)
     {
      //--- 订单的参数
      int  position_ticket=PositionGetTicket(i);                                    // 持仓编号
      string position_symbol=PositionGetString(POSITION_SYMBOL);                      // 交易品种 
      int    digits=(int)SymbolInfoInteger(position_symbol,SYMBOL_DIGITS);            // 持仓价格
      int  magic=PositionGetInteger(POSITION_MAGIC);                                // 持仓的幻数
      double volume=PositionGetDouble(POSITION_VOLUME);                               // 持仓交易量
      double sl=PositionGetDouble(POSITION_SL);                                       // 持仓的止损
      double tp=PositionGetDouble(POSITION_TP);                                       // 持仓的止赢
      ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);  // 持仓类型
      //--- 输出持仓信息
      PrintFormat("#%d %s  %s  %.2f  %s  sl: %s  tp: %s  [%d]",
                  position_ticket,
                  position_symbol,
                  EnumToString(type),
                  volume,
                  DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN),digits),
                  DoubleToString(sl,digits),
                  DoubleToString(tp,digits),
                  magic);
      //--- 如果幻数匹配
      //if(magic==EXPERT_MAGIC)
        //{
         for(int j=0; j<i; j++)
           {
            string symbol=PositionGetSymbol(j); // 反向持仓交易品种
            //--- 如果反向持仓交易品种和初始交易品种匹配
            if(symbol==position_symbol)
              {
               //--- 设置反向持仓类型
               ENUM_POSITION_TYPE type_by=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
               //--- 离开，如果初始持仓和反向持仓类型匹配
               if(type==type_by)
                  continue;
               //--- 归零请求和结果值
               ZeroMemory(request);
               ZeroMemory(result);
               //--- 设置操作参数
               request.action=TRADE_ACTION_CLOSE_BY;                         // 交易操作类型
               request.position=position_ticket;                             // 持仓编号
               request.position_by=PositionGetInteger(POSITION_TICKET);      // 反向持仓价格
               //request.symbol     =position_symbol;
               request.magic=EXPERT_MAGIC;                                   // 持仓的幻数
               //--- 输出反向持仓平仓的信息
               PrintFormat("Close #%I64d %s %s by #%I64d",position_ticket,position_symbol,EnumToString(type),request.position_by);
               //--- 发送请求
               if(!OrderSend(request,result))
                  PrintFormat("OrderSend error %d",GetLastError()); // 如果不能发送请求，输出错误代码
 
               //--- 操作信息   
               PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
              }
           }
        //}
     }
  }
//+------------------------------------------------------------------+