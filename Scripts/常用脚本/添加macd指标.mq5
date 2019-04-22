//+------------------------------------------------------------------+
//|                                                      显示自定义模板.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int indicator_handle = INVALID_HANDLE;

void OnStart()
{
    indicator_handle = iMACD(_Symbol, _Period, 12, 26, 9, PRICE_CLOSE);
    //   ChartIndicatorAdd(0,0,handle);
    //   printf(GetLastError());
    int subwindow = (int)ChartGetInteger(0, CHART_WINDOWS_TOTAL);
    if (!ChartIndicatorAdd(0, subwindow, indicator_handle))
    {
        PrintFormat("Failed to add MACD indicator on %d chart window. Error code  %d", subwindow, GetLastError());
    }
}
