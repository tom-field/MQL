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

string symbols_show[] = {"GOLD", "EURUSD"};
bool is_custom_symbol = false;

void OnStart()
{
    for (int i = SymbolsTotal(true) - 1; i > 0; i--)
    {
        string symbol_name = SymbolName(i, true);
        SymbolSelect(symbol_name, false);
    }
    for (int i = 0; i < ArraySize(symbols_show); i++)
    {
        if(SymbolExist(symbols_show[i],is_custom_symbol)){
            SymbolSelect(symbols_show[i], true);
        }else{
            Print(symbols_show[i],"不能存在");
        }
        
    }
}
