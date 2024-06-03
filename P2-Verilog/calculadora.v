module projeto2sd(
	input [7:0] a, b,
	input s_a, s_b,
	input clk,
	input btn,
	input btn2,
	input btn3,
	input btn4,
	output reg [7:0] data,
	output reg EN, RS, RW
);

parameter ONEMS = 50000, HALFMS = 25000;
parameter WRITE = 1'b0, WAIT = 1'b1;
reg [31:0] counter = 32'b0;
reg state = WRITE;

reg [17:0] new_a, new_b;

parameter END = 6'd63;
reg [5:0] instructions = 6'b0;
reg [1:0] button_state = 2'b00;

reg display_enable = 1;
	
reg [16:0] res;
reg s_res;
reg [16:0]unidade, dezena, centena, milhar, dezenaM;
reg [7:0]unidadeA, dezenaA, centenaA;
reg [7:0]unidadeB, dezenaB, centenaB;	
reg ligado = 0;

initial begin
    data = 8'b0;
    EN = 1'b1;
    RS = 1'b0;
    RW = 1'b0;
end

reg btnstate;

always @(posedge clk) begin

	btnstate <= btn;

	if(button_state == 2'b01 && instructions == END)begin
		instructions <= 6'b0;
	end
	else if(button_state == 2'b10 && instructions == END || !btn2 && ligado) begin
		instructions <= 6'b0;
		//multiplicação
		new_a = s_a ? -a : a;
		new_b = s_b ? -b : b;
		{s_res, res} = new_a * new_b;
		res = s_res ? -res : res;
		button_state <= 2'b10;
		instructions <= 6'b0;
	end
	else if(button_state == 2'b11 && instructions == END || !btn3 && ligado) begin
		instructions <= 6'b0;
		//subtração
		new_a = s_a ? -a : a;
		new_b = s_b ? -b : b;
		{s_res, res} = new_a - new_b;
		res = s_res ? -res : res;
		button_state <= 2'b11;
		instructions <= 6'b0;
	end
	else if(button_state == 2'b00 && instructions == END || !btn4 && ligado) begin
		instructions <= 6'b0;
		//soma
		new_a = s_a ? -a : a;
		new_b = s_b ? -b : b;
		{s_res, res} = new_a + new_b;
		res = s_res ? -res : res;
		button_state <= 2'b00;
		instructions <= 6'b0;
	end
	
	if (btn && ~btnstate) begin
		if(display_enable == 1)begin
			display_enable <= 0;
			ligado <= 0;
		end
		else begin
			display_enable <= 1;
			ligado <= 1;
		end
		
		button_state <= 2'b01;
		instructions <= 6'b0;
	
	end
	
	case (state)
		WRITE: begin
		if (counter == ONEMS) begin
			state <= WAIT;
			counter <= 32'b0;
			EN <= 1'b0;
		end
		else begin
			counter <= counter + 1;
		end
		end
		WAIT: begin
			if (counter == HALFMS) begin 
				state <= WRITE;
				counter <= 32'b0;
				EN <= 1'b1;
			if (instructions != END) begin
				instructions <= instructions + 1;
			end
		end
		else begin
		counter <= counter + 1;
		end
		end
	endcase

end

always @(*) begin

		unidade = (res) % 10;
		dezena = (res/10) % 10;
		centena = (res/100) % 10;
		milhar = (res/1000) % 10;
		dezenaM = (res/10000) % 10;
		
		unidadeA = (a) % 10;
		dezenaA = (a/10) % 10;
		centenaA = (a/100) % 10;
		
		unidadeB = (b) % 10;
		dezenaB = (b/10) % 10;
		centenaB = (b/100) % 10;
		
		case(unidadeA)
			0: begin unidadeA = 8'h30; end
			1:	begin	unidadeA = 8'h31; end
			2:	begin	unidadeA = 8'h32; end
			3:	begin	unidadeA = 8'h33; end
			4:	begin	unidadeA = 8'h34; end
			5:	begin	unidadeA = 8'h35; end
			6:	begin	unidadeA = 8'h36; end
			7:	begin	unidadeA = 8'h37; end
			8:	begin	unidadeA = 8'h38; end
			9:	begin	unidadeA = 8'h39; end
			default: begin unidadeA = 8'h00; end
		endcase
		case(dezenaA)
			0: begin dezenaA = 8'h30; end
			1:	begin	dezenaA = 8'h31; end
			2:	begin	dezenaA = 8'h32; end
			3:	begin	dezenaA = 8'h33; end
			4:	begin	dezenaA = 8'h34; end
			5:	begin	dezenaA = 8'h35; end
			6:	begin	dezenaA = 8'h36; end
			7:	begin	dezenaA = 8'h37; end
			8:	begin	dezenaA = 8'h38; end
			9:	begin	dezenaA = 8'h39; end
			default: begin dezenaA = 8'h00; end
		endcase
		case(centenaA)
			0: begin centenaA = 8'h30; end
			1:	begin	centenaA = 8'h31; end
			2:	begin	centenaA = 8'h32; end
			3:	begin	centenaA = 8'h33; end
			4:	begin	centenaA = 8'h34; end
			5:	begin	centenaA = 8'h35; end
			6:	begin	centenaA = 8'h36; end
			7:	begin	centenaA = 8'h37; end
			8:	begin	centenaA = 8'h38; end
			9:	begin	centenaA = 8'h39; end
			default: begin centenaA = 8'h00; end
		endcase
		case(unidadeB)
			0: begin unidadeB = 8'h30; end
			1:	begin	unidadeB = 8'h31; end
			2:	begin	unidadeB = 8'h32; end
			3:	begin	unidadeB = 8'h33; end
			4:	begin	unidadeB = 8'h34; end
			5:	begin	unidadeB = 8'h35; end
			6:	begin	unidadeB = 8'h36; end
			7:	begin	unidadeB = 8'h37; end
			8:	begin	unidadeB = 8'h38; end
			9:	begin	unidadeB = 8'h39; end
			default: begin unidadeB = 8'h00; end
		endcase
		case(dezenaB)
			0: begin dezenaB = 8'h30; end
			1:	begin	dezenaB = 8'h31; end
			2:	begin	dezenaB = 8'h32; end
			3:	begin	dezenaB = 8'h33; end
			4:	begin	dezenaB = 8'h34; end
			5:	begin	dezenaB = 8'h35; end
			6:	begin	dezenaB = 8'h36; end
			7:	begin	dezenaB = 8'h37; end
			8:	begin	dezenaB = 8'h38; end
			9:	begin	dezenaB = 8'h39; end
			default: begin dezenaB = 8'h00; end
		endcase
		case(centenaB)
			0: begin centenaB = 8'h30; end
			1:	begin	centenaB = 8'h31; end
			2:	begin	centenaB = 8'h32; end
			3:	begin	centenaB = 8'h33; end
			4:	begin	centenaB = 8'h34; end
			5:	begin	centenaB = 8'h35; end
			6:	begin	centenaB = 8'h36; end
			7:	begin	centenaB = 8'h37; end
			8:	begin	centenaB = 8'h38; end
			9:	begin	centenaB = 8'h39; end
			default: begin centenaB = 8'h00; end
		endcase
		case(unidade)
			0: begin unidade = 17'h30; end
			1:	begin	unidade = 17'h31; end
			2:	begin	unidade = 17'h32; end
			3:	begin	unidade = 17'h33; end
			4:	begin	unidade = 17'h34; end
			5:	begin	unidade = 17'h35; end
			6:	begin	unidade = 17'h36; end
			7:	begin	unidade = 17'h37; end
			8:	begin	unidade = 17'h38; end
			9:	begin	unidade = 17'h39; end
			default: begin unidade = 17'h00; end
		endcase
		case(dezena)
			0: begin dezena = 17'h30; end
			1:	begin	dezena = 17'h31; end
			2:	begin	dezena = 17'h32; end
			3:	begin	dezena = 17'h33; end
			4:	begin	dezena = 17'h34; end
			5:	begin	dezena = 17'h35; end
			6:	begin	dezena = 17'h36; end
			7:	begin	dezena = 17'h37; end
			8:	begin	dezena = 17'h38; end
			9:	begin	dezena = 17'h39; end
			default: begin dezena = 17'h00; end
		endcase
		case(centena)
			0: begin centena = 17'h30; end
			1:	begin	centena = 17'h31; end
			2:	begin	centena = 17'h32; end
			3:	begin	centena = 17'h33; end
			4:	begin	centena = 17'h34; end
			5:	begin	centena = 17'h35; end
			6:	begin	centena = 17'h36; end
			7:	begin	centena = 17'h37; end
			8:	begin	centena = 17'h38; end
			9:	begin	centena = 17'h39; end
			default: begin centena = 17'h00; end
		endcase
		case(milhar)
			0: begin milhar = 17'h30; end
			1:	begin	milhar = 17'h31; end
			2:	begin	milhar = 17'h32; end
			3:	begin	milhar = 17'h33; end
			4:	begin	milhar = 17'h34; end
			5:	begin	milhar = 17'h35; end
			6:	begin	milhar = 17'h36; end
			7:	begin	milhar = 17'h37; end
			8:	begin	milhar = 17'h38; end
			9:	begin	milhar = 17'h39; end
			default: begin milhar = 17'h00; end
		endcase
		case(dezenaM)
			0: begin dezenaM = 17'h30; end
			1:	begin	dezenaM = 17'h31; end
			2:	begin	dezenaM = 17'h32; end
			3:	begin	dezenaM = 17'h33; end
			4:	begin	dezenaM = 17'h34; end
			5:	begin	dezenaM = 17'h35; end
			6:	begin	dezenaM = 17'h36; end
			7:	begin	dezenaM = 17'h37; end
			8:	begin	dezenaM = 17'h38; end
			9:	begin	dezenaM = 17'h39; end
			default: begin dezenaM = 17'h00; end
		endcase

	if (display_enable) begin
		case (button_state)
			2'b01: begin
			// Lógica para o KEY 0
			case (instructions)
			6'b000000: begin data = 8'b10000000; RS = 1'b0; end
			6'b000001: begin data = 8'b10000000; RS = 1'b0; end // Ir para a posição 0
			6'b000010: begin data = 8'b00111000; RS = 1'b0; end // Configurar o display
			6'b000011: begin data = 8'b00001100; RS = 1'b0; end // Configurar o display
			6'b000100: begin if(s_a == 1) begin data = 8'h2D; RS = 1'b1; end else begin data = 8'h2B; RS = 1'b1; end end
			6'b000101: begin data = centenaA; RS = 1'b1; end 
			6'b000110: begin data = dezenaA; RS = 1'b1; end 
			6'b000111: begin data = unidadeA; RS = 1'b1; end 
			6'b001000: begin data = 8'h20; RS = 1'b1; end   // espace
			6'b001001: begin data = 8'h20; RS = 1'b1; end   // espace
			6'b001010: begin data = 8'b10001100; RS = 1'b0; end
			6'b001011: begin if(s_b == 1) begin data = 8'h2D; RS = 1'b1; end else begin data = 8'h2B; RS = 1'b1; end end
			6'b001100: begin data = centenaB; RS = 1'b1; end 
			6'b001101: begin data = dezenaB; RS = 1'b1; end 
			6'b001110: begin data = unidadeB; RS = 1'b1; end
			default: begin data = 8'b10000000; RS = 1'b0; end // Ir para a posição 0
			endcase
			end
			2'b10: begin
			// Lógica para o KEY 1
			case (instructions)
			6'b000000: begin data = 8'b10000000; RS = 1'b0; end
			6'b000001: begin data = 8'b10000000; RS = 1'b0; end // Ir para a posição 0
			6'b000010: begin data = 8'b00111000; RS = 1'b0; end // Configurar o display
			6'b000011: begin data = 8'b00001100; RS = 1'b0; end // Configurar o display
			6'b000100: begin if(s_a == 1) begin data = 8'h2D; RS = 1'b1; end else begin data = 8'h2B; RS = 1'b1; end end
			6'b000101: begin data = centenaA; RS = 1'b1; end 
			6'b000110: begin data = dezenaA; RS = 1'b1; end 
			6'b000111: begin data = unidadeA; RS = 1'b1; end 
			6'b001000: begin data = 8'b10001000; RS = 1'b0; end
			6'b001001: begin data = 8'h58; RS = 1'b1; end // x
			6'b001010: begin data = 8'b10001100; RS = 1'b0; end
			6'b001011: begin if(s_b == 1) begin data = 8'h2D; RS = 1'b1; end else begin data = 8'h2B; RS = 1'b1; end end
			6'b001100: begin data = centenaB; RS = 1'b1; end 
			6'b001101: begin data = dezenaB; RS = 1'b1; end 
			6'b001110: begin data = unidadeB; RS = 1'b1; end
			6'b001111: begin data = 8'b11000000; RS = 1'b0; end //quebra de linha
			6'b010000: begin if(s_res == 1) begin data = 8'h2D; RS = 1'b1; end else begin data = 8'h2B; RS = 1'b1; end end
			6'b010001: begin data = dezenaM; RS = 1'b1; end 
			6'b010010: begin data = milhar; RS = 1'b1; end 
			6'b010011: begin data = centena; RS = 1'b1; end
			6'b010100: begin data = dezena; RS = 1'b1; end
			6'b010101: begin data = unidade; RS = 1'b1; end
			default: begin data = 8'b10000000; RS = 1'b0; end // Ir para a posição 0
			endcase
			end
			2'b11: begin
			// Lógica para o KEY 2
			case (instructions)
			6'b000000: begin data = 8'b10000000; RS = 1'b0; end
			6'b000001: begin data = 8'b10000000; RS = 1'b0; end // Ir para a posição 0
			6'b000010: begin data = 8'b00111000; RS = 1'b0; end
			6'b000011: begin data = 8'b00001100; RS = 1'b0; end
			6'b000100: begin if(s_a == 1) begin data = 8'h2D; RS = 1'b1; end else begin data = 8'h2B; RS = 1'b1; end end
			6'b000101: begin data = centenaA; RS = 1'b1; end 
			6'b000110: begin data = dezenaA; RS = 1'b1; end 
			6'b000111: begin data = unidadeA; RS = 1'b1; end 
			6'b001000: begin data = 8'b10001000; RS = 1'b0; end
			6'b001001: begin data = 8'h2D; RS = 1'b1; end // -
			6'b001010: begin data = 8'b10001100; RS = 1'b0; end
			6'b001011: begin if(s_b == 1) begin data = 8'h2D; RS = 1'b1; end else begin data = 8'h2B; RS = 1'b1; end end
			6'b001100: begin data = centenaB; RS = 1'b1; end 
			6'b001101: begin data = dezenaB; RS = 1'b1; end 
			6'b001110: begin data = unidadeB; RS = 1'b1; end
			6'b001111: begin data = 8'b11000000; RS = 1'b0; end //quebra de linha
			6'b010000: begin if(s_res == 1) begin data = 8'h2D; RS = 1'b1; end else begin data = 8'h2B; RS = 1'b1; end end
			6'b010001: begin data = dezenaM; RS = 1'b1; end 
			6'b010010: begin data = milhar; RS = 1'b1; end 
			6'b010011: begin data = centena; RS = 1'b1; end
			6'b010100: begin data = dezena; RS = 1'b1; end
			6'b010101: begin data = unidade; RS = 1'b1; end
			
			default: begin data = 8'b10000000; RS = 1'b0; end // Ir para a posição 0
			endcase
			end
			2'b00: begin
			// Lógica para o KEY 3
			case (instructions)
			6'b000000: begin data = 8'b10000000; RS = 1'b0; end
			6'b000001: begin data = 8'b10000000; RS = 1'b0; end // Ir para a posição 0
			6'b000010: begin data = 8'b00111000; RS = 1'b0; end // Configurar o display
			6'b000011: begin data = 8'b00001100; RS = 1'b0; end // Configurar o display
			6'b000100: begin if(s_a == 1) begin data = 8'h2D; RS = 1'b1; end else begin data = 8'h2B; RS = 1'b1; end end
			6'b000101: begin data = centenaA; RS = 1'b1; end 
			6'b000110: begin data = dezenaA; RS = 1'b1; end 
			6'b000111: begin data = unidadeA; RS = 1'b1; end 
			6'b001000: begin data = 8'b10001000; RS = 1'b0; end
			6'b001001: begin data = 8'h2B; RS = 1'b1; end // +
			6'b001010: begin data = 8'b10001100; RS = 1'b0; end
			6'b001011: begin if(s_b == 1) begin data = 8'h2D; RS = 1'b1; end else begin data = 8'h2B; RS = 1'b1; end end
			6'b001100: begin data = centenaB; RS = 1'b1; end 
			6'b001101: begin data = dezenaB; RS = 1'b1; end 
			6'b001110: begin data = unidadeB; RS = 1'b1; end
			6'b001111: begin data = 8'b11000000; RS = 1'b0; end //quebra de linha
			6'b010000: begin if(s_res == 1) begin data = 8'h2D; RS = 1'b1; end else begin data = 8'h2B; RS = 1'b1; end end
			6'b010001: begin data = dezenaM; RS = 1'b1; end 
			6'b010010: begin data = milhar; RS = 1'b1; end 
			6'b010011: begin data = centena; RS = 1'b1; end
			6'b010100: begin data = dezena; RS = 1'b1; end
			6'b010101: begin data = unidade; RS = 1'b1; end
			
			default: begin data = 8'b10000000; RS = 1'b0; end // Ir para a posição 0
			endcase
			end
		default: begin data = 8'b10000000; RS = 1'b0; end // Ir para a posição 0
		endcase
	end
else begin
	case (instructions)
		6'b000000: begin data = 8'b00000001; RS = 1'b0; end // Limpar o display
		6'b000001: begin data = 8'b10000000; RS = 1'b0; end // Ir para a posição 0
		default: begin data = 8'b00000001; RS = 1'b0; end // Limpar o display
	endcase
end
end

endmodule
