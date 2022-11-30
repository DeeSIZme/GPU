module gpu_top #(
  parameter ADDR_WIDTH = 32,
  parameter COORD_WIDTH = 16,
  parameter COLOR_WIDTH = 16,
  parameter VERTEX_SIZE = 6, // in byte
  parameter SCREEN_X_SIZE = 800,
  parameter SCREEN_Y_SIZE = 600,
  parameter CORES_COUNT = 10
) (
  input clk,
  input reset_n,

  //////////////////////////////
  ////   AXI4-lite Slave   /////
  ////      Interface      /////
  //////////////////////////////

  input      [AXI_ADDR_WIDTH-1:0] awaddr,
  input                     [2:0] awprot,
  input                           awvalid,
  output                          awready,
  input                    [31:0] wdata,
  input                     [3:0] wstrb,
  input                           wvalid,
  output                          wready,
  output                    [1:0] bresp,
  output                          bvalid,
  input                           bready,
  input      [AXI_ADDR_WIDTH-1:0] araddr,
  input                     [2:0] arprot,
  input                           arvalid,
  output                          arready,
  output                   [31:0] rdata,
  output                    [1:0] rresp,
  output                          rvalid,
  input                           rready,

  //////////////////////////////
  //// Avalon Stream Maser /////
  ////      Interface      /////
  //////////////////////////////

  input                           pixel_clock,
  input                           pixel_resetn,
  output                   [29:0] m_data,
  output                          m_startofpacket,
  output                          m_endofpacket,
  output                          m_empty,
  output                          m_valid,
  input                           m_ready,

  //////////////////////////////
  ////  Interrupt Request  /////
  //////////////////////////////

  output                          irq
);

wire frame_end;
wire frame_start;
wire [31:0]triangles_count;
wire [ADDR_WIDTH-1:0]base_addr_vertex;
wire [ADDR_WIDTH-1:0]base_addr_color;

//TODO AXI target

wire fetch_start;
wire [ADDR_WIDTH-1:0]curr_addr_vertex;
wire [ADDR_WIDTH-1:0]curr_addr_color;
wire [COLOR_WIDTH-1:0]fetch_color;
wire [COORD_WIDTH-1:0]fetch_vertexes[3][3];
wire fetch_eoc;

data_fetch #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .COORD_WIDTH(COORD_WIDTH)
  ) fetch_inst (
    .clk(clk),
    .rst(reset_n),
    .start(fetch_start),
    .addr_vertex(curr_addr_vertex),
    .addr_colors(curr_addr_color),
    .colors(fetch_color),
    .vertexes(fetch_vertexes),
    .eoc(fetch_eoc)
  );

wire ver_start;
wire [COORD_WIDTH-1:0]ver_vertexes[3][3];
wire [COORD_WIDTH-1:0]ver_vertexes_proj[3][2];
wire [COORD_WIDTH-1:0]ver_normal_vectors[3][2];
wire ver_eoc;

vertex_computation #(
    .COORD_WIDTH(COORD_WIDTH),
    .SCREEN_X_SIZE(SCREEN_X_SIZE),
    .SCREEN_Y_SIZE(SCREEN_Y_SIZE)
  ) ver_inst (
    .clk(clk),
    .rst(reset_n),
    .start(ver_start),
    .vertexes(ver_vertexes),
    .vertexes_proj(ver_vertexes_proj),
    .normal_vectors(ver_normal_vectors),
    .eoc(ver_eoc)
  );

wire pix_start;
wire [COORD_WIDTH-1:0]pix_vertexes_proj[3][2];
wire [COORD_WIDTH-1:0]pix_normal_vectors[3][2];
wire [COLOR_WIDTH-1:0]pix_color;
wire pix_eoc;

pixel_computation #(
    .COORD_WIDTH(COORD_WIDTH),
    .COLOR_WIDTH(COLOR_WIDTH),
    .SCREEN_X_SIZE(SCREEN_X_SIZE),
    .SCREEN_Y_SIZE(SCREEN_Y_SIZE),
    .CORES_COUNT(CORES_COUNT)
  ) pix_inst (
    .clk(clk),
    .rst(reset_n),
    .start(pix_start),
    .vertexes_proj(pix_vertexes_proj),
    .normal_vectors(pix_normal_vectors),
    .color(pix_color),
    .eoc(pix_eoc)
  );

vga_master vga_master_i (
    .clk            (pixel_clock    ),
    .resetn         (pixel_resetn   ),
    .m_data         (m_data         ),
    .m_startofpacket(m_startofpacket),
    .m_endofpacket  (m_endofpacket  ),
    .m_empty        (m_empty        ),
    .m_valid        (m_valid        ),
    .m_ready        (m_ready        )
);

pipeline #(
  .ADDR_WIDTH(ADDR_WIDTH),
  .COORD_WIDTH(COORD_WIDTH),
  .COLOR_WIDTH(COLOR_WIDTH),
  .VERTEX_SIZE(VERTEX_SIZE)
  ) pipeline_inst (.*);

endmodule