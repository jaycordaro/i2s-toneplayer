module i2s_top(
		input INPUT_CLK,
		input reset_n,
		input logic sclk,
		input logic ws,
		output logic sdo
		);
		
	logic clk;
	logic [15:0] word_data;
	logic [4:0] addr;
	//logic [31:0] word_data;
	
	pll	pll_inst (
		.inclk0 ( INPUT_CLK ),
		.c0 ( clk ),
		.c1 (CLKOUT)
		);
	
	i2srom	i2srom_inst (
		.address 	(addr),	
		.clock		(clk),
		.q			(word_data)
	);
		
	i2s_play i2s_play_inst(
		.clk 		(clk),
		.sclk		(sclk),
		.reset_n 	(reset_n),
		.addr		(addr),
		.word_data	(word_data),
		.ws			(ws),
		.sdo		(sdo)	
	);
	
endmodule : i2s_top