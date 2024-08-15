Library IEEE;

use ieee.std_logic_1164.all;
Entity seven_segment_decoder Is
	Port( 
			BCD:In std_logic_vector(3 downto 0);
			SEG:Out std_logic_vector(6 downto 0)
		  );
End seven_segment_decoder;

Architecture Behaviour Of seven_segment_decoder Is
	Begin
		With BCD select
			SEG<=	"1000000" When "0000",--0
					"1111001" When "0001",--1
					"0100100" When "0010",--2
					"0110000" When "0011",--3
					"0011001" When "0100",--4
					"0010010" When "0101",--5
					"0000010" When "0110",--6
					"1111000" When "0111",--7
					"0000000" When "1000",--8
					"0010000" When "1001",--9
					"0001000" When "1010",--a
					"0000000" When "1011",--b
					"1000110" When "1100",--c
					"1000000" When "1101",--d
					"0000110" When "1110",--e
					"0001110" When others;--f
	
	End Behaviour;