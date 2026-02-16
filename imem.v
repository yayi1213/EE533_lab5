`timescale 1ns/1ps

module imem(
	clka,
    rst,
	dina,
	addra,
	wea,
	douta);


input clka, rst;
input [31 : 0] dina;
input [8 : 0] addra;
input [0 : 0] wea;
output reg [31 : 0] douta;

reg [31 : 0] mem [0 : 511];


// Optional: to initialize instruction memory from a hex file,
// uncomment and change "program.hex" to your file.
// initial $readmemh("program.hex", mem);

always @(negedge rst) begin
    if (!rst) begin
        mem[0] <= {1'b0, 1'b1, 3'b0,3'b0,3'd2, 21'b0};
        mem[1] <= {1'b0, 1'b1, 3'b0, 3'b0, 3'd3, 21'b0};
        mem[2] <= 32'b0;   
        mem[3] <= 32'b0;
        mem[4] <= 32'b0;
        mem[5] <= {1'b1, 1'b0, 3'd2, 3'd3, 3'd0, 21'b0};
    end
end

always @(*) begin
    douta = mem[addra];
end

// 在 imem 模組中，加入：
/*initial begin
    // 載入指令檔 (hex, one 32-bit word per line)
    $readmemh("im.txt", mem);
end*/


endmodule