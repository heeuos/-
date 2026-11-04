module seg_dac(
	input clk,
	input rst,
	input [7:0] value,
	output reg [7:0] seg_data,
	output reg [7:0] seg_sel
);

	reg [9:0] scan_cnt;
	reg [3:0] digit;

	wire [3:0] hun = value / 8'd100;
	wire [3:0] ten = (value % 8'd100) / 8'd10;
	wire [3:0] one = value % 8'd10;

	always @(posedge clk or negedge rst) begin
		if(!rst)
			scan_cnt <= 10'd0;
		else
			scan_cnt <= scan_cnt + 1'b1;
	end

	always @(*) begin
		case(scan_cnt[9:8])
			2'd0 : begin seg_sel = 8'b1101_1111; digit = hun; end
			2'd1 : begin seg_sel = 8'b1011_1111; digit = ten; end
			2'd2 : begin seg_sel = 8'b0111_1111; digit = one; end
			default : begin seg_sel = 8'b1111_1111; digit = 4'd0; end
		endcase
	end

	always @(*) begin
		case(digit)
			4'd0 : seg_data = 8'b0011_1111;
			4'd1 : seg_data = 8'b0000_0110;
			4'd2 : seg_data = 8'b0101_1011;
			4'd3 : seg_data = 8'b0100_1111;
			4'd4 : seg_data = 8'b0110_0110;
			4'd5 : seg_data = 8'b0110_1101;
			4'd6 : seg_data = 8'b0111_1101;
			4'd7 : seg_data = 8'b0000_0111;
			4'd8 : seg_data = 8'b0111_1111;
			4'd9 : seg_data = 8'b0110_1111;
			default : seg_data = 8'b0000_0000;
		endcase
	end

endmodule
