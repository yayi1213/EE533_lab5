`timescale 1ns/1ps

module tb_pipeline_fixed;
    // Testbench signals (module scope declarations)
    reg clk;
    reg rst_n;

    // loop variables declared at module scope to avoid illegal declarations in procedural blocks
    integer cycles;
    integer i;

    // Instantiate DUT
    pipeline_no_ram uut (
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation: 10ns period (100 MHz)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // Tasks must be declared (or available) before they're used in initial blocks.
    task print_cycle_info(input integer current_time, input integer cycle);
        integer j;
        begin
            // Note: hierarchical references may cause simulator errors if names differ.
            $display("%8d | %5d | PC=%3d | instr=%08h | WRE_WB=%b WME_MEM=%b | DM_dout=%016h DM_dout_WB=%016h",
                     current_time,
                     cycle,
                     uut.PC,
                     uut.instruction,
                     uut.WRE_WB,
                     uut.WME_MEM,
                     uut.DM_dout,
                     uut.DM_dout_WB);
            $display(" RF (0..7):");
            for (j = 0; j < 8; j = j + 1) begin
                $display("  RF[%0d] = %016h", j, uut.RF[j]);
            end
            $display("-------------------------------");
        end
    endtask

    task print_RF;
        integer j;
        begin
            for (j = 0; j < 16; j = j + 1) begin
                $display(" RF[%0d] = %016h", j, uut.RF[j]);
            end
        end
    endtask

    // Simulation control
    initial begin
        // waveform (for GTKWave / ModelSim)
        $dumpfile("tb_pipeline_fixed.vcd");
        $dumpvars(0, tb_pipeline_fixed);

        // apply reset (active-low)
        rst_n = 1'b1;
        force clk = 1'b0;
        #(0.5) rst_n = 0;
        #20;
        rst_n = 1; // release reset
        #10; release clk;
        // optionally initialize some RF entries (hierarchical access — simulator-only)


        // run and print
        cycles = 0;
        $display("Starting simulation...");
        $display("Time(ns) | Cycle | PC | instruction | ...");
        repeat (200) begin
            @(posedge clk);
            cycles = cycles + 1;
            print_cycle_info($time, cycles);
        end

        $display("\n=== FINAL REGISTER FILE (RF) ===");
        print_RF();

        $display(" DM (0..4):");
            for (i = 0; i < 5; i = i + 1) begin
                $display("  DM[%0d] = %016h", i, uut.dmem_inst.mem[i]);
            end

            $display("-------------------------------");

        $display("\nSimulation finished after %0d cycles.", cycles);
        #10;
        $finish;
    end

endmodule
