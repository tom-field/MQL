//+------------------------------------------------------------------+
//|                                                        Learn.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

// ima方法返回的句柄
int macd_handle;
// ma10
int fast_ema_period = 12;
int slow_ema_period = 26;
int macd_sma = 9;
ENUM_APPLIED_PRICE applied_price = PRICE_CLOSE;

//存ma数据的数组
double macd_buffer[];
double signal_buffer[];

void OnStart()
  {
//---
   macd_handle=iMACD(Symbol(),PERIOD_CURRENT,fast_ema_period,slow_ema_period,macd_sma,applied_price);

   if(macd_handle == INVALID_HANDLE)
   {
        printf("句柄获取失败");
   }
   else{
        printf("macd_handle的句柄为%d",macd_handle);

        ArraySetAsSeries(macd_buffer,true);
        ArraySetAsSeries(signal_buffer,true);
        // CopyBuffer的第二个参数表示的是第几个指标数据
        CopyBuffer(macd_handle,0,0,10,macd_buffer);
        CopyBuffer(macd_handle,1,0,10,signal_buffer);

        printf(DoubleToString(macd_buffer[0]));
        printf(DoubleToString(signal_buffer[0]));
   }

  }
//+------------------------------------------------------------------+
