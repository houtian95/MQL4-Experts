//+------------------------------------------------------------------+
//                        DO NOT DELETE THIS HEADER
//             DELETING THIS HEADER IS COPYRIGHT INFRIGMENT 
//
//                   Copyright ©2011, ForexEAdvisor.com
//                 ForexEAdvisor Strategy Builder version 0.2
//                        http://www.ForexEAdvisor.com 
//
// THIS EA CODE HAS BEEN GENERATED USING FOREXEADVISOR STRATEGY BUILDER 0.2 
// on: 8/24/2016 7:54:04 AM
// Disclaimer: This EA is provided to you "AS-IS", and ForexEAdvisor disclaims any warranty
// or liability obligations to you of any kind. 
// UNDER NO CIRCUMSTANCES WILL FOREXEADVISOR BE LIABLE TO YOU, OR ANY OTHER PERSON OR ENTITY,
// FOR ANY LOSS OF USE, REVENUE OR PROFIT, LOST OR DAMAGED DATA, OR OTHER COMMERCIAL OR
// ECONOMIC LOSS OR FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, STATUTORY, PUNITIVE,
// EXEMPLARY OR CONSEQUENTIAL DAMAGES WHATSOEVER RELATED TO YOUR USE OF THIS EA OR 
// FOREXEADVISOR STRATEGY BUILDER     
// Because software is inherently complex and may not be completely free of errors, you are 
// advised to verify this EA. Before using this EA, please read the ForexEAdvisor Strategy Builder
// license for a complete understanding of ForexEAdvisor' disclaimers.  
// USE THIS EA AT YOUR OWN RISK. 
//  
// Before adding this expert advisor to a chart, make sure there are NO
// open positions.
//                      DO NOT DELETE THIS HEADER
//             DELETING THIS HEADER IS COPYRIGHT INFRIGMENT 
//+------------------------------------------------------------------+


extern int MagicNumber=10001;
extern double Lots =0.1;
extern double StopLoss=30;
extern double TakeProfit=80;
extern int TrailingStop=50;
extern int Slippage=3;
//+------------------------------------------------------------------+
//    expert start function
//+------------------------------------------------------------------+
int start()
{
  double MyPoint=Point;
  if(Digits==3 || Digits==5) MyPoint=Point*10;
  
  double TheStopLoss=0;
  double TheTakeProfit=0;
  if( TotalOrdersCount()==0 ) 
  {
     int result=0;
     if((iRSI(NULL,PERIOD_H1,14,PRICE_CLOSE,0)<30)&&(iADX(NULL,PERIOD_H1,14,PRICE_CLOSE,MODE_MAIN,0)>25)) // Here is your open buy rule
     {
        result=OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,0,"EA Generator www.ForexEAdvisor.com",MagicNumber,0,Blue);
        if(result>0)
        {
         TheStopLoss=0;
         TheTakeProfit=0;
         if(TakeProfit>0) TheTakeProfit=Ask+TakeProfit*MyPoint;
         if(StopLoss>0) TheStopLoss=Ask-StopLoss*MyPoint;
         OrderSelect(result,SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),0,Green);
        }
        return(0);
     }
     if((iRSI(NULL,PERIOD_H1,14,PRICE_CLOSE,0)>70)&&(iADX(NULL,PERIOD_H1,14,PRICE_CLOSE,MODE_MAIN,0)>25)) // Here is your open Sell rule
     {
        result=OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,0,"EA Generator www.ForexEAdvisor.com",MagicNumber,0,Red);
        if(result>0)
        {
         TheStopLoss=0;
         TheTakeProfit=0;
         if(TakeProfit>0) TheTakeProfit=Bid-TakeProfit*MyPoint;
         if(StopLoss>0) TheStopLoss=Bid+StopLoss*MyPoint;
         OrderSelect(result,SELECT_BY_TICKET);
         OrderModify(OrderTicket(),OrderOpenPrice(),NormalizeDouble(TheStopLoss,Digits),NormalizeDouble(TheTakeProfit,Digits),0,Green);
        }
        return(0);
     }
  }
  
  for(int cnt=0;cnt<OrdersTotal();cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL &&   
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber 
         )  
        {
         if(OrderType()==OP_BUY)  
           {
              if((iRSI(NULL,PERIOD_H1,14,PRICE_CLOSE,0)>70)||(iADX(NULL,PERIOD_H1,14,PRICE_CLOSE,MODE_MAIN,0)<25)) //here is your close buy rule
              {
                   OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Red);
              }
            if(TrailingStop>0)  
              {                 
               if(Bid-OrderOpenPrice()>MyPoint*TrailingStop)
                 {
                  if(OrderStopLoss()<Bid-MyPoint*TrailingStop)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TrailingStop*MyPoint,OrderTakeProfit(),0,Green);
                     return(0);
                    }
                 }
              }
           }
         else 
           {
                if((iRSI(NULL,PERIOD_H1,14,PRICE_CLOSE,0)<30)||(iADX(NULL,PERIOD_H1,14,PRICE_CLOSE,MODE_MAIN,0)<25)) // here is your close sell rule
                {
                   OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),Slippage,Red);
                }
            if(TrailingStop>0)  
              {                 
               if((OrderOpenPrice()-Ask)>(MyPoint*TrailingStop))
                 {
                  if((OrderStopLoss()>(Ask+MyPoint*TrailingStop)) || (OrderStopLoss()==0))
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+MyPoint*TrailingStop,OrderTakeProfit(),0,Red);
                     return(0);
                    }
                 }
              }
           }
        }
     }
   return(0);
}

int TotalOrdersCount()
{
  int result=0;
  for(int i=0;i<OrdersTotal();i++)
  {
     OrderSelect(i,SELECT_BY_POS ,MODE_TRADES);
     if (OrderMagicNumber()==MagicNumber) result++;

   }
  return (result);
}
