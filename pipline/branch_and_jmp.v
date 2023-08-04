module thr_bit_cnt(
	input				we,
	input				jmp,
	input	[2:0]		state,
	output reg	[2:0]	next_state
);

	always@(*) begin
		case(state)
			3'h0: begin
				if(we) begin
					if(jmp)
						next_state = 3'h1;
					else
						next_state = 3'h0;
				end
				else
					next_state = 3'h0;
			end
			3'h1: begin
				if(we) begin
					if(jmp)
						next_state = 3'h2;
					else
						next_state = 3'h0;
				end
				else
					next_state = 3'h1;
			end
			3'h2: begin
				if(we) begin
					if(jmp)
						next_state = 3'h3;
					else
						next_state = 3'h1;
				end
				else
					next_state = 3'h2;
			end
			3'h3: begin
				if(we) begin
					if(jmp)
						next_state = 3'h4;
					else
						next_state = 3'h2;
				end
				else
					next_state = 3'h3;
			end
			3'h4: begin
				if(we) begin
					if(jmp)
						next_state = 3'h5;
					else
						next_state = 3'h3;
				end
				else
					next_state = 3'h4;
			end
			3'h5: begin
				if(we) begin
					if(jmp)
						next_state = 3'h6;
					else
						next_state = 3'h4;
				end
				else
					next_state = 3'h0;
			end
			3'h6: begin
				if(we) begin
					if(jmp)
						next_state = 3'h7;
					else
						next_state = 3'h5;
				end
				else
					next_state = 3'h6;
			end
			3'h7: begin
				if(we) begin
					if(jmp)
						next_state = 3'h7;
					else
						next_state = 3'h6;
				end
				else
					next_state = 3'h7;
			end
			default: next_state = 3'h0;
		endcase
	end

endmodule



module two_bit_cnt(
	input				we,
	input				jmp,
	input				pred,
	input	[2:0]		state,
	output reg	[2:0]	next_state
);

	always(*) begin
		case(state)
			2'h0: begin
				if(we) begin
					if(jmp == pred)
						next_state = 2'h1;
					else
						next_state = 2'h0;
				end
				else
					next_state = 2'h0;
			end
			2'h1: begin
				if(we) begin
					if(jmp == pred)
						next_state = 2'h2;
					else
						next_state = 2'h0;
				end
				else
					next_state = 2'h1;
			end
			2'h2: begin
				if(we) begin
					if(jmp == pred)
						next_state = 2'h3;
					else
						next_state = 2'h1;
				end
				else
					next_state = 2'h2;
			end
			2'h3: begin
				if(we) begin
					if(jmp == pred)
						next_state = 2'h3;
					else
						next_state = 2'h2;
				end
				else
					next_state = 2'h3;
			end
		endcase
	end

endmodule



//For Branch Hazard
//Target address adder and Register comparator
module branch_and_jmp(
    input              clk,
    input              rst_n,  

	// predict channel
	input wire[5:0]    alu_op,
	// input wire[31:0]   reg_data1,
	// input wire[31:0]   reg_data2,
	input wire[31:0]   imm,
	input wire[31:0]   old_inst_addr,
	output reg         jmp_predict,
	output reg[31:0]   new_inst_addr

	// update channel
	input wire		   we,  // from ex, indicating write enable
	// input wire		   jmp_from_ex,  // from ex, indicating branch or not
	input wire		   jmp

);

	parameter BEQ  = 6'b001011;
	parameter BLT  = 6'b001100;
	parameter BGE  = 6'b001101;
	parameter JAL  = 6'b001110;

	//storage budget=256Kbit, n=18
	localparam bp_entry_num = 16384;
	localparam tp_entry_num = 4096;

	reg [1:0] base_predictor [0:bp_entry_num-1];
	reg [13:0] tag_predictor_1 [0:tp_entry_num-1];
	reg [13:0] tag_predictor_2 [0:tp_entry_num-1];
	reg [13:0] tag_predictor_3 [0:tp_entry_num-1];
	reg [13:0] tag_predictor_4 [0:tp_entry_num-1];

	
	reg is_branch_inst;
	reg [32-1:0] inst_addr_record;
	wire [13:0] bp_addr;
	wire [11:0] tp_1_addr;
	wire bp_we, tp_1_we;
	// reg [2:0] bp_state, bp_next_state;
	wire [2:0] state;
	reg [2:0] next_state;

	//===========================predict===========================
	always@(*) begin
		if((alu_op == BEQ) || (alu_op == BLT) || (alu_op == BGE))
			is_branch_inst = 1'b1;
		else
			is_branch_inst = 1'b0;
	end

	//---------------------------base predictor predict---------------------------
	wire [1:0] bp_cnt;
	assign bp_cnt = (is_branch_inst) ? base_predictor[old_inst_addr[13:0]] : 2'h0;

	reg bp_pred;
	always@(*) begin
		if(is_branch_inst && (bp_cnt>2'h1))
			bp_pred = 1'b1;
		else
			bp_pred = 1'b0;
	end
	
	//---------------------------tag predictor 1 predict---------------------------
	wire [11:0] tp_1_raddr;
	assign tp_1_raddr = old_inst_addr[11:0]^global_branch_hist[11:0];

	wire tp_1_re;
	assign tp_1_re = ((old_inst_addr[8:0]^global_branch_hist[8:0]) == tag_predictor_1[tp_1_raddr][10:2]); //hit or not

	wire [2:0] tp_1_cnt;
	assign tp_1_cnt = (is_branch_inst && tp_1_re) ? tag_predictor_1[tp_1_raddr][13:11] : 3'h0;

	reg tp_1_pred;
	always@(*) begin
		if(is_branch_inst && (tp_1_cnt>3'h3))
			tp_1_pred = 1'b1;
		else
			tp_1_pred = 1'b0;
	end

	//---------------------------tag predictor 2 predict---------------------------
	wire [11:0] tp_2_raddr;
	assign tp_2_raddr = old_inst_addr[11:0]^global_hist_24_fold_12;

	wire tp_2_re;
	assign tp_2_re = ((old_inst_addr[8:0]^global_hist_24_fold_9) == tag_predictor_2[tp_2_raddr][10:2]); //hit or not

	wire [2:0] tp_2_cnt;
	assign tp_2_cnt = (is_branch_inst && tp_2_re) ? tag_predictor_2[tp_2_raddr][13:11] : 3'h0;

	reg tp_2_pred;
	always@(*) begin
		if(is_branch_inst && (tp_2_cnt>3'h3))
			tp_2_pred = 1'b1;
		else
			tp_2_pred = 1'b0;
	end	

	//---------------------------tag predictor 3 predict---------------------------
	wire [11:0] tp_3_raddr;
	assign tp_3_raddr = old_inst_addr[11:0]^global_hist_48_fold_12;

	wire tp_3_re;
	assign tp_3_re = ((old_inst_addr[8:0]^global_hist_48_fold_9) == tag_predictor_3[tp_3_raddr][10:2]); //hit or not

	wire [2:0] tp_3_cnt;
	assign tp_3_cnt = (is_branch_inst && tp_3_re) ? tag_predictor_3[tp_3_raddr][13:11] : 3'h0;

	reg tp_3_pred;
	always@(*) begin
		if(is_branch_inst && (tp_3_cnt>3'h3))
			tp_3_pred = 1'b1;
		else
			tp_3_pred = 1'b0;
	end	

	//---------------------------tag predictor 4 predict---------------------------
	wire [11:0] tp_4_raddr;
	assign tp_4_raddr = old_inst_addr[11:0]^global_hist_96_fold_12;

	wire tp_4_re;
	assign tp_4_re = ((old_inst_addr[8:0]^global_hist_96_fold_9) == tag_predictor_4[tp_4_raddr][10:2]); //hit or not

	wire [2:0] tp_4_cnt;
	assign tp_4_cnt = (is_branch_inst && tp_4_re) ? tag_predictor_4[tp_4_raddr][13:11] : 3'h0;

	reg tp_4_pred;
	always@(*) begin
		if(is_branch_inst && (tp_4_cnt>3'h3))
			tp_4_pred = 1'b1;
		else
			tp_4_pred = 1'b0;
	end	

	//---------------------------final predict---------------------------
	always@(*) begin
		if(tp_4_re) jmp_predict = tp_4_pred;
		else if(tp_3_re) jmp_predict = tp_3_pred;
		else if(tp_2_re) jmp_predict = tp_2_pred;
		else if(tp_1_re) jmp_predict = tp_1_pred;
		else jmp_predict = bp_pred;
	end

	always@(*) begin
		if(jmp_predict)
			new_inst_addr = old_inst_addr + imm;
		else
			new_inst_addr = old_inst_addr;
	end

	
	//===========================update===========================
	//---------------------------record pc---------------------------
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            inst_addr_record <= 32'b0;
        else if(is_branch_inst) 
            inst_addr_record <= old_inst_addr;
    end

	//---------------------------update branch history---------------------------
	reg [95:0] global_branch_hist;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			global_branch_hist <= 96'b0;
		else if(we)
			global_branch_hist <= {global_branch_hist[94:0], jmp};
	end 

	//---------------------------update base predictor---------------------------
	assign bp_addr = inst_addr_record[13:0];

	integer i_bp_pred;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_bp_pred=0; i_bp_pred<bp_entry_num; i_bp_pred=i_bp_pred+1) begin: i_bp_pred
				base_predictor[i_bp_pred] <= 2'h2;
			end
		else if(bp_we)
			base_predictor[bp_addr] <= next_state;
	end

	//---------------------------update tag predictor 1---------------------------
	assign tp_1_addr = inst_addr_record[11:0] ^ global_branch_hist[11:0];
	assign tp_1_we = ()//////////////////////////////////////////////////////////

	integer i_tp_pred_1;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_1=0; i_tp_pred_1<tp_entry_num; i_tp_pred_1=i_tp_pred_1+1) begin: i_tp_pred_1
				tag_predictor_1[i_tp_pred_1][1:0] <= 2'h0;
				tag_predictor_1[i_tp_pred_1][10:2] <= 9'h0;
				tag_predictor_1[i_tp_pred_1][13:11] <= 3'h4;
			end
		else if(tp_1_we)
			tag_predictor_1[tp_1_addr][13:11] <= next_state;
	end


	//---------------------------update tag predictor 2---------------------------

	// circular shift register
	reg [11:0] global_hist_24_fold_12;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			global_hist_24_fold_12 <= 12'b0;
		else if(we)
			global_hist_24_fold_12 <= {global_hist_24_fold_12[10:0], global_hist_24_fold_12[11]^jmp^global_branch_hist[23]}; // equal global_branch_hist[11:0] ^ global_branch_hist[23:12]
	end

	reg [8:0] global_hist_24_fold_9;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			global_hist_24_fold_9 <= 9'b0;
		else if(we)
			global_hist_24_fold_9 <= {global_hist_24_fold_9[7:6], global_hist_24_fold_9[5]^global_branch_hist[23], global_hist_24_fold_9[4:0], global_hist_24_fold_9[8]^jmp};
	end

	// wire [11:0] tp_2_addr;
	// // assign tp_2_addr = inst_addr_record[11:0] ^ global_branch_hist[11:0] ^ global_branch_hist[23:12];
	// assign tp_2_addr = inst_addr_record[11:0] ^ global_hist_24_fold_12;

	// wire [8:0] tp_2_tag;
	// assign tp_2_tag = inst_addr_record[8:0] ^ global_hist_24_fold_9;

	reg [11:0] tp_2_waddr;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			tp_2_waddr <= 12'h0;
		else if(is_branch_inst)
			tp_2_waddr <= tp_2_raddr;
	end

	reg tp_2_hit;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			tp_2_hit <= 1'b0;
		else if(is_branch_inst)
			tp_2_hit <= tp_2_re;
	end

	reg tp_2_pred_res;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			tp_2_pred_res <= 1'b0;
		else if(is_branch_inst)
			tp_2_pred_res <= tp_2_pred;
	end	

	// update predictor

	// update pred cnt
	wire tp_2_we_pred;
	// assign tp_2_we = ((tp_2_tag == tag_predictor_2[tp_2_addr][10:2]) & we); //update or not
	tp_2_we_pred = (tp_2_hit & (~tp_3_hit) & (~tp_4_hit));

	wire [2:0] tp_2_pred_state, tp_2_pred_next_state;
	assign tp_2_pred_state = (tp_2_we_pred) ? tag_predictor_2[tp_2_waddr][13:11] : 3'h0;
	thr_bit_cnt tp_2_thr_bit_cnt(.we(tp_2_we_pred), .jmp(jmp), .state(tp_2_pred_state), .next_state(tp_2_pred_next_state));

	integer i_tp_pred_2_pred;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_2_pred=0; i_tp_pred_2_pred<tp_entry_num; i_tp_pred_2_pred=i_tp_pred_2_pred+1) begin: i_tp_pred_2_pred
				tag_predictor_2[i_tp_pred_2_pred][13:11] <= 3'h4;
			end
		else if(tp_2_we_pred)
			tag_predictor_2[tp_2_waddr][13:11] <= tp_2_pred_next_state;
	end

	// update useful cnt
	reg tp_2_we_u;
	// assign tp_2_we_u = (tp_2_hit && ((tp_1_hit&&(tp_1_pred_res!=tp_2_pred_res)) || (bp_pred_res!=tp_2_pred_res)));
	always@(*) begin
		if(!rst_n)
			tp_2_we_u = 1'b0;
		else if(tp_2_hit) begin
			if(tp_1_hit) begin
				if(tp_1_pred_res != tp_2_pred_res)
					tp_2_we_u = 1'b1;
				else
					tp_2_we_u = 1'b0;
			end
			else begin
				if(bp_pred_res != tp_2_pred_res)
					tp_2_we_u = 1'b1;
				else
					tp_2_we_u = 1'b0;
			end
		end
		else
			tp_2_we_u = 1'b0;
	end

	wire [1:0] tp_2_u_state, tp_2_u_next_state;
	assign tp_2_u_state = (tp_2_we_u) ? tag_predictor_2[tp_2_waddr][1:0] : 2'h0;
	two_bit_cnt tp_2_two_bit_cnt(.we(tp_2_we_u), .jmp(jmp), .pred(tp_2_pred_res), .state(tp_2_u_state), .next_state(tp_2_u_next_state));

	integer i_tp_pred_2_u;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_2_u=0; i_tp_pred_2_u<tp_entry_num; i_tp_pred_2_u=i_tp_pred_2_u+1) begin: i_tp_pred_2_u
				tag_predictor_2[i_tp_pred_2_u][1:0] <= 2'h0;
			end
		else if(tp_2_we_u)
			tag_predictor_2[tp_2_waddr][1:0] <= tp_2_u_next_state;
	end


	// update tag when allocate
	integer i_tp_pred_2_tag;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_2_tag=0; i_tp_pred_2_tag<tp_entry_num; i_tp_pred_2_tag=i_tp_pred_2_tag+1) begin: i_tp_pred_2_tag
				tag_predictor_2[i_tp_pred_2_tag][10:2] <= 9'h0;
			end
		else if(tp_2_we_tag)
			tag_predictor_2[tp_2_waddr][10:2] <= tp_2_tag_next_state;
	end


	//---------------------------update tag predictor 3---------------------------

	// circular shift register
	reg [11:0] global_hist_48_fold_12;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			global_hist_48_fold_12 <= 12'b0;
		else if(we)
			global_hist_48_fold_12 <= {global_hist_48_fold_12[10:0], global_hist_48_fold_12[11]^jmp^global_branch_hist[47]};
	end

	// assign tp_3_addr = inst_addr_record[11:0] ^ global_branch_hist[11:0] ^ global_branch_hist[23:12] ^ global_branch_hist[35:24] ^ global_branch_hist[47:36];
	assign tp_3_addr = inst_addr_record[11:0] ^ global_hist_48_fold_12;

	integer i_tp_pred_3;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_3=0; i_tp_pred_3<tp_entry_num; i_tp_pred_3=i_tp_pred_3+1) begin: i_tp_pred_3
				tag_predictor_3[i_tp_pred_3][1:0] <= 2'h0;
				tag_predictor_3[i_tp_pred_3][10:2] <= 9'h0;
				tag_predictor_3[i_tp_pred_3][13:11] <= 3'h4;
			end
		else if(tp_3_we)
			tag_predictor_3[tp_3_addr][13:11] <= next_state;
	end

	//---------------------------update tag predictor 4---------------------------

	// circular shift register
	reg [11:0] global_hist_96_fold_12;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			global_hist_96_fold_12 <= 12'b0;
		else if(we)
			global_hist_96_fold_12 <= {global_hist_96_fold_12[10:0], global_hist_96_fold_12[11]^jmp^global_branch_hist[95]};
	end

	assign tp_4_addr = inst_addr_record[11:0] ^ global_hist_96_fold_12;

	integer i_tp_pred_4;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_4=0; i_tp_pred_4<tp_entry_num; i_tp_pred_4=i_tp_pred_4+1) begin: i_tp_pred_4
				tag_predictor_4[i_tp_pred_4][1:0] <= 2'h0;
				tag_predictor_4[i_tp_pred_4][10:2] <= 9'h0;
				tag_predictor_4[i_tp_pred_4][13:11] <= 3'h4;
			end
		else if(tp_4_we)
			tag_predictor_4[tp_4_addr][13:11] <= next_state;
	end


	// //read
	// assign state = base_predictor[bp_addr];

	// always@(*) begin
	// 	if(!rst_n)
	// 		next_state = 3'h4;
	// 	else
	// 		case(state)
	// 			3'h0: begin
	// 				if(we) begin
	// 					if(jmp)
	// 						next_state = 3'h1;
	// 					else
	// 						next_state = 3'h0;
	// 				end
	// 				else
	// 					next_state = 3'h0;
	// 			end
	// 			3'h1: begin
	// 				if(we) begin
	// 					if(jmp)
	// 						next_state = 3'h2;
	// 					else
	// 						next_state = 3'h0;
	// 				end
	// 				else
	// 					next_state = 3'h1;
	// 			end
	// 			3'h2: begin
	// 				if(we) begin
	// 					if(jmp)
	// 						next_state = 3'h3;
	// 					else
	// 						next_state = 3'h1;
	// 				end
	// 				else
	// 					next_state = 3'h2;
	// 			end
	// 			3'h3: begin
	// 				if(we) begin
	// 					if(jmp)
	// 						next_state = 3'h4;
	// 					else
	// 						next_state = 3'h2;
	// 				end
	// 				else
	// 					next_state = 3'h3;
	// 			end
	// 			3'h4: begin
	// 				if(we) begin
	// 					if(jmp)
	// 						next_state = 3'h5;
	// 					else
	// 						next_state = 3'h3;
	// 				end
	// 				else
	// 					next_state = 3'h4;
	// 			end
	// 			3'h5: begin
	// 				if(we) begin
	// 					if(jmp)
	// 						next_state = 3'h6;
	// 					else
	// 						next_state = 3'h4;
	// 				end
	// 				else
	// 					next_state = 3'h0;
	// 			end
	// 			3'h6: begin
	// 				if(we) begin
	// 					if(jmp)
	// 						next_state = 3'h7;
	// 					else
	// 						next_state = 3'h5;
	// 				end
	// 				else
	// 					next_state = 3'h6;
	// 			end
	// 			3'h7: begin
	// 				if(we) begin
	// 					if(jmp)
	// 						next_state = 3'h7;
	// 					else
	// 						next_state = 3'h6;
	// 				end
	// 				else
	// 					next_state = 3'h7;
	// 			end
	// 			default: next_state = 3'h4;
	// 		endcase
	// end


	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		state <= 3'h4;
	// 	else
	// 		state <= next_state;
	// end



	// genvar i_bp_pred_cnt;
	// generate
	// 	for(i_bp_pred_cnt=0; i_bp_pred_cnt<16384; i_bp_pred_cnt=i_bp_pred_cnt+1) begin: i_bp_pred_cnt
	// 		3bit_cnt u_3bit_cnt(
	// 			.clk(clk),
	// 			.rst_n(rst_n),
	// 			.we(),
	// 			.jmp(jmp),
	// 			.re(),
	// 			.jmp_predict()
	// 		);
	// 	end
	// endgenerate




	// parameter JUM_S = 2'b0;
	// parameter JUM_W = 2'b1;
	// parameter NJUM_W = 2'b10;
	// parameter NJUM_S = 2'b11;
	
	// reg [64-1:0] bhr;
    // reg [32-1:0] inst_addr_record;
	// reg is_branch_inst;
    // wire [4-1:0] inst_addr_low_4bit, pht_addr;
    // reg [16*2-1:0] pht;
    // wire [4-1:0] pht_sel;
	// wire [1:0] state, next_state;

    // //write bhr
	// always@ * 
	// 	if((alu_op == BEQ) || (alu_op == BLT) || (alu_op == BGE))
	// 		is_branch_inst = 1'b1;
	// 	else
	// 		is_branch_inst = 1'b0;

    // always@(posedge clk or negedge rst_n) begin
    //     if(!rst_n)
    //         inst_addr_record <= 32'b0;
    //     else if(is_branch_inst) 
    //         inst_addr_record <= old_inst_addr;
    // end

    // assign inst_addr_low_4bit = inst_addr_record[3:0];
    
	// always@(posedge clk or negedge rst_n) begin
    //     if(!rst_n)
    //         bhr <= 64'b0;
    //     else if(we) begin
    //         if(jmp_from_ex)
    //             bhr[inst_addr_low_4bit*4+:4] <= {bhr[inst_addr_low_4bit*4+:3], 1'b1};
    //         else
    //             bhr[inst_addr_low_4bit*4+:4] <= {bhr[inst_addr_low_4bit*4+:3], 1'b0};
    //     end
    // end

	// //update pht
	// assign pht_addr = inst_addr_low_4bit ^ bhr[inst_addr_low_4bit*4+:4];
	// assign state = pht[pht_addr*2+:2];
	// // update bimodel
	// always @ * begin
	// 	case(state)
	// 		JUM_S: begin
	// 			if(we) begin
	// 				if(jmp_from_ex)
	// 					next_state = JUM_S;
	// 				else
	// 					next_state = JUM_W;
	// 			end
	// 			else
	// 				next_state = JUM_S;
	// 		end
	// 		JUM_W: begin
	// 			if(we) begin
	// 				if(jmp_from_ex)
	// 					next_state = JUM_S;
	// 				else
	// 					next_state = NJUM_W;
	// 			end
	// 			else
	// 				next_state = JUM_W;
	// 		end
	// 		NJUM_W: begin
	// 			if(we) begin
	// 				if(jmp_from_ex)
	// 					next_state = JUM_W;
	// 				else
	// 					next_state = NJUM_S;
	// 			end
	// 			else
	// 				next_state = NJUM_W;
	// 		end
	// 		NJUM_S: begin
	// 			if(we) begin
	// 				if(jmp_from_ex)
	// 					next_state = NJUM_W;
	// 				else
	// 					next_state = NJUM_S;
	// 			end
	// 			else
	// 				next_state = NJUM_S;
	// 		end
	// 		default: next_state = JUM_S;
	// 	endcase
	// end

	// always@(posedge clk or negedge rst_n) begin
	// 	if(!rst_n)
	// 		pht = 32'b0;
	// 	else
	// 		pht[pht_addr*2+:2] <= next_state;
	// end

	// genvar i;
	// generate
	// 	for(i=0; i<16; i=i+1) begin: pht
	// 		always@(posedge clk or negedge rst_n) begin
	// 			if(!rst_n)
	// 				pht = 32'b0;
	// 			else
	// 				pht[pht_addr*2+:2] <= next_state;
	// 		end
	// 	end
	// endgenerate

    // //predict
    // assign pht_sel = old_inst_addr[3:0] ^ bhr[old_inst_addr[3:0]*4+:4];
	// assign bim = pht[pht_sel*2+:2];
    // always @ * begin
	// 	case(bim)
    //     	NJUM_S, NJUM_W: is_taken = 1'b0;
	// 		JUM_S, JUM_W: is_taken = 1'b1;
	// 		default: is_taken = 1'b0;
	// 	endcase
    // end

//   always @ *
//   if((alu_op == BEQ && reg_data1 == reg_data2) ||
//      (alu_op == BLT && reg_data1 <  reg_data2) ||
//      (alu_op == BGE && reg_data1 >= reg_data2) ||
//      (alu_op == JAL))
//         jmp = 1'b1;
//   else
//         jmp = 1'b0;  

//   always @ *
// 	if(alu_op == JAL)
// 		jmp_predict = 1'b1;
// 	else if((alu_op == BEQ) || (alu_op == BLT) || (alu_op == BGE))
// 		//jump or not
// 		jmp_predict = (is_taken) ? 1'b1 : 1'b0;
// 	else
// 		jmp_predict = 1'b0;  

//   assign new_inst_addr = old_inst_addr + imm;
        
endmodule  


// module 3bit_cnt(
// 	input			clk,
// 	input			rst_n,
// 	input			we,
// 	input			jmp,

// 	input			re,
// 	output reg		jmp_predict
// );

// 	reg [2:0] state, next_state;

// 	always@(*) begin
// 		if(!rst_n)
// 			next_state = 3'h4;
// 		else
// 			case(state)
// 				3'h0: begin
// 					if(we) begin
// 						if(jmp)
// 							next_state = 3'h1;
// 						else
// 							next_state = 3'h0;
// 					end
// 					else
// 						next_state = 3'h0;
// 				end
// 				3'h1: begin
// 					if(we) begin
// 						if(jmp)
// 							next_state = 3'h2;
// 						else
// 							next_state = 3'h0;
// 					end
// 					else
// 						next_state = 3'h1;
// 				end
// 				3'h2: begin
// 					if(we) begin
// 						if(jmp)
// 							next_state = 3'h3;
// 						else
// 							next_state = 3'h1;
// 					end
// 					else
// 						next_state = 3'h2;
// 				end
// 				3'h3: begin
// 					if(we) begin
// 						if(jmp)
// 							next_state = 3'h4;
// 						else
// 							next_state = 3'h2;
// 					end
// 					else
// 						next_state = 3'h3;
// 				end
// 				3'h4: begin
// 					if(we) begin
// 						if(jmp)
// 							next_state = 3'h5;
// 						else
// 							next_state = 3'h3;
// 					end
// 					else
// 						next_state = 3'h4;
// 				end
// 				3'h5: begin
// 					if(we) begin
// 						if(jmp)
// 							next_state = 3'h6;
// 						else
// 							next_state = 3'h4;
// 					end
// 					else
// 						next_state = 3'h0;
// 				end
// 				3'h6: begin
// 					if(we) begin
// 						if(jmp)
// 							next_state = 3'h7;
// 						else
// 							next_state = 3'h5;
// 					end
// 					else
// 						next_state = 3'h6;
// 				end
// 				3'h7: begin
// 					if(we) begin
// 						if(jmp)
// 							next_state = 3'h7;
// 						else
// 							next_state = 3'h6;
// 					end
// 					else
// 						next_state = 3'h7;
// 				end
// 				default: next_state = 3'h4;
// 			endcase
// 	end

// 	always@(posedge clk or negedge rst_n) begin
// 		if(!rst_n)
// 			state <= 3'h4;
// 		else
// 			state <= next_state;
// 	end

// 	always@(*) begin
// 		if(re && (state>3'h3))
// 			jmp_predict = 1'b1;
// 		else
// 			jmp_predict = 1'b0;
// 	end

// endmodule