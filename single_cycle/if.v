module IF(

	input wire		 clk,
	input wire		 rst,        // high is reset
	input wire		 jmp,
	input wire[31:0] new_inst_addr,
	output reg		 ce,
	output reg[31:0] inst_addr

);
	reg[31:0] pc;
  
	always @ (posedge clk or posedge rst)
	if(rst)
		ce <= 1'b0;
	else
		ce <= 1'b1;

	always @ (posedge clk or posedge rst)
	if(rst)
		pc <= 32'b0;
	else if(jmp)
		pc <= new_inst_addr + 32'd4;
	else
		pc <= pc + 32'd4;

	always @ (posedge clk or posedge rst)
	if(rst)
		inst_addr <= 32'b0;
	else if(jmp)
		inst_addr <= new_inst_addr;
	else
		inst_addr <= pc;
    
endmodule