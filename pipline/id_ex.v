module id_ex(
  
  //=================input=================//
  //-------------clk rst_n stall------------//
  input wire       clk,
  input wire       rst_n,
  input wire       if_id_stall,
  //-------------for Data Hazard----------//
  input wire       id_stall_req,//Force control values to 0
  //---------reg addr and inst addr-------//
  input wire[31:0] inst_addr_from_id,
  input wire[4:0]  rs1_from_id,
  input wire[4:0]  rs2_from_id,
  input wire[4:0]  rd_from_id,
  //----------------control---------------//
  input wire[5:0]  alu_op_from_id,
  input wire       write_reg_from_id,
  input wire       read_mem_from_id,
  input wire       write_mem_from_id,
  input wire       jmp_from_id,
  input wire       flush,
  //------------------data----------------//
  input wire[31:0] imm_from_id,
  input wire[31:0] reg_data1_from_reg,
  input wire[31:0] reg_data2_from_reg,
  input wire[31:0] data_to_mem_from_reg,
  //================output=================//
  //---------reg addr and inst addr-------//
  output reg[31:0] inst_addr_to_ex,
  output reg[4:0]  rs1_to_ex,
  output reg[4:0]  rs2_to_ex,
  output reg[4:0]  rd_to_ex,
  //-----------------control---------------//
  output reg[5:0]  alu_op_to_ex,
  output reg       write_reg_to_ex,
  output reg       read_mem_to_ex,
  output reg       write_mem_to_ex,
  output reg       jmp_to_ex,
  //------------------data-----------------//
  output reg[31:0] imm_to_ex,
  output reg[31:0] reg_data1_to_ex,   
  output reg[31:0] reg_data2_to_ex,
  output reg[31:0] data_to_mem_to_ex
  
);
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    inst_addr_to_ex <= 32'bz;
  else if(if_id_stall)
    inst_addr_to_ex <= inst_addr_to_ex;
  else if(flush)
    inst_addr_to_ex <= 32'b0;
  else
    inst_addr_to_ex <= inst_addr_from_id;
  
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    rs1_to_ex <= 5'bz;
  else if(if_id_stall)
    rs1_to_ex <= rs1_to_ex;
  else if(flush)
    rs1_to_ex <= 5'b0;
  else
    rs1_to_ex <= rs1_from_id;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    rs2_to_ex <= 5'bz;
  else if(if_id_stall)
    rs2_to_ex <= rs2_to_ex;
  else if(flush)
    rs2_to_ex <= 5'b0;
  else
    rs2_to_ex <= rs2_from_id;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    rd_to_ex <= 5'bz;
  else if(if_id_stall)
    rd_to_ex <= rd_to_ex;
  else if(flush)
    rd_to_ex <= 5'b0;
  else
    rd_to_ex <= rd_from_id;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    alu_op_to_ex <= 6'bz;
  else if(id_stall_req)
    alu_op_to_ex <= 6'bz;
  else if(if_id_stall)
    alu_op_to_ex <= alu_op_to_ex;
  else if(flush)
    alu_op_to_ex <= 6'b0;
  else
    alu_op_to_ex <= alu_op_from_id;

  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    jmp_to_ex <= 1'bz;
  else if(id_stall_req)
    jmp_to_ex <= 1'bz;
  else if(if_id_stall)
    jmp_to_ex <= jmp_to_ex;
  else if(flush)
    jmp_to_ex <= 1'b0;
  else
    jmp_to_ex <= jmp_from_id;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    write_reg_to_ex <= 1'bz;
  else if(id_stall_req)
    write_reg_to_ex <= 1'b0;
  else if(if_id_stall)
    write_reg_to_ex <= write_reg_to_ex;
  else if(flush)
    write_reg_to_ex <= 1'b0;
  else
    write_reg_to_ex <= write_reg_from_id;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    read_mem_to_ex <= 1'bz;
  else if(id_stall_req)
    read_mem_to_ex <= 1'b0;
  else if(if_id_stall)
    read_mem_to_ex <= read_mem_to_ex;
  else if(flush)
    read_mem_to_ex <= 1'b0;
  else
    read_mem_to_ex <= read_mem_from_id;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    write_mem_to_ex <= 1'bz;
  else if(id_stall_req)
    write_mem_to_ex <= 1'b0;
  else if(if_id_stall)
    write_mem_to_ex <= write_mem_to_ex;
  else if(flush)
    write_mem_to_ex <= 1'b0;
  else
    write_mem_to_ex <= write_mem_from_id;

  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    imm_to_ex <= 32'bz;
  else if(if_id_stall)
    imm_to_ex <= imm_to_ex;
  else if(flush)
    imm_to_ex <= 32'b0;
  else
    imm_to_ex <= imm_from_id;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    reg_data1_to_ex <= 32'bz;
  else if(if_id_stall)
    reg_data1_to_ex <= reg_data1_to_ex;
  else if(flush)
    reg_data1_to_ex <= 32'b0;
  else
    reg_data1_to_ex <= reg_data1_from_reg;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    reg_data2_to_ex <= 32'bz;
  else if(if_id_stall)
    reg_data2_to_ex <= reg_data2_to_ex;
  else if(flush)
    reg_data2_to_ex <= 32'b0;
  else
    reg_data2_to_ex <= reg_data2_from_reg;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    data_to_mem_to_ex <= 32'bz;
  else  if(if_id_stall)
    data_to_mem_to_ex <= data_to_mem_to_ex;
  else if(flush)
    data_to_mem_to_ex <= 32'b0;
  else
    data_to_mem_to_ex <= data_to_mem_from_reg;
    
endmodule    