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
#include <Expert\Money\MoneyFixedRisk.mqh>
#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
CMoneyFixedRisk m_money;
CTrade m_trade;
CSymbolInfo m_symbol;
CPositionInfo m_position;
// ima方法返回的句柄
int handle1;
int handle2;
int handle3;
//--- 输入参数
input int 短均线周期 = 9;
input int 中均线周期 = 14;
input int 长均线周期 = 29;
input double InpLots = 0.01;//交易手数
input ushort InpMAspread = 10;    // MA's spread (in pips)
input ulong InpMagic = 123456; //magic
// TODO 单单带止损效果
//input int 止盈点 = 600;
//input int 止损点 = 300;
//--
ulong 滑点 = 10;
int MA_SHIFT = 0;

double ExtMAspread = 0;
double m_adjusted_point; // point value adjusted for 3 or 5 points
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

   if(!m_symbol.Name(_Symbol))  // sets symbol name
      return (INIT_FAILED);
   RefreshRates();

   string err_text = "";

   m_trade.SetExpertMagicNumber(InpMagic);
   m_trade.SetMarginMode();
   m_trade.SetTypeFillingBySymbol(m_symbol.Name());
   m_trade.SetDeviationInPoints(滑点);

//--- TODO 理解不了3,5位的兼容 tuning for 3 or 5 digits
   int digits_adjust = 1;
   if(m_symbol.Digits() == 3 || m_symbol.Digits() == 5)
      digits_adjust = 10;
   m_adjusted_point = m_symbol.Point() * digits_adjust;
   ExtMAspread = InpMAspread * m_adjusted_point;

   handle1 = iMA(Symbol(), _Period, 短均线周期, MA_SHIFT, MODE_SMA, PRICE_CLOSE);
   handle2 = iMA(Symbol(), _Period, 中均线周期, MA_SHIFT, MODE_SMA, PRICE_CLOSE);
   handle3 = iMA(Symbol(), _Period, 长均线周期, MA_SHIFT, MODE_SMA, PRICE_CLOSE);

//判断是否开启智能交易
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) && !(Bars(_Symbol, _Period) > 100))
     {
      printf("未开启智能交易,或者柱图个数不足");
      return (INIT_FAILED);
     }

   if(handle1 == INVALID_HANDLE || handle2 == INVALID_HANDLE || handle3 == INVALID_HANDLE)
     {
      printf("创建MA指标失败");
      return (INIT_FAILED);
     }
//---
   return (INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   double 短均线数据_0 = iMAGet(handle1,0);
   double 中均线数据_0 = iMAGet(handle2,0);
   double 长均线数据_0 = iMAGet(handle3,0);

   bool close = false;
   int count_buys = 0;
   int count_sells = 0;

   for(int i = PositionsTotal() - 1; i>=0; i--)
     {
      if(m_position.SelectByIndex(i))
        {
         printf(m_position.Symbol());
         printf(m_symbol.Name());
         printf(m_position.Magic());
         printf(InpMagic);
         if(m_position.Symbol() == m_symbol.Name() && m_position.Magic() == InpMagic)
           {
            if(m_position.PositionType() == POSITION_TYPE_BUY)
              {
               if(短均线数据_0 < 中均线数据_0)
                 {
                  m_trade.PositionClose(m_position.Ticket());
                  close = true;
                 }
               else
                 {
                  count_buys++;
                 }
              }
            if(m_position.PositionType() == POSITION_TYPE_SELL)
              {
               if(短均线数据_0 > 中均线数据_0)
                 {
                  m_trade.PositionClose(m_position.Ticket());
                  close = true;
                 }
               else
                 {
                  count_sells++;
                 }
              }
           }
        }
     }
   if(!close)
     {
      if(短均线数据_0 > (中均线数据_0 + ExtMAspread) && 中均线数据_0 > (长均线数据_0 + ExtMAspread) && count_buys == 0)
        {
         if(!RefreshRates())
           {
            return;
           }
         OpenBuy(0.0,0.0);
        }
      if(短均线数据_0 < (中均线数据_0 - ExtMAspread) && 中均线数据_0 < (长均线数据_0 - ExtMAspread) && count_sells == 0)
        {
         if(!RefreshRates())
           {
            return;
           }
         OpenSell(0.0,0.0);
        }
     }

  }
//+------------------------------------------------------------------+
//| Open Buy position                                                |
//+------------------------------------------------------------------+
void OpenBuy(double sl, double tp)
  {
//sl=m_symbol.NormalizePrice(sl);
//tp=m_symbol.NormalizePrice(tp);
//--- check volume before OrderSend to avoid "not enough money" error (CTrade)
   double check_volume_lot = m_trade.CheckVolume(m_symbol.Name(), InpLots, m_symbol.Ask(), ORDER_TYPE_BUY);

   if(check_volume_lot != 0.0)
     {
      if(check_volume_lot >= InpLots)
        {
         if(m_trade.Buy(InpLots, m_symbol.Name(), m_symbol.Ask(), sl, tp))
           {
            if(m_trade.ResultDeal() == 0)
              {
               Print(__FUNCTION__, ", #1 Buy -> false. Result Retcode: ", m_trade.ResultRetcode(),
                     ", description of result: ", m_trade.ResultRetcodeDescription());
               PrintResultTrade(m_trade, m_symbol);
              }
            else
              {
               Print(__FUNCTION__, ", #2 Buy -> true. Result Retcode: ", m_trade.ResultRetcode(),
                     ", description of result: ", m_trade.ResultRetcodeDescription());
               PrintResultTrade(m_trade, m_symbol);
              }
           }
         else
           {
            Print(__FUNCTION__, ", #3 Buy -> false. Result Retcode: ", m_trade.ResultRetcode(),
                  ", description of result: ", m_trade.ResultRetcodeDescription());
            PrintResultTrade(m_trade, m_symbol);
           }
        }
      else
        {
         Print(__FUNCTION__, ", ERROR: method CheckVolume (", DoubleToString(check_volume_lot, 2), ") ",
               "< Lots (", DoubleToString(InpLots, 2), ")");
         return;
        }
     }
   else
     {
      Print(__FUNCTION__, ", ERROR: method CheckVolume returned the value of \"0.0\"");
      return;
     }
//---
  }
//+------------------------------------------------------------------+
//| Open Sell position                                               |
//+------------------------------------------------------------------+
void OpenSell(double sl, double tp)
  {
//sl=m_symbol.NormalizePrice(sl);
//tp=m_symbol.NormalizePrice(tp);
//--- check volume before OrderSend to avoid "not enough money" error (CTrade)
   double check_volume_lot = m_trade.CheckVolume(m_symbol.Name(), InpLots, m_symbol.Bid(), ORDER_TYPE_SELL);

   if(check_volume_lot != 0.0)
     {
      if(check_volume_lot >= InpLots)
        {
         if(m_trade.Sell(InpLots, m_symbol.Name(), m_symbol.Bid(), sl, tp))
           {
            if(m_trade.ResultDeal() == 0)
              {
               Print(__FUNCTION__, ", #1 Sell -> false. Result Retcode: ", m_trade.ResultRetcode(),
                     ", description of result: ", m_trade.ResultRetcodeDescription());
               PrintResultTrade(m_trade, m_symbol);
              }
            else
              {
               Print(__FUNCTION__, ", #2 Sell -> true. Result Retcode: ", m_trade.ResultRetcode(),
                     ", description of result: ", m_trade.ResultRetcodeDescription());
               PrintResultTrade(m_trade, m_symbol);
              }
           }
         else
           {
            Print(__FUNCTION__, ", #3 Sell -> false. Result Retcode: ", m_trade.ResultRetcode(),
                  ", description of result: ", m_trade.ResultRetcodeDescription());
            PrintResultTrade(m_trade, m_symbol);
           }
        }
      else
        {
         Print(__FUNCTION__, ", ERROR: method CheckVolume (", DoubleToString(check_volume_lot, 2), ") ",
               "< Lots (", DoubleToString(InpLots, 2), ")");
         return;
        }
     }
   else
     {
      Print(__FUNCTION__, ", ERROR: method CheckVolume returned the value of \"0.0\"");
      return;
     }
//---
  }
//+------------------------------------------------------------------+
//| Get value of buffers for the iMA                                 |
//+------------------------------------------------------------------+
double iMAGet(const int handle_iMA, const int index)
  {
   double MA[1];
//--- reset error code
   ResetLastError();
//--- fill a part of the iMABuffer array with values from the indicator buffer that has 0 index
   if(CopyBuffer(handle_iMA, 0, index, 1, MA) < 0)
     {
      //--- if the copying fails, tell the error code
      PrintFormat("Failed to copy data from the iMA indicator, error code %d", GetLastError());
      //--- quit with zero result - it means that the indicator is considered as not calculated
      return (0.0);
     }
   return (MA[0]);
  }
//+------------------------------------------------------------------+
//| Refreshes the symbol quotes data                                 |
//+------------------------------------------------------------------+
bool RefreshRates(void)
  {
//--- refresh rates
   if(!m_symbol.RefreshRates())
     {
      Print("RefreshRates error");
      return (false);
     }
//--- protection against the return value of "zero"
   if(m_symbol.Ask() == 0 || m_symbol.Bid() == 0)
      return (false);
//---
   return (true);
  }
//+------------------------------------------------------------------+
//| Check the correctness of the position volume                     |
//+------------------------------------------------------------------+
bool CheckVolumeValue(double volume, string &error_description)
  {
//--- minimal allowed volume for trade operations
   double min_volume = m_symbol.LotsMin();
   if(volume < min_volume)
     {
      error_description = StringFormat("Volume is less than the minimal allowed SYMBOL_VOLUME_MIN=%.2f", min_volume);
      return (false);
     }
//--- maximal allowed volume of trade operations
   double max_volume = m_symbol.LotsMax();
   if(volume > max_volume)
     {
      error_description = StringFormat("Volume is greater than the maximal allowed SYMBOL_VOLUME_MAX=%.2f", max_volume);
      return (false);
     }
//--- get minimal step of volume changing
   double volume_step = m_symbol.LotsStep();
   int ratio = (int)MathRound(volume / volume_step);
   if(MathAbs(ratio * volume_step - volume) > 0.0000001)
     {
      error_description = StringFormat("Volume is not a multiple of the minimal step SYMBOL_VOLUME_STEP=%.2f, the closest correct volume is %.2f",
                                       volume_step, ratio * volume_step);
      return (false);
     }
   error_description = "Correct volume value";
   return (true);
  }
//+------------------------------------------------------------------+
//| Print CTrade result                                              |
//+------------------------------------------------------------------+
void PrintResultTrade(CTrade &trade, CSymbolInfo &symbol)
  {
   Print("File: ", __FILE__, ", symbol: ", m_symbol.Name());
   Print("Code of request result: " + IntegerToString(trade.ResultRetcode()));
   Print("code of request result as a string: " + trade.ResultRetcodeDescription());
   Print("Deal ticket: " + IntegerToString(trade.ResultDeal()));
   Print("Order ticket: " + IntegerToString(trade.ResultOrder()));
   Print("Volume of deal or order: " + DoubleToString(trade.ResultVolume(), 2));
   Print("Price, confirmed by broker: " + DoubleToString(trade.ResultPrice(), symbol.Digits()));
   Print("Current bid price: " + DoubleToString(symbol.Bid(), symbol.Digits()) + " (the requote): " + DoubleToString(trade.ResultBid(), symbol.Digits()));
   Print("Current ask price: " + DoubleToString(symbol.Ask(), symbol.Digits()) + " (the requote): " + DoubleToString(trade.ResultAsk(), symbol.Digits()));
   Print("Broker comment: " + trade.ResultComment());
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
