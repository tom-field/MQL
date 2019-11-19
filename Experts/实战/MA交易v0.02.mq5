//+------------------------------------------------------------------+
//| 加入按照margin百分比下单策略                                        |
//| 固定0.01手下单反而能挣钱,                                          |
//| 加了百分比下单反而亏损                                             |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                    MA交易v0.01.mq5|
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
#include <Expert\Money\MoneyFixedMargin.mqh>
#include <Trade\Trade.mqh>
#include <Trade\SymbolInfo.mqh>
CMoneyFixedMargin m_money;
CTrade m_trade;
CSymbolInfo m_symbol;
CPositionInfo m_position;
//--- 输入参数
input int Inp_ma_period_MA1 = 9;  //短周期均线
input int Inp_ma_shift_MA1 = 0;   // MA 1: 水平偏移
input int Inp_ma_period_MA2 = 14; //中周期均线
input int Inp_ma_shift_MA2 = 1;   // MA 2: 水平偏移
input int Inp_ma_period_MA3 = 29; //长周期均线
input int Inp_ma_shift_MA3 = 2;   // MA 3: 水平偏移
input double InpLots = 0.01;//交易手数
input double Inp_lots_percent = 50; //占用保证金比率
input ushort InpMAspread = 10;    // MA's spread (in pips)
input ulong InpMagic = 123456; //magic
ulong m_slippage = 10;        // 滑点
double ExtMAspread = 0;       // spread
double m_adjusted_point; // point value adjusted for 3 or 5 points
// ima方法返回的句柄
int handle_iMA1;
int handle_iMA2;
int handle_iMA3;
// TODO 单单带止损效果
//input int 止盈点 = 600;
//input int 止损点 = 300;
//--
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
   m_trade.SetDeviationInPoints(m_slippage);

   m_money.Init(GetPointer(m_symbol), _Period, _Digits);
   m_money.Percent(Inp_lots_percent);
   Print("验证设置:", m_money.ValidationSettings());

//--- TODO 理解不了3,5位的兼容 tuning for 3 or 5 digits
   int digits_adjust = 1;
   if(m_symbol.Digits() == 3 || m_symbol.Digits() == 5)
      digits_adjust = 10;
   m_adjusted_point = m_symbol.Point() * digits_adjust;
   ExtMAspread = InpMAspread * m_adjusted_point;

   handle_iMA1 = iMA(m_symbol.Name(), _Period, Inp_ma_period_MA1, Inp_ma_shift_MA1, MODE_SMA, PRICE_CLOSE);
   handle_iMA2 = iMA(m_symbol.Name(), _Period, Inp_ma_period_MA2, Inp_ma_shift_MA2, MODE_SMA, PRICE_CLOSE);
   handle_iMA3 = iMA(m_symbol.Name(), _Period, Inp_ma_period_MA3, Inp_ma_shift_MA3, MODE_SMA, PRICE_CLOSE);

//判断是否开启智能交易
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) && !(Bars(_Symbol, _Period) > 100))
     {
      printf("未开启智能交易,或者柱图个数不足");
      return (INIT_FAILED);
     }

   if(handle_iMA1 == INVALID_HANDLE || handle_iMA2 == INVALID_HANDLE || handle_iMA3 == INVALID_HANDLE)
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
   double 短均线数据_0 = iMAGet(handle_iMA1,0);
   double 中均线数据_0 = iMAGet(handle_iMA2,0);
   double 长均线数据_0 = iMAGet(handle_iMA3,0);

   bool close = false;
   int count_buys = 0;
   int count_sells = 0;

   for(int i = PositionsTotal() - 1; i>=0; i--)
     {
      if(m_position.SelectByIndex(i))
        {
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
   if(close)
     {
      return;
     }
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
//+------------------------------------------------------------------+
//| Open Buy position                                                |
//+------------------------------------------------------------------+
void OpenBuy(double sl, double tp)
  {
//sl=m_symbol.NormalizePrice(sl);
//tp=m_symbol.NormalizePrice(tp);
//--- check volume before OrderSend to avoid "not enough money" error (CTrade)
   double check_open_long_lot = m_money.CheckOpenLong(m_symbol.Ask(),sl);
   double check_volume_lot = m_trade.CheckVolume(m_symbol.Name(), check_open_long_lot, m_symbol.Ask(), ORDER_TYPE_BUY);

   if(check_volume_lot != 0.0)
     {
      if(check_volume_lot >= check_open_long_lot)
        {
         if(m_trade.Buy(check_open_long_lot, m_symbol.Name(), m_symbol.Ask(), sl, tp))
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
               "< Lots (", DoubleToString(check_open_long_lot, 2), ")");
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
   double check_open_short_lot = m_money.CheckOpenShort(m_symbol.Ask(),sl);
   double check_volume_lot = m_trade.CheckVolume(m_symbol.Name(), check_open_short_lot, m_symbol.Bid(), ORDER_TYPE_SELL);

   if(check_volume_lot != 0.0)
     {
      if(check_volume_lot >= check_open_short_lot)
        {
         if(m_trade.Sell(check_open_short_lot, m_symbol.Name(), m_symbol.Bid(), sl, tp))
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
               "< Lots (", DoubleToString(check_open_short_lot, 2), ")");
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
