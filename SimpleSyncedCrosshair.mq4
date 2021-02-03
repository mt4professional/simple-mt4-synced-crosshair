//+------------------------------------------------------------------+
//|                                              SyncedCrosshair.mq4 |
//|                                           Resilient Traders, LLC |
//|                                  https://www.mt4professional.com |
//+------------------------------------------------------------------+
#property copyright "Resilient Traders, LLC"
#property link      "https://www.mt4professional.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   IndicatorSetString(INDICATOR_SHORTNAME,"MT4ProfessionalSimpleSyncedCrosshair");
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, true);
   SetupLines();
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

//--- return value of prev_calculated for next call
   return(rates_total);
  }

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
    MoveCrossHair(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+


void SetupLines(){
    ObjectDelete(0, "MT4ProfessionalSimpleVLine");
    ObjectCreate(0, "MT4ProfessionalSimpleVLine", OBJ_VLINE, 0, TimeGMT(), 0);
    ObjectSetInteger(0, "MT4ProfessionalSimpleVLine", OBJPROP_COLOR, clrBlue);
    ObjectSetInteger(0, "MT4ProfessionalSimpleVLine", OBJPROP_STYLE, STYLE_DASH);
    ObjectSetInteger(0, "MT4ProfessionalSimpleVLine", OBJPROP_WIDTH, 1);
    ObjectSetInteger(0, "MT4ProfessionalSimpleVLine", OBJPROP_SELECTABLE, false);
    ObjectSetString(0, "MT4ProfessionalSimpleVLine", OBJPROP_TOOLTIP, "\n");
    ObjectDelete(0, "MT4ProfessionalSimpleHLine");
    ObjectCreate(0, "MT4ProfessionalSimpleHLine", OBJ_HLINE, 0, TimeGMT(), SymbolInfoDouble(Symbol(),SYMBOL_BID));
    ObjectSetInteger(0, "MT4ProfessionalSimpleHLine", OBJPROP_COLOR, clrBlue);
    ObjectSetInteger(0, "MT4ProfessionalSimpleHLine", OBJPROP_STYLE, STYLE_DASH);
    ObjectSetInteger(0, "MT4ProfessionalSimpleHLine", OBJPROP_WIDTH, 1);
    ObjectSetInteger(0, "MT4ProfessionalSimpleHLine", OBJPROP_SELECTABLE    , false);
    ObjectSetString(0, "MT4ProfessionalSimpleHLine", OBJPROP_TOOLTIP, "\n");
}

void MoveCrossHair(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam){
    if(id != CHARTEVENT_MOUSE_MOVE) return;

    int x = (int)lparam;
    int y = (int)dparam;
    datetime dt    =0;
    double   price =0;
    int      window=0;

    if(ChartXYToTimePrice(0,x,y,window,dt,price))
    {

        long currentChart = ChartFirst();
        while(currentChart >= 0){
            if(currentChart >= 0 && ObjectFind("MT4ProfessionalSimpleVLine") >= 0){
                ObjectMove(currentChart,"MT4ProfessionalSimpleVLine",0,dt,0);
                ObjectMove(currentChart,"MT4ProfessionalSimpleHLine",0,0,price);
                if(currentChart != ChartID()){
                    int BarBack = (int)(-iBarShift( ChartSymbol(currentChart), ChartPeriod(currentChart), dt, false) + ChartGetInteger(currentChart,CHART_VISIBLE_BARS)/2);
                    ChartNavigate(currentChart,CHART_END,BarBack);
                }
                ChartRedraw(currentChart);
            }
            currentChart = ChartNext(currentChart);
        }
    }
}