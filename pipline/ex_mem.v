module ex_mem(
  
  //=================input=================//
  //-------------clk rst_n stall------------//
  input wire        clk,
  input wire        rst_n,
  input wire        ex_mem_stall,
  //---------------reg addr---------------//
  input wire[4:0]   rd_from_ex,
  //----------------control---------------//
  input wire        write_reg_from_ex,
  input wire        read_mem_from_ex,
  input wire        write_mem_from_ex,
  //------alu result and data to mem------//
  input wire[31:0]  result_from_ex,
  input wire[31:0]  data_to_mem_from_ex,
  //================output=================//
  //---------------reg addr---------------//
  output reg[4:0]   rd_to_mem,
  //----------------control---------------//
  output reg        write_reg_to_mem,
  output reg        read_mem_to_mem,
  output reg        write_mem_to_mem,
  //------alu result and data to mem------//
  output reg[31:0]  result_to_mem,
  output reg[31:0]  data_to_mem_to_mem
  
);

  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    rd_to_mem <= 5'bz;
  else if(ex_mem_stall)
    rd_to_mem <= rd_to_mem;
  else
    rd_to_mem <= rd_from_ex;
      
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    write_reg_to_mem <= 1'bz;
  else if(ex_mem_stall)
    write_reg_to_mem <= write_reg_to_mem;
  else
    write_reg_to_mem <= write_reg_from_ex;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    read_mem_to_mem <= 1'bz;
  else if(ex_mem_stall)
    read_mem_to_mem <= read_mem_to_mem;
  else
    read_mem_to_mem <= read_mem_from_ex;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    write_mem_to_mem <= 1'bz;
  else if(ex_mem_stall)
    write_mem_to_mem <= write_mem_to_mem;
  else
    write_mem_to_mem <= write_mem_from_ex;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    result_to_mem <= 32'bz;
  else if(ex_mem_stall)
    result_to_mem <= result_to_mem;
  else
    result_to_mem <= result_from_ex;
    
  always @ (posedge clk or negedge rst_n)
  if(!rst_n)
    data_to_mem_to_mem <= 32'bz;
  else if(ex_mem_stall)
    data_to_mem_to_mem <= data_to_mem_to_mem;
  else
    data_to_mem_to_mem <= data_to_mem_from_ex;
    
endmodule   