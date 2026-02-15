`timescale 1ns/1ps

module dmem(
	clka,
	dina,
	addra,
	wea,
	clkb,
	addrb,
	doutb);


input clka;
input [63 : 0] dina;
input [7 : 0] addra;
input [0 : 0] wea;
input clkb;
input [7 : 0] addrb;
output reg [63 : 0] doutb;

reg [63 : 0] mem [0 : 255];

always @(posedge clka) begin
    if (wea) begin
        mem[addra] <= dina;
    end
end

// Port B: read on clkb (registered output)
always @(posedge clkb) begin
    doutb <= mem[addra];
end

initial begin
    // 載入 data memory：每行一個 64-bit hex 字
    $readmemh("dm.txt", mem);
end


endmodule
