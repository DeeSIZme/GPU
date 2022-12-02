`timescale 1ps/1ps
module pixel_computaion_tb();

logic clk, resetn;
parameter COORD_WIDTH = 16;
parameter COLOR_WIDTH = 16;
parameter SCREEN_X_SIZE = 800;
parameter SCREEN_Y_SIZE = 600;
parameter CORES_COUNT = 10;

initial begin
    clk = 0;
    while(1) begin
        #5ns;
        clk = !clk;
    end
end
initial begin
    resetn = 1;
    #20ns;
    resetn = 0;
end


pixel_computation pixel_computation_i #(
    .COORD_WIDTH    (COORD_WIDTH),
    .COLOR_WIDTH    (COLOR_WIDTH),
    .SCREEN_X_SIZE  (SCREEN_X_SIZE),
    .SCREEN_Y_SIZE  (SCREEN_Y_SIZE),
    .CORES_COUNT    (CORES_COUNT)
) (
    .clk(clk),
    .resetn(resetn),
);


endmodule