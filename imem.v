`timescale 1ns/1ps

module imem(
	clka,
	dina,
	addra,
	wea,
	douta);


input clka;
input [31 : 0] dina;
input [8 : 0] addra;
input [0 : 0] wea;
output reg [31 : 0] douta;

reg [31 : 0] mem [0 : 511];


// Optional: to initialize instruction memory from a hex file,
// uncomment and change "program.hex" to your file.
// initial $readmemh("program.hex", mem);

always @(posedge clka) begin
    if (wea) begin
        mem[addra] <= dina;
        douta <= dina;
    end else begin
        douta <= mem[addra];
    end
end
// 在 imem 模組中，加入：
initial begin
    // 載入指令檔 (hex, one 32-bit word per line)
    $readmemh("im.txt", mem);
end


endmodule