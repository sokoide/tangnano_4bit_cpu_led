module tb_cpu;
    // signals for test
    logic clk;
    logic reset;
    logic [3:0] btn;
    logic [3:0] led;
    logic [3:0] adr;
    logic [7:0] dout;
    logic [7:0] regs [7:0];
    logic [7:0] col;
    logic [7:0] row;
    logic [23:0] counter;

    // individual register assignments
    logic [7:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;

    // ram instance
    logic [7:0] r_data;
    ram ram_inst (
            .clk    (clk),
            .we     (1'b0),
            .r_addr ({4'b0000, adr}),  // receive from CPU
            .r_data (r_data),
            .w_addr (8'd0),
            .w_data (8'd0)
        );

    // DUT (Device Under Test)
    cpu dut (
            .reset  (reset),
            .clk    (clk),
            .btn    (btn),
            .counter(counter),
            .led    (led),
            .adr    (adr),
            .col    (col),
            .row    (row),
            .dout   (r_data)
`ifdef DEBUG_MODE
            , .debug_regs(regs)
`endif
        );

`ifdef DEBUG_MODE
    initial begin
        $display("DEBUG_MODE is ENABLED");
    end
`endif

    // assign individual registers for waveform
    always_comb begin
        {reg7, reg6, reg5, reg4, reg3, reg2, reg1, reg0} = {regs[7], regs[6], regs[5], regs[4], regs[3], regs[2], regs[1], regs[0]};
    end

    // 10ns clock (#5 means 5ns)
    always #5 clk = ~clk;

    // test
    initial begin
        clk = 0;

        $display("=== Test Start ===");
        btn = 4'b0000;

        reset = 0; // active
        repeat (1) @(posedge clk);  // wait for 1 clock cycles
        reset = 1; // release

        // afetr 10 cycles (reset), adr must be 0
        $display("10 cycles");
        // test led
        if (led !== 4'b0000) begin
            $display("ERROR: Unexpected led value: %b", led);
            $stop;
        end
        // test regs
        if (regs[0] !== 4'b0000) begin
            $display("ERROR: Unexpected regs[0] value: %b", regs[0]);
            //$stop;
        end
        if (regs[6] !== 4'b0000) begin
            $display("ERROR: Unexpected regs[6] value: %b", regs[6]);
            //$stop;
        end

        // after 13 cycles
        $display("13 cycles");
        repeat (3) @(posedge clk);
        if (led !== 4'b0001) begin
            $display("ERROR: Unexpected led value: %b", led);
            //$stop;
        end
        // test regs
        if (regs[0] !== 4'b0010) begin
            $display("ERROR: Unexpected regs[0] value: %b", regs[0]);
            //$stop;
        end

        if (regs[6] !== 4'b0001) begin
            $display("ERROR: Unexpected regs[6] value: %b", regs[6]);
            //$stop;
        end

        // after 15 cycles
        $display("15 cycles");
        repeat (2) @(posedge clk);
        // test regs
        if (regs[1] !== 4'b0011) begin
            $display("ERROR: Unexpected regs[1] value: %b", regs[1]);
            //$stop;
        end

        // get traces some more in the vcd
        repeat (10) @(posedge clk);

        $display("All Test Passed");
        $finish;
    end
endmodule
