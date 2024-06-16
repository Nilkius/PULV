module top(
	input clk,
	input reset,
	input button1,
	input button2,
	output [3:0] wys,
	output [7:0] segment
	);
	
	wire debounced_button1;
	wire debounced_button2;
	
	debouncer u_debouncer1 (
		.clk(clk),
		.reset(reset),
		.noisy(button1),
		.clean(debounced_button1)
		);
	debouncer u_debouncer2 (
		.clk(clk),
		.reset(reset),
		.noisy(button2),
		.clean(debounced_button2)
		);
	
	sevseg u_sevseg(
		.clk(clk),
		.reset(reset),
		.button1(debounced_button1),
		.button2(debounced_button2),
		.wys(wys),
		.segment(segment)
		);
		
endmodule
		