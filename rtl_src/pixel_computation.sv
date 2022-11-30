module pixel_computation #(
  parameter COORD_WIDTH = 16,
  parameter COLOR_WIDTH = 16,
  parameter SCREEN_X_SIZE = 800,
  parameter SCREEN_Y_SIZE = 600,
  parameter CORES_COUNT = 10
) (
    input                       clk,
    input                       reset_n,
    input                       start,
    input     [COORD_WIDTH-1:0] bounds[3][3],
    input     [COLOR_WIDTH-1:0] color,
    output                      eoc
);

endmodule