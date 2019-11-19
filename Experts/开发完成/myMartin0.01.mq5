//+------------------------------------------------------------------+
//|                                                    MA交易v0.01.mq5 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>

CPositionInfo m_position;
CTrade m_trade;
CSymbolInfo m_symbol;

// ima方法返回的句柄
int handle1;
int handle2;
int handle3;

// 马丁开始 比较重要参数
bool 已开买单 = false;
input int 最大加仓次数 = 20;
int 当前加仓次数 = 0;
input double 预设步距 = 0.002;

input int 短均线周期 = 30;
input int 中均线周期 = 50;
input int 长均线周期 = 100;
input double 成交手数 = 0.01;
input int 止盈点 = 600;
input int 止损点 = 300;

ulong 滑点 = 10; // 滑点

int ma_shift = 0;

int 魔术号 = 123456;

bool 是否零售帐号 = false;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
{
    if (!m_symbol.Name("EURUSD")) // sets symbol name
        return (INIT_FAILED);
    RefreshRates();
    //---
    //ENUM_ACCOUNT_MARGIN_MODE::ACCOUNT_MARGIN_MODE_RETAIL_HEDGING
    是否零售帐号 = ((ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING);

    m_trade.SetExpertMagicNumber(魔术号);
    m_trade.SetMarginMode();
    m_trade.SetTypeFillingBySymbol(m_symbol.Name());
    m_trade.SetDeviationInPoints(滑点);

    //TODO _Period后面优化为输入参数
    handle1 = iMA(m_symbol.Name(), _Period, 短均线周期, ma_shift, MODE_SMA, PRICE_CLOSE);
    handle2 = iMA(m_symbol.Name(), _Period, 中均线周期, ma_shift, MODE_SMA, PRICE_CLOSE);
    handle3 = iMA(m_symbol.Name(), _Period, 长均线周期, ma_shift, MODE_SMA, PRICE_CLOSE);

    //判断是否开启智能交易
    if (!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) && !(Bars(_Symbol, _Period) > 100))
    {
        printf("未开启智能交易,或者柱图个数不足");
        return (INIT_FAILED);
    }

    if (handle1 == INVALID_HANDLE || handle2 == INVALID_HANDLE || handle3 == INVALID_HANDLE)
    {
        printf("创建MA指标失败");
        return (INIT_FAILED);
    }
    return (INIT_SUCCEEDED);
}
void OnDeinit(const int reason)
{
    //---
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
    CheckForOpen();
    CheckForJiaCang();
}
//+------------------------------------------------------------------+

void CheckForOpen()
{
    // 短周期数值>中等周期>长周期开多单
    double 短均线数据[2];
    double 中均线数据[2];
    double 长均线数据[2];

    ENUM_ORDER_TYPE 订单类型 = WRONG_VALUE;

    if (CopyBuffer(handle1, 0, 0, 2, 短均线数据) != -1 && CopyBuffer(handle2, 0, 0, 2, 中均线数据) != -1 && CopyBuffer(handle3, 0, 0, 2, 长均线数据) != -1)
    {
        if (短均线数据[0] > 中均线数据[0] && 中均线数据[0] > 长均线数据[0])
        {
            订单类型 = ORDER_TYPE_BUY;
        }
    }
    if (订单类型 != WRONG_VALUE)
    {
        if (订单类型 == ORDER_TYPE_BUY)
        {
            if (已开买单 == false)
            {
                m_trade.Buy(成交手数, m_symbol.Name(), m_symbol.Ask(), 0, 0, "#buy 0");
                已开买单 = true;
            }
        }
    }
}

void CheckForPingCang()
{
    
}

void CheckForJiaCang()
{
    if (PositionsTotal() < 1)
    {
        return;
    }
    int total = PositionsTotal();
    if (m_position.SelectByIndex(total - 1))
    {
        if (!RefreshRates()){
            return;
        }
        double _priceOpen = m_position.PriceOpen();
        double _ask = m_symbol.Ask();
        Print(_priceOpen-预设步距,_ask);
        if(m_position.PriceOpen() + 预设步距 * 当前加仓次数 < m_symbol.Ask()){
            //平掉所有仓位
            CloseAllPositions();
            已开买单 = false;
            当前加仓次数 = 0;
            return;
        }
        if (m_position.PriceOpen() - 预设步距 > m_symbol.Ask())
        {
            if (当前加仓次数 >= 最大加仓次数)
            {
                //平掉所有仓位
                CloseAllPositions();
            }
            else
            {
                //两倍加仓 TODO 不开单 2的n次方
                m_trade.Buy(成交手数 * MathPow(2,当前加仓次数), m_symbol.Name(), m_symbol.Ask(), 0, 0, "#buy 加仓" + IntegerToString(当前加仓次数));
                当前加仓次数++;
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Refreshes the symbol quotes data                                 |
//+------------------------------------------------------------------+
bool RefreshRates(void)
{
    //--- refresh rates
    if (!m_symbol.RefreshRates())
    {
        Print("RefreshRates error");
        return (false);
    }
    //--- protection against the return value of "zero"
    if (m_symbol.Ask() == 0 || m_symbol.Bid() == 0)
        return (false);
    //---
    return (true);
}

void CloseAllPositions()
{
    for (int i = PositionsTotal() - 1; i >= 0; i--)
    {                                    // returns the number of current position
        if (m_position.SelectByIndex(i)) // selects the position by index for further access to its properties
        {
            if (m_position.Symbol() == m_symbol.Name() && m_position.Magic() == 魔术号)
                m_trade.PositionClose(m_position.Ticket()); // close a position by the specified symbol
        }
    }
}