/********************* (C) COPYRIGHT 2011 e-Design Co.,Ltd. ********************
                     Sync signal select and control module  
 Version   : FPGA CFG Ver 2.x                                     Author : bure
*******************************************************************************/
module Signal( Reset, Mclk, Trigg_Mode, Vthreshold, XTthreshold, A, B, CD, 
               Sampled, Start); 

  input   Reset;              // Trigger status rst    -> Active high 
  input   Mclk;               // main clock
  input   [ 7:0]Trigg_Mode;   // Trigger Mode 
  input   [ 7:0]Vthreshold;   // Trigger voltage threshold 
  input   [31:0]XTthreshold;  // Trigger time threshold 
  input   [7:0]A;             // Buffered inputs 
  input   [7:0]B;
  input   [1:0]CD;
  input   Sampled;            // Signals end of pre-trigger sampling

  output  Start;              // Sync start            -> Active high 
  reg     Start;

  wire     [ 8:0]Delta_V1;      
  wire     [ 8:0]Delta_V2;
  wire     [ 8:0]Delta_V3;
  wire     [ 8:0]Delta_V4;

  reg     A_Flag;
  reg     A_Dt_L;
  reg     A_Dt_H;
  reg     A_Ut_L;
  reg     A_Ut_H;
  reg     [31:0]A_Cnt;                      //runs continuously while untriggered, using 32 bit reg instead of 12 bit to extend range
   
  reg     B_Flag;
  reg     B_Dt_L;
  reg     B_Dt_H;
  reg     B_Ut_L;
  reg     B_Ut_H;
  reg     [31:0]B_Cnt;
  
  reg     C_Flag;
  reg     C_Dt_L;
  reg     C_Dt_H;
  reg     C_Ut_L;
  reg     C_Ut_H;
  reg     [31:0]C_Cnt;
  
  reg     D_Flag;
  reg     D_Dt_L;
  reg     D_Dt_H;
  reg     D_Ut_L;
  reg     D_Ut_H;
  reg     [31:0]D_Cnt;

  reg  A_Hi;
  reg  A_Lo;
  reg  B_Hi;
  reg  B_Lo;
  reg  A_Rise;
  reg  A_Fall;
  reg  B_Rise;
  reg  B_Fall;

  assign Delta_V1[8:0] = (Vthreshold[7:0] + 12);                                           
  assign Delta_V2[8:0] = (Vthreshold[7:0] - 12); 
  assign Delta_V3[8:0] = (Vthreshold[7:0] + 1);  
  assign Delta_V4[8:0] = (Vthreshold[7:0] - 1);  

  always @( posedge Mclk or posedge Reset ) begin          
    if ( Reset ) begin 
      Start    <= 0;
      A_Dt_L   <= 0;
      A_Dt_H   <= 0;
      A_Ut_L   <= 0;
      A_Ut_H   <= 0;
      B_Dt_L   <= 0;
      B_Dt_H   <= 0;
      B_Ut_L   <= 0;
      B_Ut_H   <= 0;
      C_Dt_L   <= 0;
      C_Dt_H   <= 0;
      C_Ut_L   <= 0;
      C_Ut_H   <= 0;
      D_Dt_L   <= 0;
      D_Dt_H   <= 0;
      D_Ut_L   <= 0;
      D_Ut_H   <= 0;
      A_Hi     <= 0;
      A_Lo     <= 0;
      A_Rise   <= 0;
      A_Fall   <= 0;
      B_Hi     <= 0;
      B_Lo     <= 0;
      B_Rise   <= 0;
      B_Fall   <= 0;
    end else begin

      // For CH_A Trigger
      if ( A > Delta_V3 )begin
        A_Hi   <= Sampled;
      end 
      if ( A < Delta_V4 )begin
        A_Lo   <= Sampled;
      end
      if ( A > Delta_V1 )begin
        A_Rise <= Sampled;
      end 
      if ( A < Delta_V2 )begin
        A_Fall <= Sampled;
      end

      if (( A > Delta_V3 )&&(~A_Flag )) begin
          if ( A_Cnt < XTthreshold)  A_Dt_L <= Sampled;               
          else                       A_Ut_L <= Sampled;               
          A_Flag <= 1;                                      
          A_Cnt  <= 0;
      end else 
      if (( A < Delta_V4 )&&( A_Flag )) begin
          if ( A_Cnt < XTthreshold )  A_Dt_H <= Sampled; 
          else                       A_Ut_H <= Sampled; 
          A_Flag <= 0;
          A_Cnt  <= 0;
      end  else A_Cnt <= A_Cnt + 1; 

      
      // For CH_B Trigger
      if ( B > Delta_V3 )begin
        B_Hi   <= Sampled;                                                    
      end 
      if ( B < Delta_V4 )begin
        B_Lo   <= Sampled;
      end
      if ( B > Delta_V1 )begin
        B_Rise <= Sampled;
      end
      if ( B < Delta_V2 )begin
        B_Fall <= Sampled;
      end    

      if (( B > Delta_V3 )&&(~B_Flag )) begin
          if ( B_Cnt < XTthreshold )  B_Dt_L <= Sampled;
          else                       B_Ut_L <= Sampled;
          B_Flag <= 1;
          B_Cnt  <= 0;
      end else
      if (( B < Delta_V4 )&&( B_Flag )) begin
          if ( B_Cnt < XTthreshold )  B_Dt_H <= Sampled;
          else                       B_Ut_H <= Sampled;
          B_Flag <= 0;
          B_Cnt  <= 0;
      end  else B_Cnt <= B_Cnt + 1; 


      // For CH_C Trigger
      if ( CD[0] != C_Flag ) begin
        if ( C_Cnt < XTthreshold ) begin
          if ( CD[0] )  C_Dt_L <= Sampled;
          else                               C_Dt_H <= Sampled;
        end else begin
          if ( CD[0] )  C_Ut_L <= Sampled;
          else                               C_Ut_H <= Sampled;
        end 
        C_Cnt <= 0;
      end else  C_Cnt <= C_Cnt + 1; 
      C_Flag <= CD[0]; 
       
      // For CH_D Trigger
      if ( CD[1] != D_Flag ) begin
        if ( D_Cnt < XTthreshold ) begin
          if ( CD[1] )  D_Dt_L <= Sampled;
          else                               D_Dt_H <= Sampled;
        end else begin
          if ( CD[1] )  D_Ut_L <= Sampled;
          else                               D_Ut_H <= Sampled;
        end  
        D_Cnt <= 0;
      end else  D_Cnt <= D_Cnt + 1; 
      D_Flag <= CD[1]; 

    
      case( Trigg_Mode )
        // For CH_A Trigger
        8'h00: if ( A < Vthreshold ) Start <= A_Rise;     // Negedge  
        8'h01: if ( A > Vthreshold ) Start <= A_Fall;     // Posedge 
        8'h02: if ( A < Vthreshold ) Start <= A_Hi;       // L Level 
        8'h03: if ( A > Vthreshold ) Start <= A_Lo;       // H Level
        8'h04: Start <= A_Dt_L;                                                      // Pulse 0 < ConfigDt
        8'h05: Start <= A_Ut_L;                                                      // Pulse 0 > ConfigDt
        8'h06: Start <= A_Dt_H;                                                      // Pulse 1 < ConfigDt
        8'h07: Start <= A_Ut_H;                                                      // Pulse 1 > ConfigDt

        // For CH_B Trigger
        8'h08: if ( B < Vthreshold ) Start <= B_Rise;     // Negedge
        8'h09: if ( B > Vthreshold ) Start <= B_Fall;     // Posedge
        8'h0A: if ( B < Vthreshold ) Start <= B_Hi;       // L Level
        8'h0B: if ( B > Vthreshold ) Start <= B_Lo;       // H Level
        8'h0C: Start <= B_Dt_L;                                                      // Pulse 0 < ConfigDt
        8'h0D: Start <= B_Ut_L;                                                      // Pulse 0 > ConfigDt
        8'h0E: Start <= B_Dt_H;                                                      // Pulse 1 < ConfigDt
        8'h0F: Start <= B_Ut_H;                                                      // Pulse 1 > ConfigDt

        // For CH_C Trigger
        8'h10: if (( ~CD[0] )&&(  C_Flag ))  Start <= Sampled;  // Negedge
        8'h11: if ((  CD[0] )&&( ~C_Flag ))  Start <= Sampled;  // Posedge
        8'h12: if (( ~CD[0] )&&(  C_Flag ))  Start <= Sampled;  // L Level
        8'h13: if ((  CD[0] )&&( ~C_Flag ))  Start <= Sampled;  // H Level
        8'h14: Start <= C_Dt_L; // Pulse 0 < ConfigDt
        8'h15: Start <= C_Ut_L; // Pulse 0 > ConfigDt
        8'h16: Start <= C_Dt_H; // Pulse 1 < ConfigDt
        8'h17: Start <= C_Ut_H; // Pulse 1 > ConfigDt
        // For CH_D Trigger
        8'h18: if (( ~CD[1] )&&(  D_Flag ))  Start <= Sampled;  // Negedge
        8'h19: if ((  CD[1] )&&( ~D_Flag ))  Start <= Sampled;  // Posedge
        8'h1A: if (( ~CD[1] )&&(  D_Flag ))  Start <= Sampled;  // L Level
        8'h1B: if ((  CD[1] )&&( ~D_Flag ))  Start <= Sampled;  // H Level
        8'h1C: Start <= D_Dt_L; // Pulse 0 < ConfigDt
        8'h1D: Start <= D_Ut_L; // Pulse 0 > ConfigDt
        8'h1E: Start <= D_Dt_H; // Pulse 1 < ConfigDt
        8'h1F: Start <= D_Ut_H; // Pulse 1 > ConfigDt
        8'h20: Start <= 1;      //Uncondition trig mode

      endcase
    end
  end
endmodule