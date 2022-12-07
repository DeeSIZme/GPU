module vga_master #(
    parameter VGA_WIDTH = 800,
    parameter VGA_HEIGHT = 600,
    parameter CORES_COUNT = 10,
    parameter BUFFER_ADDR_W = 32,
    parameter COLOR_WIDTH = 16
    )(
    //////////////////////////////
    //// Avalon Stream Maser /////
    ////      Interface      /////
    //////////////////////////////
    input         vga_clk,
    input         resetn,
	output [29:0] m_data,
	output        m_startofpacket,
	output        m_endofpacket,
	output        m_valid,
    input         m_ready,


    //////////////////////////////
    ////      GPU memories    ////
    ////        interface     ////
    //////////////////////////////

    input         clk,
    input  [COLOR_WIDTH-1:0]   rdata,
    output [BUFFER_ADDR_W-1:0] raddress,
    
    output [$clog2(CORES_COUNT)-1:0] rselect
);

/* http://www.audentia-gestion.fr/INTEL/PDF/mnl_avalon_spec.pdf p.51
    startofpacket—All interfaces supporting packet transfers require the
startofpacket signal. startofpacket marks the active cycle containing the
start of the packet. This signal is only interpreted when valid is asserted.
    
    endofpacket—All interfaces supporting packet transfers require the
endofpacket signal. endofpacket marks the active cycle containing the end of
the packet. This signal is only interpreted when valid is asserted.
startofpacket and endofpacket can be asserted in the same cycle. No idle
cycles are required between packets. The startofpacket signal can follow
immediately after the previous endofpacket signal.
*/

// from nios_sys_video_vga_controller_0.v
parameter R_UI								= 29;
parameter R_LI								= 22;
parameter G_UI								= 19;
parameter G_LI								= 12;
parameter B_UI								= 9;
parameter B_LI								= 2;



localparam VGA_SIZE = VGA_WIDTH * VGA_HEIGHT;

//////////////////////////////////////////
///////////// VGA CLK DOMAIN /////////////
//////////////////////////////////////////

logic [31:0] vga_px_counter;
wire vga_end   = (vga_px_counter+1) == VGA_SIZE;
wire vga_begin = vga_px_counter == 0;
assign m_startofpacket = vga_begin;
assign m_endofpacket   = vga_end;

always_ff @(posedge vga_clk or negedge resetn) begin
    if(!resetn) begin
        vga_px_counter <= 0;
    end
    else begin
        if(m_ready) begin
            if(vga_end)
                vga_px_counter <= 0;
            else
                vga_px_counter <= vga_px_counter + 32'h1;
        end
    end
end



//////////////////////////////////////////
///////////// GPU CLK DOMAIN /////////////
//////////////////////////////////////////
wire fifo_full;

logic [31:0] x;
logic [31:0] y;
logic [31:0] ppuy;

wire x_rst    = x + 1 == VGA_WIDTH;
wire y_rst    = x_rst && (y + 1 == VGA_HEIGHT);
wire ppuy_rst = x_rst && (ppuy + 1 == VGA_HEIGHT / CORES_COUNT);

always @* assert(y_rst == vga_end);


wire  [31:0] nx = x_rst ? 0 : x + 1;
wire  [31:0] ny = x_rst ? (y_rst ? 0 : y + 1) : y;
wire  [31:0] nppuy = x_rst ? (ppuy_rst ? 0 : ppuy + 1) : ppuy;


// index of the PPU in charge of rendering
// the current part of the screen
logic [$clog2(CORES_COUNT) - 1: 0] ppui;


assign rselect = ppui;

always_ff @(posedge clk or negedge resetn)
    if(!resetn) begin
         x <= 0;
        y <= 0;
        ppui <= '0;
        ppuy <= '0;
    end
    else begin
        if(!fifo_full) begin
            x <= nx;
            y <= ny;
            ppuy <= nppuy;

            if(ppuy_rst) begin
                if(ppui == CORES_COUNT - 1)
                    ppui <= '0;
                else
                    ppui <= ppui + 1;
            end
        end
    end




////// cross domain fifo
wire rst = !resetn;

async_fifo #(
      DATA_WIDTH (COLOR_WIDTH), 
      DEPTH_WIDTH(2)
) fifo0 (
    .rst(rst),

    ///// VGA /////
    .rclk(vga_clk),
    .read(m_ready),
    .rdata(m_data),
    .rempty(m_valid),

    ///// PPU /////
    .wclk(clk),
    .wdata(rdata),
    .write(1),
    .wfull(fifo_full),
    .walmost_full(0), // unused
);

endmodule