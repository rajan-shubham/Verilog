`timescale 1ns / 1ps

/* Behavioral design of a simple processor (MU01) */

module mu01 (
    input clk,
    input reset
);

    /* Two phases of instruction execution used here */
    localparam FETCH = 1'b0;
    localparam EXEC  = 1'b1;

    /* Instruction Set supported by the processor,
     * Mnemonic, and the corresponding opcode */
    localparam [3:0] 
        LDA  = 4'b0000,
        LDAI = 4'b1000,
        STO  = 4'b0001,
        ADD  = 4'b0010,
        ADDI = 4'b1010,
        SUB  = 4'b0011,
        SUBI = 4'b1011,
        JMP  = 4'b0100,
        JGE  = 4'b0101,
        JNE  = 4'b0110,
        STP  = 4'b0111;

    /* cs represents current state, and
     * ns represents the next state */
    reg cs, ns;

    reg [11:0] pc; // 12-bit program counter
    reg [15:0] acc, ir; // 16-bit accumulator and instruction register
    reg [15:0] mem[0:4095]; // 4096 (i.e., 4k) memory locations, each 16-bit in size

    wire [11:0] operand;
    wire [3:0] opcode;
    assign operand = ir[11:0];
    assign opcode  = ir[15:12];

    // Overflow and underflow flags
    reg overflow, underflow;

    // Sign-extended immediate operand
    wire [15:0] signed_operand;
    assign signed_operand = {{4{operand[11]}}, operand};

    integer i;
    initial begin
        /* initialize the memory locations before instruction execution starts */
        for (i = 0; i < 4095; i = i + 1) mem[i] = 16'h0000;

        /* Write the program into memory here (in opcodes of course) */
        /* start of program: Overflow Condition */
        mem[0] = {LDAI, 12'h7FFF}; // LDAI 7FFFH (largest positive 16-bit number)
        mem[1] = {ADDI, 12'h0001}; // ADDI 0001H (this will cause overflow)
        mem[2] = {STO,  12'hFFF};  // STO  FFFH (store the result to memory)
        mem[3] = {LDAI, 12'h8000}; // LDAI 8000H (largest negative 16-bit number)
        mem[4] = {SUBI, 12'h0001}; // SUBI 0001H (this will cause underflow)
        mem[5] = {STO,  12'hFFF};  // STO  FFFH (store the result to memory)
        mem[6] = {STP,  12'h000};  // STP
        /* end of program */
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cs <= FETCH;
            pc <= 12'h000;
            acc <= 16'h0000;
            overflow <= 0;
            underflow <= 0;
        end else begin
            cs <= ns;
        end
    end

    always @(cs) begin
        case (cs)
            /* instruction fetch */
            FETCH: begin
                ir <= mem[pc];
                pc <= pc + 1;
                ns <= EXEC;
            end

            /* instruction decoding, execution, memory access (if needed)
             * and writeback, all is taken care of during this EXEC phase
             * for this simple processor */
            EXEC: begin
                case (opcode)
                    LDA: begin // load accumulator
                        acc <= mem[operand];
                        ns <= FETCH;
                    end
                    LDAI: begin // load accumulator immediate
                        acc <= {{4{operand[11]}}, operand};
                        ns <= FETCH;
                    end
                    STO: begin // store to memory
                        mem[operand] <= acc;
                        ns <= FETCH;
                    end
                    ADD: begin // add
                        {overflow, acc} <= acc + mem[operand];
                        underflow <= 0;
                        ns <= FETCH;
                    end
                    ADDI: begin // add immediate
                        {overflow, acc} <= acc + signed_operand; // Sign-extended immediate value
                        underflow <= 0;
                        ns <= FETCH;
                    end
                    SUB: begin // subtract
                        {underflow, acc} <= acc - mem[operand];
                        overflow <= 0;
                        ns <= FETCH;
                    end
                    SUBI: begin // subtract immediate
                        {underflow, acc} <= acc - signed_operand; // Sign-extended immediate value
                        overflow <= 0;
                        ns <= FETCH;
                    end
                    JMP: begin // unconditional jump
                        pc <= operand;
                        ns <= FETCH;
                    end
                    JGE: begin // jump if accumulator value greater than or equal to zero
                        if (acc >= 0) begin
                            pc <= operand;
                        end
                        ns <= FETCH;
                    end
                    JNE: begin // jump if accumulator value not equal to zero
                        if (acc != 0) begin
                            pc <= operand;
                        end
                        ns <= FETCH;
                    end
                    STP: begin // halt processor
                        ns <= EXEC; // stay in EXEC state
                    end
                    default: begin // any unknown instruction will halt the processor
                        ns <= EXEC; // stay in EXEC state
                    end
                endcase // case (opcode)
            end
        endcase // case (cs)
    end
endmodule // mu01

module mu01_tg (output reg clk, reset);

    initial begin
        $monitor($time,,,"cs=%b: operand=%b opcode=%b acc=%b pc=%b mem[FFF]=%h overflow=%b underflow=%b",
            t_mu01.cs, t_mu01.operand, t_mu01.opcode,
            t_mu01.acc, t_mu01.pc, t_mu01.mem[12'hfff], t_mu01.overflow, t_mu01.underflow);
        clk = 1'b0; 
        reset = 1'b1;
        #4 reset = 1'b0;
        #60 $finish;
    end

    always #1 clk = ~clk;
endmodule // mu01_tg

module mu01_wb; // work bench
    wire clk, reset;

    mu01 t_mu01(clk, reset);
    mu01_tg tg(clk, reset);
endmodule // mu01_wb
