`timescale 1 ps / 1 ps
module top_tb();

logic[7:0]  vga_b;
logic       vga_blank_n;
logic       vga_clk;
logic[7:0]  vga_g;
logic       vga_hs;
logic[7:0]  vga_r;
logic       vga_sync_n;
logic       vga_vs;

logic resetn, clk;

initial begin
    resetn = 0;
    #40ns;
    resetn = 1;
end


initial begin
    clk = 0;
    while(1) begin
        #10ns;
        clk = !clk;
    end
end


video_if ifs();


assign ifs.master.CLK   = !vga_clk;
assign ifs.master.HS    = vga_hs;
assign ifs.master.VS    = vga_vs;
assign ifs.master.BLANK = vga_blank_n;
assign ifs.master.RGB   = {vga_r,vga_g,vga_b};


DE1_SoC dut(
    .clock_50(clk),
    .key({3'b0, resetn}),
    .vga_b      (vga_b      ),
    .vga_blank_n(vga_blank_n),
    .vga_clk    (vga_clk    ),
    .vga_g      (vga_g      ),
    .vga_hs     (vga_hs     ),
    .vga_r      (vga_r      ),
    .vga_sync_n (vga_sync_n ),
    .vga_vs     (vga_vs      )
);


/*

screen screen0 (
    .video_ifs(ifs.slave)
);

*/

endmodule