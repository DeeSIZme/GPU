module pixel_computation #(
  parameter COORD_WIDTH = 16,
  parameter COLOR_WIDTH = 16,
  parameter SCREEN_X_SIZE = 800,
  parameter SCREEN_Y_SIZE = 600,
  parameter CORES_COUNT = 10,
  parameter BUFFER_ADDR_W = 32
) (
    input clk,
    input reset_n,
    input start,
    output eoc,


    // bound_coefs[i] . (x,y,1) + bound_const[i] = res[i]
    // if sign(res[i]) != sign(res[j]), 
    // the point is out of the trianle
    input [COORD_WIDTH-1:0]   bound_coefs[3] [2],
    input [2*COORD_WIDTH-1:0] bound_const[3],


    input [COLOR_WIDTH-1:0] color,
  
    output logic [COLOR_WIDTH-1:0]   ppu_data   [0:CORES_COUNT-1],
    output logic [BUFFER_ADDR_W-1:0] ppu_address[0:CORES_COUNT-1],
    output logic                     ppu_valid  [0:CORES_COUNT-1]

);
typedef logic [COORD_WIDTH -1: 0] var_t;
typedef logic [COORD_WIDTH -1: 0] var_reg_t;


initial assert((SCREEN_Y_SIZE % CORES_COUNT) == 0);

localparam LINES_PER_PPU = SCREEN_Y_SIZE / CORES_COUNT;
localparam ITER_COUNT = SCREEN_X_SIZE * LINES_PER_PPU;

localparam X_BITS = COORD_WIDTH;//$clog2(SCREEN_X_SIZE);
localparam Y_BITS = COORD_WIDTH;//$clog2(SCREEN_Y_SIZE);

var_reg_t ppu_y[0:CORES_COUNT-1];


logic computing;


always@(posedge clk or negedge reset_n) 
  if(!reset_n) begin
    computing <= 0;
  end
  else begin
    if(start)
      computing <= 1;
    if(eoc)
      computing <= 0;
  end



var_reg_t x;
var_reg_t y;


wire x_reset = !computing || x + 1 == SCREEN_X_SIZE;
wire y_reset = !computing;

assign eoc = (y + 1 == SCREEN_Y_SIZE) && x_reset;

wire y_inc   = computing && x_reset && !y_reset;


always_ff @(posedge clk or posedge reset_n) begin
  if(reset_n) begin
    x <= 0;
    y <= 0;
  end else begin
    if(x_reset) 
      x <= '0;
    else
      x <= x + 16'h1;

    if(y_inc)
      y <= y + 16'h1;
    else if(y_reset)
      y <= 0;
  end
end


// external
//logic [COLOR_WIDTH-1:0] ppu_buffers[0:CORES_COUNT-1];



generate
  genvar i;
  for(i = 0;i < CORES_COUNT; i++) begin: pppus

    var_t y_base = LINES_PER_PPU * i;
    
    wire [COLOR_WIDTH-1:0] color_in = color;
    wire [COLOR_WIDTH-1:0] color_out;
    wire valid;

    logic [BUFFER_ADDR_W-1:0] buf_addr;

    

    // memory access

    always_ff @(posedge clk or posedge reset_n) begin
      if(reset_n) begin
        ppu_data[i]    <= 0;
        ppu_address[i] <= 0;
        ppu_valid[i]   <= 0;

        ppu_y[i] <= y_base;
      end else begin
        if(y_inc) begin
          ppu_y[i] <= ppu_y[i] + 16'h1;
        end
        if(y_reset) begin
          ppu_y[i] <= y_base;
        end

        if(y_reset)
          ppu_address[i] <= '0;
        else
          ppu_address[i] <= ppu_address[i];

        ppu_data[i] <= color_out;
        ppu_valid[i] <= computing && valid;
      end
    end


    ppu #(
      .COORD_WIDTH(COORD_WIDTH), 
      .COLOR_WIDTH(COLOR_WIDTH)
    ) ppui (
      .x          (x        ),
      .y          (ppu_y[i] ),
      .bound_coefs(bound_coefs),
      .bound_const(bound_const),
      .color_in   (color_in ),
      .color_out  (color_out),
      .valid      (valid)
    );
  end
endgenerate



endmodule