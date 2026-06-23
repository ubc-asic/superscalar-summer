`include "types.svh"

module shifter #(
  parameter int unsigned XLEN        = config_pkg::XLEN,
  parameter int unsigned SLICE_WIDTH = config_pkg::SLICE_WIDTH,

  localparam int unsigned SLICE_ADDR_WIDTH = $clog2(XLEN / SLICE_WIDTH)
) (
  input logic clk_i,
  input logic rst_ni,

  /* Shift direction. 0: left; 1: right. */
  input logic shift_type_i,
  /* Arithmetic shift. */
  input logic shift_arithmetic_i,
  input logic [4:0] shamt_i,

  input slice_t data_i,
  input [SLICE_ADDR_WIDTH-1:0] slice_i,

  output word_t result_o,
  output [SLICE_ADDR_WIDTH-1:0] slice_o
);

  slice_t next_slice_d, next_slice_q;

  /* Slice shift amounts. */
  logic [1:0] shamt1, shamt2;
  assign shamt1 = shamt[1:0];
  assign shamt2 = 4 - shamt1;

  /* Output slice logic. */
  always_comb begin
    if (shift_type_i) begin
      slice_o = slice_i - (shamt_i >> 2);
    end else begin
      slice_o = slice_i + (shamt_i >> 2);
    end
  end

  /* Output logic. */
  always_comb begin
    if (shift_type_i) begin
      if (slice_i == '1) begin
        if (shift_arithmetic_i) begin
          data_o = $signed(data_i) >> shamt1;
        end else begin
          data_o = data_i >> shamt1;
        end
      end else begin
        data_o = next_slice_q | (data_i >> shamt1);
      end
      next_slice_d = data_i << shamt2;
    end else begin
      if (slice_i == '0) begin
        data_o = data_i << shamt1;
      end else begin
        data_o = next_slice_q | (data_i << shamt1);
      end
      next_slice_d = data_i >> shamt2;
    end
  end

  always_ff @(posedge clk_i) begin : next_slice_ff
    if (!rst_ni) begin
      next_slice_q <= '0;
    end else begin
      next_slice_q <= next_slice_d;
    end
  end : next_slice_ff

endmodule : shifter
