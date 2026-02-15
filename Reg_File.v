module Reg_File (
    input              clk,
    input              rst_n,
    input      [5:0]   r0addr,
    input      [5:0]   r1addr,
    input      [5:0]   waddr,
    input      [63:0]  wdata,
    input              wena,
    output reg [63:0]  r0data,
    output reg [63:0]  r1data
);

    reg [63:0] reg_file [0:63]; 
    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 64; i = i + 1)
                reg_file[i] <= 64'b0;
        end else if (wena) begin
            reg_file[waddr] <= wdata;
        end
    end


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r0data <= 64'b0;
            r1data <= 64'b0;
        end else begin
            r0data <= reg_file[r0addr];
            r1data <= reg_file[r1addr];
        end
    end
endmodule