/*
*	Control Unit for Processor
*	Includes the memory unit
*	Vincent "Styxx" Chang
*/


module control_unit (clk,data_in,reset,run,shift,update, data_out,z);

  // I/O definitions:
  input clk, data_in;								//The clock and the serial input
  input reset, run, shift, update;					//Signals from the FSM
  output data_out;									//Data shifted out bit by bit.
  output [4:0] z;									//Internal
  memory:	reg [3:0] mem [3:0];
  
  /*
  *	Variables for the internal shift register and the shadow_reg:
  *	bits [7:6] = opcode (INITLZ_MEM, ARITH, LOGIC, BUFFER)
  * bits [5:4] = address in the memory when opcode=INITLZ_MEM
  * 0/1 for addition/subtraction when opcode=ARITH
  * 0/1 for AND/OR when opcode = LOGIC
  * bits [3:0] = data to the mem when opcode = INITLZ_MEM
  * = the addresses of the data in the mem when opcode = ARITH or LOGIC
  * bits [4:0] = data sent out to the output when opcode = BUFFER
  */
  reg [7:0] shift_reg, shadow_reg;

  //Extra variable definitions:
  wire data_out;
  reg [4:0] z;
  reg [1:0] address;
  reg [1:0] addressA, addressB;
  
  // Inputs: reset, run, shift, update (mutually exclusive)
  // Input: data_in
  always @ (posedge clk)
  	//When "reset" is activated, the memory unit and the internal registers are reset.
  	if (reset) begin
  		shift_reg = 7'b0000000;
  		shadow_reg = 7'b0000000;
  		mem = 0;										//Figure out syntax for memory unit
  	end
  	//At the "shift" state, data from "data_in" is shifted into the shift register.
  	//"data_out" gets the bumped out bit.
  	else if (shift) begin
  		data_out = shift_reg[7];
  		shift_reg[7] = shift_reg[6];
  		shift_reg[6] = shift_reg[5];
  		shift_reg[5] = shift_reg[4];
  		shift_reg[4] = shift_reg[3];
  		shift_reg[3] = shift_reg[2];
  		shift_reg[2] = shift_reg[1];
  		shift_reg[1] = shift_reg[0];
  		shift_reg[0] = data_in;
  	end
  	//At "update", shadow register gets content of shift register
  	else if (update) begin
  		shadow_reg[7] = shift_reg[7];
  		shadow_reg[6] = shift_reg[6];
  		shadow_reg[5] = shift_reg[5];
  		shadow_reg[4] = shift_reg[4];
  		shadow_reg[3] = shift_reg[3];
  		shadow_reg[2] = shift_reg[2];
  		shadow_reg[1] = shift_reg[1];
  		shadow_reg[0] = shift_reg[0];
  	end
  	//During "run", the stable contents of the shadow register tell the control unit
  	//or memory unit what to do.
  	else if (run) begin
  		// Opcode 00: Initialize the MEM: writing data to the MEM before they can be used
  		// Bits 5:4 - Address of the Mem
  		// Bits 3:0 - Data written to the Mem
  		if(shadow_reg[7:6] == 2'b00) begin
  			mem[shadow_reg[5:4]] <= shadow_reg[3:0];				//Array in mem = shadow's 4 bits
  		end
  		// Opcode 01: Arithmetic operation - output to z
  		// Bit 5 - Set the addition (0) or subtraction (1) operations
  		// Bit 3:2 and 1:0 - Addresses of the operands.
  		if(shadow_reg[7:6] == 2'b01) begin
  			if(shadow_reg[5] == 0) begin
  				z[4:0] <= shadow_reg[3:2] + shadow_reg[1:0];
  			end
  			else begin
  				z[4:0] <= shadow_reg[3:2] - shadow_reg[1:0];
  			end
  		end
  		// Opcode 10: Logic operation - output to z
  		// Bit 5 - Set the AND (0) or OR (1) operations
  		// Bits 3:2 and 1:0 - Addresses of the operands.
  		if(shadow_reg[7:6] == 2'b10) begin
  			if(shadow_reg[5] == 0) begin
  				z[4:0] <= mem[shadow_reg[3:2]] and mem[shadow_reg[1:0]];
  			end
  			else begin
  				z[4:0] <= mem[shadow_reg[3:2]] or mem[shadow_reg[1:0]];
  			end
  		end
  		// Opcode 11: Buffering data: send input data to output z
  		// Bits 4:0 - Data sent to the output
  		if(shadow_reg[7:6] == 2'b11) begin
  			z[4:0] <= shadow_reg[4:0];
  		end
  	end
  	
endmodule
