module debouncer(
	input clk,
	input reset,
	input noisy,
	output clean
	);
	
	localparam COUNTER_MAX = 1000000;
	
	reg [19:0] counter;
	reg [1:0] ff_i;
	reg ff_o;
	
	wire clear_counter;
	wire counter_max;
	
	always @(posedge clk or negedge reset) begin
		if (!reset) begin
			ff_i <= 0;
		end else begin
			ff_i[1:0] <= {ff_i[0], noisy};
		end
	end
	
	assign clear_counter = ^ff_i;
	
	always @(posedge clk or negedge reset) begin
		if (!reset) begin
			counter <= 0;
		end else if (clear_counter || counter_max) begin
			counter <= 0;
		end else begin
			counter <= counter + 1'b1;
		end
	end

	assign counter_max = (counter == COUNTER_MAX);
	
	always @(posedge clk or negedge reset) begin
		if (!reset) begin
			ff_o <= 0;
		end else if (counter_max) begin
			ff_o <= ff_i[1];
		end
	end
	
	assign clean = ff_o;
	
endmodule