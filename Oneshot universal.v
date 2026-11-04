module oneshot_universal #(parameter WIDTH = 6) (
	input clk,
	input rst,
	input [WIDTH-1:0] btn,
	output reg [WIDTH-1:0] btn_t
);

	reg [WIDTH-1:0] btn_d;

	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			btn_d <= {WIDTH{1'b0}};
			btn_t <= {WIDTH{1'b0}};
		end
		else begin
			btn_d <= btn;
			btn_t <= btn & ~btn_d;
		end
	end

endmodule
