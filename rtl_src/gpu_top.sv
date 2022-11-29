module gpu_top #(
    parameter AXI_ADDR_WIDTH = 32
) (

    //////////////////////////////
    ////   AXI4-lite Slave   /////
    ////      Interface      /////
    //////////////////////////////
   input aclk,
   input aresetn,
   input   [AXI_ADDR_WIDTH - 1:0] awaddr,
   input   [2:0]              awprot,
   input                      awvalid,
   output                       awready,
   input     [31:0]             wdata,
   input     [3:0]      wstrb,
   input                       wvalid,
   output                 wready,
   output    [1:0]              bresp,
   output                       bvalid,
   input                      bready,
   input   [AXI_ADDR_WIDTH - 1:0] araddr,
   input   [2:0]              arprot,
   input                      arvalid,
   output                       arready,
   output  [31:0]               rdata,
   output   [1:0]               rresp,
   output                       rvalid,
   input                      rready,


   ////// interrupt request
    output irq,


    //////////////////////////////
    //// Avalon Stream Maser /////
    ////      Interface      /////
    //////////////////////////////
    input         pixel_clock,
    input         pixel_resetn,
	output [29:0] m_data,
	output        m_startofpacket,
	output        m_endofpacket,
	output        m_empty,
	output        m_valid,
    input         m_ready
);



endmodule