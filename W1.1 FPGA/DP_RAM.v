/********************* (C) COPYRIGHT 2011 e-Design Co.,Ltd. ********************
                       4096 * 18Bits dual-port SRAM module  
 Version   : FPGA CFG Ver 2.x                                     Author : bure
*******************************************************************************/

module DP_RAM ( OS_Size, Din, Wclk, nRclk, Waddr, Raddr, Dout, Counter, A, B, CD );

  input  [15:0]OS_Size;                                 // Oversampling factor control
  input  Wclk;                                          // Wr clock       -> rising edge
  input  nRclk;                                         // Rd clock       -> falling edge
  input  [11:0]Waddr;                                   // written address
  input  [11:0]Raddr;                                   // read address
  input  [17:0]Din;                                     // input data
  output [17:0]Dout;                                    // output data
  output [15:0]Counter;
  output [7:0]A;                                        // Output buffered input channel data to triggering (signal) section
  output [7:0]B;
  output [1:0]CD;
  reg [15:0] Counter;                                   // Oversampling mode sample counter
  reg [7:0] ACC_A[1:0];                                 // Data accumulator/transfer
  reg [7:0] ACC_B[1:0];                                 // Data accumulator/transfer
  reg [17:0] Dout;                                      // Data out/high level output
  reg [17:0] Mem_data [4095:0];  
  reg [17:0]TrigBuf[3:0] /* synthesis syn_noprune=1 */; // Trig buffer, holds 4 last ADC values
  reg [1:0]TrigBufAddr;                                 // 2 bit Trig buffer address, holds index to 4 TrigBuf subscripts

  reg [1:0]  Multi;                                     // Holds either chC/D or Oversampling index flag
  reg [7:0]A;
  reg [7:0]B;
  reg [1:0]CD;

  always @( posedge Wclk ) begin                                    
    TrigBuf[TrigBufAddr]<=Din;                                             //load latest data from ADC into 4 sample buffer
    TrigBufAddr <= TrigBufAddr+1;
    A<=TrigBuf[TrigBufAddr-2][ 7:0];                                       //Used for both triggering and data transfer
    B<=TrigBuf[TrigBufAddr-2][15:8];                                 
    CD<=TrigBuf[TrigBufAddr-2][17:16];

    if(Counter<2)begin                                                     //in OS mode, writes 0-1 data sequence, kept at 0 in non OS mode                                                     
      if(OS_Size)begin                                                     //OS_Size>0 denotes oversampling mode on
        Multi<= 2'b01;                                                     //Reset Multi synch flag for OS lo/hi data (active low)
      end else Multi<=CD;                                                  //if in non OS mode, use to carry ch C/D data  
      Mem_data[Waddr]<= {Multi,ACC_B[Counter],ACC_A[Counter]};             //load low, high data sequentially
    end                                                                        

    if(OS_Size)begin
      if(Counter>=OS_Size)begin                                            //Load OS data
        Counter<=0;                                                        //Reset
        Multi<=2'b00;                                                      //Synch flag for program (low active)
      end else  Counter<=Counter + 1;                                      //Advance counter in OS mode
    end else begin
      Counter<=0;                                                          //Keep at 0 for non OS modes
    end

    if(Counter==0)begin                                                    //reset to first acquired samples 
      ACC_A[0]<=A;                                                         //Also used for transfer in non OS modes
      ACC_B[0]<=B; 
    end else begin
      if(Counter==1)begin
        if(A>ACC_A[0])ACC_A[1]<=A;                                         //load highest of 2 first samples in high ACC as reset
          else ACC_A[1]<=ACC_A[0];
        if(B>ACC_B[0])ACC_B[1]<=B;
          else ACC_B[1]<=ACC_B[0];
      end else begin                                                       //Update accumulators
        if(A>ACC_A[1])ACC_A[1]<=A;                  
        if(B>ACC_B[1])ACC_B[1]<=B;
      end
      if(A<ACC_A[0])ACC_A[0]<=A;
      if(B<ACC_B[0])ACC_B[0]<=B;
    end

  end

  always @( negedge nRclk ) begin
    Dout<=Mem_data[Raddr];                              
  end

endmodule




