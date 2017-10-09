/********************* (C) COPYRIGHT 2011 e-Design Co.,Ltd. ********************
                          Input & output control module  
 Version   : FPGA CFG Ver 2.x                                     Author : bure
*******************************************************************************/

module IO_Ctrl(CE, nRD, SCK, SDA, Dout, Start, Full, Empty, H_L, C_D, Ready,  
                PerCnt, nPD, Trigg_Mode, Vthreshold, XTthreshold, CtrlReg, DB, FreeRun, OS_Size); 

  input     CE;                 // Databus selece enable -> Active high
  input     nRD;                // Databus read enable   -> Active low
  input     SCK;                // Serial input clock    -> rising edge 
  input     SDA;                // Serial input data 
  input     [17:0]Dout;         // Output data                     
  input     Start;              // Sync start            -> active high
  input     Ready;              // Sampling start        -> active high
  input     Full;               // FIFO RAM is full      -> active high
  input     Empty;              // FIFO RAM is empty     -> active high
  input     H_L;                // 0/1 = Status/[15:0]Din -> [15:0]DB
  input     C_D;                // 1 = [15:0]Data        -> [15:0]DB

  output    [15:0]PerCnt;       // Per-sampling counter                        
  output    nPD;                // ADC power down        -> Active low
  output    [ 7:0]Trigg_Mode;   // Trigger Mode 
  output    [ 7:0]Vthreshold;   // Trigger voltage threshold 
  output    [ 31:0]XTthreshold; // Trigger time threshold 
  output    [ 7:0]CtrlReg;      // bit0=nPD, bit1=Mode, 
  inout     [15:0]DB;           // Data bus to MCU
  output    FreeRun;
  output    [15:0]OS_Size;

  reg       [ 7:0]Trigg_Mode;   // Trigger Mode 
  reg       [ 7:0]Vthreshold;   // Trigger voltage threshold 
  reg       [ 31:0]XTthreshold;   // Trigger time threshold 
  reg       [ 7:0]CtrlReg;
  reg       [ 7:0]RegAddr;
  reg       [ 7:0]DataBuff;
  wire      [15:0]DB_Mux ; 
  reg       [ 7:0]Select;
  wire      [15:0]CD_Mux ; 
  reg       [15:0]PerCnt;                         
  reg       [15:0]Data/* synthesis syn_preserve=1 */;
  reg       FreeRun;
  reg       [15:0]OS_Size;
   
  assign nPD = CtrlReg[0];
  assign CD_Mux = C_D ? Data[15:0] : { 10'h000, Start, Empty, Full, Ready, Dout[17:16] };  //Program uses Ready (2) as start flag
  assign DB_Mux = H_L ? Dout[15:0] : CD_Mux;  
  assign DB = ( CE && !nRD ) ? DB_Mux : 16'hzzzz ;
  
  always @(posedge SCK) begin
    DataBuff  = { DataBuff[6:0], SDA };
  end

  always @( posedge SDA ) begin
    if ( !SCK ) begin
      if ( H_L ) begin
        RegAddr  = DataBuff;
        case(Select)
          8'h00: Data<={8'h57,8'h31};   //For FPGA version ID: Ascii chars "W1" identifies revised fpga  
          8'h01: Data<= 16'h0101;       //Sub-version, identifies updates
        default: Data<=0;
        endcase

      end else begin
        case( RegAddr )
          8'h00:  begin 
            Trigg_Mode = DataBuff;    
            PerCnt     = 150;
          end
          8'h01:  Vthreshold[ 7:0]  = DataBuff;    
          8'h02:  XTthreshold[ 7:0]  = DataBuff;    
          8'h03:  XTthreshold[15:8]  = DataBuff;    
          8'h04:  CtrlReg   [ 7:0]  = DataBuff;    
          8'h05:  Select    [ 7:0]  = DataBuff;    

          8'h08:  PerCnt    [ 7:0]  = DataBuff;                         
          8'h09:  PerCnt    [15:8]  = DataBuff;                         

          8'h0E:  FreeRun           = DataBuff[0];      
          8'h0F:  OS_Size   [ 7:0]  = DataBuff;
          8'h10:  OS_Size   [15:8]  = DataBuff;
          8'h11:  XTthreshold[23:16]  = DataBuff;
          8'h12:  XTthreshold[31:24]  = DataBuff;
        endcase 
      end               //if H_L, else
    end                 //if (!SCK)  
  end                   //always @(posedge SDA)

endmodule