module mem_wb(
  
  //=================input=================//
  //----------------clk rst---------------//
  input wire        clk,
  input wire        rst,
  //----------------reg addr--------------//
  input wire[4:0]   rd_from_mem,
  //----------------control---------------//
  input wire        write_reg_from_mem,
  input wire        read_mem_from_mem,// use to judge data from alu or mem
  //----alu result and data from mem------//
  input wire[31:0]  result_from_mem,
  input wire[31:0]  data_from_mem_from_mem,
  //================output=================//
  //----------------reg addr--------------//
  output reg[4:0]   rd_to_reg,
  //----------------control---------------//
  output reg        write_reg_to_reg,
  output reg        read_mem_to_wb,// use to judge data from alu or mem
  //----alu result and data from mem------//
  output reg[31:0]  result_to_wb,
  output reg[31:0]  data_from_mem_to_wb
  
);

  always @ (posedge clk or negedge rst)
  if(rst)
    rd_to_reg <= 5'bz;
  else
    rd_to_reg <= rd_from_mem;
    
  always @ (posedge clk or negedge rst)
  if(rst)
    write_reg_to_reg <= 1'bz;
  else
    write_reg_to_reg <= write_reg_from_mem;
    
  always @ (posedge clk or negedge rst)
  if(rst)
    read_mem_to_wb <= 1'bz;
  else
    read_mem_to_wb <= read_mem_from_mem;
    
  always @ (posedge clk or negedge rst)
  if(rst)
    result_to_wb <= 32'bz;
  else
    result_to_wb <= result_from_mem;
    
  always @ (posedge clk or negedge rst)
  if(rst)
    data_from_mem_to_wb <= 32'bz;
  else
    data_from_mem_to_wb <= data_from_mem_from_mem;
    
endmodule