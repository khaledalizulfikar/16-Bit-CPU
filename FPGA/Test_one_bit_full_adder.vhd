LIBRARY IEEE;

use ieee.std_logic_1164.all;
ENTITY Test_one_bit_full_adder IS
	PORT(SW:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			LEDR:OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END entity;

ARCHITECTURE Behaviour of Test_one_bit_full_adder IS
	COMPONENT one_bit_full_adder IS
		PORT(A, B, CarryIn : IN std_logic;
				S, CarryOut : OUT std_logic
		);
	END COMPONENT;
	BEGIN
		fulladder : one_bit_full_adder PORT MAP(SW(0), SW(1), SW(2), LEDR(0), LEDR(1));
END Behaviour;