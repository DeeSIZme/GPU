module pipeline #(
  parameter ADDR_WIDTH = 32,
  parameter COORD_WIDTH = 16,
  parameter COLOR_WIDTH = 16,
  parameter VERTEX_SIZE = 6 // in byte
) (
  input                                clk,
  input                                reset_n,
  /// CONTROLLER INTERFACE
  input            [ADDR_WIDTH - 1: 0] base_addr_vertex,
  input            [ADDR_WIDTH - 1: 0] base_addr_color,
  input                         [31:0] triangles_count,
  input                                frame_start,
  output logic                         frame_end,
  /// DATA FETCH INTERFACE
  output                               fetch_start,
  output           [ADDR_WIDTH - 1: 0] curr_addr_vertex,
  output           [ADDR_WIDTH - 1: 0] curr_addr_color,
  input            [COLOR_WIDTH- 1: 0] fetch_color,
  input            [COORD_WIDTH- 1: 0] fetch_vertexes[3][3],
  input                                fetch_eoc,
  /// VERTEX COMPUTATION INTERFACE
  output                               ver_start,
  output logic    [COORD_WIDTH - 1: 0] ver_vertexes[3][3],
  input logic        [COORD_WIDTH-1:0] ver_bound_coefs[3][2],
  input logic      [2*COORD_WIDTH-1:0] ver_bound_const[3],
  input                                ver_eoc,
  /// PIXEL COMPUTATION INTERFACE
  output                               pix_start,
  output logic       [COORD_WIDTH-1:0] pix_bound_coefs[3][2],
  output logic     [2*COORD_WIDTH-1:0] pix_bound_const[3],
  output logic    [COLOR_WIDTH - 1: 0] pix_color,
  input                                pix_eoc
);

/// STATE MACHINE
logic [31:0]curr_triangle;

wire global_eoc       = fetch_eoc && ver_eoc && pix_eoc;
wire is_last_triangle = curr_triangle == triangles_count-1;

wire next_triangle    = global_eoc && !is_last_triangle;
assign frame_end      = global_eoc && is_last_triangle;

typedef enum logic {IDLE, COMPUTING} state_t;
state_t state;
state_t next_state;

always_comb begin: next_state_proc
  case (state)
    IDLE      : next_state = !frame_start ? IDLE      : COMPUTING ;
    COMPUTING : next_state = !frame_end   ? COMPUTING : IDLE      ;
  endcase
end

always_ff @(posedge clk or negedge reset_n) begin: state_proc
  if (!reset_n)
    state <= IDLE;
  else
    state <= next_state;
end

/// ADRESSES
always_ff @(posedge clk or negedge reset_n) begin: addr_proc
  if (!reset_n) begin
    curr_addr_vertex <= 0;
    curr_addr_color  <= 0;
  end
  else begin
    if(frame_start) begin
      curr_addr_vertex <= base_addr_vertex;
      curr_addr_color  <= base_addr_color;
    end
    else begin
      curr_addr_vertex <= curr_addr_vertex + VERTEX_SIZE;
      curr_addr_color  <= curr_addr_color  + COLOR_WIDTH;
    end
  end
end

/// DATA FLOW
logic [COLOR_WIDTH-1:0]ver_color;

always_ff @(posedge clk or negedge reset_n) begin: data_flow_proc
  if (!reset_n) begin
    state               <= IDLE;
    curr_triangle       <= '0;
    for (int i=3; i<3; ++i) begin
      ver_vertexes[i][0]        <= '0;
      ver_vertexes[i][1]        <= '0;
      ver_vertexes[i][2]        <= '0;
      pix_bound_coefs[i][0]     <= '0;
      pix_bound_coefs[i][1]     <= '0;
      pix_bound_const           <= '0;
    end
    ver_color           <= '0;
    pix_color           <= '0;
  end
  else
    if(next_triangle) begin
      curr_triangle       <= curr_triangle+1;
      ver_vertexes        <= fetch_vertexes;
      pix_bound_coefs     <= ver_bound_coefs;
      pix_bound_const     <= ver_bound_const;
      ver_color           <= fetch_color;
      pix_color           <= ver_color;
    end
end

/// DATA CONTROL
assign fetch_start  = next_triangle;
assign ver_start    = next_triangle;
assign pix_start    = next_triangle;

endmodule