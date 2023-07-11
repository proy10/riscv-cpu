module id(
	
	input  wire[31:0]	inst,
	output reg[5:0]	   	alu_op,
	output reg[4:0]	    rs1,
	output reg[4:0]	    rs2,
	output reg[4:0]	    rd,
	output reg		    read_reg1,
	output reg		    read_reg2,
	output reg		    write_reg,
	output reg          read_mem,
	output reg          write_mem,
	output reg[31:0]    imm
	
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
	begin
	  alu_op <= 6'bx;
		case(inst[6:0])
			7'b0110011: 
				case(inst[14:12])
					3'b000:
						if(inst[31:25] == 7'b0)
							alu_op <= ADD;
						else
							alu_op <= SUB;
					3'b001:
						alu_op <= SLL;
					3'b100:
						alu_op <= XOR;
					3'b101:
						alu_op <= SRL;
					3'b110:
						alu_op <= OR;
					3'b111:
						alu_op <= AND;
					default:
					  alu_op <= 6'bz;
				endcase
			7'b0000011:
				alu_op <= LW;
			7'b0010011:
				alu_op <= ADDI;
			7'b0100011:
				alu_op <= SW;
			7'b1100011:
				if(inst[14:12] == 3'b000)
					alu_op <= BEQ;
				else if(inst[14:12] == 3'b100)
					alu_op <= BLT;
				else
				  alu_op <= BGE;
			7'b1101111:
				alu_op <= JAL;
			default:
			  alu_op <= 6'bz;
		endcase
	end

	always @ *
	if(inst[6:0] == 7'b0110011 ||
	   inst[6:0] == 7'b0000011 ||
	   inst[6:0] == 7'b0010011 ||
	   inst[6:0] == 7'b0100011 ||
	   inst[6:0] == 7'b1100011)//R or I or S or B
	    read_reg1 <= 1'b1;
	else
	    read_reg1 <= 1'b0;
	    
 	always @ *
	if(inst[6:0] == 7'b0110011 ||
	   inst[6:0] == 7'b0000011 ||
	   inst[6:0] == 7'b0010011 ||
	   inst[6:0] == 7'b0100011 ||
	   inst[6:0] == 7'b1100011)//R or I or S or B
	    rs1 <= inst[19:15];
	else
	    rs1 <= 5'bz;
	    
	always @ *
	if(inst[6:0] == 7'b0110011 ||
	   inst[6:0] == 7'b0100011 ||
	   inst[6:0] == 7'b1100011)//R or S or B
	    read_reg2 <= 1'b1;
	else
	    read_reg2 <= 1'b0;
	    
	always @ *
	if(inst[6:0] == 7'b0110011 ||
	   inst[6:0] == 7'b0100011 ||
	   inst[6:0] == 7'b1100011)//R or S or B
	     rs2 <= inst[24:20];
	else
	     rs2 <= 5'bz;
	     
	always @ *
	if(inst[6:0] == 7'b0110011 ||
	   inst[6:0] == 7'b0000011 ||
	   inst[6:0] == 7'b0010011 ||
	   inst[6:0] == 7'b1101111)//R or I or J
	     write_reg <= 1'b1;
	else
	     write_reg <= 1'b0;
	 
	always @ *
	if(inst[6:0] == 7'b0110011 ||
	   inst[6:0] == 7'b0000011 ||
	   inst[6:0] == 7'b0010011 ||
	   inst[6:0] == 7'b1101111)//R or I or J
	     rd <= inst[11:7];
	else
	     rd <= 5'bz;
	     
	always @ *
	if(inst[6:0] == 7'b0000011)
	   read_mem <= 1'b1;
	else
	   read_mem <= 1'b0;
	   
	always @ *
	if(inst[6:0] == 7'b0100011)
	   write_mem <= 1'b1;
	else
	   write_mem <= 1'b0;
	   	 
	always @ *
	begin
	imm = 32'bx; 
	  case(inst[6:0])
	   7'b0000011://I type
	      if(inst[31])
	        imm <= {20'hfffff, inst[31:20]};
	     else
	        imm <= {20'b0, inst[31:20]};
	   7'b0010011://I type
	     if(inst[31])
	        imm <= {20'hfffff, inst[31:20]};
	     else
	        imm <= {20'b0, inst[31:20]};
	   7'b0100011://S type
	      if(inst[31])
	        imm <= {20'hfffff, inst[31:25], inst[11:7]};
	     else
	        imm <= {20'b0, inst[31:25], inst[11:7]};    
  	  7'b1100011://B type
	       if(inst[31])
	         imm <= {20'hfffff, inst[7], inst[30:25], inst[11:8], 1'b0};
	      else
	         imm <= {20'b0, inst[7], inst[30:25], inst[11:8], 1'b0};
	   7'b1101111://J type
  	     if(inst[31])
	        imm <= {12'hfff, inst[19:12], inst[20], inst[30:21], 1'b0};
	      else
	        imm <= {12'b0, inst[19:12], inst[20], inst[30:21], 1'b0};
	   default:
	     imm <= 32'bz;
    endcase
	end      
endmodule	   
