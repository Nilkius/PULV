module sevseg (input clk, reset, button1, button2,
				 output reg [3:0] wys,
				 output reg [7:0] segment);
				 
reg [23:0] counter;
reg [23:0] counter2;
reg [23:0] counter3;
reg [3:0] led_bcd;
reg [1:0] stan = 0, stan_nast = 0;
reg [15:0] keyval1 = 16'h0000;
reg running = 0;
reg running2 = 0;
reg mode = 0;
reg button1_prev;
reg button2_prev;

parameter [1:0] stan0 = 0, stan1 = 1, stan2 = 2, stan3 = 3;

//initial begin 
//	keyval = 16'h1234;
//	end

always@(posedge clk or negedge reset) begin
	if(!reset) begin
		counter <= 0;
	end else begin
			counter <= counter + 1;
			if(counter >= 10000) begin
				counter <= 0;
				stan <= stan_nast;
			end else begin
				stan <= stan;
			end
		end
	end

			
always@(posedge clk) begin
	if (!reset) begin
		counter2 <= 0;
		counter3 <= 0;
		running <= 1;
		running2 <= 1;
		keyval1 <= (mode == 1) ? 16'h6000 : 16'h0000;
	end else begin
	if (button2 && !button2_prev) begin
		mode <= ~mode;
		keyval1 <= (mode == 1) ? 16'h6000 : 16'h0000;
	end
	
	
	
	if (mode == 1) begin
	if (button1 && !button1_prev) begin
		running <= ~running;
	 end else if (running == 1) begin
			counter2 <= counter2 + 1;
			if (counter2 >= 10000000) begin
				counter2 <= 0;
				keyval1[3:0] <= keyval1[3:0] + 1;
			end
			if (keyval1[3:0] > 9) begin
				keyval1[7:4] <= keyval1[7:4] +1;
				keyval1[3:0] <= 0;
			end
			if (keyval1[7:4] == 6) begin
				keyval1[11:8] <= keyval1[11:8] +1;
				keyval1[7:4] <= 0;
				keyval1[3:0] <= 0;
			end
			if (keyval1[11:8] > 9) begin
				keyval1[15:12] <= keyval1[15:12] +1;
				keyval1[11:8] <= 0;
			end
		end
	end else begin
	if( button1 && !button1_prev) begin
		running2 <= ~running2;
	end else if (running2 == 1) begin
		counter3 <= counter3 + 1;
		if(counter3 >= 10000000) begin
			counter3 <= 0;
			keyval1[3:0] <= keyval1[3:0] - 1;
		end
		if (keyval1[3:0] > 9) begin
			keyval1[7:4] <= keyval1[7:4] - 1;
			keyval1[3:0] <= 9;
			end
			if (keyval1[7:4] > 9) begin
				keyval1[11:8] <= keyval1[11:8] - 1;
				keyval1[7:4] <= 5;
				keyval1[3:0] <= 9;
			end
			if (keyval1[11:8] > 9) begin
				keyval1[15:12] <= keyval1[15:12] - 1;
				keyval1[11:8] <= 9;
			end
		end
	end
end
	button2_prev <= button2;
	button1_prev <= button1;
end


always@(*)
begin
	stan_nast <= stan;
	case(stan)
		stan0:
		begin
			wys <= 4'b0001;
			led_bcd <= keyval1[3:0];
			segment[7] = 1'b0;
			stan_nast <= stan1;
		end
		stan1:
		begin
			wys <= 4'b0010;
			led_bcd <= keyval1[7:4];
			segment[7] = 1'b0;
			stan_nast <= stan2;
		end
		stan2:
		begin
			wys <= 4'b0100;
			led_bcd <= keyval1[11:8];
			segment[7] = 1'b1;
			stan_nast <= stan3;
		end
		stan3:
		begin
			wys <= 4'b1000;
			led_bcd <= keyval1[15:12];
			segment[7] = 1'b0;
			stan_nast <= stan0;
		end
	endcase
end

always@(*)
begin
	case(led_bcd)
			4'b0000: segment[6:0] = 7'b00111111;//0
			4'b0001: segment[6:0] = 7'b00000110;//1
			4'b0010: segment[6:0] = 7'b01011011;//2
			4'b0011: segment[6:0] = 7'b01001111;//3
			4'b0100: segment[6:0] = 7'b01100110;//4
			4'b0101: segment[6:0] = 7'b01101101;//5
			4'b0110: segment[6:0] = 7'b01111101;//6
			4'b0111: segment[6:0] = 7'b00000111;//7
			4'b1000: segment[6:0] = 7'b01111111;//8
			4'b1001: segment[6:0] = 7'b01101111;//9
			4'b1010: segment[6:0] = 7'b01110111;//A
			4'b1011: segment[6:0] = 7'b01111111;//B
			4'b1100: segment[6:0] = 7'b00111001;//C
			4'b1101: segment[6:0] = 7'b00111111;//D
			4'b1110: segment[6:0] = 7'b01111001;//E
			4'b1111: segment[6:0]= 7'b01110001;//F
			default: segment[6:0] = 7'b00000000;//-
	endcase
end

endmodule	