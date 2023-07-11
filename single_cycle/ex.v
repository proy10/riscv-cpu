module ex(
  
 	input wire[5:0]	   alu_op,
 	input wire[31:0]   old_inst_addr,
 	input wire[31:0]   reg_data1,
 	input wire[31:0]   reg_data2,
	input wire[31:0]   imm,
	output reg         jmp,
	output reg[31:0]   new_inst_addr,
	output reg[31:0]   data_addr,
	output reg[31:0]   result
	
);
	parameter ADD  = 6'b000001;
	parameter SUB  = 6'b000010;
	parameter SLL  = 6'b000011;
	parameter XOR  = 6'b000100;
	parameter SRL  = 6'b000101;
	parameter OR   = 6'b000110;
	parameter AND  = 6'b000111;
	parameter LW   = 6'b001000;
	parameter ADDI = 6'b001001;
	parameter SW   = 6'b001010;
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

  always @ *
  if((alu_op == BEQ && reg_data1 == reg_data2) ||
     (alu_op == BLT && reg_data1 <  reg_data2) ||
     (alu_op == BGE && reg_data1 >= reg_data2) ||
     (alu_op == JAL))
        new_inst_addr <= old_inst_addr + imm;
  else
        new_inst_addr <= 32'bz;
  
  always @ *
  if(alu_op == LW || alu_op == SW)
    data_addr <= reg_data1 + imm;
  else
    data_addr <= 32'bz;
  
  always @ *
  begin 
  result <= 32'bx;
    case(alu_op)
    ADD:
      result <= reg_data1 + reg_data2;
    SUB:
      result <= reg_data1 + (~reg_data2) + 32'b1;
    SLL:
      result <= reg_data1 << reg_data2[4:0];
    XOR:
      result <= reg_data1 ^ reg_data2;
    SRL:
      result <= reg_data1 >> reg_data2[4:0];
    OR:
      result <= reg_data1 | reg_data2;
    AND:
      result <= reg_data1 & reg_data2;
    ADDI:
      result <= reg_data1 + imm;
    JAL:
      result <= old_inst_addr + 32'd4;
    default:
      result <= 32'bz;
    endcase
  end
endmodule