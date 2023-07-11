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

  // wire
  /////////the same as single cycle////////
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
  wire[31:0] data_addr;   //for read/write mem
  wire[31:0] data_to_mem; //for read/write mem
  wire[31:0] imm;
 	wire[31:0] reg_data1;
	wire[31:0] reg_data2;
  wire[31:0] result;      //alu result
  wire[31:0] write_back_data;//for write back
  /////////////////stall/////////////////////
  wire       id_stall_req;
  wire       ex_stall_req;
  wire       mem_stall_req;
  wire       if_stall;
  wire       if_id_stall;
  wire       id_ex_stall;
  wire       ex_mem_stall;
  //////////////////if_id///////////////////
  wire[31:0] inst_addr_to_id;
  wire[31:0] inst_to_id;
  //////////////////id_ex///////////////////
  wire[31:0] inst_addr_to_ex;//for JAL
  wire[4:0]  rs1_to_ex;
  wire[4:0]  rs2_to_ex;
  wire[4:0]  rd_to_ex;
  wire[5:0]  alu_op_to_ex;
  wire       write_reg_to_ex;
  wire       read_mem_to_ex;
  wire       write_mem_to_ex;
  wire[31:0] imm_to_ex;
  wire[31:0] reg_data1_to_ex;   
  wire[31:0] reg_data2_to_ex;
  wire[31:0] data_to_mem_to_ex;
  ////////////////ex_mem///////////////////
  wire[4:0]  rd_to_mem;
  wire       write_reg_to_mem;
  wire       read_mem_to_mem;
  wire       write_mem_to_mem;
  wire[31:0] result_to_mem;
  ////////////////mem_wb///////////////////
  wire[4:0]  rd_to_reg;
  wire       write_reg_to_reg;
  wire       read_mem_to_wb;//use to judge data from alu or mem
  wire[31:0] result_to_wb;
  wire[31:0] data_from_mem_to_wb;
  ////////////////forwading////////////////
  wire[31:0]  new_reg_data1;
  wire[31:0]  new_reg_data2;
  wire[31:0]  br_new_reg_data1;//for branch 
  wire[31:0]  br_new_reg_data2;//for branch
  
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
	    //=================input=================//
			.clk(clk),
			.rst(rst),
			.jmp(jmp),
			.if_stall(if_stall),
			.new_inst_addr(new_inst_addr),
			//================output=================//
			.ce(inst_ce_o),
			.inst_addr(inst_addr)
		);
		
  if_id IF_ID(
      //=================input=================//
      .clk(clk),
		  .rst(rst),
		  .jmp(jmp),
		  .if_id_stall(if_id_stall),
		  .inst_addr_from_if(inst_addr),
		  .inst_from_if(inst_i),
		  //================output=================//
		  .inst_addr_to_id(inst_addr_to_id),
		  .inst_to_id(inst_to_id)
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
	    //=================input=================//
      .inst(inst_to_id),
      //-------------for Data Hazard----------//
      .id_ex_write_reg(write_reg_to_ex),
      .id_ex_read_mem(read_mem_to_ex),
      .id_ex_rd(rd_to_ex),
      .ex_mem_read_mem(read_mem_to_mem),
      .ex_mem_rd(rd_to_mem),
      //================output=================//
      .alu_op(alu_op),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .read_reg1(read_reg1),
      .read_reg2(read_reg2),
      .write_reg(write_reg),
      .read_mem(read_mem),
      .write_mem(write_mem),
      .imm(imm),
     //-------------for Data Hazard----------//
      .id_stall_req(id_stall_req)  
    );
    
  branch_and_jmp #(
 	    .BEQ(BEQ),
	    .BLT(BLT),
	    .BGE(BGE),
	    .JAL(JAL)
	)BRANCH_AND_JMP(
      //=================input=================//
      .alu_op(alu_op),
      .reg_data1(br_new_reg_data1),
      .reg_data2(br_new_reg_data2),
      .imm(imm),
      .old_inst_addr(inst_addr_to_id),
      //================output=================//
      .jmp(jmp),
      .new_inst_addr(new_inst_addr)
    );
      
  id_ex ID_EX(
      //=================input=================//
      //-------------clk rst stall------------//
      .clk(clk),
		  .rst(rst),
		  .if_id_stall(if_id_stall),
		  //-------------for Data Hazard----------//
		  .id_stall_req(id_stall_req),
      //---------reg addr and inst addr-------//
      .inst_addr_from_id(inst_addr_to_id),
		  .rs1_from_id(rs1),
		  .rs2_from_id(rs2),
		  .rd_from_id(rd),
		  //----------------control---------------//
		  .alu_op_from_id(alu_op),
		  .write_reg_from_id(write_reg),
		  .read_mem_from_id(read_mem),
		  .write_mem_from_id(write_mem),
		  //------------------data----------------//
		  .imm_from_id(imm),
		  .reg_data1_from_reg(reg_data1),
		  .reg_data2_from_reg(reg_data2),
		  .data_to_mem_from_reg(data_to_mem),
		  //================output=================//
      //---------reg addr and inst addr-------//
      .inst_addr_to_ex(inst_addr_to_ex),
		  .rs1_to_ex(rs1_to_ex),
		  .rs2_to_ex(rs2_to_ex),
		  .rd_to_ex(rd_to_ex),
		  //-----------------control---------------//
		  .alu_op_to_ex(alu_op_to_ex),
		  .write_reg_to_ex(write_reg_to_ex),
		  .read_mem_to_ex(read_mem_to_ex),
		  .write_mem_to_ex(write_mem_to_ex),
		  //------------------data-----------------//
		  .imm_to_ex(imm_to_ex),
		  .reg_data1_to_ex(reg_data1_to_ex),
		  .reg_data2_to_ex(reg_data2_to_ex),
		  .data_to_mem_to_ex(data_to_mem_to_ex)
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
	    .JAL(JAL)
	)EX(
	    //=================input=================//
      .alu_op(alu_op_to_ex),
      .reg_data1(new_reg_data1),
      .reg_data2(new_reg_data2),
      .imm(imm_to_ex),
      .old_inst_addr(inst_addr_to_ex),
      //================output=================//
      .result(result)
    );
    
  ex_mem EX_MEM(
      //=================input=================//
      //-------------clk rst stall------------//
      .clk(clk),
		  .rst(rst),
		  .ex_mem_stall(ex_mem_stall),
		  //---------------reg addr---------------//
		  .rd_from_ex(rd_to_ex),
		  //----------------control---------------//
		  .write_reg_from_ex(write_reg_to_ex),
		  .read_mem_from_ex(read_mem_to_ex),
		  .write_mem_from_ex(write_mem_to_ex),
		  //------alu result and data to mem------//
		  .result_from_ex(result),
		  .data_to_mem_from_ex(data_to_mem_to_ex),
		  //================output=================//
		  //---------------reg addr---------------//
		  .rd_to_mem(rd_to_mem),
		  //----------------control---------------//
		  .write_reg_to_mem(write_reg_to_mem),
		  .read_mem_to_mem(read_mem_to_mem),
		  .write_mem_to_mem(write_mem_to_mem),
		  //------alu result and data to mem------//
		  .result_to_mem(result_to_mem),
		  .data_to_mem_to_mem(data_o)
		 );
		             
  mem MEM(
      //=================input=================//
      .read_mem(read_mem_to_mem),
      .write_mem(write_mem_to_mem),
      .result(result_to_mem),
      //================output=================//
      .ce(data_ce_o),
      .we(data_we_o),
      .data_addr(data_addr_o)
    );
    
  mem_wb MEM_WB(
      //=================input=================//
      //----------------clk rst---------------//
      .clk(clk),
		.rst(rst),
		//----------------reg addr--------------//
		.rd_from_mem(rd_to_mem),
		//----------------control---------------//
		.write_reg_from_mem(write_reg_to_mem),
		.read_mem_from_mem(read_mem_to_mem),
		//----alu result and data from mem------//
		.result_from_mem(result_to_mem),
		.data_from_mem_from_mem(data_i),
		//================output=================//
      //----------------reg addr--------------//
      .rd_to_reg(rd_to_reg),
      //----------------control---------------//
      .write_reg_to_reg(write_reg_to_reg),
      .read_mem_to_wb(read_mem_to_wb),
      //----alu result and data from mem------//
      .result_to_wb(result_to_wb),
      .data_from_mem_to_wb(data_from_mem_to_wb)
    );
    
  wb  WB(
      //=================input=================//
      .read_mem(read_mem_to_wb),
      .result(result_to_wb),
      .data_from_mem(data_from_mem_to_wb),
      //================output=================//
      .write_back_data(write_back_data)
    );
      
  register REGISTER(
      //=================input=================//
      .clk(clk),
		.rst(rst),
		.read_reg1(read_reg1),
      .read_reg2(read_reg2),
      .write_mem(write_mem),
      .rs1(rs1),
      .rs2(rs2),
      .write_reg(write_reg_to_reg),
      .rd(rd_to_reg),
      .write_back_data(write_back_data),
      //================output=================//
			.reg_data1(reg_data1),
      .reg_data2(reg_data2),
      .data_to_mem(data_to_mem)
    );
      
  assign ex_stall_req = 1'b0;//no used now
  assign mem_stall_req = 1'b0;//no used now
  stall STALL(
      //=================input=================//
      .stall_req_id(id_stall_req),
      .stall_req_ex(ex_stall_req),
      .stall_req_men(mem_stall_req),
      //================output=================//
      .if_stall(if_stall),
      .if_id_stall(if_id_stall),
      .id_ex_stall(id_ex_stall),
      .ex_mem_stall(ex_mem_stall)
    );
    
  forwarding EX_FORWARDING( //Solve Data Hazards for ex
      //=================input=================//
      .id_ex_rs1(rs1_to_ex),
      .id_ex_rs2(rs2_to_ex),
      .ex_mem_write_reg(write_reg_to_mem),
      .ex_mem_rd(rd_to_mem),
      .mem_wb_write_reg(write_reg_to_reg),
      .mem_wb_rd(rd_to_reg),
      .ex_mem_result(result_to_mem),
      .write_back_data(write_back_data),
      .old_reg_data1(reg_data1_to_ex),
      .old_reg_data2(reg_data2_to_ex),
      //================output=================//
      .new_reg_data1(new_reg_data1),
      .new_reg_data2(new_reg_data2)
    );
    
    forwarding ID_FORWARDING( //Solve Data Hazards for id(for branch) 
      //=================input=================//
      .id_ex_rs1(rs1),
      .id_ex_rs2(rs2),
      .ex_mem_write_reg(write_reg_to_mem),
      .ex_mem_rd(rd_to_mem),
      .mem_wb_write_reg(write_reg_to_reg),
      .mem_wb_rd(rd_to_reg),
      .ex_mem_result(result_to_mem),
      .write_back_data(write_back_data),
      .old_reg_data1(reg_data1),
      .old_reg_data2(reg_data2),
      //================output=================//
      .new_reg_data1(br_new_reg_data1),
      .new_reg_data2(br_new_reg_data2)
    );
      
endmodule