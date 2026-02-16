module pipeline_no_ram(
	input clk,
	input rst_n
);

reg [63:0] RF [0:15];
wire [31:0] instruction;
reg [8:0] PC;//32-bit; 512 entries
reg [2:0] DM_addr;
wire [63:0] DM_dout;
reg [63:0] DM_dout_WB, dddm_dout;

reg [2:0] REG1_ID, REG1_EX, REG1_MEM;
reg [2:0] REG2_ID;
reg [2:0] WREG1_ID, WREG1_EX, WREG1_MEM, WREG1_WB;
reg WRE_ID, WRE_EX, WRE_MEM, WRE_WB;
reg WME_ID, WME_EX, WME_MEM;

reg [63:0] RF_dout, RF_dout_EX, RF_dout_MEM;

imem imem_inst (
        .clka(clk),
		.rst(rst_n),
        .dina(32'b0),
        .addra(PC),          
        .wea(1'b0),
        .douta(instruction)  
);

dmem dmem_inst (  
	 .clka(clk),
	 .rst(rst_n),                 
     .dina (RF_dout_MEM),              
     .addra(RF[REG1_MEM][7:0]),//store address             
     .wea(WME_MEM),                              
     .addrb({5'b0,REG1_MEM}),//load              
     .doutb(DM_dout)                
);

always @(*) begin
	DM_addr = REG1_MEM;
	dddm_dout = DM_dout;
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		PC <= 0;
	else
		PC <= PC + 1;
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		REG1_ID <= 0;
		REG1_EX <= 0;
		REG1_MEM <= 0;

		REG2_ID <= 0;

		WREG1_ID <= 0;
		WREG1_EX <= 0;
		WREG1_MEM <= 0;
		WREG1_WB <= 0;

		WRE_ID <= 0;
		WRE_EX <= 0;
		WRE_MEM <= 0;
		WRE_WB <= 0;
		
		WME_ID <= 0;
		WME_EX <= 0;
		WME_MEM <= 0;
	end else begin
		REG1_ID <= instruction[29:27];
		REG1_EX <= REG1_ID;
		REG1_MEM <= REG1_EX;

		REG2_ID <= instruction[26:24];

		WREG1_ID <= instruction[23:21];
		WREG1_EX <= WREG1_ID;
		WREG1_MEM <= WREG1_EX;
		WREG1_WB <= WREG1_MEM;

		WRE_ID <= instruction[30];
		WRE_EX <= WRE_ID;
		WRE_MEM <= WRE_EX;
		WRE_WB <= WRE_MEM;

		WME_ID <= instruction[31];
		WME_EX <= WME_ID;
		WME_MEM <= WME_EX;
	end
end


integer i;

/*always @(*) begin
	DM_addr = REG1_MEM;
	DM_dout = DM[REG1_MEM];
end*/

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		DM_dout_WB <= 0;
		for(i=0;i<16;i=i+1)
			RF[i] <= 0;
	end else begin
		DM_dout_WB <= DM_dout;
		if(WRE_WB)
			RF[WREG1_WB] <= DM_dout_WB;
	end
end

always @(*) begin
	RF_dout = RF[REG2_ID];
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
	  	RF_dout_EX <= 0;
		RF_dout_MEM <= 0;
	end else begin
		RF_dout_EX <= RF_dout;
		RF_dout_MEM <= RF_dout_EX;
	end
end

/*always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
	  	DM[0] <= 64'd4;
		DM[4] <= 64'd100;
	end else begin
		if(WME_MEM)
			DM[RF[REG1_MEM]] <= RF_dout_MEM;
	end
end*/


endmodule