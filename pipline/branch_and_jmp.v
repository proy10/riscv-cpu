//For Branch Hazard
//Target address adder and Register comparator
module branch_and_jmp(
  
	input wire[5:0]    alu_op,
	input wire[31:0]   reg_data1,
	input wire[31:0]   reg_data2,
	input wire[31:0]   imm,
	input wire[31:0]   old_inst_addr,
	output reg         jmp,
	output wire[31:0]  new_inst_addr

);

	parameter BEQ  = 6'b001011;
	parameter BLT  = 6'b001100;
	parameter BGE  = 6'b001101;
	parameter JAL  = 6'b001110;
	
  always @ *
  if((alu_op == BEQ && reg_data1 == reg_data2) ||
     (alu_op == BLT && reg_data1 <  reg_data2) ||
     (alu_op == BGE && reg_data1 >= reg_data2) ||
     (alu_op == JAL))
        jmp <= 1'b1;
  else
        jmp <= 1'b0;  

  assign new_inst_addr = old_inst_addr + imm;
        
endmodule  