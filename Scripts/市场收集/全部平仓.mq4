//+------------------------------------------------------------------+
//|                                                        close.mq4 |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net/"
#property show_confirm

//+------------------------------------------------------------------+
//| script "close first market order if it is first in the list"     |
//+------------------------------------------------------------------+
int start()
  {
   double price;
   int    cmd,error;
//----
   int cnt=0,total;
   total = OrdersTotal();
   int count=0;
while(total!=0 && count<100) {
   for(cnt=0;cnt<total;cnt++) {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
            cmd = OrderType();
            //while(true)
              {
               //Sleep(500);
               if(cmd==OP_BUY) price=MarketInfo(OrderSymbol(),MODE_BID);
               else            price=MarketInfo(OrderSymbol(),MODE_ASK);
               OrderClose(OrderTicket(),OrderLots(),price,3,CLR_NONE);
              // if(result!=TRUE) { error=GetLastError(); Print("LastError = ",error); }
              // else error=0;
              // if(error==135) RefreshRates();
              // else break;
              }
   }   
   count++;
   total = OrdersTotal();   
}
//----
   
  }
return(0);  

//+------------------------------------------------------------------+