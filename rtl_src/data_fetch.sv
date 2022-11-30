module data_fetch #(
    parameter ADDR_WIDTH = 32,
    parameter COORD_WIDTH = 16,
    parameter COLOR_WIDTH = 16
) (
    input clk,
    input rst,
    input start,
    input [ADDR_WIDTH-1:0]addr_vertex,
    input [ADDR_WIDTH-1:0]addr_colors,
    output logic [COLOR_WIDTH-1:0]colors,
    output logic [COORD_WIDTH-1:0]vertexes[3][3],
    output logic eoc
  );

endmodule