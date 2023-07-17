module IF(

	input wire		 clk,
	input wire		 rst_n,        // low is reset
	input wire		 jmp,
	input wire		 jmp_from_ex,
	input wire       if_stall,
	input wire[31:0] new_inst_addr,
	input wire[31:0] new_inst_addr_from_ex,
	output reg		 ce,
	output reg[31:0] inst_addr

);
  reg[31:0] pc;//point to the next instruction
  
	always @ (posedge clk or negedge rst_n)
	if(!rst_n)
		ce <= 1'b0;
	else
		ce <= 1'b1;

	always @ (posedge clk or negedge rst_n)
	if(!rst_n)
		pc <= 32'b0;
	else if(if_stall)
		pc <= pc;
	else if(jmp)
		pc <= new_inst_addr + 32'd4;
	else if(jmp_from_ex)
		pc <= new_inst_addr_from_ex + 32'd4;
	else
		pc <= pc + 32'd4;

	always @ (posedge clk or negedge rst_n)
	if(!rst_n)
		inst_addr <= 32'b0;
	else if(if_stall)
		inst_addr <= inst_addr;
	else if(jmp)
		inst_addr <= new_inst_addr;
	else if(jmp_from_ex)
		inst_addr <= new_inst_addr_from_ex;
	else
		inst_addr <= pc;
    
endmodule