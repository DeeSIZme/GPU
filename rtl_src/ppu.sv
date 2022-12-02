module ppu #(
  parameter COORD_WIDTH = 16,
  parameter COLOR_WIDTH = 16
) (
  input clk, resetn,
  input  [COORD_WIDTH -1: 0]x,
  input  [COORD_WIDTH -1: 0]y,
  input [COORD_WIDTH-1:0] bounds[3] [3],


  input  [COLOR_WIDTH-1:0] color_in,
  output [COLOR_WIDTH-1:0] color_out,
  output valid
);

typedef bit [COORD_WIDTH -1: 0] var_t;
typedef bit [2*COORD_WIDTH -1: 0] mul_res_t;


function var_t plane(var_t x, var_t y, var_t bounds[3]);
  mul_res_t mul0 = ($signed(x) * $signed(bounds[0]));
  mul_res_t mul1 = ($signed(y) * $signed(bounds[1]));

  return  mul0 [2 * COORD_WIDTH - 1: COORD_WIDTH] 
       +  mul1 [2 * COORD_WIDTH - 1: COORD_WIDTH]
       +  bounds[2];
endfunction



wire [COORD_WIDTH - 1: 0] res[3];
wire  res_sig[3];


//////////////////////////////////////////
////// a.(x-xref) + b.(y-yref) >= 0 //////
//////////////////////////////////////////
generate
    // 3 planes
  genvar i;
  for(i = 0;i < 3; i++) begin
    assign res[i] = plane(x, y, bounds[i]);

    assign res_sig[i] = res[i][COORD_WIDTH - 1];
  end
endgenerate


assign color_out = color_in;
assign valid = (&res_sig || ~|res_sig);
endmodule

