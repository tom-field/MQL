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
#include <Trade\SymbolInfo.mqh>
CSymbolInfo SymbolInfo;

void OnStart()
{
    SymbolInfo.Name(_Symbol);
    SymbolInfo.Refresh();
    Print("刷新品种报价:", SymbolInfo.RefreshRates());
    Print("品种与服务器已经同步:", SymbolInfo.IsSynchronized());
     // TODO 并未获取到
    printf("最后一笔成交单的成交量:%f", DoubleToString(SymbolInfo.Volume(), 2));
    printf("获取日内最大成交量:%f", DoubleToString(SymbolInfo.VolumeHigh(), 2));
    printf("获取日内最小成交量:%f", DoubleToString(SymbolInfo.VolumeLow(), 2));
    printf("获取点差 :%f", DoubleToString(SymbolInfo.Spread(), 2));
    Print("获取浮动点差标志:", SymbolInfo.SpreadFloat());
    Print("获取即时报价保存的深度:", SymbolInfo.TicksBookDepth());
    Print("获取订单距现价的最小距离:", SymbolInfo.StopsLevel());
    Print("获取订单距现价的最小距离:", SymbolInfo.StopsLevel());
    Print("获取冻结位 :", SymbolInfo.FreezeLevel());
    Print("获取当前卖出价格 :", SymbolInfo.Bid());
    Print("获取日内最高卖出价格:", SymbolInfo.BidHigh());
    Print("获取日内最低卖出价格:", SymbolInfo.BidLow());
    Print("获取当前买入价格 :", SymbolInfo.Ask());
    Print("获取日内最高买入价格:", SymbolInfo.AskHigh());
    Print("获取当前最后价格:", SymbolInfo.Last());
    Print("获取日内最高最后价格:", SymbolInfo.LastHigh());
    Print("获取日内最低最后价格:", SymbolInfo.LastLow());
    Print("获取合约成本计算模式:",SymbolInfo.TradeCalcMode() == SYMBOL_CALC_MODE_FOREX);
    Print("获取订单执行类型:",SymbolInfo.TradeCalcMode() == SYMBOL_TRADE_EXECUTION_REQUEST);
    Print("获取掉期利率的计算模式:",SymbolInfo.SwapMode() == SYMBOL_SWAP_MODE_POINTS);
    Print("获取掉期利率滚动日:",SymbolInfo.SwapRollover3days() == WEDNESDAY);
    Print("获取初始保证金值:",SymbolInfo.MarginInitial());
    Print("获取维护保证金值:",SymbolInfo.MarginMaintenance());
    Print("获取支付多头仓位的保证金率:",SymbolInfo.MarginLong());
    Print("获取支付控头仓位的保证金率:",SymbolInfo.MarginShort());
    Print("获取支付限价单的保证金率:",SymbolInfo.MarginLimit());
    Print("获取支付突破单的保证金率:",SymbolInfo.MarginStop());
    Print("获取支付突破/限价单的保证金率:",SymbolInfo.MarginStopLimit());
    Print("获取允许的订单过期模式标志:",SymbolInfo.TradeTimeFlags());
    Print("小数点之后的位数:",SymbolInfo.Digits());
    Print("获取点数值:",SymbolInfo.Point());
    Print("获取即时报价成本 (最小价格变化):",SymbolInfo.TickValue());
    Print("获取经计算的盈利仓位的即时价格:",SymbolInfo.TickValueProfit());
    Print("获取经计算的亏损仓位的即时价格:",SymbolInfo.TickValueLoss());
    Print("获取价格的最小变化:",SymbolInfo.TickSize());
    Print("获取交易合约的额度:",SymbolInfo.ContractSize());
    Print("获取一笔成交的最小成交量:",SymbolInfo.LotsMin());
    Print("获取一笔成交的最大成交量:",SymbolInfo.LotsMax());
    Print("获取一笔成交的最小变化步长:",SymbolInfo.LotsStep());
    Print("获取一个品种的最大允许开仓和挂单交易量 (方向无关):",SymbolInfo.LotsLimit());
    Print("获取多头持仓的掉期利率值:",SymbolInfo.SwapLong());
    Print("获取空头持仓的掉期利率值:",SymbolInfo.SwapShort());
    Print("获取品名的基准货币:",SymbolInfo.CurrencyBase());
    Print("获取盈利货币名:",SymbolInfo.CurrencyProfit());
    Print("获取保证金货币名:",SymbolInfo.CurrencyMargin());
    Print("获取当前报价来源的名称:",SymbolInfo.Bank());
    Print("获取品种的字符串描述:",SymbolInfo.Description());
    Print("获取品种树的路径:",SymbolInfo.Path());
    Print("获取当前时段的成交单数量:",SymbolInfo.SessionDeals());
    Print("获取当前时刻的多头订单数量:",SymbolInfo.SessionBuyOrders());
    Print("获取当前时刻的空头订单数量:",SymbolInfo.SessionSellOrders());
    Print("获取当前时段的流水摘要:",SymbolInfo.SessionTurnover());
    Print("获取多头订单的当前交易量:",SymbolInfo.SessionBuyOrdersVolume());
    Print("获取空头订单的当前交易量:",SymbolInfo.SessionSellOrdersVolume());
    Print("获取当前时段的开仓价:",SymbolInfo.SessionOpen());
    Print("获取当前时段的平仓价:",SymbolInfo.SessionClose());
    Print("获取当前时段的平均加权价:",SymbolInfo.SessionAW());
    Print("获取当前时段的结算价:",SymbolInfo.SessionPriceSettlement());
    Print("获取当前时段的最小价:",SymbolInfo.SessionPriceLimitMin());
    Print("获取当前时段的最大价:",SymbolInfo.SessionPriceLimitMax());
}
//+------------------------------------------------------------------+
