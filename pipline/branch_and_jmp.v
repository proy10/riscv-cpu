//For Branch Hazard
//Target address adder and Register comparator
module branch_and_jmp(
    input              clk,
    input              rst_n,  
	input wire[5:0]    alu_op,
	// input wire[31:0]   reg_data1,
	// input wire[31:0]   reg_data2,
	input wire[31:0]   imm,
	input wire[31:0]   old_inst_addr,
	input wire		   we,  // from ex, indicating write enable
	input wire		   jmp_from_ex,  // from ex, indicating branch or not

	output reg         jmp,
	output wire[31:0]  new_inst_addr

);

	parameter BEQ  = 6'b001011;
	parameter BLT  = 6'b001100;
	parameter BGE  = 6'b001101;
	parameter JAL  = 6'b001110;
	parameter JUM_S = 2'b0;
	parameter JUM_W = 2'b1;
	parameter NJUM_W = 2'b11;
	parameter NJUM_S = 2'b10;
	
	reg [64-1:0] bhr;
    reg [32-1:0] inst_addr_record;
	reg history_req;
    wire [4-1:0] inst_addr_low_4bit, pht_addr;
    reg [16*2-1:0] pht;
    wire [4-1:0] pht_sel;
	wire [1:0] state, next_state;

    //write bhr
	always@ * 
		if((alu_op == BEQ) || (alu_op == BLT) || (alu_op == BGE))
			history_req = 1'b1;
		else
			history_req = 1'b0;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            inst_addr_record <= 32'b0;
        else if(history_req) 
            inst_addr_record <= old_inst_addr;
    end

    assign inst_addr_low_4bit = inst_addr_record[3:0];
    
	always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            bhr <= 64'b0;
        else if(we) begin
            if(jmp_from_ex)
                bhr[inst_addr_low_4bit*4+:4] <= {bhr[inst_addr_low_4bit*4+:3], 1'b1};
            else
                bhr[inst_addr_low_4bit*4+:4] <= {bhr[inst_addr_low_4bit*4+:3], 1'b0};
        end
    end

	//update pht
	assign pht_addr = inst_addr_low_4bit ^ bhr[inst_addr_low_4bit*4+:4];
	assign state = pht[pht_addr*2+:2];
	// update bimodel
	always @ * begin
		case(state)
			JUM_S: begin
				if(we) begin
					if(jmp_from_ex)
						next_state = JUM_S;
					else
						next_state = JUM_W;
				end
				else
					next_state = JUM_S;
			end
			JUM_W: begin
				if(we) begin
					if(jmp_from_ex)
						next_state = JUM_S;
					else
						next_state = NJUM_W;
				end
				else
					next_state = JUM_W;
			end
			NJUM_W: begin
				if(we) begin
					if(jmp_from_ex)
						next_state = JUM_W;
					else
						next_state = NJUM_S;
				end
				else
					next_state = NJUM_W;
			end
			NJUM_S: begin
				if(we) begin
					if(jmp_from_ex)
						next_state = NJUM_W;
					else
						next_state = NJUM_S;
				end
				else
					next_state = NJUM_S;
			end
			default: next_state = JUM_S;
		endcase
	end

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			pht = 32'b0;
		else
			pht[pht_addr*2+:2] <= next_state;
	end

    //predict
    assign pht_sel = old_inst_addr[3:0] ^ bhr[old_inst_addr[3:0]*4+:4];
	assign bim = pht[pht_sel*2+:2];
    always @ * begin
		case(bim)
        	NJUM_S, NJUM_W: is_taken = 1'b0;
			JUM_S, JUM_W: is_taken = 1'b1;
			default: is_taken = 1'b0;
		endcase
    end

//   always @ *
//   if((alu_op == BEQ && reg_data1 == reg_data2) ||
//      (alu_op == BLT && reg_data1 <  reg_data2) ||
//      (alu_op == BGE && reg_data1 >= reg_data2) ||
//      (alu_op == JAL))
//         jmp = 1'b1;
//   else
//         jmp = 1'b0;  

  always @ *
	if(alu_op == JAL)
		jmp = 1'b1;
	else if((alu_op == BEQ) || (alu_op == BLT) || (alu_op == BGE))
		//jump or not
		jmp = is_taken;
	else
		jmp = 1'b0;  

  assign new_inst_addr = old_inst_addr + imm;
        
endmodule  