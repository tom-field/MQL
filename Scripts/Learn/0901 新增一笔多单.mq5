//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#define EXPERT_MAGIC 123456   // EA交易的幻数
//+------------------------------------------------------------------+
//| 打开买入持仓                                                       |
//+------------------------------------------------------------------+
void OnStart()
  {
   MqlTick latest_price;

   MqlTradeRequest request = {0};

   MqlTradeResult result = {0};

   SymbolInfoTick(_Symbol,latest_price);

   request.action=TRADE_ACTION_DEAL;                                  // immediate order execution

   request.price=NormalizeDouble(latest_price.ask,_Digits);           // latest ask price

   request.sl=0; // Stop Loss

   request.tp=0; // Take Profit

   request.symbol=_Symbol;                                            // currency pair

   request.volume=0.01;                                                 // number of lots to trade

   request.magic=123456;                                             // Order Magic Number

   request.type=ORDER_TYPE_BUY;                                        // Buy Order

   // 注意点不写type_filling成交不了单子
   request.type_filling=ORDER_FILLING_IOC;

   request.deviation=100;                                                // Deviation from current price

   //--- 发送请求
      if(!OrderSend(request,result))
         PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
   //--- 操作信息
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);

  }
//+------------------------------------------------------------------+
