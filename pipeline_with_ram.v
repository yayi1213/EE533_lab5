`timescale 1ns / 1ps

module pipeline_with_ram (
    input clk,
    input rst
);

    // PC 
    reg  [8:0]  PC;              // Program Counter
    wire [31:0] Instruction;     
    
    // Pipeline Register 1 (IF -> ID)
    reg  [31:0] IF_ID_Instr;
    
    // Instruction Format 
    wire        WMemEn   = IF_ID_Instr[31];
    wire        WRegEn   = IF_ID_Instr[30];
    wire [2:0]  Reg1Addr = IF_ID_Instr[29:27];
    wire [2:0]  Reg2Addr = IF_ID_Instr[26:24];
    wire [2:0]  WRegAddr = IF_ID_Instr[23:21];

    // RegFile
    wire [63:0] R1_Data;
    wire [63:0] R2_Data;

    // Pipeline Register 2 (ID -> MEM)
    reg  [63:0] ID_MEM_R1;      
    reg  [63:0] ID_MEM_R2;      
    reg         ID_MEM_WMemEn;
    reg         ID_MEM_WRegEn;
    reg  [2:0]  ID_MEM_WRegAddr;

    // D_MEM
    wire [63:0] Mem_Dout;
    wire [7:0] dmem_addr;
    assign dmem_addr = ID_MEM_R1[7:0];

    // Pipeline Register 3 (MEM -> WB)
    reg  [63:0] MEM_WB_Data;    
    reg         MEM_WB_WRegEn;
    reg  [2:0]  MEM_WB_WRegAddr;

    // module
    // A. I_MEM 
    imem imem_inst (
        .clka(clk),
        .dina(32'b0),
        .addra(PC),          
        .wea(1'b0),
        .douta(Instruction)  
    );

    // RegFile
    Reg_File regfile_inst (
        .clk(clk),
        .rst_n(rst),
        .r0addr(Reg1Addr),   
        .r1addr(Reg2Addr),
        .r0data(R1_Data),
        .r1data(R2_Data),
        .wena(MEM_WB_WRegEn),
        .waddr(MEM_WB_WRegAddr),
        .wdata(MEM_WB_Data)
    );

    // D_MEM
    dmem dmem_inst (
     .clka (clk),                    
     .dina (ID_MEM_R2),              
     .addra(dmem_addr),             
     .wea(ID_MEM_WMemEn),          
     .clkb (clk),                    
     .addrb(dmem_addr),              
     .doutb(Mem_Dout)                
    );

    //  Pipeline Registers
    // Fetch (PC +1)
    always @(posedge clk) begin
        if (rst) 
            PC <= 0;
        else 
            PC <= PC + 1; 
    end

    // IF -> ID 
    always @(posedge clk) begin
        if (rst) 
            IF_ID_Instr <= 0;
        else 
            IF_ID_Instr <= Instruction;
    end

    // ID -> MEM 
    always @(posedge clk) begin
        if (rst) begin
            ID_MEM_R1       <= 0;
            ID_MEM_R2       <= 0;
            ID_MEM_WMemEn   <= 0;
            ID_MEM_WRegEn   <= 0;
            ID_MEM_WRegAddr <= 0;
        end else begin
            ID_MEM_R1       <= R1_Data;     
            ID_MEM_R2       <= R2_Data;     
            ID_MEM_WMemEn   <= WMemEn;      
            ID_MEM_WRegEn   <= WRegEn;
            ID_MEM_WRegAddr <= WRegAddr;
        end
    end

    // MEM -> WB
    always @(posedge clk) begin
        if (rst) begin
            MEM_WB_Data     <= 0;
            MEM_WB_WRegEn   <= 0;
            MEM_WB_WRegAddr <= 0;
        end else begin
            MEM_WB_Data     <= Mem_Dout;      
            MEM_WB_WRegEn   <= ID_MEM_WRegEn; 
            MEM_WB_WRegAddr <= ID_MEM_WRegAddr;
        end
    end

endmodule