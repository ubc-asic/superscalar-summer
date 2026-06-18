/* SPDX-License-Identifier: CERN-OHL-P-2.0 */

/**
 * @brief  Formal verification of regfile requirements
 * @author Warrick Lo
 */

`include "types.svh"

module regfile_ind (
  input logic clk_i,
  input logic rst_ni,
  input logic [1:0] slice_sel_i,

  input logic [1:0][3:0] raddr_i,

  input logic wen_i,
  input logic [3:0] waddr_i,
  input logic [7:0] wdata_i
);

  word_bank_t register;
  logic [1:0][7:0] rdata;

  regfile #(
    .XLEN(32),
    .SLICE_WIDTH(8),
    .ADDR_WIDTH(4),
    .NUM_READ_PORTS(2)
  ) dut (
    .register_dbg(register),
    .clk_i,
    .rst_ni,
    .slice_sel_i,

    .raddr_i,
    .rdata_o(rdata),

    .wen_i,
    .waddr_i,
    .wdata_i
  );

  /* Assert reset (active low) and clear register.
   * Requirement DR-REGFILE-053 cannot be verified in this module
   * as we need to verify the behaviour of register 0 without
   * any prior reset assertions. */

  initial assume (rst_ni == '0);
  initial assume (register == '0);

  /* DR-REGFILE-010:
   * The module must store NUM_WORDS words, each XLEN bits wide.
   *
   * Notes: This verification module assumes NUM_WORDS = 16 and XLEN = 32.
   *        The definition of 'register' must use the type defined
   *        in types.svh. */

  initial assert ($bits(register) == 16 * 32);

  /* DR-REGFILE-030:
   * Register contents must be 0 at most one clock after the
   * synchronous reset is asserted. */

  always_ff @(posedge clk_i) begin
    if ($past(!rst_ni, 1)) begin
      assert (register == '0);
    end
  end

  /* DR-REGFILE-052:
   * The read output rdata[i] must be zero when raddr[i] is zero,
   * regardless of any prior writes to register 0. */

  always_comb begin
    if (raddr_i[0] == '0) assert (rdata[0] == '0);
    if (raddr_i[1] == '0) assert (rdata[1] == '0);
  end

endmodule : regfile_ind
