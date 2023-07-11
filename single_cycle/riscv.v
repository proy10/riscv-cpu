module riscv(

	input wire		 clk,
	input wire		 rst,        // high is reset
	
    // inst_mem
	input wire[31:0]         inst_i,
	output wire[31:0]        inst_addr_o,
	output wire              inst_ce_o,	

    // data_mem
	input wire[31:0]         data_i,      // load data from data_mem
	output wire              data_we_o,
	output wire              data_ce_o,
	output wire[31:0]        data_addr_o,
	output wire[31:0]        data_o       // store data to  data_mem

);

//  instance your module  below
	wire       jmp;
	wire       read_reg1;
	wire       read_reg2;
	wire       write_reg;
	wire       read_mem;
	wire       write_mem;
	wire[31:0] inst_addr;
	wire[31:0] new_inst_addr;
	wire[5:0]  alu_op;
	wire[4:0]  rs1;
	wire[4:0]  rs2;
	wire[4:0]  rd;
	wire[31:0] imm;
	wire[31:0] reg_data1;
	wire[31:0] reg_data2;
	wire[31:0] result;      //alu result

  //parameter
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

  assign inst_addr_o = inst_addr;

	IF IF(
			.clk(clk),
			.rst(rst),
			.jmp(jmp),
			.new_inst_addr(new_inst_addr),
			.ce(inst_ce_o),
			.inst_addr(inst_addr)
		);
  
  id #(
	    .ADD(ADD),
	    .SUB(SUB),
	    .SLL(SLL),
	    .XOR(XOR),
	    .SRL(SRL),
	    .OR(OR),
	    .AND(AND),
	    .LW(LW),
	    .ADDI(ADDI),
	    .SW(SW),
	    .BEQ(BEQ),
	    .BLT(BLT),
	    .BGE(BGE),
	    .JAL(JAL)
	)ID(
      .inst(inst_i),
      .alu_op(alu_op),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .read_reg1(read_reg1),
      .read_reg2(read_reg2),
      .write_reg(write_reg),
      .read_mem(read_mem),
      .write_mem(write_mem),
      .imm(imm)
    );
    
  ex #(
	    .ADD(ADD),
	    .SUB(SUB),
	    .SLL(SLL),
	    .XOR(XOR),
	    .SRL(SRL),
	    .OR(OR),
	    .AND(AND),
	    .LW(LW),
	    .ADDI(ADDI),
	    .SW(SW),
	    .BEQ(BEQ),
	    .BLT(BLT),
	    .BGE(BGE),
	    .JAL(JAL)
	)EX(
      .alu_op(alu_op),
      .old_inst_addr(inst_addr),
      .reg_data1(reg_data1),
      .reg_data2(reg_data2),
      .imm(imm),
      .jmp(jmp),
      .new_inst_addr(new_inst_addr),
      .data_addr(data_addr_o),
      .result(result)
    );
  
  mem MEM(
      .read_mem(read_mem),
      .write_mem(write_mem),
      .ce(data_ce_o),
      .we(data_we_o)
    );
    
  register REGISTER(
      .clk(clk),
	  .rst(rst),
	  .read_reg1(read_reg1),
      .read_reg2(read_reg2),
      .write_reg(write_reg),
      .read_mem(read_mem),
      .write_mem(write_mem),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .result(result),
      .data_from_mem(data_i),
	  .reg_data1(reg_data1),
      .reg_data2(reg_data2),
      .data_to_mem(data_o)
    );
      
endmodule