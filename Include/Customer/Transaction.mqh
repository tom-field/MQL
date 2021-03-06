//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2012, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
class Transaction
  {
private:
protected:
public:

                     Transaction();
   void              SayHi(void);
   bool              BuyOne(const string symbol,const double volume,const double stopLoss,const double takeProfit,const ulong divition,const ulong magic);
   bool              SellOne(const string symbol,const double volume,const double stopLoss,const double takeProfit,const ulong divition,const ulong magic);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Transaction::Transaction()
  {
   printf(__FUNCTION__);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Transaction::SayHi(void)
  {
   printf(__FUNCTION__);
  };
//+------------------------------------------------------------------+
//|现价买                                                                  |
//+------------------------------------------------------------------+
bool Transaction::BuyOne(const string symbol,const double volume,const double stopLoss,const double takeProfit,const ulong divition,const ulong magic)
  {
   MqlTradeRequest request={0};
   MqlTradeResult result={0};
   MqlTick last_tick;

   if(SymbolInfoTick(symbol,last_tick))
     {
      request.action=TRADE_ACTION_DEAL;                                 // immediate order execution
      request.price=NormalizeDouble(last_tick.ask,_Digits);          // latest ask price
      request.sl=stopLoss; // Stop Loss
      request.tp=takeProfit; // Take Profit
      request.symbol=symbol;                                           // currency pair
      request.volume=volume;                                              // number of lots to trade
      request.magic=magic;                                             // Order Magic Number
      request.type=ORDER_TYPE_BUY;                                      // Buy Order 
      request.type_filling=ORDER_FILLING_IOC;
      request.deviation=divition;                                            // 注意点不写type_filling成交不了单子            

      //--- 发送请求
      if(!OrderSend(request,result))
        {
         PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
         return false;
        }

      //--- 操作信息
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
      printf(__FUNCTION__);
      return true;
     }
   else
     {
      return false;
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|现价卖                                                                  |
//+------------------------------------------------------------------+
bool Transaction::SellOne(const string symbol,const double volume,const double stopLoss,const double takeProfit,const ulong divition,const ulong magic)
  {
   MqlTradeRequest request={0};
   MqlTradeResult result={0};
   MqlTick last_tick;

   if(SymbolInfoTick(symbol,last_tick))
     {
      request.action=TRADE_ACTION_DEAL;                                 // immediate order execution
      request.price=NormalizeDouble(last_tick.ask,_Digits);          // latest ask price
      request.sl=stopLoss; // Stop Loss
      request.tp=takeProfit; // Take Profit
      request.symbol=symbol;                                           // currency pair
      request.volume=volume;                                              // number of lots to trade
      request.magic=magic;                                             // Order Magic Number
      request.type=ORDER_TYPE_BUY;                                      // Buy Order 
      request.type_filling=ORDER_FILLING_IOC;
      request.deviation=divition;                                            // 注意点不写type_filling成交不了单子            

      //--- 发送请求
      if(!OrderSend(request,result))
        {
         PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
         return false;
        }

      //--- 操作信息
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
      printf(__FUNCTION__);
      return true;
     }
   else
     {
      return false;
     }
  }
//+------------------------------------------------------------------+