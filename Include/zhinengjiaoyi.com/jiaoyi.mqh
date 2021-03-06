//智能交易网www.zhinengjiaoyi.com出品，关注微信公众号：智能交易"
class jiaoyi
{
public:
  ulong buy(string symbol,double lots,int slpoint,int tppoint,string com,int magic);
  ulong buyplus(string symbol,double lots,int slpoint,int tppoint,string com,int magic);
  ulong buygua(double guaprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0);
  ulong buyguaplus(double guaprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0);
  ulong buystoplimit(double stopprice,double limitprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0);
  ulong buystoplimitplus(double stopprice,double limitprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0);
  ulong sell(string symbol,double lots,int slpoint,int tppoint,string com,int magic);
  ulong sellplus(string symbol,double lots,int slpoint,int tppoint,string com,int magic);
  ulong sellgua(double guaprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0);
  ulong sellguaplus(double guaprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0);
  ulong sellstoplimit(double stopprice,double limitprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0);
  ulong sellstoplimitplus(double stopprice,double limitprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0);
  void closeallbuy(string symbol,int magic);
  void closeallsell(string symbol,int magic);
  void closeall(string symbol,int magic);
  void modifysltp(string symbol,ENUM_POSITION_TYPE type,double sl,double tp,int magic);//sl或tp设成0表示把止损或止盈改成0这个价位，设成-1表示不修改止损止盈
  void delorders(string symbol,int magic);
  void guamodify(string symbol,ENUM_ORDER_TYPE type,double guaprice,double limitprice,double sl,double tp,int magic);//sl或tp设成0表示把止损或止盈改成0这个价位，设成-1表示不修改止损止盈
  int danshu(string symbol,ENUM_POSITION_TYPE type,int magic);
  int danshuall(string symbol,int magic);
  double profit(string symbol,ENUM_POSITION_TYPE type,int magic);
  double profitall(string symbol,int magic);
  double formatlots(string symbol,double lots);
  double baifenbiLots(ENUM_ORDER_TYPE action,string symbol,int baifenbi);
  double profit0price(string symbol,ENUM_POSITION_TYPE type,int magic);
  long zuijindan(string symbol,ENUM_POSITION_TYPE type,double &openprice,datetime &opentime,double &openlots,double &opensl,double &opentp,int magic);
  void yidong(int yidongdian,string symbol,ENUM_POSITION_TYPE type,int magic);
  void getlasthistory(string symbol,int type,int magic,double &op,datetime &optime,double &lots);
};
void jiaoyi::getlasthistory(string symbol,int type,int magic,double &op,datetime &optime,double &lots)
  {
     HistorySelect(0,TimeCurrent());
     int dealstotal=HistoryDealsTotal();
     for(int i=dealstotal-1;i>=0;i--)
      {
        ulong dealticket=HistoryDealGetTicket(i);
        if(dealticket>0)
         {
           if(HistoryDealGetInteger(dealticket,DEAL_ENTRY)==DEAL_ENTRY_OUT && HistoryDealGetString(dealticket,DEAL_SYMBOL)==symbol && HistoryDealGetInteger(dealticket,DEAL_TYPE)==type)
            {
               if(magic==0)
                {
                  optime=(datetime)HistoryDealGetInteger(dealticket,DEAL_TIME);
                  lots=HistoryDealGetDouble(dealticket,DEAL_VOLUME);
                  op=HistoryDealGetDouble(dealticket,DEAL_PRICE);
                  break;
                }
               else
                {
                  if(HistoryDealGetInteger(dealticket,DEAL_MAGIC)==magic)
                   {
                     optime=(datetime)HistoryDealGetInteger(dealticket,DEAL_TIME);
                     lots=HistoryDealGetDouble(dealticket,DEAL_VOLUME);
                     op=HistoryDealGetDouble(dealticket,DEAL_PRICE);
                     break;
                   }
                }
            }
         }
      }
  }
double jiaoyi::baifenbiLots(ENUM_ORDER_TYPE action,string symbol,int baifenbi)
 {
   double margin1=0;
   bool a1=OrderCalcMargin(action,symbol,1,SymbolInfoDouble(symbol,SYMBOL_BID),margin1);
   double a2=baifenbi*0.01*AccountInfoDouble(ACCOUNT_EQUITY);
   double lots=formatlots(symbol,(1/margin1)*baifenbi*0.01*AccountInfoDouble(ACCOUNT_EQUITY));
   return(lots);
 }
long jiaoyi::zuijindan(string symbol,ENUM_POSITION_TYPE type,double &openprice,datetime &opentime,double &openlots,double &opensl,double &opentp,int magic=0)
 {    
      openprice=0;
      opentime=0;
      openlots=0;
      opensl=0;
      opentp=0;
      long ticket=0;
      int t=PositionsTotal();
      for(int i=t-1;i>=0;i--)
        {
          if(PositionGetTicket(i)>0)
           {
             if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_TYPE)==type)
              {
                if(magic==0)
                 {
                    openprice=PositionGetDouble(POSITION_PRICE_OPEN);
                    opentime=(datetime)PositionGetInteger(POSITION_TIME);
                    openlots=PositionGetDouble(POSITION_VOLUME);
                    opensl=PositionGetDouble(POSITION_SL);
                    opentp=PositionGetDouble(POSITION_TP);
                    ticket=PositionGetInteger(POSITION_TICKET);
                    break;
                 }
                else
                 {
                   if(PositionGetInteger(POSITION_MAGIC)==magic)
                    {
                       openprice=PositionGetDouble(POSITION_PRICE_OPEN);
                       opentime=(datetime)PositionGetInteger(POSITION_TIME);
                       openlots=PositionGetDouble(POSITION_VOLUME);
                       opensl=PositionGetDouble(POSITION_SL);
                       opentp=PositionGetDouble(POSITION_TP);
                       ticket=PositionGetInteger(POSITION_TICKET);
                       break;
                    }
                 }
              }
           }
        }
      return(ticket);
 }
double jiaoyi::formatlots(string symbol,double lots)
   {
     double a=0;
     double minilots=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
     double steplots=SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
     if(lots<minilots) return(0);
     else
      {
        double a1=MathFloor(lots/minilots)*minilots;
        a=a1+MathFloor((lots-a1)/steplots)*steplots;
      }
     return(a);
   }
int jiaoyi::danshu(string symbol,ENUM_POSITION_TYPE type,int magic=0)
   {
      int a=0;
      int t=PositionsTotal();
      for(int i=t-1;i>=0;i--)
        {
          if(PositionGetTicket(i)>0)
           {
             if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_TYPE)==type)
              {
                if(magic==0)
                 {
                   a++;
                 }
                else
                 {
                   if(PositionGetInteger(POSITION_MAGIC)==magic)
                    {
                      a++;
                    }
                 }
              }
           }
        }
     return(a);
   }
int jiaoyi::danshuall(string symbol,int magic=0)
   {
      int a=0;
      int t=PositionsTotal();
      for(int i=t-1;i>=0;i--)
        {
          if(PositionGetTicket(i)>0)
           {
             if(PositionGetString(POSITION_SYMBOL)==symbol && (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY || PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL))
              {
                if(magic==0)
                 {
                   a++;
                 }
                else
                 {
                   if(PositionGetInteger(POSITION_MAGIC)==magic)
                    {
                      a++;
                    }
                 }
              }
           }
        }
     return(a);
   }
double jiaoyi::profit(string symbol,ENUM_POSITION_TYPE type,int magic=0)
   {
      double a=0;
      int t=PositionsTotal();
      for(int i=t-1;i>=0;i--)
        {
          if(PositionGetTicket(i)>0)
           {
             if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_TYPE)==type)
              {
                if(magic==0)
                 {
                   a=a+PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP);
                 }
                else
                 {
                   if(PositionGetInteger(POSITION_MAGIC)==magic)
                    {
                      a=a+PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP);
                    }
                 }
              }
           }
        }
     return(a);
   }
double jiaoyi::profitall(string symbol,int magic=0)
   {
      double a=0;
      int t=PositionsTotal();
      for(int i=t-1;i>=0;i--)
        {
          if(PositionGetTicket(i)>0)
           {
             if(PositionGetString(POSITION_SYMBOL)==symbol && (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY || PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL))
              {
                if(magic==0)
                 {
                   a=a+PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP);
                 }
                else
                 {
                   if(PositionGetInteger(POSITION_MAGIC)==magic)
                    {
                      a=a+PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP);
                    }
                 }
              }
           }
        }
     return(a);
   }
ulong jiaoyi::buystoplimitplus(double stopprice,double limitprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0)
   {
      ulong a=0;
      int t=OrdersTotal();
      for(int i=t-1;i>=0;i--)
        {
          if(OrderGetTicket(i)>0)
           {
             if(OrderGetString(ORDER_SYMBOL)==symbol && (OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_STOP_LIMIT) && OrderGetInteger(ORDER_MAGIC)==magic && OrderGetString(ORDER_COMMENT)==com)
              {
                a=1;
                return(0);
              }
           }
        }
      if(a==0)
        {
          a=buystoplimit(stopprice,limitprice,symbol,lots,slpoint,tppoint,com,magic,expiration);
        }
      return(a);
   }
ulong jiaoyi::buyguaplus(double guaprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0)
   {
      ulong a=0;
      int t=OrdersTotal();
      for(int i=t-1;i>=0;i--)
        {
          if(OrderGetTicket(i)>0)
           {
             if(OrderGetString(ORDER_SYMBOL)==symbol && (OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_LIMIT || OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_BUY_STOP) && OrderGetInteger(ORDER_MAGIC)==magic && OrderGetString(ORDER_COMMENT)==com)
              {
                a=1;
                return(0);
              }
           }
        }
      if(a==0)
        {
          a=buygua(guaprice,symbol,lots,slpoint,tppoint,com,magic,expiration);
        }
      return(a);
   }
ulong jiaoyi::buyplus(string symbol,double lots,int slpoint,int tppoint,string com,int magic)
   {
      ulong a=0;
      int t=PositionsTotal();
      for(int i=t-1;i>=0;i--)
        {
          if(PositionGetTicket(i)>0)
           {
             if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY && PositionGetInteger(POSITION_MAGIC)==magic && PositionGetString(POSITION_COMMENT)==com)
              {
                a=1;
                return(0);
              }
           }
        }
      if(a==0)
        {
          a=buy(symbol,lots,slpoint,tppoint,com,magic);
        }
      return(a);
   }
ulong jiaoyi::buy(string symbol,double lots,int slpoint,int tppoint,string com,int magic)
   {
      MqlTradeRequest request={0};
      MqlTradeResult  result={0};
      request.action=TRADE_ACTION_DEAL;
      request.symbol=symbol;
      request.type=ORDER_TYPE_BUY;
      request.volume=lots;
      request.deviation=100;
      request.type_filling=ORDER_FILLING_IOC;
      request.price=SymbolInfoDouble(symbol,SYMBOL_ASK);
      if(slpoint>SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL))
       {
          request.sl=SymbolInfoDouble(symbol,SYMBOL_ASK)-slpoint*SymbolInfoDouble(symbol,SYMBOL_POINT);
       }
      if(tppoint>SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL))
       {
          request.tp=SymbolInfoDouble(symbol,SYMBOL_ASK)+tppoint*SymbolInfoDouble(symbol,SYMBOL_POINT);
       } 
      request.comment=com;
      request.magic=magic;
     //--- 发送请求
      if(!OrderSend(request,result))
            PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
      //--- 操作信息
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
      return(result.order);
   }
ulong jiaoyi::buystoplimit(double stopprice,double limitprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0)
   {
      stopprice=NormalizeDouble(stopprice,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
      limitprice=NormalizeDouble(limitprice,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
      MqlTradeRequest request={0};
      MqlTradeResult  result={0};
      request.action=TRADE_ACTION_PENDING;
      request.type=ORDER_TYPE_BUY_STOP_LIMIT;
      request.symbol=symbol;
      request.type_filling=ORDER_FILLING_IOC;
      double askp=SymbolInfoDouble(symbol,SYMBOL_ASK);
      
      if(stopprice<=askp)
       {
         Alert("stopprice必须大于市价");
         return(0);
       }
      if(limitprice>=stopprice)
       {
         Alert("limitprice必须小于stopprice");
         return(0);
       }
      request.volume=lots;
      request.deviation=100;
      request.price=stopprice;
      request.stoplimit=limitprice;
      if(slpoint>SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL))
       {
         request.sl=limitprice-slpoint*SymbolInfoDouble(symbol,SYMBOL_POINT);
       }
      if(tppoint>SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL))
       {
         request.tp=limitprice+tppoint*SymbolInfoDouble(symbol,SYMBOL_POINT);
       } 
      request.comment=com;
      request.magic=magic;
       if(expiration>0) 
       {
         request.type_time=ORDER_TIME_SPECIFIED;
         request.expiration=expiration;
       }
     //--- 发送请求
      if(!OrderSend(request,result))
            PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
      return(result.order);
   }
ulong jiaoyi::buygua(double guaprice, string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0)
   {
      guaprice=NormalizeDouble(guaprice,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
      MqlTradeRequest request={0};
      MqlTradeResult  result={0};
      request.action=TRADE_ACTION_PENDING;
      request.type_filling=ORDER_FILLING_IOC;
      request.symbol=symbol;
      double askp=SymbolInfoDouble(symbol,SYMBOL_ASK);
      if(guaprice>askp)
       {
         request.type=ORDER_TYPE_BUY_STOP;
       }
      if(guaprice<askp)
       {
         request.type=ORDER_TYPE_BUY_LIMIT;
       }
      request.volume=lots;
      request.deviation=100;
      request.price=guaprice;
      if(slpoint>SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL))
       {
         request.sl=guaprice-slpoint*SymbolInfoDouble(symbol,SYMBOL_POINT);
       }
      if(tppoint>SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL))
       {
         request.tp=guaprice+tppoint*SymbolInfoDouble(symbol,SYMBOL_POINT);
       } 
      request.comment=com;
      request.magic=magic;
      if(expiration>0) 
       {
         request.type_time=ORDER_TIME_SPECIFIED;
         request.expiration=expiration;
       }
     //--- 发送请求
      if(!OrderSend(request,result))
            PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
      return(result.order);
   }

ulong jiaoyi::sell(string symbol,double lots,int slpoint,int tppoint,string com,int magic)
   {
      MqlTradeRequest request={0};
      MqlTradeResult  result={0};
      request.action=TRADE_ACTION_DEAL;
      request.symbol=symbol;
      request.type=ORDER_TYPE_SELL;
      request.volume=lots;
      request.deviation=100;
      request.type_filling=ORDER_FILLING_IOC;
      request.price=SymbolInfoDouble(symbol,SYMBOL_BID);
      if(slpoint>SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL))
       {
         request.sl=SymbolInfoDouble(symbol,SYMBOL_BID)+slpoint*SymbolInfoDouble(symbol,SYMBOL_POINT);
       }
      if(tppoint>SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL))
       {
         request.tp=SymbolInfoDouble(symbol,SYMBOL_BID)-tppoint*SymbolInfoDouble(symbol,SYMBOL_POINT);
       } 
      request.comment=com;
      request.magic=magic;
     //--- 发送请求
      if(!OrderSend(request,result))
            PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
      //--- 操作信息
      PrintFormat("retcode=%u  deal=%I64u  order=%I64u",result.retcode,result.deal,result.order);
      return(result.order);
   }
ulong jiaoyi::sellstoplimitplus(double stopprice,double limitprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0)
   {
      ulong a=0;
      int t=OrdersTotal();
      for(int i=t-1;i>=0;i--)
        {
          if(OrderGetTicket(i)>0)
           {
             if(OrderGetString(ORDER_SYMBOL)==symbol && (OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_STOP_LIMIT) && OrderGetInteger(ORDER_MAGIC)==magic && OrderGetString(ORDER_COMMENT)==com)
              {
                a=1;
                return(0);
              }
           }
        }
      if(a==0)
        {
          a=sellstoplimit(stopprice,limitprice,symbol,lots,slpoint,tppoint,com,magic,expiration);
        }
      return(a);
   }
ulong jiaoyi::sellguaplus(double guaprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0)
   {
      ulong a=0;
      int t=OrdersTotal();
      for(int i=t-1;i>=0;i--)
        {
          if(OrderGetTicket(i)>0)
           {
             if(OrderGetString(ORDER_SYMBOL)==symbol && (OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_LIMIT || OrderGetInteger(ORDER_TYPE)==ORDER_TYPE_SELL_STOP) && OrderGetInteger(ORDER_MAGIC)==magic && OrderGetString(ORDER_COMMENT)==com)
              {
                a=1;
                return(0);
              }
           }
        }
      if(a==0)
        {
          a=sellgua(guaprice,symbol,lots,slpoint,tppoint,com,magic,expiration);
        }
      return(a);
   }
ulong jiaoyi::sellplus(string symbol,double lots,int slpoint,int tppoint,string com,int magic)
   {
      ulong a=0;
      int t=PositionsTotal();
      for(int i=t-1;i>=0;i--)
        {
          if(PositionGetTicket(i)>0)
           {
             if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL && PositionGetInteger(POSITION_MAGIC)==magic && PositionGetString(POSITION_COMMENT)==com)
              {
                a=1;
                return(0);
              }
           }
        }
      if(a==0)
        {
          a=sell(symbol,lots,slpoint,tppoint,com,magic);
        }
      return(a);
   }
ulong jiaoyi::sellstoplimit(double stopprice,double limitprice,string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0)
   {
      stopprice=NormalizeDouble(stopprice,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
      limitprice=NormalizeDouble(limitprice,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
      MqlTradeRequest request={0};
      MqlTradeResult  result={0};
      request.action=TRADE_ACTION_PENDING;
      request.type=ORDER_TYPE_SELL_STOP_LIMIT;
      request.symbol=symbol;
      request.type_filling=ORDER_FILLING_IOC;
      double bidp=SymbolInfoDouble(symbol,SYMBOL_BID);
      if(stopprice>=bidp)
       {
         Alert("stopprice必须小于市价");
         return(0);
       }
      if(limitprice<=stopprice)
       {
         Alert("limitprice必须大于stopprice");
         return(0);
       }
      request.volume=lots;
      request.deviation=100;
      request.price=stopprice;
      request.stoplimit=limitprice;
      if(slpoint>SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL))
       {
         request.sl=limitprice+slpoint*SymbolInfoDouble(symbol,SYMBOL_POINT);
       }
      if(tppoint>SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL))
       {
         request.tp=limitprice-tppoint*SymbolInfoDouble(symbol,SYMBOL_POINT);
       } 
      request.comment=com;
      request.magic=magic;
      if(expiration>0) 
       {
         request.type_time=ORDER_TIME_SPECIFIED;
         request.expiration=expiration;
       }
     //--- 发送请求
      if(!OrderSend(request,result))
            PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
      return(result.order);
   }
ulong jiaoyi::sellgua(double guaprice, string symbol,double lots,int slpoint,int tppoint,string com,int magic,datetime expiration=0)
   {
      guaprice=NormalizeDouble(guaprice,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
      MqlTradeRequest request={0};
      MqlTradeResult  result={0};
      request.action=TRADE_ACTION_PENDING;
      request.symbol=symbol;
      request.type_filling=ORDER_FILLING_IOC;
      double bidp=SymbolInfoDouble(symbol,SYMBOL_BID);
      if(guaprice<bidp)
       {
         request.type=ORDER_TYPE_SELL_STOP;
       }
      if(guaprice>bidp)
       {
         request.type=ORDER_TYPE_SELL_LIMIT;
       }
      request.volume=lots;
      request.deviation=100;
      request.price=guaprice;
      if(slpoint>SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL))
       {
         request.sl=guaprice+slpoint*SymbolInfoDouble(symbol,SYMBOL_POINT);
       }
      if(tppoint>SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL))
       {
         request.tp=guaprice-tppoint*SymbolInfoDouble(symbol,SYMBOL_POINT);
       } 
      request.comment=com;
      request.magic=magic;
      if(expiration>0) 
       {
         request.type_time=ORDER_TIME_SPECIFIED;
         request.expiration=expiration;
       }
     //--- 发送请求
      if(!OrderSend(request,result))
            PrintFormat("OrderSend error %d",GetLastError());     // 如果不能发送请求，输出错误代码
      return(result.order);
   }
void jiaoyi::closeallbuy(string symbol,int magic=0)
 {
   int t=PositionsTotal();
   for(int i=t-1;i>=0;i--)
     {
       if(PositionGetTicket(i)>0)
        {
          if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           {
              if(magic==0)
               {
                  MqlTradeRequest request={0};
                  MqlTradeResult  result={0};
                  request.action   =TRADE_ACTION_DEAL;                     // 交易操作类型
                  request.symbol   =symbol;                              // 交易品种
                  request.volume   =PositionGetDouble(POSITION_VOLUME); // 0.1手交易量 
                  request.type     =ORDER_TYPE_SELL;                        // 订单类型
                  request.price    =SymbolInfoDouble(symbol,SYMBOL_BID); // 持仓价格
                  request.type_filling=ORDER_FILLING_IOC;
                  request.deviation=100; // 允许价格偏差
                  request.position =PositionGetTicket(i);
                  if(!OrderSend(request,result))
                  PrintFormat("OrderSend error %d",GetLastError());   // 如果不能发送请求，输出错误
               }
              else
               {
                  if(PositionGetInteger(POSITION_MAGIC)==magic)
                  {
                     MqlTradeRequest request={0};
                     MqlTradeResult  result={0};
                     request.action   =TRADE_ACTION_DEAL;                     // 交易操作类型
                     request.symbol   =symbol;                              // 交易品种
                     request.volume   =PositionGetDouble(POSITION_VOLUME); // 0.1手交易量 
                     request.type     =ORDER_TYPE_SELL;                        // 订单类型
                     request.price    =SymbolInfoDouble(symbol,SYMBOL_BID); // 持仓价格
                     request.deviation=100; // 允许价格偏差
                     request.type_filling=ORDER_FILLING_IOC;
                     request.position =PositionGetTicket(i);
                     if(!OrderSend(request,result))
                     PrintFormat("OrderSend error %d",GetLastError());   // 如果不能发送请求，输出错误
                  }
               }
             
           }
        }
     }
 }
void jiaoyi::closeallsell(string symbol,int magic=0)
 {
   int t=PositionsTotal();
   for(int i=t-1;i>=0;i--)
     {
       if(PositionGetTicket(i)>0)
        {
          if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
           {
              if(magic==0)
               {
                 MqlTradeRequest request={0};
                 MqlTradeResult  result={0};
                  request.action   =TRADE_ACTION_DEAL;                     // 交易操作类型
                  request.symbol   =symbol;                              // 交易品种
                  request.volume   =PositionGetDouble(POSITION_VOLUME); // 0.1手交易量 
                  request.type     =ORDER_TYPE_BUY;                        // 订单类型
                  request.price    =SymbolInfoDouble(symbol,SYMBOL_ASK); // 持仓价格
                  request.deviation=100; // 允许价格偏差
                  request.type_filling=ORDER_FILLING_IOC;
                  request.position =PositionGetTicket(i);
                  if(!OrderSend(request,result))
                  PrintFormat("OrderSend error %d",GetLastError());   // 如果不能发送请求，输出错误
               }
              else
               {
                  if(PositionGetInteger(POSITION_MAGIC)==magic)
                  {
                     MqlTradeRequest request={0};
                     MqlTradeResult  result={0};
                     request.action   =TRADE_ACTION_DEAL;                     // 交易操作类型
                     request.symbol   =symbol;                              // 交易品种
                     request.volume   =PositionGetDouble(POSITION_VOLUME); // 0.1手交易量 
                     request.type     =ORDER_TYPE_BUY;                        // 订单类型
                     request.price    =SymbolInfoDouble(symbol,SYMBOL_ASK); // 持仓价格
                     request.deviation=100; // 允许价格偏差
                     request.type_filling=ORDER_FILLING_IOC;
                     request.position =PositionGetTicket(i);
                     if(!OrderSend(request,result))
                     PrintFormat("OrderSend error %d",GetLastError()); 
                  }
               }
           }
        }
     }
 }
void jiaoyi::closeall(string symbol,int magic=0)
 {
   int t=PositionsTotal();
   for(int i=t-1;i>=0;i--)
     {
       if(PositionGetTicket(i)>0)
        {
          if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
           {
              if(magic==0)
               {
                  MqlTradeRequest request={0};
                  MqlTradeResult  result={0};
                  request.action   =TRADE_ACTION_DEAL;                     // 交易操作类型
                  request.symbol   =symbol;                              // 交易品种
                  request.volume   =PositionGetDouble(POSITION_VOLUME); // 0.1手交易量 
                  request.type     =ORDER_TYPE_SELL;                        // 订单类型
                  request.price    =SymbolInfoDouble(symbol,SYMBOL_BID); // 持仓价格
                  request.deviation=100; // 允许价格偏差
                  request.type_filling=ORDER_FILLING_IOC;
                  request.position =PositionGetTicket(i);
                  if(!OrderSend(request,result))
                  PrintFormat("OrderSend error %d",GetLastError());   // 
               }
              else
               {
                  if(PositionGetInteger(POSITION_MAGIC)==magic)
                  {
                     MqlTradeRequest request={0};
                     MqlTradeResult  result={0};
                     request.action   =TRADE_ACTION_DEAL;                     // 交易操作类型
                     request.symbol   =symbol;                              // 交易品种
                     request.volume   =PositionGetDouble(POSITION_VOLUME); // 0.1手交易量 
                     request.type     =ORDER_TYPE_SELL;                        // 订单类型
                     request.price    =SymbolInfoDouble(symbol,SYMBOL_BID); // 持仓价格
                     request.deviation=100; // 允许价格偏差
                     request.type_filling=ORDER_FILLING_IOC;
                     request.position =PositionGetTicket(i);
                     if(!OrderSend(request,result))
                     PrintFormat("OrderSend error %d",GetLastError());  
                  }
               }
           }
          if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
           {
              if(magic==0)
               {
                 MqlTradeRequest request={0};
                 MqlTradeResult  result={0};
                  request.action   =TRADE_ACTION_DEAL;                     // 交易操作类型
                  request.symbol   =symbol;                              // 交易品种
                  request.volume   =PositionGetDouble(POSITION_VOLUME); // 0.1手交易量 
                  request.type     =ORDER_TYPE_BUY;                        // 订单类型
                  request.price    =SymbolInfoDouble(symbol,SYMBOL_ASK); // 持仓价格
                  request.deviation=100; // 允许价格偏差
                  request.type_filling=ORDER_FILLING_IOC;
                  request.position =PositionGetTicket(i);
                  if(!OrderSend(request,result))
                  PrintFormat("OrderSend error %d",GetLastError());   // 如果不能发送请求，输出错误
               }
              else
               {
                  if(PositionGetInteger(POSITION_MAGIC)==magic)
                  {
                     MqlTradeRequest request={0};
                     MqlTradeResult  result={0};
                     request.action   =TRADE_ACTION_DEAL;                     // 交易操作类型
                     request.symbol   =symbol;                              // 交易品种
                     request.volume   =PositionGetDouble(POSITION_VOLUME); // 0.1手交易量 
                     request.type     =ORDER_TYPE_BUY;                        // 订单类型
                     request.price    =SymbolInfoDouble(symbol,SYMBOL_ASK); // 持仓价格
                     request.deviation=100; // 允许价格偏差
                     request.type_filling=ORDER_FILLING_IOC;
                     request.position =PositionGetTicket(i);
                     if(!OrderSend(request,result))
                     PrintFormat("OrderSend error %d",GetLastError());  
                  }
               }
           }
        }
     }
 }
void jiaoyi::guamodify(string symbol,ENUM_ORDER_TYPE type,double guaprice,double limitprice,double sl,double tp,int magic=0)
 {
   int t=OrdersTotal();
   for(int i=t-1;i>=0;i--)
     {
       if(OrderGetTicket(i)>0)
        {
          if(OrderGetString(ORDER_SYMBOL)==symbol)
           {
             if(type==ORDER_TYPE_BUY_LIMIT || type==ORDER_TYPE_BUY_STOP || type==ORDER_TYPE_SELL_LIMIT || type==ORDER_TYPE_SELL_STOP)
              {
                if(magic==0)
                 {
                    MqlTradeRequest request={0};
                    MqlTradeResult  result={0};
                    request.action=TRADE_ACTION_MODIFY;
                    request.type=type;
                    request.order=OrderGetTicket(i);
                    request.symbol=symbol;
                    request.sl=NormalizeDouble(sl,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                    request.tp=NormalizeDouble(tp,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                    if(guaprice!=0)
                     {
                       request.price=NormalizeDouble(guaprice,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                     }
                    if(sl<0) request.sl=NormalizeDouble(OrderGetDouble(ORDER_SL),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                    if(tp<0) request.tp=NormalizeDouble(OrderGetDouble(ORDER_TP),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                    if(guaprice<0) request.price=NormalizeDouble(OrderGetDouble(ORDER_PRICE_OPEN),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                    if(!OrderSend(request,result))
                    PrintFormat("OrderSend error %d",GetLastError()); 
                 }
                else
                 {
                    if(OrderGetInteger(ORDER_MAGIC)==magic)
                    {
                       MqlTradeRequest request={0};
                       MqlTradeResult  result={0};
                       request.action=TRADE_ACTION_MODIFY;
                       request.type=type;
                       request.order=OrderGetTicket(i);
                       request.symbol=symbol;
                       request.sl=NormalizeDouble(sl,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       request.tp=NormalizeDouble(tp,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(guaprice!=0)
                        {
                          request.price=NormalizeDouble(guaprice,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                        }
                       if(sl<0) request.sl=NormalizeDouble(OrderGetDouble(ORDER_SL),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(tp<0) request.tp=NormalizeDouble(OrderGetDouble(ORDER_TP),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(guaprice<0) request.price=NormalizeDouble(OrderGetDouble(ORDER_PRICE_OPEN),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(!OrderSend(request,result))
                       PrintFormat("OrderSend error %d",GetLastError()); 
                    }
                 }
              }
             if(type==ORDER_TYPE_BUY_STOP_LIMIT || type==ORDER_TYPE_SELL_STOP_LIMIT)
              {
                if(magic==0)
                 {
                    MqlTradeRequest request={0};
                    MqlTradeResult  result={0};
                    request.action=TRADE_ACTION_MODIFY;
                    request.type=type;
                    request.order=OrderGetTicket(i);
                    request.symbol=symbol;
                    request.sl=NormalizeDouble(sl,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                    request.tp=NormalizeDouble(tp,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                    if(guaprice!=0)
                     {
                       request.price=NormalizeDouble(guaprice,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                     }
                    if(limitprice!=0)
                     {
                       request.stoplimit=NormalizeDouble(limitprice,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                     }
                    if(sl<0) request.sl=NormalizeDouble(OrderGetDouble(ORDER_SL),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                    if(tp<0) request.tp=NormalizeDouble(OrderGetDouble(ORDER_TP),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                    if(guaprice<0) request.price=NormalizeDouble(OrderGetDouble(ORDER_PRICE_OPEN),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                    if(limitprice<0) request.stoplimit=NormalizeDouble(OrderGetDouble(ORDER_PRICE_STOPLIMIT),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                    if(!OrderSend(request,result))
                    PrintFormat("OrderSend error %d",GetLastError()); 
                 }
                else
                 {
                    if(OrderGetInteger(ORDER_MAGIC)==magic)
                    {
                       MqlTradeRequest request={0};
                       MqlTradeResult  result={0};
                       request.action=TRADE_ACTION_MODIFY;
                       request.type=type;
                       request.order=OrderGetTicket(i);
                       request.symbol=symbol;
                       request.sl=NormalizeDouble(sl,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       request.tp=NormalizeDouble(tp,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(guaprice!=0)
                        {
                          request.price=NormalizeDouble(guaprice,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                        }
                       if(limitprice!=0)
                        {
                          request.stoplimit=NormalizeDouble(limitprice,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                        }
                       if(sl<0) request.sl=NormalizeDouble(OrderGetDouble(ORDER_SL),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(tp<0) request.tp=NormalizeDouble(OrderGetDouble(ORDER_TP),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(guaprice<0) request.price=NormalizeDouble(OrderGetDouble(ORDER_PRICE_OPEN),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(limitprice<0) request.stoplimit=NormalizeDouble(OrderGetDouble(ORDER_PRICE_STOPLIMIT),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(!OrderSend(request,result))
                       PrintFormat("OrderSend error %d",GetLastError()); 
                    }
                 }
              }
           } 
        }
     }
 }
void jiaoyi::yidong(int yidongdian,string symbol,ENUM_POSITION_TYPE type,int magic)
 {
   int t=PositionsTotal();
   for(int i=t-1;i>=0;i--)
     {
       if(PositionGetTicket(i)>0)
        {
          if(PositionGetString(POSITION_SYMBOL)==symbol)
           {
             double bid=SymbolInfoDouble(symbol,SYMBOL_BID);
             double ask=SymbolInfoDouble(symbol,SYMBOL_ASK);
             long dig=SymbolInfoInteger(symbol,SYMBOL_DIGITS);
             double pot=SymbolInfoDouble(symbol,SYMBOL_POINT);
             double op=PositionGetDouble(POSITION_PRICE_OPEN);
             double sl=PositionGetDouble(POSITION_SL);
             double tp=PositionGetDouble(POSITION_TP);  
             if(type==POSITION_TYPE_BUY)
              {
                if((bid-op)>=pot*yidongdian && (sl<(bid-pot*yidongdian) || (sl==0)))
                 {
                   if(magic==0)
                    {
                       MqlTradeRequest request={0};
                       MqlTradeResult  result={0};
                       request.action=TRADE_ACTION_SLTP;
                       request.position=PositionGetTicket(i);
                       request.symbol=symbol;
                       request.sl=bid-pot*yidongdian;
                       request.tp=tp;
                       if(!OrderSend(request,result))
                       PrintFormat("OrderSend error %d",GetLastError()); 
                    }
                   else
                    {
                       if(PositionGetInteger(POSITION_MAGIC)==magic)
                       {
                          MqlTradeRequest request={0};
                          MqlTradeResult  result={0};
                          request.action=TRADE_ACTION_SLTP;
                          request.position=PositionGetTicket(i);
                          request.symbol=symbol;
                          request.sl=bid-pot*yidongdian;
                          request.tp=tp;
                          if(!OrderSend(request,result))
                          PrintFormat("OrderSend error %d",GetLastError()); 
                       }
                    } 
                 }
              }
              if(type==POSITION_TYPE_SELL)
              {
                 if((op-ask)>=pot*yidongdian && ((sl>(ask+pot*yidongdian)) || (sl==0)))
                  {
                    if(magic==0)
                     {
                       MqlTradeRequest request={0};
                       MqlTradeResult  result={0};
                       request.action=TRADE_ACTION_SLTP;
                       request.position=PositionGetTicket(i);
                       request.symbol=symbol;
                       request.sl=ask+pot*yidongdian;
                       request.tp=tp;
                       if(!OrderSend(request,result))
                       PrintFormat("OrderSend error %d",GetLastError()); 
                    }
                    else
                    {
                       if(PositionGetInteger(POSITION_MAGIC)==magic)
                       {
                          MqlTradeRequest request={0};
                          MqlTradeResult  result={0};
                          request.action=TRADE_ACTION_SLTP;
                          request.position=PositionGetTicket(i);
                          request.symbol=symbol;
                          request.sl=ask+pot*yidongdian;
                          request.tp=tp;
                          if(!OrderSend(request,result))
                          PrintFormat("OrderSend error %d",GetLastError()); 
                       }
                    }
                  }
              }
           } 
        }
     }
 }
void jiaoyi::modifysltp(string symbol,ENUM_POSITION_TYPE type,double sl,double tp,int magic=0)
 {
   int t=PositionsTotal();
   for(int i=t-1;i>=0;i--)
     {
       if(PositionGetTicket(i)>0)
        {
          if(PositionGetString(POSITION_SYMBOL)==symbol)
           {
             if(type==POSITION_TYPE_BUY)
              {
                if(magic==0)
                 {
                     if((NormalizeDouble(sl,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))!=NormalizeDouble(PositionGetDouble(POSITION_SL),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))||NormalizeDouble(tp,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))!=NormalizeDouble(PositionGetDouble(POSITION_TP),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))))
                     {
                       MqlTradeRequest request={0};
                       MqlTradeResult  result={0};
                       request.action=TRADE_ACTION_SLTP;
                       request.position=PositionGetTicket(i);
                       request.symbol=symbol;
                       request.sl=NormalizeDouble(sl,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       request.tp=NormalizeDouble(tp,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(sl<0) request.sl=NormalizeDouble(PositionGetDouble(POSITION_SL),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(tp<0) request.tp=NormalizeDouble(PositionGetDouble(POSITION_TP),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(!OrderSend(request,result))
                       PrintFormat("OrderSend error %d",GetLastError()); 
                      }
                 }
                else
                 {
                    if(PositionGetInteger(POSITION_MAGIC)==magic)
                    {
                        if((NormalizeDouble(sl,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))!=NormalizeDouble(PositionGetDouble(POSITION_SL),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))||NormalizeDouble(tp,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))!=NormalizeDouble(PositionGetDouble(POSITION_TP),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))))
                         {
                          MqlTradeRequest request={0};
                          MqlTradeResult  result={0};
                          request.action=TRADE_ACTION_SLTP;
                          request.position=PositionGetTicket(i);
                          request.symbol=symbol;
                          request.sl=NormalizeDouble(sl,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                          request.tp=NormalizeDouble(tp,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                          if(sl<0) request.sl=NormalizeDouble(PositionGetDouble(POSITION_SL),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                          if(tp<0) request.tp=NormalizeDouble(PositionGetDouble(POSITION_TP),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                          if(!OrderSend(request,result))
                          PrintFormat("OrderSend error %d",GetLastError()); 
                         }
                    }
                 }
              }
              if(type==POSITION_TYPE_SELL)
              {
                 if(magic==0)
                  {
                     if((NormalizeDouble(sl,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))!=NormalizeDouble(PositionGetDouble(POSITION_SL),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))||NormalizeDouble(tp,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))!=NormalizeDouble(PositionGetDouble(POSITION_TP),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))))
                      {
                       MqlTradeRequest request={0};
                       MqlTradeResult  result={0};
                       request.action=TRADE_ACTION_SLTP;
                       request.position=PositionGetTicket(i);
                       request.symbol=symbol;
                       request.sl=NormalizeDouble(sl,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       request.tp=NormalizeDouble(tp,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(sl<0) request.sl=NormalizeDouble(PositionGetDouble(POSITION_SL),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(tp<0) request.tp=NormalizeDouble(PositionGetDouble(POSITION_TP),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                       if(!OrderSend(request,result))
                       PrintFormat("OrderSend error %d",GetLastError()); 
                      }
                 }
                else
                 {
                    if(PositionGetInteger(POSITION_MAGIC)==magic)
                    {
                        if((NormalizeDouble(sl,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))!=NormalizeDouble(PositionGetDouble(POSITION_SL),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))||NormalizeDouble(tp,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))!=NormalizeDouble(PositionGetDouble(POSITION_TP),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS))))
                         {
                          MqlTradeRequest request={0};
                          MqlTradeResult  result={0};
                          request.action=TRADE_ACTION_SLTP;
                          request.position=PositionGetTicket(i);
                          request.symbol=symbol;
                          request.sl=NormalizeDouble(sl,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                          request.tp=NormalizeDouble(tp,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                          if(sl<0) request.sl=NormalizeDouble(PositionGetDouble(POSITION_SL),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                          if(tp<0) request.tp=NormalizeDouble(PositionGetDouble(POSITION_TP),(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
                          if(!OrderSend(request,result))
                          PrintFormat("OrderSend error %d",GetLastError()); 
                         }
                    }
                 }
              }
           } 
        }
     }
 }
void jiaoyi::delorders(string symbol,int magic=0)
 {
    int t=OrdersTotal();
    for(int i=t-1;i>=0;i--)
     {
       if(OrderGetTicket(i)>0)
        {
          if(OrderGetString(ORDER_SYMBOL)==symbol)
           {
             if(magic==0)
              {
                 MqlTradeRequest request={0};
                 MqlTradeResult  result={0};
                 request.action=TRADE_ACTION_REMOVE;
                 request.order=OrderGetTicket(i);
                 request.symbol=symbol;
                 if(!OrderSend(request,result))
                 PrintFormat("OrderSend error %d",GetLastError()); 
              }
             else
              {
                 if(OrderGetInteger(ORDER_MAGIC)==magic)
                   {
                    MqlTradeRequest request={0};
                    MqlTradeResult  result={0};
                    request.action=TRADE_ACTION_REMOVE;
                    request.order=OrderGetTicket(i);
                    request.symbol=symbol;
                    if(!OrderSend(request,result))
                    PrintFormat("OrderSend error %d",GetLastError()); 
                   }
              }
           }
        }
     }
 }
double jiaoyi::profit0price(string symbol,ENUM_POSITION_TYPE type,int magic)
 {
   double a=0;
   double totallots=0;
   double lotsprice=0;
   int t=PositionsTotal();
   for(int i=t-1;i>=0;i--)
     {
       if(PositionGetTicket(i)>0)
        {
          if(PositionGetString(POSITION_SYMBOL)==symbol && PositionGetInteger(POSITION_TYPE)==type)
           {
             if(magic==0)
              {
                 if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
                  {
                    totallots=totallots+PositionGetDouble(POSITION_VOLUME);
                    lotsprice=lotsprice+PositionGetDouble(POSITION_VOLUME)*PositionGetDouble(POSITION_PRICE_OPEN);
                  }
                 if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
                  {
                    totallots=totallots-PositionGetDouble(POSITION_VOLUME);
                    lotsprice=lotsprice-PositionGetDouble(POSITION_VOLUME)*PositionGetDouble(POSITION_PRICE_OPEN);
                  }
              }
             else
              {
                if(PositionGetInteger(POSITION_MAGIC)==magic)
                 {
                    if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
                     {
                       totallots=totallots+PositionGetDouble(POSITION_VOLUME);
                       lotsprice=lotsprice+PositionGetDouble(POSITION_VOLUME)*PositionGetDouble(POSITION_PRICE_OPEN);
                     }
                    if(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_SELL)
                     {
                       totallots=totallots-PositionGetDouble(POSITION_VOLUME);
                       lotsprice=lotsprice-PositionGetDouble(POSITION_VOLUME)*PositionGetDouble(POSITION_PRICE_OPEN);
                     }
                 }
              }
           }
        }
     }
    if((totallots!=0)&&(lotsprice!=0))
    {
        a=NormalizeDouble(lotsprice/totallots,(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS));
    }
    else
    {
       a=0;
    }  
  return(a);
 }