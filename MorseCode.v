module MorseCode(O,I,Clk,Clr);
input [2:0]I ; 
input Clk,Clr;
output reg O;
localparam [2:0] s0 = 0, s1 =1, s2 = 2, s3 = 3, s4 = 4;
reg [2:0] State;
reg [3:0] MovReg0,MovReg1;
reg Sig;
always@(posedge Clr or negedge Clk)
begin
if(Clr)
begin
	MovReg0 <=	(I == 3'd0)? 4'b1000:
					(I == 3'd1)? 4'b0111:
					(I == 3'd2)? 4'b0101:
					(I == 3'd3)? 4'b0110:
					(I == 3'd4)? 4'b1000:
					(I == 3'd5)? 4'b1101:
					(I == 3'd6)? 4'b0010:
					(I == 3'd7)? 4'b1111:4'b0;
	
	MovReg1 <=	(I == 3'd0)? 4'b0100:
					(I == 3'd1)? 4'b1000:
					(I == 3'd2)? 4'b1010:
					(I == 3'd3)? 4'b1000:
					(I == 3'd4)? 4'b0000:
					(I == 3'd5)? 4'b0010:
					(I == 3'd6)? 4'b1100:
					(I == 3'd7)? 4'b0000:4'b0;
end	
else
	if(Sig)
	begin
	MovReg0 = (MovReg0 << 1);
	MovReg1 = (MovReg1 << 1);
	end
end

always@(posedge Clk or posedge Clr)
begin
if(Clr)
begin
	State <= s0;
	Sig <= 1'b0;
end
else
begin
	case(State)
		s0:
		begin
		Sig <= 1'b0;
		if(MovReg0[3] == 1'b1 && MovReg1[3] == 1'b0)
			State <= s1;
		else
		begin
			if(MovReg0[3] == 1'b0 && MovReg1[3] == 1'b1)
				State <= s2;
		end
		end
		
		s1:
		begin
		Sig <= 1'b1;
		State <= s0;
		end
		
		s2:
		begin
		State <= s3;
		end
		
		s3:
		begin
		State <= s4;
		end
		
		s4:
		begin
		Sig <= 1'b1;
		State <= s0;
		end
		
	endcase
end

end

always@(*)
begin
	if(State == s0)
		O <= 1'b0;
	else
		O <= 1'b1;
end

endmodule