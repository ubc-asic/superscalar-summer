module ci_test #(
  /* explicit-parameter-storage-type will fail. */
  parameter WIDTH = 8
) (
  /* port-name-suffix will fail. */
  input clk,
  input [WIDTH-1:0] in,
  output [WIDTH-1:0] out
);

  /* enum-name-style will fail. */
  typedef enum logic {
    READ,
    WRITE
  } access;

  /* always-comb will fail. */
  always @(*) begin
    out = in;
  end

endmodule : ci_test
