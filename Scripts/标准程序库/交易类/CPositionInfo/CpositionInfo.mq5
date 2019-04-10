//+------------------------------------------------------------------+
//|                                                  CsymbolInfo.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
#include <Trade\PositionInfo.mqh>
CPositionInfo PositionInfo;

void OnStart()
{
    //---
    if (PositionInfo.Select(_Symbol))
    {
        Print("获取开仓时间:", PositionInfo.Time());
        Print("获取开仓的时间(时间戳):", PositionInfo.TimeMsc());
        Print("持仓变更时间, 数值是自1970年1月1日以来的秒数:", PositionInfo.TimeUpdate());
        Print("持仓变更时间, 数值是自1970年1月1日以来的毫秒数:", PositionInfo.TimeUpdateMsc());
        Print("持仓类型 (值为 ENUM_POSITION_TYPE 枚举):", PositionInfo.PositionType());
        Print("持仓类型的字符串描述:", PositionInfo.TypeDescription());
        Print("获取开仓的智能交易ID:", PositionInfo.Magic());
        Print("持仓的ID:", PositionInfo.Identifier());
        Print("持仓成交量:", PositionInfo.Volume());
        Print("开仓价:", PositionInfo.PriceOpen());
        Print("止损价:", PositionInfo.StopLoss());
        Print("止盈价:", PositionInfo.TakeProfit());
        Print("当前价格:", PositionInfo.PriceCurrent());
        Print("持仓的佣金额度:", PositionInfo.Commission());
        Print("当前盈利:", PositionInfo.Profit());
        Print("持仓品种:", PositionInfo.Symbol());
        Print("持仓的注释:", PositionInfo.Comment());
        Print("持仓的注释:", PositionInfo.Comment());
    }
    //适用于遍历
    if(PositionInfo.SelectByIndex(1)){
        Print("根据开仓索引获取开仓时间:", PositionInfo.Time());
    }
    if(PositionInfo.SelectByMagic(_Symbol,123456)){
        Print("根据智能交易ID获取开仓时间:", PositionInfo.Time());
    }
    if(PositionInfo.SelectByTicket(227417195))
    {
        Print("根据订单号获取开仓时间:", PositionInfo.Time());
    }
    // TODO StoreState CheckState不知道啥作用
}
//+------------------------------------------------------------------+
