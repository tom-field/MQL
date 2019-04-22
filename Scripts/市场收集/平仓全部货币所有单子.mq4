//+------------------------------------------------------------------+
//|                                           平仓全部货币所有单子.mq4 |
//|                       Copyright ?2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#include <stdlib.mqh>
#include <WinUser32.mqh>
#property show_inputs
//+------------------------------------------------------------------+
extern string 说明="点确定平仓当前图表币种的所有单子";
//+------------------------------------------------------------------+
int start()
  {
//----
while (cal()>0)
  {
  RefreshRates();
   for(int i=0;i<OrdersTotal();i++)
   {
   
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
   
   string symd=OrderSymbol();
   //if(symd!=Symbol()) continue;
   double pr;
   if(OrderType()==0)
     {
     pr=MarketInfo(symd,MODE_BID);
     if(!OrderClose(OrderTicket(),OrderLots(),pr,3,White)) Print("#"+OrderTicket()+",  平仓出错:"+GetLastError());
     }
   if(OrderType()==1)
     {
     pr=MarketInfo(symd,MODE_ASK);
     if(!OrderClose(OrderTicket(),OrderLots(),pr,3,White)) Print("#"+OrderTicket()+",  平仓出错:"+GetLastError());
     }
   if(OrderType()>1) OrderDelete(OrderTicket());
   }
   
   }
   Alert("操作完成");
   return(0);
  }
//+------------------------------------------------------------------+
int cal()
{
int os;
for(int i=0;i<OrdersTotal();i++)
   {
   if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
   if(OrderLots( ) >0) os++;
   }
   return(os);

}