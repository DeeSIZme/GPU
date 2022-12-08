module ppu_memories #(
  parameter COLOR_WIDTH = 16,
  parameter SCREEN_X_SIZE = 800,
  parameter SCREEN_Y_SIZE = 600,
  parameter CORES_COUNT = 10,
  parameter BUFFER_ADDR_W = 32
) (
    input clk, reset_n,

    // write ports
    input  [COLOR_WIDTH-1:0]   wdata   [0:CORES_COUNT-1],
    input  [BUFFER_ADDR_W-1:0] waddress[0:CORES_COUNT-1],
    input                      wvalid  [0:CORES_COUNT-1],


    // read port
    output    [COLOR_WIDTH-1:0]   rdata,
    input reg [BUFFER_ADDR_W-1:0] raddress,
    
    input     [$clog2(CORES_COUNT)-1:0] rselect
);

localparam MEMORY_SIZE = SCREEN_X_SIZE * SCREEN_Y_SIZE;

logic [COLOR_WIDTH-1:0] mem_out[0:CORES_COUNT-1];

generate
    genvar i;
    for(i = 0; i < CORES_COUNT; i++) begin: mem_units
        // memory instanciation
        
        logic [COLOR_WIDTH-1:0] mem[MEMORY_SIZE / CORES_COUNT];
        

        always_ff @(posedge clk) begin
            mem_out[i] <= mem[raddress];

            if(wvalid[i])
                mem[waddress[i]] <= wdata[i];
        end
    end
endgenerate


logic [$clog2(CORES_COUNT)-1:0] rselect_q;

always_ff@(posedge clk or negedge reset_n)
    if(!reset_n)
        rselect_q <= '0;
    else
        rselect_q <= rselect;


assign rdata = mem_out[rselect_q];



endmodule