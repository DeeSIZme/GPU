module vga_master #(
    parameter VGA_WIDTH = 800,
    parameter VGA_HEIGHT = 600
    )(
    //////////////////////////////
    //// Avalon Stream Maser /////
    ////      Interface      /////
    //////////////////////////////
    input         clk,
    input         resetn,
	output [29:0] m_data,
	output        m_startofpacket,
	output        m_endofpacket,
	output [1:0]  m_empty,
	output        m_valid,
    input         m_ready
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


wire valid_cycle = 1;
assign m_empty = '0;
assign m_data = 30'h3fffffff;
assign m_valid = valid_cycle;


localparam VGA_SIZE = VGA_WIDTH * VGA_HEIGHT;



logic [31:0] px_counter;
wire vga_end   = px_counter == VGA_SIZE;
wire vga_begin = px_counter == 0;



assign m_startofpacket = vga_begin;
assign m_endofpacket   = vga_end;


always_ff @(posedge clk or negedge resetn) begin
    if(!resetn) begin
        px_counter <= 0;
    end    
    else begin
        if(m_ready) begin
            if(vga_end)
                px_counter <= 0;
            else
                px_counter <= px_counter + 32'h1;
        end
    end
end

endmodule