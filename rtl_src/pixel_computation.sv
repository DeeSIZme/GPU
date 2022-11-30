module pixel_computation #(
  parameter COORD_WIDTH = 16,
  parameter COLOR_WIDTH = 16,
  parameter SCREEN_X_SIZE = 800,
  parameter SCREEN_Y_SIZE = 600,
  parameter CORES_COUNT = 10
) (
  input                               clk,
  input                               reset_n,
  input                               start,
  input logic       [COORD_WIDTH-1:0] bound_coefs[3][2],
  input logic     [2*COORD_WIDTH-1:0] bound_const[3],
  input             [COLOR_WIDTH-1:0] color,
  output                              eoc
);

endmodule