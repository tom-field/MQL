#property copyright "瞬间的光辉QQ:215607364"
#property link      "http://www.zhinengjiaoyi.com"
extern datetime 挂单时间=D'2015.01.01 00:00';
extern int 挂单价距离现价上下几点=100;
extern int 挂单有效分钟=20;
extern double 挂单下单量=0.1;
extern int 挂单止损点数=400;
extern int 挂单止盈点数=400;
extern int 挂单成交后移动止损点数=200;
extern int magic=405215;
int init()
  {
   return(0);
  }
int deinit()
  {
   return(0);
  }
bool opentime()
  {
    bool a=false;
    if(TimeLocal()>=挂单时间 && TimeLocal()<(挂单时间+60))
     {
       a=true;
     }
    return(a);
  }
void delduo()
  {
     for(int i1=0;i1<OrdersTotal();i1++)
         {
             if(OrderSelect(i1,SELECT_BY_POS,MODE_TRADES))
               {
                 if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
                   {
                      if(OrderType()>OP_BUYSTOP)
                        {
                          OrderDelete(OrderTicket());
                        }       
                   } 
               }
         } 
  }
void delkong()
  {
     for(int i1=0;i1<OrdersTotal();i1++)
         {
             if(OrderSelect(i1,SELECT_BY_POS,MODE_TRADES))
               {
                 if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
                   {
                      if(OrderType()>OP_SELLSTOP)
                        {
                          OrderDelete(OrderTicket());
                        }       
                   } 
               }
         } 
  }
int start()
  {
    if(挂单成交后移动止损点数>0)
     {
       yidong();
     }
    for(int i1=0;i1<OrdersTotal();i1++)
      {
          if(OrderSelect(i1,SELECT_BY_POS,MODE_TRADES))
            {
              if(OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
                {
                   if(OrderType()>1 && (TimeCurrent()-OrderOpenTime())>=挂单有效分钟*60)
                     {
                       OrderDelete(OrderTicket());
                     }       
                } 
            }
      } 
    if(duodanshu()>0)
      {
        delkong();
      }
    if(kongdanshu()>0)
      {
        delduo();
      }
    if(danshu()==0 && opentime())
      {
         int sells=0;
         int buys=0;
         while(sells==0 || buys==0)
          {
             if(sellstop(挂单下单量,挂单止损点数,挂单止盈点数,Symbol()+"sell",Low[1]-挂单价距离现价上下几点*Point,magic)>0)
               {
                  sells=1;
               }
             if(buystop(挂单下单量,挂单止损点数,挂单止盈点数,Symbol()+"buy",High[1]+挂单价距离现价上下几点*Point,magic)>0)
               {
                  buys=1;
               }
              Sleep(1000);
          }
      }
   return(0);
  }
int danshu()
{
  int a=0;
         for(int i1=0;i1<OrdersTotal();i1++)
               {
                   if(OrderSelect(i1,SELECT_BY_POS,MODE_TRADES))
                     {
                       if(OrderSymbol()==Symbol()&& OrderMagicNumber()==magic)    
                         {
                            a++;       
                         } 
                      }
               } 
  return(a);
}
int kongdanshu()
{
  int a=0;
         for(int i1=0;i1<OrdersTotal();i1++)
               {
                   if(OrderSelect(i1,SELECT_BY_POS,MODE_TRADES))
                     {
                       if(OrderSymbol()==Symbol()&& OrderMagicNumber()==magic)    
                         {
                            if(OrderType()==1)
                              {
                                a++;
                              }       
                         } 
                      }
               } 
  return(a);
}
int duodanshu()
{
  int a=0;
         for(int i1=0;i1<OrdersTotal();i1++)
               {
                   if(OrderSelect(i1,SELECT_BY_POS,MODE_TRADES))
                     {
                       if(OrderSymbol()==Symbol()&& OrderMagicNumber()==magic)    
                         {
                            if(OrderType()==0)
                              {
                                a++;
                              }       
                         } 
                      }
               } 
  return(a);
}
void yidong()
  {
    for(int i=0;i<OrdersTotal();i++)//移动止损通用代码,次代码会自动检测buy和sell单并对其移动止损
         {
            if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
              {
                if(OrderType()==0 && OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
                  {
                     if((Bid-OrderOpenPrice()) >=Point*挂单成交后移动止损点数)
                      {
                         if(OrderStopLoss()<(Bid-Point*挂单成交后移动止损点数) || (OrderStopLoss()==0))
                           {
                              OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Point*挂单成交后移动止损点数,0,0,Green);
                           }
                      }      
                  }
                if(OrderType()==1 && OrderSymbol()==Symbol() && OrderMagicNumber()==magic)
                  {
                    if((OrderOpenPrice()-Ask)>=(Point*挂单成交后移动止损点数))
                      {
                         if((OrderStopLoss()>(Ask+Point*挂单成交后移动止损点数)) || (OrderStopLoss()==0))
                           {
                              OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*挂单成交后移动止损点数,0,0,Red);
                           }
                      }
                  }
               }
         }
  }
void DrawLabel(string name,string text,int X,int Y,string FontName,int FontSize,color FontColor,int zhongxin)
{
   if(ObjectFind(name)!=0)
   {
    ObjectDelete(name);
    ObjectCreate(name,OBJ_LABEL,0,0,0);
      ObjectSet(name,OBJPROP_CORNER,zhongxin);
      ObjectSet(name,OBJPROP_XDISTANCE,X);
      ObjectSet(name,OBJPROP_YDISTANCE,Y);
    }  
   ObjectSetText(name,text,FontSize,FontName,FontColor);
   WindowRedraw();
}
int buystop(double Lots,double sun,double ying,string comment,double price,int magic)
  {
    int kaidanok=0;
    int kaiguan=0;
    int ticket=0;
      for(int i=0;i<OrdersTotal();i++)
         {
             if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                 if((OrderComment()==comment) && OrderSymbol()==Symbol() && OrderMagicNumber()==magic)  
                   {
                     kaiguan=1;                     
                   } 
                }
         }
      if(kaiguan==0)
        {
          if((sun!=0)&&(ying!=0))
            {
              ticket=OrderSend(Symbol( ) ,OP_BUYSTOP,Lots,price,0,price-sun*Point,price+ying*Point,comment,magic,0,White);
            }
          if((sun==0)&&(ying!=0))
            {
              ticket=OrderSend(Symbol( ) ,OP_BUYSTOP,Lots,price,0,0,price+ying*Point,comment,magic,0,White);
            }
           if((sun!=0)&&(ying==0))
            {
              ticket=OrderSend(Symbol( ) ,OP_BUYSTOP,Lots,price,0,price-sun*Point,0,comment,magic,0,White);
            }
           if((sun==0)&&(ying==0))
            {
              ticket=OrderSend(Symbol( ) ,OP_BUYSTOP,Lots,price,0,0,0,comment,magic,0,White);
            }
            kaidanok=ticket;
        }
      return(kaidanok);  
  }
int sellstop(double Lots,double sun,double ying,string comment,double price,int magic)
    {
    int kaidanok=0;
    int kaiguan=0;
    int ticket=0;
      for(int i=0;i<OrdersTotal();i++)
         {
             if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
               {
                 if((OrderComment()==comment) && OrderSymbol()==Symbol() && OrderMagicNumber()==magic)    
                   {
                     kaiguan=1;                     
                   } 
                }
         }
      if(kaiguan==0)
        {
           if((sun!=0)&&(ying!=0))
             {
                ticket=OrderSend(Symbol( ) ,OP_SELLSTOP,Lots,price,0,price+sun*Point,price-ying*Point,comment,magic,0,Red);
             }
           if((sun==0)&&(ying!=0))
             {
                ticket=OrderSend(Symbol( ) ,OP_SELLSTOP,Lots,price,0,0,price-ying*Point,comment,magic,0,Red);
             }
           if((sun!=0)&&(ying==0))
             {
                ticket=OrderSend(Symbol( ) ,OP_SELLSTOP,Lots,price,0,price+sun*Point,0,comment,magic,0,Red);
             }
           if((sun==0)&&(ying==0))
             {
                ticket=OrderSend(Symbol( ) ,OP_SELLSTOP,Lots,price,0,0,0,comment,magic,0,Red);
             }
           kaidanok=ticket;
        }
      return(kaidanok);  
   }