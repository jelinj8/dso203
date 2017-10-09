	/********************* (C) COPYRIGHT 2011 e-Design Co.,Ltd. ********************
             Pre-sampling FIFO address counter and control module  
 Version   : FPGA CFG Ver 2.x                                     Author : bure
*******************************************************************************/
module AddrCtrl (Counter, OS_Size, FreeRun, ClrW, Wclk, Start, nRclk, RE, H_L, PerCnt,           // Depth, PerCnt, Delay,
                  Ready, Sampled, Full, Empty, Wptr, Rptr);     

  input   [15:0]Counter;// Oversampling mode OS sample counter
  input   [15:0]OS_Size;// Oversampling mode OS factor
  input   FreeRun;      // Flag for non triggered synchronized free running AUTO timebase mode
  input	  ClrW;         // Wr addr cnt rst      -> Active high 
  input	  Wclk;         // Wr clock             -> rising edge 
  input	  Start;        // Sync start           -> active high 
  input   nRclk;        // Rd clock             -> falling edge
  input   RE;           // Rd cnt enable        -> active high
  input   H_L;          // Data output select   -> 1/0: [17:16]/[15: 0]Dout->[15:0]DB
  input   [15:0]PerCnt; // Pre-sampling counter                        
  
  output  Sampled;      // Pre-sampling finish  -> active high
  output  Ready;        // Sampling start       -> active high
  output  Full;         // FIFO RAM is full     -> active high
  output  Empty;        // FIFO RAM is empty    -> active high
  output  [11:0]Wptr;   // written address pointer
  output  [11:0]Rptr;   // Read address pointer

  reg     Full;
  reg     Ready; 
  reg     Loaded;       // marked the Start address loaded ok   
  reg     [11:0]Wptr;
  reg     [11:0]Rptr;
  reg     [12:0]Pcnt;   
  reg     [11:0]Bptr;
  reg     [1:0]DelayCnt;  
  reg     Sampled;
  reg     Empty;

  always@ ( posedge Wclk or posedge ClrW ) begin
    if ( ClrW ) begin
        Full <= 0;
        Pcnt <= 0;
        Sampled  <= 0;
        DelayCnt <= 2'b00;  
        Ready    <= 0;              
    end else begin

      if ((Empty)&&(!Start)&&(FreeRun)) begin                                    
        Sampled <= 0;         
        Full <= 0;                                                                 
        Pcnt <= 0;            
        Wptr <= 0;                                                             
      end                              

      if ((Start)&&(DelayCnt<3))begin                                           
        if(Counter==0)DelayCnt <= DelayCnt+1;
      end

      if ( Pcnt >= PerCnt ) Sampled <= 1;

      if (!Full) begin
        if(OS_Size)begin
          if(Counter<2)Wptr <= Wptr + 1;              
        end else Wptr <= Wptr + 1;
      end

      if(OS_Size)begin
        if(Pcnt>=2047)begin                                                 
          if ((FreeRun==0)||(Start==1)) Full <= Ready; else Full <= 1; 
        end else if(Counter>=OS_Size)Pcnt <= Pcnt +1;
      end else begin
        if ( Pcnt >= 4095 )begin                                                   
          if ((FreeRun==0)||(Start==1)) Full <= Ready; else Full <= 1; 
        end  else Pcnt <= Pcnt +1;
      end

      if( (!Start )&&(FreeRun==0)&&(Pcnt >= PerCnt) ) Pcnt <= PerCnt;              

      if ( DelayCnt == 1 ) begin                                            
        if(Counter==0)begin                                                 
          Ready <= 1;              
          Bptr  <= Wptr;
          Pcnt  <= PerCnt; 
        end
      end 

    end 
  end

  always @ (Rptr or Wptr) if ( Rptr == Wptr ) Empty <= 1; else Empty <=0;       //read/write "splice"

  always @( posedge nRclk or posedge ClrW ) begin
    if ( ClrW ) begin
      Loaded <= 0; 
      Rptr <= 0;   
    end else begin
      if ( ( H_L ) && RE && (~Loaded) && (Start) )begin 
        Loaded <= 1;                                       
        if(OS_Size)Rptr<=Bptr-(PerCnt*2);             
          else Rptr<=Bptr-PerCnt;                                                
      end else if ( H_L && RE ) Rptr <= Rptr + 1;
    end  
  end

endmodule



