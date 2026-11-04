module DAC_disp(
	input clk,
	input rst,
	input [5:0] btn,
	input add_sel,
	output dac_csn,
	output dac_ldacn,
	output dac_wrn,
	output dac_a_b,
	output [7:0] dac_d,
	output [7:0] led_out,
	output [7:0] seg_data,
	output [7:0] seg_sel,
	output lcd_rs,
	output lcd_rw,
	output lcd_e,
	output [7:0] lcd_d
);

	DAC u_dac (
		.clk(clk),
		.rst(rst),
		.btn(btn),
		.add_sel(add_sel),
		.dac_csn(dac_csn),
		.dac_ldacn(dac_ldacn),
		.dac_wrn(dac_wrn),
		.dac_a_b(dac_a_b),
		.dac_d(dac_d),
		.led_out(led_out)
	);

	seg_dac u_seg (
		.clk(clk),
		.rst(rst),
		.value(dac_d),
		.seg_data(seg_data),
		.seg_sel(seg_sel)
	);

	lcd_dac u_lcd (
		.clk(clk),
		.rst(rst),
		.value(dac_d),
		.lcd_rw(lcd_rw),
		.lcd_rs(lcd_rs),
		.lcd_e(lcd_e),
		.lcd_d(lcd_d)
	);

endmodule
