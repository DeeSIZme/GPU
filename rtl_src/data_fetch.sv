module data_fetch #(
    parameter MASTER_ADDR_WIDTH = 32,
    parameter COORD_WIDTH = 16,
    parameter COLOR_WIDTH = 16
) (
  input clk,
  input reset_n,
  input start,
  input [MASTER_ADDR_WIDTH-1:0]addr_vertex,
  input [MASTER_ADDR_WIDTH-1:0]addr_colors,
  output [COLOR_WIDTH-1:0]colors,
  output [COORD_WIDTH-1:0]vertexes[3][3],
  output eoc,

  /********* AXI MASTER **************/
  // Write Address Channel
  output  logic  [MASTER_ADDR_WIDTH-1:0] AWADDR_m,
  output  logic  [2:0]                   AWPROT_m,
  output  logic                         AWVALID_m,
  input   logic                         AWREADY_m,
  // Write Data Channel
  output  logic                          WVALID_m,
  input   logic                          WREADY_m,
  output  logic  [31:0]                   WDATA_m,
  output  logic  [3:0]                    WSTRB_m,
  // Write Response Channel
  input   logic  [1:0]                    BRESP_m,
  input   logic                          BVALID_m,
  output  logic                          BREADY_m,
  // Read Address Channel
  output  logic  [MASTER_ADDR_WIDTH-1:0] ARADDR_m,
  output  logic  [2:0]                   ARPROT_m,
  output  logic                         ARVALID_m,
  input   logic                         ARREADY_m,
  // Read Data Channel
  input   logic  [31:0]                   RDATA_m,
  input   logic  [1:0]                    RRESP_m,
  input   logic                          RVALID_m,
  output  logic                          RREADY_m
  );

localparam RESP_OKAY = 2'b00, RESP_EXOKAY = 2'b01, RESP_SLVERR = 2'b10, RESP_DECERR = 2'b11;

localparam VERTEX_SIZE = 5;
localparam COLORS_SIZE = 1;

logic [31:0]raw_vertex[VERTEX_SIZE];
logic [31:0]raw_colors[COLORS_SIZE];

//// STATE MACHINE ////
typedef enum logic[1:0] {READ_COLORS, READ_VERTEX, IDLE, FINAL} state_t;
state_t state;
state_t next_state;
wire read_vertex_end;
wire read_colors_end;

always_comb begin: next_state_proc
  case (state)
    IDLE          : next_state = !start           ? IDLE        : READ_VERTEX ;
    READ_VERTEX   : next_state = !read_vertex_end ? READ_VERTEX : READ_COLORS ;
    READ_COLORS   : next_state = !read_colors_end ? READ_COLORS : IDLE        ;
    default       : next_state = IDLE;
  endcase
end

always_ff @(posedge clk or negedge reset_n) begin: state_proc
  if (!reset_n)
    state <= IDLE;
  else
    state <= next_state;
end

///// MASTER AXI /////
wire AR_handshake_m = ARVALID_m && ARREADY_m ;
wire R_handshake_m  = RVALID_m  && RREADY_m  ;

//// READ ////
always_comb begin: araddr_comb
  case (next_state)
    IDLE          : ARADDR_m = '0;
    READ_VERTEX   : ARADDR_m = addr_vertex;
    READ_COLORS   : ARADDR_m = addr_colors;
    default       : ARADDR_m = '0;
  endcase
end

assign ARPROT_m  = '0;
assign ARVALID_m = !raddr_ok_m && (state == READ_VERTEX || state == READ_COLORS);
assign RREADY_m  = 1;

logic raddr_ok_m;
wire next_raddr_ok_m;
assign next_raddr_ok_m  = raddr_ok_m ? !R_handshake_m : AR_handshake_m ;

always_ff @(posedge clk or negedge reset_n) begin: raddr_ok_proc
  if (!reset_n)
    raddr_ok_m <= 0;
  else
    raddr_ok_m <= next_raddr_ok_m;
end

always_ff @(posedge clk or negedge reset_n) begin: raw_vertex_proc
  if (!reset_n)
    for (int i=0; i<COLORS_SIZE; ++i) begin
      raw_vertex[i] <= '0;
    end
  else
    if(R_handshake_m && state == READ_VERTEX)
      raw_vertex[index] <= RDATA_m;
end

always_ff @(posedge clk or negedge reset_n) begin: raw_colors_proc
  if (!reset_n)
    for (int i=0; i<COLORS_SIZE; ++i) begin
      raw_colors[i] <= '0;
    end
  else
    if(R_handshake_m && state == READ_COLORS)
      raw_colors[index] <= RDATA_m;
end

//// INDEX ////
logic [7:0]index;

assign read_vertex_end = (index == VERTEX_SIZE-1) && (state == READ_VERTEX) && R_handshake_m;
assign read_colors_end = (index == COLORS_SIZE-1) && (state == READ_COLORS) && R_handshake_m;

always_ff @(posedge clk or negedge reset_n) begin: colors_proc
  if (!reset_n)
    index <= '0;
  else
    if(next_state != state)
      index <= '0;
    else if(R_handshake_m && (state == READ_COLORS || state == READ_VERTEX))
      index <= index+1;
end

//// OUTPUT ////
assign eoc = state == FINAL;

assign colors = raw_colors[0][COLOR_WIDTH-1:0];

wire [VERTEX_SIZE*32-1:0]raw_colors_concat = {raw_vertex[4],raw_vertex[3],raw_vertex[2],raw_vertex[1],raw_vertex[0]};

assign vertexes[0][0] = raw_colors_concat[15+0*16+0:0*16+0];
assign vertexes[0][1] = raw_colors_concat[15+1*16+0:1*16+0];
assign vertexes[0][2] = raw_colors_concat[15+2*16+0:2*16+0];
assign vertexes[1][0] = raw_colors_concat[15+0*16+48:0*16+48];
assign vertexes[1][1] = raw_colors_concat[15+1*16+48:1*16+48];
assign vertexes[1][2] = raw_colors_concat[15+2*16+48:2*16+48];
assign vertexes[2][0] = raw_colors_concat[15+0*16+96:0*16+96];
assign vertexes[2][1] = raw_colors_concat[15+1*16+96:1*16+96];
assign vertexes[2][2] = raw_colors_concat[15+2*16+96:2*16+96];

//// WRITE ////
assign AWADDR_m   = '0;
assign AWVALID_m  = '0;
assign AWPROT_m   = '0;
assign WDATA_m    = '0;
assign WVALID_m   = '0;
assign WSTRB_m    = '0;
assign BREADY_m   = '0;

endmodule
