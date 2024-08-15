Library IEEE;

use ieee.std_logic_1164.all;

ENTITY Test_n_bit_full_adder IS
	PORT(SW:IN STD_LOGIC_VECTOR(8 DOWNTO 0);
			LEDR:OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END entity;

ARCHITECTURE Behaviour OF Test_n_bit_full_adder IS
	COMPONENT n_bit_full_adder IS
		PORT(A, B:IN std_logic_vector(3 downto 0);
			CarryIn:In std_logic;
			CarryOut:OUT std_logic;
			S: OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	BEGIN
		adder: n_bit_full_adder PORT MAP(A=>SW(3 downto 0), 
							 B=>SW(7 downto 4), 
							 CarryIn=>SW(8), 
							 CarryOut=>LEDR(4), 
							 S=>LEDR(3 downto 0)
							 );
END Behaviour;