module lcd_dac(
	input clk,
	input rst,
	input [7:0] value,
	output lcd_rw,
	output reg lcd_rs,
	output reg lcd_e,
	output reg [7:0] lcd_d
);

	localparam S_PWR = 3'd0,
		S_SETUP = 3'd1,
		S_EHI = 3'd2,
		S_ELO = 3'd3,
		S_WAIT = 3'd4;

	parameter PWR_WAIT = 16'd20000;

	reg [2:0] state;
	reg [15:0] cnt;
	reg [5:0] idx;
	reg is_data;
	reg [7:0] byte_out;
	reg [15:0] wait_len;

	wire [3:0] hun = value / 8'd100;
	wire [3:0] ten = (value % 8'd100) / 8'd10;
	wire [3:0] one = value % 8'd10;

	assign lcd_rw = 1'b0;

	always @(*) begin
		is_data = 1'b1;
		byte_out = 8'h20;
		case(idx)
			6'd0, 6'd1, 6'd2 : begin is_data = 1'b0; byte_out = 8'h38; end
			6'd3 : begin is_data = 1'b0; byte_out = 8'h0C; end
			6'd4 : begin is_data = 1'b0; byte_out = 8'h01; end
			6'd5 : begin is_data = 1'b0; byte_out = 8'h06; end
			6'd6 : begin is_data = 1'b0; byte_out = 8'h80; end
			6'd7 : byte_out = "D";
			6'd8 : byte_out = "A";
			6'd9 : byte_out = "C";
			6'd10 : byte_out = " ";
			6'd11 : byte_out = "I";
			6'd12 : byte_out = "N";
			6'd13 : byte_out = " ";
			6'd14 : byte_out = "D";
			6'd15 : byte_out = "E";
			6'd16 : byte_out = "C";
			6'd17 : byte_out = " ";
			6'd18 : byte_out = ":";
			6'd19 : byte_out = " ";
			6'd20 : byte_out = {4'h3, hun};
			6'd21 : byte_out = {4'h3, ten};
			6'd22 : byte_out = {4'h3, one};
			6'd23 : begin is_data = 1'b0; byte_out = 8'hC0; end
			6'd24 : byte_out = "B";
			6'd25 : byte_out = "I";
			6'd26 : byte_out = "N";
			6'd27 : byte_out = " ";
			6'd28 : byte_out = ":";
			6'd29 : byte_out = " ";
			6'd30 : byte_out = {7'h18, value[7]};
			6'd31 : byte_out = {7'h18, value[6]};
			6'd32 : byte_out = {7'h18, value[5]};
			6'd33 : byte_out = {7'h18, value[4]};
			6'd34 : byte_out = {7'h18, value[3]};
			6'd35 : byte_out = {7'h18, value[2]};
			6'd36 : byte_out = {7'h18, value[1]};
			6'd37 : byte_out = {7'h18, value[0]};
			default : byte_out = 8'h20;
		endcase
	end

	always @(*) begin
		case(idx)
			6'd0 : wait_len = 16'd5000;
			6'd1 : wait_len = 16'd150;
			6'd4 : wait_len = 16'd2000;
			default : wait_len = 16'd50;
		endcase
	end

	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			state <= S_PWR;
			cnt <= 16'd0;
			idx <= 6'd0;
			lcd_rs <= 1'b0;
			lcd_e <= 1'b0;
			lcd_d <= 8'h00;
		end
		else begin
			case(state)
				S_PWR : begin
					if(cnt >= PWR_WAIT) begin
						cnt <= 16'd0;
						state <= S_SETUP;
					end
					else cnt <= cnt + 1'b1;
				end
				S_SETUP : begin
					lcd_rs <= is_data;
					lcd_d <= byte_out;
					lcd_e <= 1'b0;
					if(cnt >= 16'd2) begin
						cnt <= 16'd0;
						state <= S_EHI;
					end
					else cnt <= cnt + 1'b1;
				end
				S_EHI : begin
					lcd_e <= 1'b1;
					if(cnt >= 16'd2) begin
						cnt <= 16'd0;
						state <= S_ELO;
					end
					else cnt <= cnt + 1'b1;
				end
				S_ELO : begin
					lcd_e <= 1'b0;
					cnt <= 16'd0;
					state <= S_WAIT;
				end
				S_WAIT : begin
					if(cnt >= wait_len) begin
						cnt <= 16'd0;
						state <= S_SETUP;
						if(idx == 6'd37) idx <= 6'd6;
						else idx <= idx + 1'b1;
					end
					else cnt <= cnt + 1'b1;
				end
				default : state <= S_PWR;
			endcase
		end
	end

endmodule
