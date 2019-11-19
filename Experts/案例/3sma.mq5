//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                3sma(barabashkakvn's edition).mq5 |
//|                                                         emsjoflo |
//|                                  automaticforex.invisionzone.com |
//+------------------------------------------------------------------+
#property copyright "emsjoflo"
#property link "automaticforex.invisionzone.com"
#property version "1.001"
//---
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
CPositionInfo m_position; // trade position object
CTrade m_trade;           // trading object
CSymbolInfo m_symbol;     // symbol info object
//--- input parameters
input double InpLots = 0.1;       // Lots
input ushort InpMAspread = 10;    // MA's spread (in pips)
input int Inp_ma_period_MA1 = 9;  // MA 1: averaging period
input int Inp_ma_shift_MA1 = 0;   // MA 1: horizontal shift
input int Inp_ma_period_MA2 = 14; // MA 2: averaging period
input int Inp_ma_shift_MA2 = 1;   // MA 2: horizontal shift
input int Inp_ma_period_MA3 = 29; // MA 3: averaging period
input int Inp_ma_shift_MA3 = 2;   // MA 3: horizontal shift
input ulong m_magic = 3415489;    // magic number
//---
ulong m_slippage = 10; // slippage

double ExtMAspread = 0;

int handle_iMA1; // variable for storing the handle of the iMA indicator
int handle_iMA2; // variable for storing the handle of the iMA indicator
int handle_iMA3; // variable for storing the handle of the iMA indicator

double m_adjusted_point; // point value adjusted for 3 or 5 points
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if(!m_symbol.Name("GBPJPY"))  // sets symbol name
      return (INIT_FAILED);
   RefreshRates();

   string err_text = "";
   if(!CheckVolumeValue(InpLots, err_text))
     {
      Print(__FUNCTION__, ", ERROR: ", err_text);
      return (INIT_PARAMETERS_INCORRECT);
     }
//---
   m_trade.SetExpertMagicNumber(m_magic);
   m_trade.SetMarginMode();
   m_trade.SetTypeFillingBySymbol(m_symbol.Name());
   m_trade.SetDeviationInPoints(m_slippage);
//--- tuning for 3 or 5 digits
   int digits_adjust = 1;
   if(m_symbol.Digits() == 3 || m_symbol.Digits() == 5)
      digits_adjust = 10;
   m_adjusted_point = m_symbol.Point() * digits_adjust;

   ExtMAspread = InpMAspread * m_adjusted_point;
//--- create handle of the indicator iMA
   handle_iMA1 = iMA(m_symbol.Name(), Period(), Inp_ma_period_MA1, Inp_ma_shift_MA1, MODE_SMA, PRICE_CLOSE);
//--- if the handle is not created
   if(handle_iMA1 == INVALID_HANDLE)
     {
      //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the iMA indicator for the symbol %s/%s, error code %d",
                  m_symbol.Name(),
                  EnumToString(Period()),
                  GetLastError());
      //--- the indicator is stopped early
      return (INIT_FAILED);
     }
//--- create handle of the indicator iMA
   handle_iMA2 = iMA(m_symbol.Name(), Period(), Inp_ma_period_MA2, Inp_ma_shift_MA2, MODE_SMA, PRICE_CLOSE);
//--- if the handle is not created
   if(handle_iMA2 == INVALID_HANDLE)
     {
      //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the iMA indicator for the symbol %s/%s, error code %d",
                  m_symbol.Name(),
                  EnumToString(Period()),
                  GetLastError());
      //--- the indicator is stopped early
      return (INIT_FAILED);
     }
//--- create handle of the indicator iMA
   handle_iMA3 = iMA(m_symbol.Name(), Period(), Inp_ma_period_MA3, Inp_ma_shift_MA3, MODE_SMA, PRICE_CLOSE);
//--- if the handle is not created
   if(handle_iMA3 == INVALID_HANDLE)
     {
      //--- tell about the failure and output the error code
      PrintFormat("Failed to create handle of the iMA indicator for the symbol %s/%s, error code %d",
                  m_symbol.Name(),
                  EnumToString(Period()),
                  GetLastError());
      //--- the indicator is stopped early
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
//---
   double ma1_0 = iMAGet(handle_iMA1, 0);
   double ma2_0 = iMAGet(handle_iMA2, 0);
   double ma3_0 = iMAGet(handle_iMA3, 0);
//---
   bool close = false;
   int count_buys = 0;
   int count_sells = 0;

   for(int i = PositionsTotal() - 1; i >= 0; i--)
      if(m_position.SelectByIndex(i))  // selects the position by index for further access to its properties
         if(m_position.Symbol() == m_symbol.Name() && m_position.Magic() == m_magic)
           {
            if(m_position.PositionType() == POSITION_TYPE_BUY)
              {
               if(ma1_0 < ma2_0 - ExtMAspread / 2.0)
                 {
                  m_trade.PositionClose(m_position.Ticket());
                  close = true;
                 }
               else
                  count_buys++;
              }

            if(m_position.PositionType() == POSITION_TYPE_SELL)
              {
               if(ma1_0 > ma2_0 + ExtMAspread / 2.0)
                 {
                  m_trade.PositionClose(m_position.Ticket());
                  close = true;
                 }
               else
                  count_sells++;
              }
           }
   if(close)
      return;
//---
   if(ma1_0 > (ma2_0 + ExtMAspread) && ma2_0 > (ma3_0 + ExtMAspread) && count_buys == 0)
     {
      if(!RefreshRates())
         return;
      Print("Buy condition");
      OpenBuy(0.0, 0.0);
      return;
     }
   if(ma1_0 < (ma2_0 - ExtMAspread) && ma2_0 < (ma3_0 - ExtMAspread) && count_sells == 0)
     {
      if(!RefreshRates())
         return;
      Print("Sell condition");
      OpenSell(0.0, 0.0);
      return;
     }
//---
  }
//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
  {
//---
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
      if(TerminalInfoString(TERMINAL_LANGUAGE) == "Russian")
         error_description = StringFormat("Объем меньше минимально допустимого SYMBOL_VOLUME_MIN=%.2f", min_volume);
      else
         error_description = StringFormat("Volume is less than the minimal allowed SYMBOL_VOLUME_MIN=%.2f", min_volume);
      return (false);
     }
//--- maximal allowed volume of trade operations
   double max_volume = m_symbol.LotsMax();
   if(volume > max_volume)
     {
      if(TerminalInfoString(TERMINAL_LANGUAGE) == "Russian")
         error_description = StringFormat("Объем больше максимально допустимого SYMBOL_VOLUME_MAX=%.2f", max_volume);
      else
         error_description = StringFormat("Volume is greater than the maximal allowed SYMBOL_VOLUME_MAX=%.2f", max_volume);
      return (false);
     }
//--- get minimal step of volume changing
   double volume_step = m_symbol.LotsStep();
   int ratio = (int)MathRound(volume / volume_step);
   if(MathAbs(ratio * volume_step - volume) > 0.0000001)
     {
      if(TerminalInfoString(TERMINAL_LANGUAGE) == "Russian")
         error_description = StringFormat("Объем не кратен минимальному шагу SYMBOL_VOLUME_STEP=%.2f, ближайший правильный объем %.2f",
                                          volume_step, ratio * volume_step);
      else
         error_description = StringFormat("Volume is not a multiple of the minimal step SYMBOL_VOLUME_STEP=%.2f, the closest correct volume is %.2f",
                                          volume_step, ratio * volume_step);
      return (false);
     }
   error_description = "Correct volume value";
   return (true);
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
