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
#include <Trade\TerminalInfo.mqh>
CTerminalInfo TerminalInfo;

void OnStart()
{
  //---
  //当前为2007
  Print("客户终端集成构建的版本号:",TerminalInfo.Build());
  Print("获取有关与交易服务器连接的信息:",TerminalInfo.IsConnected());
  Print("获取有关使用 DLL 权限的信息:",TerminalInfo.IsDLLsAllowed());
  Print("获取有关交易权限的信息:",TerminalInfo.IsTradeAllowed());
  Print("允许获取发送电子邮件至 SMTP 服务器:",TerminalInfo.IsEmailEnabled());
  Print("允许发送交易报告至 FTP 服务器:",TerminalInfo.IsEmailEnabled());
  Print("获取客户端设置里指定的图表最大柱线数量:",TerminalInfo.MaxBars());
  Print("获取有关客户终端语言代码页的信息:",TerminalInfo.CodePage());
  Print("获取有关系统中 CPU 核心数量的信息:",TerminalInfo.CPUCores());
  Print("获取有关物理内存的信息:",TerminalInfo.MemoryPhysical());
  Print("获取有关提供给终端/代理的总内存的信息 (以兆字节为单位):",TerminalInfo.MemoryTotal());
  Print("获取有关提供给终端/代理的总内存的信息 (以兆字节为单位):",TerminalInfo.MemoryAvailable());
  Print("获取有关终端/代理进程使用内存的信息 (以兆字节为单位):",TerminalInfo.MemoryAvailable());
  Print("获取有关客户终端类型的信息 (32/64 位):",TerminalInfo.IsX64());
  Print("获取有关提供给终端/代理的自由硬盘空间的信息 (以兆字节为单位):",TerminalInfo.DiskSpace());
  Print("获取有关客户终端语言的信息:",TerminalInfo.Language());
  Print("获取有关客户终端名称信息:",TerminalInfo.Name());
  Print("获取有关经纪商名称的信息:",TerminalInfo.Company());
  Print("获取客户终端文件夹:",TerminalInfo.Path());
  Print("获取有关终端数据文件夹的信息:",TerminalInfo.DataPath());
  Print("获取安装在电脑上的客户终端公用数据文件夹:",TerminalInfo.CommonDataPath());
}
//+------------------------------------------------------------------+
