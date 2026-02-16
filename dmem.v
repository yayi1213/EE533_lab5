`timescale 1ns/1ps

module dmem(
	clka,
	rst,
	dina,
	addra,
	wea,
	clkb,
	addrb,
	doutb);


input clka, rst;
input [63 : 0] dina;
input [7 : 0] addra;
input wea;
input clkb;
input [7 : 0] addrb;
output reg [63 : 0] doutb;

reg [63 : 0] mem [0 : 255];

always @(posedge clka or negedge rst) begin
    if (!rst) begin
        mem[0] <= 64'd4;
		mem[4] <= 64'd100;
    end else if (wea) begin
        mem[addra] <= dina;
    end
end

// Port B: read on clkb (registered output)
always @(*) begin
    doutb = mem[addrb];
end

/*initial begin
    // 載入 data memory：每行一個 64-bit hex 字
    $readmemh("dm.txt", mem);
end*/


endmodule
