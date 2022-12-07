module vertex_computation #(
  parameter COORD_WIDTH = 16,
  parameter SCREEN_X_SIZE = 800,
  parameter SCREEN_Y_SIZE = 600
) (
  input clk,
  input reset_n,
  input start,
  input [COORD_WIDTH-1:0]vertexes[3][3],
  output logic [COORD_WIDTH-1:0]bound_coefs[3][2],
  output logic [2*COORD_WIDTH-1:0]bound_const[3],
  output eoc
);

logic [COORD_WIDTH-1:0]next_coefs[3][3];
assign eoc = '1;

always_comb begin
  for (int i=0; i<3; ++i) begin
        automatic int j = (i+1)%3; // next vertex
        next_coefs[i][0] = vertexes[i][1] - vertexes[j][1] ;
        next_coefs[i][1] = vertexes[j][0] - vertexes[i][0] ;
  end
end

always_ff @(posedge clk or negedge reset_n) begin
  if(!reset_n) begin
  end
  else begin
    for (int i=0; i<3; ++i) begin
          bound_coefs[i][0] <= next_coefs[i][0];
          bound_coefs[i][1] <= next_coefs[i][1];
          bound_const[i] <= -(next_coefs[i][0] * vertexes[i][0] + next_coefs[i][1] * vertexes[i][1]);
    end
  end
end

endmodule