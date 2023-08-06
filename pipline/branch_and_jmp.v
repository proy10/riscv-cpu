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



module priority_encoder(
	input [7:0]				din,
	output					valid,
	output reg [2:0]		pos
);

	always@(*) begin
		if(!din[0]) pos = 3'd0;
		else if(!din[1]) pos = 3'd1;
		else if(!din[2]) pos = 3'd2;
		else if(!din[3]) pos = 3'd3;
		else if(!din[4]) pos = 3'd4;
		else if(!din[5]) pos = 3'd5;
		else if(!din[6]) pos = 3'd6;
		else if(!din[7]) pos = 3'd7;
		else pos = 3'd0;
	end

	assign valid = (~din) ? 1'b1 : 1'b0;;

endmodule


// module and_tree #(
// 	parameter tp_entry_num = 4096
// )(
// 	input [tp_entry_num-1:0]	din,
// 	output						valid,
// 	output reg [11:0]			waddr
// );

// 	// level 0
// 	wire [7:0] cp0;
// 	genvar i_prio_enc_tree_level_0;
// 	generate
// 		for(i_prio_enc_tree_level_0=0; i_prio_enc_tree_level_0<8; i_prio_enc_tree_level_0=i_prio_enc_tree_level_0+1) begin: i_prio_enc_tree_level_0
// 			// assign cp0[i_prio_enc_tree_level_0] = &din[i_prio_enc_tree_level_0*512+:512];
// 			assign cp0[i_prio_enc_tree_level_0] = &cp1[i_prio_enc_tree_level_0*8+:8];
// 		end
// 	endgenerate

// 	// level 1
// 	wire [63:0] cp1;
// 	genvar i_prio_enc_tree_level_1;
// 	generate
// 		for(i_prio_enc_tree_level_1=0; i_prio_enc_tree_level_1<64; i_prio_enc_tree_level_1=i_prio_enc_tree_level_1+1) begin: i_prio_enc_tree_level_1
// 			// assign cp1[i_prio_enc_tree_level_1] = &din[i_prio_enc_tree_level_1*64+:64];
// 			assign cp1[i_prio_enc_tree_level_1] = &cp2[i_prio_enc_tree_level_1*8+:8];
// 		end
// 	endgenerate

// 	// level 2
// 	wire [511:0] cp2;
// 	genvar i_prio_enc_tree_level_2;
// 	generate
// 		for(i_prio_enc_tree_level_2=0; i_prio_enc_tree_level_2<512; i_prio_enc_tree_level_2=i_prio_enc_tree_level_2+1) begin: i_prio_enc_tree_level_2
// 			assign cp2[i_prio_enc_tree_level_2] = &din[i_prio_enc_tree_level_2*8+:8];
// 		end
// 	endgenerate	

// 	wire level_0_valid, level_1_valid, level_2_valid, level_3_valid;
// 	wire [2:0] level_0_pos, level_1_pos, level_2_pos, level_3_pos;

// 	priority_encoder tp_2_priority_encoder(.din(cp0), .valid(level_0_valid), .pos(level_0_pos));

// 	wire [7:0] level_1_din;
// 	assign level_1_din = (level_0_valid) ? cp1[level_0_pos*8+:8] : 8'hff;
// 	priority_encoder tp_2_priority_encoder(.din(level_1_din), .valid(level_1_valid), .pos(level_1_pos));

// 	wire [7:0] level_2_din;
// 	assign level_2_din = (level_1_valid) ? cp2[level_0_pos*64+level_1_pos*8+:8] : 8'hff;
// 	priority_encoder tp_2_priority_encoder(.din(level_2_din), .valid(level_2_valid), .pos(level_2_pos));

// 	wire [7:0] level_3_din;
// 	assign level_3_din = (level_2_valid) ? din[level_0_pos*512+level_1_pos*64+level_2_pos*8+:8] : 8'hff;
// 	priority_encoder tp_2_priority_encoder(.din(level_3_din), .valid(level_3_valid), .pos(level_3_pos));

// 	// reg [11:0] allocate_waddr;
// 	always @(*) begin
// 		if(level_0_valid)
// 			waddr = level_0_pos * 512 + level_1_pos * 64 + level_2_pos * 8 + level_3_pos;
// 		else
// 			waddr = 12'h0;
// 	end

// 	assign valid = level_0_valid;

// endmodule



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


	//===========================predict===========================
	reg is_branch_inst;
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
	//---------------------------record PC and predict---------------------------
	reg [31:0] inst_addr_record;
	reg pred_res;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            inst_addr_record <= 32'b0;
			pred_res <= 1'b0;
		end
        else if(is_branch_inst) begin
            inst_addr_record <= old_inst_addr;
			pred_res <= jmp_predict;
		end
    end

	//---------------------------update branch history---------------------------
	reg [95:0] global_branch_hist;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			global_branch_hist <= 96'b0;
		else if(we)
			global_branch_hist <= {global_branch_hist[94:0], jmp};
	end 

	//---------------------------u cnt reset periodically---------------------------
	reg [18:0] branch_cnt;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			branch_cnt <= 19'h0;
		else if(is_branch_inst)
			branch_cnt <= branch_cnt + 1'h1;
	end

	wire useful_msb_period_rst_n;
	assign useful_msb_period_rst_n = ~(branch_cnt==19'h3ffff);

	wire useful_lsb_period_rst_n;
	assign useful_lsb_period_rst_n = ~(branch_cnt==19'h7ffff);

	//---------------------------allocate compute---------------------------
	// lfr
	reg [3:0] lfr;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			lfr <= 4'h1;
		else
			lfr <= {lfr[2:1], lfr[3]^lfr[0], lfr[3]};
	end

	wire [3:0] sels;
	assign sels = {tp_4_allocate_sel, tp_3_allocate_sel, tp_2_allocate_sel, tp_1_allocate_sel};
	reg tp_1_allocate_we, tp_2_allocate_we, tp_3_allocate_we, tp_4_allocate_we;
	always@(*) begin
		tp_1_allocate_we = 1'b0;
		tp_2_allocate_we = 1'b0;
		tp_3_allocate_we = 1'b0;
		tp_4_allocate_we = 1'b0;
		case(sels)
			4'b0001: tp_1_allocate_we = 1'b1;
			4'b0010: tp_2_allocate_we = 1'b1;
			4'b0100: tp_3_allocate_we = 1'b1;
			4'b1000: tp_4_allocate_we = 1'b1;
			4'b0011: if(lfr<4'd10) tp_1_allocate_we = 1'b1; else tp_2_allocate_we = 1'b1;
			4'b0101: if(lfr<4'd10) tp_1_allocate_we = 1'b1; else tp_3_allocate_we = 1'b1;
			4'b1001: if(lfr<4'd10) tp_1_allocate_we = 1'b1; else tp_4_allocate_we = 1'b1;
			4'b0110: if(lfr<4'd10) tp_2_allocate_we = 1'b1; else tp_3_allocate_we = 1'b1;
			4'b1010: if(lfr<4'd10) tp_2_allocate_we = 1'b1; else tp_4_allocate_we = 1'b1;
			4'b1100: if(lfr<4'd10) tp_3_allocate_we = 1'b1; else tp_4_allocate_we = 1'b1;
			4'b0111: if(lfr<4'd8) tp_1_allocate_we = 1'b1; else if(lfr<4'd12) tp_2_allocate_we = 1'b1; else tp_3_allocate_we = 1'b1;
			4'b1011: if(lfr<4'd8) tp_1_allocate_we = 1'b1; else if(lfr<4'd12) tp_2_allocate_we = 1'b1; else tp_4_allocate_we = 1'b1;
			4'b1101: if(lfr<4'd8) tp_1_allocate_we = 1'b1; else if(lfr<4'd12) tp_3_allocate_we = 1'b1; else tp_4_allocate_we = 1'b1;
			4'b1110: if(lfr<4'd8) tp_2_allocate_we = 1'b1; else if(lfr<4'd12) tp_3_allocate_we = 1'b1; else tp_4_allocate_we = 1'b1;
			4'b1111: if(lfr<4'd8) tp_1_allocate_we = 1'b1; else if(lfr<4'd12) tp_2_allocate_we = 1'b1; else if(lfr<4'd15) tp_3_allocate_we = 1'b1; else tp_4_allocate_we = 1'b1;
			default: begin tp_1_allocate_we = 1'b0; tp_2_allocate_we = 1'b0; tp_3_allocate_we = 1'b0; tp_4_allocate_we = 1'b0; end
		endcase
	end

	reg tp_1_allocate_dec_we, tp_2_allocate_dec_we, tp_3_allocate_dec_we, tp_4_allocate_dec_we;
	always @(*) begin
		tp_1_allocate_dec_we = 1'b0;
		tp_2_allocate_dec_we = 1'b0;
		tp_3_allocate_dec_we = 1'b0;
		tp_4_allocate_dec_we = 1'b0;
		if(tp_1_u_re) begin // 4 candidate
			if(~tp_1_allocate_sel && ~tp_2_allocate_sel && ~tp_3_allocate_sel && ~tp_4_allocate_sel) begin // all u of them are 0
				tp_1_allocate_dec_we = 1'b1;
				tp_2_allocate_dec_we = 1'b1;
				tp_3_allocate_dec_we = 1'b1;
				tp_4_allocate_dec_we = 1'b1;
			end
			else begin
				tp_1_allocate_dec_we = 1'b0;
				tp_2_allocate_dec_we = 1'b0;
				tp_3_allocate_dec_we = 1'b0;
				tp_4_allocate_dec_we = 1'b0;
			end
		end
		else if(tp_2_u_re) begin // 3 candidate
			if(~tp_2_allocate_sel && ~tp_3_allocate_sel && ~tp_4_allocate_sel) begin // all u of them are 0
				tp_2_allocate_dec_we = 1'b1;
				tp_3_allocate_dec_we = 1'b1;
				tp_4_allocate_dec_we = 1'b1;
			end
			else begin
				tp_2_allocate_dec_we = 1'b0;
				tp_3_allocate_dec_we = 1'b0;
				tp_4_allocate_dec_we = 1'b0;
			end			
		end
		else if(tp_3_u_re) begin // 2 candidate
			if(~tp_3_allocate_sel && ~tp_4_allocate_sel) begin // all u of them are 0
				tp_3_allocate_dec_we = 1'b1;
				tp_4_allocate_dec_we = 1'b1;
			end
			else begin
				tp_3_allocate_dec_we = 1'b0;
				tp_4_allocate_dec_we = 1'b0;
			end			
		end
		else if(tp_4_u_re) begin // 1 candidate
			if(~tp_4_allocate_sel) begin // all u of them are 0
				tp_4_allocate_dec_we = 1'b1;
			end
			else begin
				tp_4_allocate_dec_we = 1'b0;
			end			
		end
	end 

	//---------------------------update base predictor---------------------------
	wire [13:0] bp_addr;
	assign bp_addr = inst_addr_record[13:0];
	wire bp_we;

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
	reg [11:0] tp_1_waddr;
	// assign tp_1_waddr = inst_addr_record[11:0] ^ global_branch_hist[11:0];
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			tp_1_waddr <= 12'h0;
		else if(is_branch_inst)
			tp_1_waddr <= tp_1_raddr;		
	end

	reg tp_1_hit;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			tp_1_hit <= 1'b0;
		else if(is_branch_inst)
			tp_1_hit <= tp_1_re;
	end

	reg tp_1_pred_res;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			tp_1_pred_res <= 1'b0;
		else if(is_branch_inst)
			tp_1_pred_res <= tp_1_pred;
	end	

	// update pred cnt
	wire tp_1_we_pred;
	tp_1_we_pred = (tp_1_hit & (~tp_2_hit) & (~tp_3_hit) & (~tp_4_hit)); // whether tp1 is pred

	wire [2:0] tp_1_pred_state, tp_1_pred_next_state;
	assign tp_1_pred_state = (tp_1_we_pred) ? tag_predictor_1[tp_1_waddr][13:11] : 3'h0;
	thr_bit_cnt tp_1_thr_bit_cnt(.we(tp_1_we_pred), .jmp(jmp), .state(tp_1_pred_state), .next_state(tp_1_pred_next_state));

	integer i_tp_pred_1_pred;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_1_pred=0; i_tp_pred_1_pred<tp_entry_num; i_tp_pred_1_pred=i_tp_pred_1_pred+1) begin: i_tp_pred_1_pred
				tag_predictor_1[i_tp_pred_1_pred][13:11] <= 3'h4;
			end
		else if(tp_1_we_pred)
			tag_predictor_1[tp_1_waddr][13:11] <= tp_1_pred_next_state;
		else if(tp_1_allocate_we) begin
			if(jmp) 
				tag_predictor_1[tp_1_waddr][13:11] <= 3'h4;
			else
				tag_predictor_1[tp_1_waddr][13:11] <= 3'h3;
		end
	end

	// update useful cnt
	reg tp_1_we_u;
	always@(*) begin
		if(!rst_n)
			tp_1_we_u = 1'b0;
		else if(tp_1_we_pred) begin
			if(bp_pred_res != tp_1_pred_res)
				tp_1_we_u = 1'b1;
			else
				tp_1_we_u = 1'b0;
		end
		else
			tp_1_we_u = 1'b0;
	end

	wire [1:0] tp_1_u_state, tp_2_1_next_state;
	assign tp_1_u_state = (tp_1_we_u) ? tag_predictor_1[tp_1_waddr][1:0] : 2'h0;
	two_bit_cnt tp_1_two_bit_cnt(.we(tp_2_we_u), .jmp(jmp), .pred(tp_1_pred_res), .state(tp_1_u_state), .next_state(tp_1_u_next_state));

	integer i_tp_pred_1_u;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_1_u=0; i_tp_pred_1_u<tp_entry_num; i_tp_pred_1_u=i_tp_pred_1_u+1) begin: i_tp_pred_1_u_rst
				tag_predictor_1[i_tp_pred_1_u][1:0] <= 2'h0;
			end
		else if(!useful_msb_period_rst_n)
			for(i_tp_pred_1_u=0; i_tp_pred_1_u<tp_entry_num; i_tp_pred_1_u=i_tp_pred_1_u+1) begin: i_tp_pred_1_u_msb_rst
				tag_predictor_1[i_tp_pred_1_u][1] <= 1'h0;
			end
		else if(!useful_lsb_period_rst_n)
			for(i_tp_pred_1_u=0; i_tp_pred_1_u<tp_entry_num; i_tp_pred_1_u=i_tp_pred_1_u+1) begin: i_tp_pred_1_u_lsb_rst
				tag_predictor_1[i_tp_pred_1_u][0] <= 1'h0;
			end
		else if(tp_1_we_u)
			tag_predictor_1[tp_1_waddr][1:0] <= tp_1_u_next_state;
		else if(tp_1_allocate_we)
			tag_predictor_1[tp_1_waddr][1:0] <= 2'h0;
		else if(tp_1_allocate_dec_we)
			tag_predictor_1[tp_1_waddr][1:0] <= tag_predictor_1[tp_1_waddr][1:0] - 1;
	end

	// allocate
	wire tp_1_u_re;
	assign tp_1_u_re = (pred_res!=jmp) && (~tp_1_hit) && (~tp_2_hit) && (~tp_3_hit) && (~tp_4_hit); //whether tp1 is the candidate for allocate new entry

	wire tp_1_allocate_sel;
	assign tp_1_allocate_sel = (!tag_predictor_1[tp_1_waddr][10:2]); //whether u == 0

	// update tag when allocate
	integer i_tp_pred_1_tag;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_1_tag=0; i_tp_pred_1_tag<tp_entry_num; i_tp_pred_1_tag=i_tp_pred_1_tag+1) begin: i_tp_pred_1_tag
				tag_predictor_1[i_tp_pred_1_tag][10:2] <= 9'h0;
			end
		else if(tp_1_allocate_we)
			tag_predictor_1[tp_1_waddr][10:2] <= inst_addr_record[8:0] ^ global_branch_hist[8:0]; 
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

	// update pred cnt
	wire tp_2_we_pred;
	// assign tp_2_we = ((tp_2_tag == tag_predictor_2[tp_2_addr][10:2]) & we); //update or not
	tp_2_we_pred = (tp_2_hit & (~tp_3_hit) & (~tp_4_hit)); // whether tp2 is pred

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
		else if(tp_2_allocate_we) begin
			if(jmp) 
				tag_predictor_2[tp_2_waddr][13:11] <= 3'h4;
			else
				tag_predictor_2[tp_2_waddr][13:11] <= 3'h3;
		end
	end

	// update useful cnt
	reg tp_2_we_u;
	always@(*) begin
		if(!rst_n)
			tp_2_we_u = 1'b0;
		else if(tp_2_we_pred) begin
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
			for(i_tp_pred_2_u=0; i_tp_pred_2_u<tp_entry_num; i_tp_pred_2_u=i_tp_pred_2_u+1) begin: i_tp_pred_2_u_rst
				tag_predictor_2[i_tp_pred_2_u][1:0] <= 2'h0;
			end
		else if(!useful_msb_period_rst_n)
			for(i_tp_pred_2_u=0; i_tp_pred_2_u<tp_entry_num; i_tp_pred_2_u=i_tp_pred_2_u+1) begin: i_tp_pred_2_u_msb_rst
				tag_predictor_2[i_tp_pred_2_u][1] <= 1'h0;
			end
		else if(!useful_lsb_period_rst_n)
			for(i_tp_pred_2_u=0; i_tp_pred_2_u<tp_entry_num; i_tp_pred_2_u=i_tp_pred_2_u+1) begin: i_tp_pred_2_u_lsb_rst
				tag_predictor_2[i_tp_pred_2_u][0] <= 1'h0;
			end
		else if(tp_2_we_u)
			tag_predictor_2[tp_2_waddr][1:0] <= tp_2_u_next_state;
		else if(tp_2_allocate_we)
			tag_predictor_2[tp_2_waddr][1:0] <= 2'h0;
		else if(tp_2_allocate_dec_we)
			tag_predictor_2[tp_2_waddr][1:0] <= tag_predictor_2[tp_2_waddr][1:0] - 1;
	end

	// allocate
	wire tp_2_u_re;
	assign tp_2_u_re = (pred_res!=jmp) && (~tp_2_hit) && (~tp_3_hit) && (~tp_4_hit); //whether tp2 is the candidate for allocate new entry

	wire tp_2_allocate_sel;
	assign tp_2_allocate_sel = (!tag_predictor_2[tp_2_waddr][10:2]); //whether u == 0

	// update tag when allocate
	integer i_tp_pred_2_tag;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_2_tag=0; i_tp_pred_2_tag<tp_entry_num; i_tp_pred_2_tag=i_tp_pred_2_tag+1) begin: i_tp_pred_2_tag
				tag_predictor_2[i_tp_pred_2_tag][10:2] <= 9'h0;
			end
		else if(tp_2_allocate_we)
			tag_predictor_2[tp_2_waddr][10:2] <= inst_addr_record[8:0] ^ global_hist_24_fold_9; 
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

	reg [8:0] global_hist_48_fold_9;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			global_hist_48_fold_9 <= 9'b0;
		else if(we)
			global_hist_48_fold_9 <= {global_hist_48_fold_9[7:6], global_hist_48_fold_9[5]^global_branch_hist[47], global_hist_48_fold_9[4:0], global_hist_48_fold_9[8]^jmp};
	end

	reg [11:0] tp_3_waddr;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			tp_3_waddr <= 12'h0;
		else if(is_branch_inst)
			tp_3_waddr <= tp_3_raddr;
	end

	reg tp_3_hit;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			tp_3_hit <= 1'b0;
		else if(is_branch_inst)
			tp_3_hit <= tp_3_re;
	end

	reg tp_3_pred_res;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			tp_3_pred_res <= 1'b0;
		else if(is_branch_inst)
			tp_3_pred_res <= tp_3_pred;
	end	

	// update pred cnt
	wire tp_3_we_pred;
	tp_3_we_pred = (tp_3_hit & (~tp_4_hit)); // whether tp3 is pred

	wire [2:0] tp_3_pred_state, tp_3_pred_next_state;
	assign tp_3_pred_state = (tp_3_we_pred) ? tag_predictor_3[tp_3_waddr][13:11] : 3'h0;
	thr_bit_cnt tp_3_thr_bit_cnt(.we(tp_3_we_pred), .jmp(jmp), .state(tp_3_pred_state), .next_state(tp_3_pred_next_state));

	integer i_tp_pred_3_pred;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_3_pred=0; i_tp_pred_3_pred<tp_entry_num; i_tp_pred_3_pred=i_tp_pred_3_pred+1) begin: i_tp_pred_3_pred
				tag_predictor_3[i_tp_pred_3_pred][13:11] <= 3'h4;
			end
		else if(tp_3_we_pred)
			tag_predictor_3[tp_3_waddr][13:11] <= tp_3_pred_next_state;
		else if(tp_3_allocate_we) begin
			if(jmp) 
				tag_predictor_3[tp_3_waddr][13:11] <= 3'h4;
			else
				tag_predictor_3[tp_3_waddr][13:11] <= 3'h3;
		end
	end

	// update useful cnt
	reg tp_3_we_u;
	always@(*) begin
		if(!rst_n)
			tp_3_we_u = 1'b0;
		else if(tp_3_we_pred) begin
			if(tp_2_hit) begin
				if(tp_2_pred_res != tp_3_pred_res)
					tp_3_we_u = 1'b1;
				else
					tp_3_we_u = 1'b0;
			end
			else if(tp_1_hit) begin
				if(tp_1_pred_res != tp_3_pred_res)
					tp_3_we_u = 1'b1;
				else
					tp_3_we_u = 1'b0;
			end
			else begin
				if(bp_pred_res != tp_3_pred_res)
					tp_3_we_u = 1'b1;
				else
					tp_3_we_u = 1'b0;
			end
		end
		else
			tp_3_we_u = 1'b0;
	end

	wire [1:0] tp_3_u_state, tp_3_u_next_state;
	assign tp_3_u_state = (tp_3_we_u) ? tag_predictor_3[tp_3_waddr][1:0] : 2'h0;
	two_bit_cnt tp_3_two_bit_cnt(.we(tp_3_we_u), .jmp(jmp), .pred(tp_3_pred_res), .state(tp_3_u_state), .next_state(tp_3_u_next_state));

	integer i_tp_pred_3_u;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_3_u=0; i_tp_pred_3_u<tp_entry_num; i_tp_pred_3_u=i_tp_pred_3_u+1) begin: i_tp_pred_3_u_rst
				tag_predictor_3[i_tp_pred_3_u][1:0] <= 2'h0;
			end
		else if(!useful_msb_period_rst_n)
			for(i_tp_pred_3_u=0; i_tp_pred_3_u<tp_entry_num; i_tp_pred_3_u=i_tp_pred_3_u+1) begin: i_tp_pred_3_u_msb_rst
				tag_predictor_3[i_tp_pred_3_u][1] <= 1'h0;
			end
		else if(!useful_lsb_period_rst_n)
			for(i_tp_pred_3_u=0; i_tp_pred_3_u<tp_entry_num; i_tp_pred_3_u=i_tp_pred_3_u+1) begin: i_tp_pred_3_u_lsb_rst
				tag_predictor_3[i_tp_pred_3_u][0] <= 1'h0;
			end
		else if(tp_3_we_u)
			tag_predictor_3[tp_3_waddr][1:0] <= tp_3_u_next_state;
		else if(tp_3_allocate_we)
			tag_predictor_3[tp_3_waddr][1:0] <= 2'h0;
		else if(tp_3_allocate_dec_we)
			tag_predictor_3[tp_3_waddr][1:0] <= tag_predictor_3[tp_3_waddr][1:0] - 1;
	end

	// allocate
	wire tp_3_u_re;
	assign tp_3_u_re = (pred_res!=jmp) && (~tp_3_hit) && (~tp_4_hit); //whether tp3 is the candidate for allocate new entry

	wire tp_3_allocate_sel;
	assign tp_3_allocate_sel = (!tag_predictor_3[tp_3_waddr][10:2]); //whether u == 0

	// update tag when allocate
	integer i_tp_pred_3_tag;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_3_tag=0; i_tp_pred_3_tag<tp_entry_num; i_tp_pred_3_tag=i_tp_pred_3_tag+1) begin: i_tp_pred_3_tag
				tag_predictor_3[i_tp_pred_3_tag][10:2] <= 9'h0;
			end
		else if(tp_3_allocate_we)
			tag_predictor_3[tp_3_waddr][10:2] <= inst_addr_record[8:0] ^ global_hist_48_fold_9; 
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

	reg [8:0] global_hist_96_fold_9;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			global_hist_96_fold_9 <= 9'b0;
		else if(we)
			global_hist_96_fold_9 <= {global_hist_96_fold_9[7:6], global_hist_96_fold_9[5]^global_branch_hist[95], global_hist_96_fold_9[4:0], global_hist_96_fold_9[8]^jmp};
	end

	reg [11:0] tp_4_waddr;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			tp_4_waddr <= 12'h0;
		else if(is_branch_inst)
			tp_4_waddr <= tp_4_raddr;
	end	

	reg tp_4_hit;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			tp_4_hit <= 1'b0;
		else if(is_branch_inst)
			tp_4_hit <= tp_4_re;
	end

	reg tp_4_pred_res;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			tp_4_pred_res <= 1'b0;
		else if(is_branch_inst)
			tp_4_pred_res <= tp_4_pred;
	end	

	// update pred cnt
	wire tp_4_we_pred;
	tp_4_we_pred = tp_4_hit; // whether tp4 is pred

	wire [2:0] tp_4_pred_state, tp_4_pred_next_state;
	assign tp_4_pred_state = (tp_4_we_pred) ? tag_predictor_4[tp_4_waddr][13:11] : 3'h0;
	thr_bit_cnt tp_4_thr_bit_cnt(.we(tp_4_we_pred), .jmp(jmp), .state(tp_4_pred_state), .next_state(tp_4_pred_next_state));

	integer i_tp_pred_4_pred;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_4_pred=0; i_tp_pred_4_pred<tp_entry_num; i_tp_pred_4_pred=i_tp_pred_4_pred+1) begin: i_tp_pred_4_pred
				tag_predictor_4[i_tp_pred_4_pred][13:11] <= 3'h4;
			end
		else if(tp_4_we_pred)
			tag_predictor_4[tp_4_waddr][13:11] <= tp_4_pred_next_state;
		else if(tp_4_allocate_we) begin
			if(jmp) 
				tag_predictor_4[tp_4_waddr][13:11] <= 3'h4;
			else
				tag_predictor_4[tp_4_waddr][13:11] <= 3'h3;
		end
	end

	// update useful cnt
	reg tp_4_we_u;
	always@(*) begin
		if(!rst_n)
			tp_4_we_u = 1'b0;
		else if(tp_4_we_pred) begin
			if(tp_3_hit) begin
				if(tp_3_pred_res != tp_4_pred_res)
					tp_4_we_u = 1'b1;
				else
					tp_4_we_u = 1'b0;
			end
			else if(tp_4_hit) begin
				if(tp_2_pred_res != tp_4_pred_res)
					tp_4_we_u = 1'b1;
				else
					tp_4_we_u = 1'b0;
			end
			else if(tp_1_hit) begin
				if(tp_1_pred_res != tp_4_pred_res)
					tp_4_we_u = 1'b1;
				else
					tp_4_we_u = 1'b0;
			end
			else begin
				if(bp_pred_res != tp_4_pred_res)
					tp_4_we_u = 1'b1;
				else
					tp_4_we_u = 1'b0;
			end
		end
		else
			tp_4_we_u = 1'b0;
	end

	wire [1:0] tp_4_u_state, tp_4_u_next_state;
	assign tp_4_u_state = (tp_4_we_u) ? tag_predictor_4[tp_4_waddr][1:0] : 2'h0;
	two_bit_cnt tp_4_two_bit_cnt(.we(tp_4_we_u), .jmp(jmp), .pred(tp_4_pred_res), .state(tp_4_u_state), .next_state(tp_4_u_next_state));

	integer i_tp_pred_4_u;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_4_u=0; i_tp_pred_4_u<tp_entry_num; i_tp_pred_4_u=i_tp_pred_4_u+1) begin: i_tp_pred_4_u_rst
				tag_predictor_4[i_tp_pred_4_u][1:0] <= 2'h0;
			end
		else if(!useful_msb_period_rst_n)
			for(i_tp_pred_4_u=0; i_tp_pred_4_u<tp_entry_num; i_tp_pred_4_u=i_tp_pred_4_u+1) begin: i_tp_pred_4_u_msb_rst
				tag_predictor_4[i_tp_pred_4_u][1] <= 1'h0;
			end
		else if(!useful_lsb_period_rst_n)
			for(i_tp_pred_4_u=0; i_tp_pred_4_u<tp_entry_num; i_tp_pred_4_u=i_tp_pred_4_u+1) begin: i_tp_pred_4_u_lsb_rst
				tag_predictor_4[i_tp_pred_4_u][0] <= 1'h0;
			end
		else if(tp_4_we_u)
			tag_predictor_4[tp_4_waddr][1:0] <= tp_4_u_next_state;
		else if(tp_4_allocate_we)
			tag_predictor_4[tp_4_waddr][1:0] <= 2'h0;
		else if(tp_4_allocate_dec_we)
			tag_predictor_4[tp_4_waddr][1:0] <= tag_predictor_4[tp_4_waddr][1:0] - 1;
	end

	// allocate
	wire tp_4_u_re;
	assign tp_4_u_re = (pred_res!=jmp) && (~tp_4_hit); //whether tp4 is the candidate for allocate new entry

	wire tp_4_allocate_sel;
	assign tp_4_allocate_sel = (!tag_predictor_4[tp_4_waddr][10:2]); //whether u == 0

	// update tag when allocate
	integer i_tp_pred_4_tag;
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n)
			for(i_tp_pred_4_tag=0; i_tp_pred_4_tag<tp_entry_num; i_tp_pred_4_tag=i_tp_pred_4_tag+1) begin: i_tp_pred_4_tag
				tag_predictor_4[i_tp_pred_4_tag][10:2] <= 9'h0;
			end
		else if(tp_4_allocate_we)
			tag_predictor_4[tp_4_waddr][10:2] <= inst_addr_record[8:0] ^ global_hist_96_fold_9; 
	end
        
endmodule  