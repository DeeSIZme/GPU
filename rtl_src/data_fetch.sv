module data_fetch #(
    parameter MADDR_WIDTH = 32,
    parameter COORD_WIDTH = 16,
    parameter COLOR_WIDTH = 16
) (
    input clk,
    input reset_n,
    input start,
    input [MADDR_WIDTH-1:0] addr_vertex,
    input [MADDR_WIDTH-1:0] addr_colors,
    output [COLOR_WIDTH-1:0] colors,
    output [COORD_WIDTH-1:0] vertexes[3][3],
    output eoc,

    /********* AXI MASTER **************/
    // Write Address Channel
    output logic [MADDR_WIDTH-1:0] awaddr_m,
    output logic [            2:0] awprot_m,
    output logic                   awvalid_m,
    input  logic                   awready_m,
    // Write Data Channel
    output logic                   wvalid_m,
    input  logic                   wready_m,
    output logic [           31:0] wdata_m,
    output logic [            3:0] wstrb_m,
    // Write Response Channel
    input  logic [            1:0] bresp_m,
    input  logic                   bvalid_m,
    output logic                   bready_m,
    // Read Address Channel
    output logic [MADDR_WIDTH-1:0] araddr_m,
    output logic [            2:0] arprot_m,
    output logic                   arvalid_m,
    input  logic                   arready_m,
    // Read Data Channel
    input  logic [           31:0] rdata_m,
    input  logic [            1:0] rresp_m,
    input  logic                   rvalid_m,
    output logic                   rready_m
);

  localparam RESP_OKAY = 2'b00, RESP_EXOKAY = 2'b01, RESP_SLVERR = 2'b10, RESP_DECERR = 2'b11;

  localparam VERTEX_SIZE = 5;
  localparam COLORS_SIZE = 1;

  logic [31:0] raw_vertex[VERTEX_SIZE-1:0];
  logic [31:0] raw_colors[COLORS_SIZE-1:0];

  //// STATE MACHINE ////
  typedef enum logic [1:0] {
    READ_COLORS,
    READ_VERTEX,
    IDLE,
    FINAL
  } state_t;
  state_t state;
  state_t next_state;
  wire read_vertex_end;
  wire read_colors_end;

  always_comb begin : next_state_proc
    case (state)
      IDLE:        next_state = !start ? IDLE : READ_VERTEX;
      READ_VERTEX: next_state = !read_vertex_end ? READ_VERTEX : READ_COLORS;
      READ_COLORS: next_state = !read_colors_end ? READ_COLORS : FINAL;
      FINAL:       next_state = !start ? FINAL : READ_VERTEX;
    endcase
  end

  always_ff @(posedge clk or negedge reset_n) begin : state_proc
    if (!reset_n) state <= IDLE;
    else state <= next_state;
  end

  ///// MASTER AXI /////
  wire AR_handshake_m = arvalid_m && arready_m;
  wire R_handshake_m = rvalid_m && rready_m;

  //// READ ////
  always_comb begin : araddr_comb
    case (next_state)
      READ_VERTEX: araddr_m = addr_vertex;
      READ_COLORS: araddr_m = addr_colors;
      default:     araddr_m = '0;
    endcase
  end
  logic raddr_ok_m;

  assign arprot_m  = '0;
  assign arvalid_m = !raddr_ok_m && (state == READ_VERTEX || state == READ_COLORS);
  assign rready_m  = 1;

  wire  next_raddr_ok_m;
  assign next_raddr_ok_m = raddr_ok_m ? !R_handshake_m : AR_handshake_m;

  always_ff @(posedge clk or negedge reset_n) begin : raddr_ok_proc
    if (!reset_n) raddr_ok_m <= 0;
    else raddr_ok_m <= next_raddr_ok_m;
  end

  //// INDEX ////
  logic [7:0] index;
  localparam index_colors_size = $clog2(COLORS_SIZE - 1) + 1;
  localparam index_vertex_size = $clog2(VERTEX_SIZE - 1) + 1;
  wire [index_colors_size-1:0] index_colors = index[index_colors_size-1:0];
  wire [index_vertex_size-1:0] index_vertex = index[index_vertex_size-1:0];

  assign read_vertex_end = (index == VERTEX_SIZE - 1) && (state == READ_VERTEX) && R_handshake_m;
  assign read_colors_end = (index == COLORS_SIZE - 1) && (state == READ_COLORS) && R_handshake_m;

  always_ff @(posedge clk or negedge reset_n) begin : colors_proc
    if (!reset_n) index <= '0;
    else if (next_state != state) index <= '0;
    else if (R_handshake_m && (state == READ_COLORS || state == READ_VERTEX)) index <= index + 1;
  end

  //// OUTPUT ////
  assign eoc = state == FINAL;

  assign colors = raw_colors[0][COLOR_WIDTH-1:0];

  always_ff @(posedge clk or negedge reset_n) begin : raw_vertex_proc
    if (!reset_n)
      for (int i = 0; i < COLORS_SIZE; ++i) begin
        raw_vertex[i] <= '0;
      end
    else if (R_handshake_m && state == READ_VERTEX) raw_vertex[index_vertex] <= rdata_m;
  end

  always_ff @(posedge clk or negedge reset_n) begin : raw_colors_proc
    if (!reset_n)
      for (int i = 0; i < COLORS_SIZE; ++i) begin
        raw_colors[i] <= '0;
      end
    else if (R_handshake_m && state == READ_COLORS) raw_colors[index_colors] <= rdata_m;
  end


  wire [VERTEX_SIZE*32-1:0] raw_colors_concat = {
    raw_vertex[4], raw_vertex[3], raw_vertex[2], raw_vertex[1], raw_vertex[0]
  };

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
  assign awaddr_m   = '0;
  assign awvalid_m  = '0;
  assign awprot_m   = '0;
  assign wdata_m    = '0;
  assign wvalid_m   = '0;
  assign wstrb_m    = '0;
  assign bready_m   = '0;

endmodule
