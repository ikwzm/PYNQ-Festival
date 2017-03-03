module fib
  (
    input wire clk,
    input wire rst,
    input wire fib_ready,
    input wire fib_accept,
    output reg fib_valid,
    input wire signed [31:0] fib_in_n,
    output reg signed [31:0] fib_out_0
    
  );

  //localparams
  localparam fib_b1_INIT = 0;
  localparam fib_b1_S1 = 1;
  localparam fib_ifthen3_S0 = 2;
  localparam fib_ifelse4_S1 = 3;
  localparam fib_ifthen6_S0 = 4;
  localparam fib_ifelse7_S0 = 5;
  localparam fib_forelse11_S1 = 6;
  localparam fib_exit2_FINISH = 7;
  localparam L1_fortest9_S0 = 8;
  localparam L1_fortest9_S1 = 9;
  localparam L1_forbody10_S0 = 10;
  localparam L1_continue12_S0 = 11;
  localparam L1_continue12_S1 = 12;
  
  //signals: 
  reg        [3:0] fib_state;
  reg signed [31:0] r14;
  reg signed [31:0] i4;
  reg signed [31:0] r03;
  wire cond25;
  wire cond22;
  reg signed [31:0] t243;
  reg signed [31:0] i3;
  reg signed [31:0] n1;
  reg signed [31:0] r13;
  wire cond23;
  //combinations: 
  assign cond22 = (n1 <= 0);
  assign cond23 = (n1 == 1);
  assign cond25 = (i3 < t243);
  
  always @(posedge clk) begin
    if (rst) begin
      fib_state <= fib_b1_INIT;
    end else begin //if (rst)
      case(fib_state)
      fib_b1_INIT: begin
        if (fib_ready == 1) begin
          n1 <= fib_in_n;
          fib_valid <= 0;
          fib_state <= fib_b1_S1;
        end
      end
      fib_b1_S1: begin
        if (cond22) begin
          fib_state <= fib_ifthen3_S0;
        end else if (1) begin
          fib_state <= fib_ifelse4_S1;
        end
      end
      fib_ifthen3_S0: begin
        fib_out_0 <= 0;
        fib_state <= fib_exit2_FINISH;
      end
      fib_ifelse4_S1: begin
        if (cond23) begin
          fib_state <= fib_ifthen6_S0;
        end else if (1) begin
          fib_state <= fib_ifelse7_S0;
        end
      end
      fib_ifthen6_S0: begin
        fib_out_0 <= 1;
        fib_state <= fib_exit2_FINISH;
      end
      fib_ifelse7_S0: begin
        i3 <= 0;
        r03 <= 0;
        r13 <= 1;
        fib_state <= L1_fortest9_S0;
      end
      fib_forelse11_S1: begin
        fib_out_0 <= r13;
        fib_state <= fib_exit2_FINISH;
      end
      fib_exit2_FINISH: begin
        fib_valid <= 1;
        if (fib_accept == 1) begin
          fib_state <= fib_b1_INIT;
        end
      end
      L1_fortest9_S0: begin
        t243 <= (n1 - 1);
        fib_state <= L1_fortest9_S1;
      end
      L1_fortest9_S1: begin
        if (cond25) begin
          fib_state <= L1_forbody10_S0;
        end else if (1) begin
          fib_state <= fib_forelse11_S1;
        end
      end
      L1_forbody10_S0: begin
        r14 <= (r03 + r13);
        fib_state <= L1_continue12_S0;
      end
      L1_continue12_S0: begin
        i4 <= (i3 + 1);
        r03 <= r13;
        fib_state <= L1_continue12_S1;
      end
      L1_continue12_S1: begin
        i3 <= i4;
        r13 <= r14;
        fib_state <= L1_fortest9_S0;
      end
      endcase
    end
  end
  

endmodule

