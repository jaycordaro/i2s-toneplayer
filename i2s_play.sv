/* BSD 2-Clause License

Copyright (c) 2021, Jay Cordaro
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */
module i2s_play(input logic clk,    // system clock
				input logic sclk,     
				input logic reset_n,
				output logic [4:0] addr,
				input logic [15:0] word_data,
				input logic ws,
				output logic sdo);
				
	logic [2:0] sync_sclk;
	logic [2:0] sync_ws;
	logic [3:0] bitcnt;
	logic [4:0] wordcnt;
	logic [15:0] i2s_out_word;
	logic sdo_t;
	
	always_ff @ (posedge clk or negedge reset_n)
    begin
        if (~reset_n)
            begin
                sync_sclk <= 3'b000;
                sync_ws   <= 3'b000;
            end
        else
            begin
                sync_sclk <= {sync_sclk[1:0], sclk};
                sync_ws   <= {sync_ws[1:0], ws};
            end
    end
	
	logic sync_sclk_re; 
	logic sync_sclk_fe;
	
	logic i2s_word_start;
	logic i2s_word_end;
	logic i2s_active;
	
	assign i2s_word_start = (sync_ws[2:1]==2'b01) ? 1'b1 : 1'b0;         // ws -- active high
	assign i2s_word_end   = (sync_ws[2:1]==2'b10) ? 1'b1 : 1'b0;       // transaction ends 
	assign i2s_active = sync_ws[1];
	
	assign sync_sclk_fe = (sync_sclk[2:1]==2'b10) ? 1'b1 : 1'b0;  	// falling edge
	assign sync_sclk_re = (sync_sclk[2:1]==2'b01) ? 1'b1 : 1'b0;  	// rising edge
				
	always_ff @(posedge clk, negedge reset_n)
	begin
		if (~reset_n)
			bitcnt <= 4'b0000;
		else if (i2s_word_start)
			bitcnt <= 4'b0000;
		else if (i2s_active && sync_sclk_re)
			bitcnt <= bitcnt + 1;
	end
	
	always_ff @(posedge clk, negedge reset_n)
	begin
		if (~reset_n)
			begin
				i2s_out_word <= 16'b0000_0000_0000_0000;
				wordcnt <= 5'b00000;
			end
		else if (i2s_active && sync_sclk_re)
			i2s_out_word <= {i2s_out_word[14:0], 1'b0};
		else if (i2s_word_end)
			begin
				i2s_out_word <= word_data;
				wordcnt <= wordcnt + 1;
			end
	end
	assign addr = wordcnt;

assign sdo_t = (i2s_active) ? i2s_out_word[15] : 1'b0;

	always_ff @(posedge clk, negedge reset_n)
		if (~reset_n)
			sdo <= 1'b0;
		else if (sync_sclk_re)
			sdo <= sdo_t;
		
endmodule : i2s_play