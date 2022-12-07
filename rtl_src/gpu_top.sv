module gpu_top #(
  parameter SADDR_WIDTH   = 32,
  parameter MADDR_WIDTH   = 32,
  parameter COORD_WIDTH   = 16,
  parameter COLOR_WIDTH   = 16,
  parameter VERTEX_SIZE   = 6, // in byte
  parameter SCREEN_X_SIZE = 800,
  parameter SCREEN_Y_SIZE = 600,
  parameter CORES_COUNT   = 10
) (
  input clk,
  input reset_n,

  //////////////////////////////
  ////   AXI4-lite Slave   /////
  ////      Interface      /////
  //////////////////////////////

  input          [SADDR_WIDTH-1:0] awaddr,
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
  input          [SADDR_WIDTH-1:0] araddr,
  input                     [2:0] arprot,
  input                           arvalid,
  output                          arready,
  output                   [31:0] rdata,
  output                    [1:0] rresp,
  output                          rvalid,
  input                           rready,

  //////////////////////////////
  ////  VGA Avalon Stream  /////
  ////   Maser Interface   /////
  //////////////////////////////

  input                           pixel_clock,
  input                           pixel_resetn,
  output                   [29:0] m_data,
  output                          m_startofpacket,
  output                          m_endofpacket,
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
wire [MADDR_WIDTH-1:0]base_addr_vertex;
wire [MADDR_WIDTH-1:0]base_addr_color;

//TODO AXI target

wire fetch_start;
wire [MADDR_WIDTH-1:0]curr_addr_vertex;
wire [MADDR_WIDTH-1:0]curr_addr_color;
wire [COLOR_WIDTH-1:0]fetch_color;
wire [COORD_WIDTH-1:0]fetch_vertexes[3][3];
wire fetch_eoc;

data_fetch #(
    .ADDR_WIDTH  (MADDR_WIDTH ),
    .COORD_WIDTH (COORD_WIDTH)
  ) fetch_inst (
    .clk         (clk             ),
    .rst         (reset_n         ),
    .start       (fetch_start     ),
    .addr_vertex (curr_addr_vertex),
    .addr_colors (curr_addr_color ),
    .colors      (fetch_color     ),
    .vertexes    (fetch_vertexes  ),
    .eoc         (fetch_eoc       )
  );

wire ver_start;
wire [COORD_WIDTH-1:0]ver_vertexes[3][3];
wire [COORD_WIDTH-1:0]ver_bound_coefs[3][2];
wire [2*COORD_WIDTH-1:0]ver_bound_const[3];
wire ver_eoc;

vertex_computation #(
    .COORD_WIDTH   (COORD_WIDTH  ),
    .SCREEN_X_SIZE (SCREEN_X_SIZE),
    .SCREEN_Y_SIZE (SCREEN_Y_SIZE)
  ) ver_inst (
    .clk            (clk            ),
    .reset_n        (reset_n        ),
    .start          (ver_start      ),
    .vertexes       (ver_vertexes   ),
    .bound_coefs    (pix_bound_coefs),
    .bound_const    (pix_bound_const),
    .eoc            (ver_eoc        )
  );

wire pix_start;
wire [COORD_WIDTH-1:0]pix_bound_coefs[3][2];
wire [2*COORD_WIDTH-1:0]pix_bound_const[3];
wire [COLOR_WIDTH-1:0]pix_color;
wire pix_eoc;


//localparam BUFFER_ADDR_W = $clog2(SCREEN_X_SIZE * SCREEN_Y_SIZE / CORES_COUNT);
localparam BUFFER_ADDR_W = 32;


logic [COLOR_WIDTH-1:0]   ppu_data   [0:CORES_COUNT-1];
logic [BUFFER_ADDR_W-1:0] ppu_address[0:CORES_COUNT-1];
logic                     ppu_valid  [0:CORES_COUNT-1];


logic [COLOR_WIDTH-1:0]         vga_mem_rdata;
logic [BUFFER_ADDR_W-1:0]       vga_mem_raddress;
logic [$clog2(CORES_COUNT)-1:0] vga_mem_rselect;


pixel_computation #(
    .COORD_WIDTH   (COORD_WIDTH  ),
    .COLOR_WIDTH   (COLOR_WIDTH  ),
    .SCREEN_X_SIZE (SCREEN_X_SIZE),
    .SCREEN_Y_SIZE (SCREEN_Y_SIZE),
    .CORES_COUNT   (CORES_COUNT  ),
    .BUFFER_ADDR_W (BUFFER_ADDR_W)
  ) pix_inst (
    .clk            (clk       ),
    .reset_n        (reset_n   ),
    .start          (pix_start ),
    .bound_coefs    (pix_bound_coefs),
    .bound_const    (pix_bound_const),
    .ppu_data       (ppu_data  ),
    .ppu_address    (ppu_address),
    .ppu_valid      (ppu_valid ),
    .color          (pix_color ),
    .eoc            (pix_eoc   )
  );

  ppu_memories #(
    .COLOR_WIDTH  (COLOR_WIDTH  ),
    .SCREEN_X_SIZE(SCREEN_X_SIZE),
    .SCREEN_Y_SIZE(SCREEN_Y_SIZE),
    .CORES_COUNT  (CORES_COUNT  ),
    .BUFFER_ADDR_W(BUFFER_ADDR_W)
  ) ppu_mem_i (
    .clk     (clk), 
    .reset_n (reset_n),

    // write ports
    .wdata   (ppu_data   ),
    .waddress(ppu_address),
    .wvalid  (ppu_valid  ),


    // read port
    .rdata   (vga_mem_rdata),
    .raddress(vga_mem_raddress),
    .rselect (vga_mem_rselect)
  );



pipeline #(
  .ADDR_WIDTH  (MADDR_WIDTH ),
  .COORD_WIDTH (COORD_WIDTH),
  .COLOR_WIDTH (COLOR_WIDTH),
  .VERTEX_SIZE (VERTEX_SIZE)
  ) pipeline_inst (.*);




vga_master #(
    .VGA_WIDTH    (SCREEN_X_SIZE),
    .VGA_HEIGHT   (SCREEN_Y_SIZE),
    .CORES_COUNT  (CORES_COUNT  ),
    .BUFFER_ADDR_W(BUFFER_ADDR_W),
    .COLOR_WIDTH  (COLOR_WIDTH  )
  ) vga_master_i (
    .vga_clk         (pixel_clock    ),
    .resetn          (pixel_resetn   ),
    .m_data          (m_data         ),
    .m_startofpacket (m_startofpacket),
    .m_endofpacket   (m_endofpacket  ),
    .m_valid         (m_valid        ),
    .m_ready         (m_ready        ),

    .clk             (clk),
    .rdata           (vga_mem_rdata),
    .raddress        (vga_mem_raddress),
    .rselect         (vga_mem_rselect),
);


endmodule