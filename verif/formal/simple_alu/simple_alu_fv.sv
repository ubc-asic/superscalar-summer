// Formal verification module for simple_alu.
// All ports are inputs - this module only observes DUT signals, never drives them.
// Instantiated via bind in simple_alu_bind.sv.
module simple_alu_fv (
    input logic        clk,
    input logic [31:0] a,
    input logic [31:0] b,
    input logic        sel,
    input logic        rst,

    input logic [31:0] y,
    input logic        overflow
  );

    //assertion check: if rst deasserted, y tied to 0
    //assertions are what we want to prove, formal verification is the engine that proves it
    // property p_rst_y;          
    //     @(posedge clk)
    //     ~rst |=> (y=='0);      
    // endproperty
    // a_rst_y: assert property (p_rst_y)
    //     else $error("RESET CHECK FAILED: rst=%0b y=%0h, expected y=0", rst, y);

    // Reset check
    a_rst_y: assert property (
        @(posedge clk) ~rst |-> (y == '0)
    ) else $error("RESET CHECK FAILED: rst=%0b y=%0h expected 0", rst, y);

endmodule
