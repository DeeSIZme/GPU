module ppu #(
  parameter COORD_WIDTH = 16,
  parameter COLOR_WIDTH = 16
) (
  input  [COORD_WIDTH -1: 0] x,
  input  [COORD_WIDTH -1: 0] y,

  // bound_coefs[i] . (x,y,1) + bound_const[i] = res[i]
  // if sign(res[i]) != sign(res[j]), 
  // the point is out of the trianle
  input [COORD_WIDTH-1:0]    bound_coefs[3] [2],
  input [2*COORD_WIDTH-1:0]  bound_const[3],

  input  [COLOR_WIDTH-1:0]   color_in,
  output [COLOR_WIDTH-1:0]   color_out,
  output                     valid
);

typedef bit [COORD_WIDTH -1: 0] var_t;
typedef bit [2*COORD_WIDTH -1: 0] mul_res_t;


function mul_res_t plane(var_t x, var_t y, var_t bound_coefs[2], mul_res_t bound_const);
  mul_res_t mul0 = ($signed(x) * $signed(bound_coefs[0]));
  mul_res_t mul1 = ($signed(y) * $signed(bound_coefs[1]));

  return mul0 + mul1 + bound_const;
endfunction



mul_res_t res[3];
wire  res_sign[3];


//////////////////////////////////////////
////// a.(x-xref) + b.(y-yref) >= 0 //////
//////////////////////////////////////////
generate
    // 3 planes
  genvar i;
  for(i = 0;i < 3; i++) begin
    assign res[i] = plane(x, y, bound_coefs[i], bound_const[i]);

    assign res_sign[i] = res[i][2*COORD_WIDTH - 1];
  end
endgenerate


assign color_out = color_in;
assign valid = (&res_sign || ~|res_sign);
endmodule

