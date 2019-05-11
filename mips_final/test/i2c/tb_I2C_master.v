
`timescale 1ns/1ps

module tb_I2C_master (); /* this is automatically generated */

	reg sys_clock;
    wire        SDA;
	wire        SCL;
	reg        reset;
	reg [31:0] ctrl_data;
	reg        wr_ctrl;
	wire [31:0] status;
	wire [7:0] IOout;

	PULLUP i1 (.O(SDA));
	PULLUP i0 (.O(SCL));
	// clock
	initial begin
		sys_clock = 1'b0;
		reset = 1'b1;
		ctrl_data = 32'h0;
		wr_ctrl = 1'b0;

		#15
		reset = 1'b0;
		#10
		ctrl_data = 32'h80AEAA00;
		#1700
		wr_ctrl = 1'b1;
		#100
		wr_ctrl = 1'b0;
		#5000
		$finish;

	end

	// (*NOTE*) replace reset, clock, others

	localparam freq          = 1;
	
	always #2.5 sys_clock = ~sys_clock;

	I2C_master #(
			.freq(freq)
		) inst_I2C_master (
			.SDA       (SDA),
			.SCL       (SCL),
			.sys_clock (sys_clock),
			.reset     (reset),
			.ctrl_data (ctrl_data),
			.wr_ctrl   (wr_ctrl),
			.status    (status)
		);


endmodule
