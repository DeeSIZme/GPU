module target #(
    parameter SADDR_WIDTH = 5,
    parameter MADDR_WIDTH = 32
) (
    // Global Signals
    input logic clk,
    input logic reset_n,

    input  [           31:0] global_state,
    output                   frame_start,
    output                   interrupt_ack,
    output [           31:0] triangles_count,
    output [MADDR_WIDTH-1:0] base_addr_vertex,
    output [MADDR_WIDTH-1:0] base_addr_color,

    /********* SLAVE **************/
    // Write Address Channel
    input  logic [SADDR_WIDTH-1:0] awaddr_s,
    input  logic [            2:0] awprot_s,
    input  logic                   awvalid_s,
    output logic                   awready_s,
    // Write Data Channel
    input  logic                   wvalid_s,
    output logic                   wready_s,
    input  logic [           31:0] wdata_s,
    input  logic [            3:0] wstrb_s,
    // Write Response Channel
    output logic [            1:0] bresp_s,
    output logic                   bvalid_s,
    input  logic                   bready_s,
    // Read Address Channel
    input  logic [SADDR_WIDTH-1:0] araddr_s,
    input  logic [            2:0] arprot_s,
    input  logic                   arvalid_s,
    output logic                   arready_s,
    // Read Data Channel
    output logic [           31:0] rdata_s,
    output logic [            1:0] rresp_s,
    output logic                   rvalid_s,
    input  logic                   rready_s
);

  // - `Reg0 @0x0` : control register.
  // - `Reg3 @0x4` : Input data (vertex) start address
  // - `Reg4 @0x8` : Input data (colours) start address
  // - `Reg5 @0xc` : Number of triangles

  localparam RESP_OKAY = 2'b00, RESP_EXOKAY = 2'b01, RESP_SLVERR = 2'b10, RESP_DECERR = 2'b11;
  localparam DATA_LENGTH = 4;
  logic [31:0] data[DATA_LENGTH-1:1];

  assign base_addr_vertex = data[1][MADDR_WIDTH-1:0];
  assign base_addr_color  = data[2][MADDR_WIDTH-1:0];
  assign triangles_count  = data[3];

  ///// SLAVE AXI /////
  function logic addr_valid(input logic [SADDR_WIDTH-1:0] addr);
    return addr % 4 == 0 && addr < DATA_LENGTH * 4;
  endfunction

  wire AR_handshake_s = arvalid_s && arready_s;
  wire R_handshake_s = rvalid_s && rready_s;
  wire AW_handshake_s = awvalid_s && awready_s;
  wire W_handshake_s = wvalid_s && wready_s;
  wire B_handshake_s = bvalid_s && bready_s;

  logic [31:0] wdata_s_q;
  logic [SADDR_WIDTH-1:0] waddr_s_q;
  logic [SADDR_WIDTH-1:0] raddr_s_q;

  ///// READ /////
  assign arready_s = 1;
  always_ff @(posedge clk or negedge reset_n) begin : read_proc_s
    if (!reset_n) begin
      rvalid_s  <= 0;
      raddr_s_q <= 0;
    end else if (AR_handshake_s) begin
      raddr_s_q <= araddr_s;
      rvalid_s  <= 1;
    end else if (R_handshake_s) begin
      rvalid_s <= 0;
    end
  end

  assign rdata_s = |raddr_s_q ? (addr_valid(raddr_s_q) ? data[raddr_s_q/4] : 0) : global_state;
  assign rresp_s = addr_valid(raddr_s_q) ? RESP_OKAY : RESP_DECERR;

  ///// WRITE /////
  logic waddr_ok_s, wdata_ok_s, wstrb_ok_s;
  wire next_waddr_ok_s, next_data_ok_s, next_wstrb_ok_s;

  assign next_waddr_ok_s = waddr_ok_s ? !B_handshake_s : AW_handshake_s;
  assign next_data_ok_s = wdata_ok_s ? !B_handshake_s : W_handshake_s;
  assign next_wstrb_ok_s = wvalid_s ? wstrb_s == 4'hf : wstrb_ok_s;

  assign awready_s = !waddr_ok_s;
  assign wready_s = !wdata_ok_s;

  always_ff @(posedge clk or negedge reset_n) begin : wstrb_ok_proc_s
    if (!reset_n) begin
      wstrb_ok_s <= 0;
    end else begin
      wstrb_ok_s <= next_wstrb_ok_s;
    end
  end

  always_ff @(posedge clk or negedge reset_n) begin : waddr_proc_s
    if (!reset_n) begin
      waddr_s_q  <= 0;
      waddr_ok_s <= 0;
    end else begin
      if (AW_handshake_s) begin
        waddr_s_q <= awaddr_s;
      end
      waddr_ok_s <= next_waddr_ok_s;
    end
  end

  always_ff @(posedge clk or negedge reset_n) begin : wdata_proc_s
    if (!reset_n) begin
      wdata_s_q  <= 0;
      wdata_ok_s <= 0;
    end else begin
      if (W_handshake_s) begin
        wdata_s_q <= wdata_s;
      end
      wdata_ok_s <= next_data_ok_s;
    end
  end

  always_ff @(posedge clk or negedge reset_n) begin : bvalid_proc_s
    if (!reset_n) begin
      bvalid_s <= 0;
    end else begin
      if (next_waddr_ok_s & next_data_ok_s) begin
        bvalid_s <= 1;
      end else if (B_handshake_s) begin
        bvalid_s <= 0;
      end
    end
  end

  always_ff @(posedge clk or negedge reset_n) begin : data_writting_proc_s
    if (!reset_n)
      for (int i = 1; i < 6; ++i) begin
        data[i] <= 0;
      end
    else if (B_handshake_s && bresp_s == RESP_OKAY && |waddr_s_q) data[waddr_s_q/4] <= wdata_s_q;
  end

  wire ctrl_wirte = B_handshake_s && bresp_s == RESP_OKAY && waddr_s_q == 0;
  assign frame_start    = ctrl_wirte && wdata_s_q[0];
  assign interrupt_ack  = ctrl_wirte && !wdata_s_q[0];

  assign bresp_s = addr_valid(waddr_s_q) && next_wstrb_ok_s ? RESP_OKAY : RESP_DECERR;

endmodule
