module Bin2BCD (
    input [11:0] bin,       // 12-bit binary input
    input clk,
    output reg [3:0] ones,
    output reg [3:0] tens,
    output reg [3:0] hundreds,
    output reg [3:0] thousands
);
//Done in class
integer i;
reg [27:0] shift_reg; // 12 (bin) + 16 (4 digits * 4 bits) = 28
//register size must be size of the binary number your taking plus, the digits needed for the double dabble alg, so if binary is 12, you need 28 total

always @(*) begin
    // Initialize shift register
    shift_reg = 28'd0;
    shift_reg[11:0] = bin;

    // Double Dabble algorithm
    for (i = 0; i < 12; i = i + 1) begin
        // Check each BCD digit and add 3 if >= 5
        if (shift_reg[15:12] >= 5)
            shift_reg[15:12] = shift_reg[15:12] + 3;
        if (shift_reg[19:16] >= 5)
            shift_reg[19:16] = shift_reg[19:16] + 3;
        if (shift_reg[23:20] >= 5)
            shift_reg[23:20] = shift_reg[23:20] + 3;
        if (shift_reg[27:24] >= 5)
            shift_reg[27:24] = shift_reg[27:24] + 3;

        // Shift left by 1
        shift_reg = shift_reg << 1;
    end

    // Assign outputs
    ones      = shift_reg[15:12];
    tens      = shift_reg[19:16];
    hundreds  = shift_reg[23:20];
    thousands = shift_reg[27:24];
end

endmodule

