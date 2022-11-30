module vertex_computation #(
  parameter COORD_WIDTH = 16,
  parameter SCREEN_X_SIZE = 800,
  parameter SCREEN_Y_SIZE = 600
) (
  input clk,
  input rst,
  input start,
  input [COORD_WIDTH-1:0]vertexes[3][3],
  output [COORD_WIDTH-1:0]bounds[3][3],
  output eoc
);

wire [COORD_WIDTH-1:0]bounds[3][2];
assign eoc = '1;

always_comb begin
  for (int i=0; i<MAX; ++i) begin
        int j = (i+1)%3; // next vertex
        next_bounds[i][0] = vertexes[i][1] - vertexes[j][1] ;
        next_bounds[i][1] = vertexes[j][0] - vertexes[i][0] ;
  end
end

always_ff @(posedge clk or negedge reset_n) begin
  if(!reset_n) begin
  end
  else begin
    for (int i=0; i<MAX; ++i) begin
          bounds[i][0] <= next_bounds[i][0];
          bounds[i][1] <= next_bounds[i][1];
          bounds[i][2] <= -(next_bounds[i][0] * vertexes[i][0] + next_bounds[i][1] * vertexes[i][1]);
    end
  end
end

endmodule