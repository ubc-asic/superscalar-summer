// Interface between core and QSPI pmod 

module qspi_controller (
    // Clock
    input  wire       clk,

    // Reset
    input  wire       rst_n     // reset_n - low to reset

    // Bi-directional I/O
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
);



endmodule
