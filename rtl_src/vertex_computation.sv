module vertex_computation #(
  parameter COORD_WIDTH = 16,
  parameter SCREEN_X_SIZE = 800,
  parameter SCREEN_Y_SIZE = 600
) (
  input clk,
  input rst,
  input start,
  input [COORD_WIDTH-1:0]vertexes[3][3],
  output [COORD_WIDTH-1:0]vertexes_proj[3][2],
  output [COORD_WIDTH-1:0]normal_vectors[3][2],
  output eoc
);

endmodule