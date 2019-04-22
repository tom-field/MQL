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
   bool   Result;
   int    i,Pos,Error;
   int    Total=OrdersTotal();
   ObjectsDeleteAll();             
   if(Total>0)
   {
     for(i=Total-1; i>=0; i--) 
     {
       if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == TRUE) 
       {
         Pos=OrderType();
         if(Pos==OP_BUY)
         {Result=OrderClose(OrderTicket(), OrderLots(), Bid, 5, CLR_NONE);}
         if(Pos==OP_SELL)
         {Result=OrderClose(OrderTicket(), OrderLots(), Ask, 5, CLR_NONE);}
         if((Pos==OP_BUYSTOP)||(Pos==OP_SELLSTOP)||(Pos==OP_BUYLIMIT)||(Pos==OP_SELLLIMIT))
         {Result=OrderDelete(OrderTicket(), CLR_NONE);}
//-----------------------
         if(Result!=true) 
          { 
             Error=GetLastError(); 
             Print("LastError = ",Error); 
          }
         else Error=0;
//-----------------------
       }   
     }
   }
   return(0);
//----
   return(0);
  }
//+------------------------------------------------------------------+