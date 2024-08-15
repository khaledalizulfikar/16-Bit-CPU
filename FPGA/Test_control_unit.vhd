Library IEEE;
use ieee.std_logic_1164.all;

Entity Test_control_unit Is
	PORT( 
			SW:IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			LEDR:OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			HEX0,HEX1,HEX2:OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			KEY:IN std_logic_vector(0 downto 0)
	);
End Entity Test_control_unit;

Architecture Behaviour Of Test_control_unit Is

	Component control_unit Is
		Port(
		Din: IN std_logic_vectOR(15 downto 0); -- 16-bit input data
		RUN, RESET, CLK: IN std_logic; -- Control inputs
		DONE, A_REGENABLE, OUT_REGENABLE, INSTRUCTION_REGENABLE: OUT std_logic; -- Output signals
		WRITEMUX, ALU_OPER: OUT std_logic_vectOR (2 downto 0); -- WRITE, ALU Control outputs
		readmux1: OUT std_logic_vectOR (3 downto 0); -- READ Multiplexer selection
		JUMPADDRESS: OUT std_logic_vectOR (4 downto 0); --JUMP ADDress
		JUMPENABLE: OUT std_logic --JUMP enable
		);
	End Component;
	
	Component seven_segment_decoder Is 
		Port( 
			BCD:In std_logic_vector(3 downto 0);
			SEG:Out std_logic_vector(6 downto 0)
		  );
	End Component;

	SIGNAL instword : std_logic_vector(15 downto 0);
	Signal readmux1:std_logic_vector(3 downto 0);
	Signal j,k : std_logic_vector(2 downto 0);
	Signal j1,k1 : std_logic_vector(3 downto 0);
	
Begin
		instword<="0010011001000110";
		
	control_map:control_unit Port map(instword,SW(0), '0',not KEY(0), LEDR(0),LEDR(1),LEDR(2),LEDR(3),j,k,readmux1);
	disp0:seven_segment_decoder port map(readmux1, HEX0);
	j1<="0"&j;
	k1<="0"&k;
	disp1:seven_segment_decoder port map(j1, HEX1);
	disp2:seven_segment_decoder port map(k1, HEX2);
End Architecture Behaviour;