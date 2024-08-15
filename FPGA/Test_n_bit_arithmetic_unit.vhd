Library IEEE;

use ieee.std_logic_1164.all;

ENTITY Test_n_bit_arithmetic_unit IS
	PORT(SW:IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			LEDR:OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END entity;

ARCHITECTURE Behaviour OF Test_n_bit_arithmetic_unit IS
	COMPONENT n_bit_arithmetic_unit IS
		GENERIC(N:INTEGER :=4);
		PORT(A, B:IN std_logic_vector(N-1 downto 0);
			CarryIn, SEL:In std_logic;
			CarryOut:OUT std_logic;
			S: OUT std_logic_vector(N-1 downto 0)
		);
	END COMPONENT;
	BEGIN
		arithmetic: n_bit_arithmetic_unit PORT MAP(A=>SW(3 downto 0), 
											 B=>SW(7 downto 4), 
											 CarryIn=>'0',
											 SEL=>SW(8), 
											 CarryOut=>LEDR(4), 
											 S=>LEDR(3 downto 0)
											);
END Behaviour;