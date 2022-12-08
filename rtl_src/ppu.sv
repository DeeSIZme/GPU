module ppu #(
    parameter COORD_WIDTH = 16,
    parameter COLOR_WIDTH = 16
) (
    input signed [COORD_WIDTH -1:0] x,
    input signed [COORD_WIDTH -1:0] y,

    // bound_coefs[i] . (x,y,1) + bound_const[i] = res[i]
    // if sign(res[i]) != sign(res[j]), 
    // the point is out of the trianle
    input signed [  COORD_WIDTH-1:0] bound_coefs[3][2],
    input signed [2*COORD_WIDTH-1:0] bound_const[3],

    input  [COLOR_WIDTH-1:0] color_in,
    output [COLOR_WIDTH-1:0] color_out,
    output                   valid
);

  typedef logic signed [COORD_WIDTH -1:0] var_t;
  typedef logic signed [2*COORD_WIDTH -1:0] mul_res_t;



  function mul_res_t plane(var_t x, var_t y, var_t bound_coefs[2], mul_res_t bound_const);
    return ($signed(x) * $signed(bound_coefs[0])) + ($signed(y) * $signed(bound_coefs[1])) +
        bound_const;
  endfunction



  mul_res_t res[3];
  wire [2:0] res_sign;


  //////////////////////////////////////////
  ////// a.(x-xref) + b.(y-yref) >= 0 //////
  //////////////////////////////////////////
  generate
    // 3 planes
    genvar i;
    for (i = 0; i < 3; i++) begin : eq_comp
      assign res[i] = plane(x, y, bound_coefs[i], bound_const[i]);

      assign res_sign[i] = res[i][2*COORD_WIDTH-1];
    end
  endgenerate


  assign color_out = color_in;
  assign valid = (&res_sign || ~|res_sign);
endmodule

