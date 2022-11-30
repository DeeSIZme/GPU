module pixel_computation #(
  parameter COORD_WIDTH = 16,
  parameter COLOR_WIDTH = 16,
  parameter SCREEN_X_SIZE = 800,
  parameter SCREEN_Y_SIZE = 600,
  parameter CORES_COUNT = 10
) (
    input clk,
    input rst,
    input start,
    input [COORD_WIDTH-1:0]vertexes_proj[3][2],
    input [COORD_WIDTH-1:0]normal_vectors[3][2],
    input [COLOR_WIDTH-1:0]color,
    output eoc
);

endmodule