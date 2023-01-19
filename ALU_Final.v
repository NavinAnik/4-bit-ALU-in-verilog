module ALU_Final(A, B, C, opcode, ZF, SF, CF, current_state, next_state, clk, reset);

	input clk;
	input [2:0] opcode;
	input [3:0] A, B;
	
	output reg ZF, SF, CF, reset;
	output reg [2:0] current_state, next_state;
	output reg [3:0] C;

	
	parameter [2:0] idle = 3'b000, NOR = 3'b001, ADD = 3'b010, XNOR = 3'b011, SUB = 3'b100;   
	reg [2:0] i = 0;
	reg [3:0] ii = 0;
	reg [3:0] compliment_2s = 0;
	reg [4:0] C_t;
	reg F;
	
	always@ (posedge clk)
		begin
			if(opcode == idle || reset == 1)  
			begin
				current_state = idle;
				next_state = idle;
				reset = 0;
				i = 0;
			end
			else
			begin
				current_state = next_state;
				case(current_state)
				idle:
				begin
					if(opcode == 1)
					begin
						next_state = NOR;
						C = 0;
						ZF = 0;
						CF = 0;
						SF = 0;
					end
					else if(opcode == 2)
					begin
						next_state = ADD;
						C = 0;
						ZF = 0;
						CF = 0;
						SF = 0;
					end
					else if(opcode == 3)
					begin
						next_state = XNOR;
						C = 0;
						ZF = 0;
						CF = 0;
						SF = 0;
					end
					else if(opcode == 4)
					begin
						next_state = SUB;
						C = 0;
						ZF = 0;
						CF = 0;
						SF = 0;
					end
				end
				NOR:
				begin
					C[i] = ~(A[i] | B[i]);
					i = i + 1; 
					if(i == 4)
					begin
						i = 0;
						reset = 1;
						CF = 0;
						if(C[3] == 1)
						begin
							SF = 1;
						end
						if(C == 0)
						begin
							ZF = 1;
						end
					end
					 
				end
				ADD:
				begin
					ii = i+1;
					{C_t[ii],C_t[i]} = (C_t[i]+A[i]+B[i]);
					C[i] = C_t[i];
					CF = A[i] & B[i];
					i = i + 1; 
					if(i == 4)
					begin
						i = 0;
						reset = 1;
						if(C[3] == 1)
						begin
							SF = 1;
						end
						if(C == 0)
						begin
							ZF = 1;
						end
					end
					
					 
				end
				XNOR:
				begin
					C[i] = (A[i] ^ B[i]);
					i = i + 1; 
					if(i == 4)
					begin
						i = 0;
						reset = 1;
						CF = 0;
						if(C[3] == 1)
						begin
							SF = 1;
						end
						if(C == 0)
						begin
							ZF = 1;
						end
					end
					
					 
				end
				SUB:
				begin
						compliment_2s = -B;
						C[i] = A[i] ^ compliment_2s[i];
						C[i] = C[i] ^ F;	
						if(F == 0)
					begin
						F = A[i] & compliment_2s[i];
					end
					else
					begin
						F = A[i] | compliment_2s[i];
					end
					
					i = i + 1; 
					if(i == 4)
					begin
						CF = 0;
						i = 0;
						reset = 1;
						if(C[3] == 1)
						begin
							SF = 1;
						end
						if(C == 0)
						begin
							ZF = 1;
						end
					end
					 
				end
				endcase
			
			end
						
		end
endmodule
