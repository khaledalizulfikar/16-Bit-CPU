Library IEEE;

use ieee.std_logic_1164.all;

ENTITY Test_one_bit_register IS
	PORT(SW:IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			LEDR:OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
	);
END entity;

ARCHITECTURE Behaviour OF Test_one_bit_register IS
	COMPONENT one_bit_register IS
		PORT( D, RESET, CLK, ENABLE:IN std_logic;
				S:OUT std_logic
		);
	END COMPONENT;
	SIGNAL CLK:std_logic:='0';
	CONSTANT clk_period:TIME:=20 ns;
	BEGIN
		CLK<=not CLK after (clk_period/2);
		reg: one_bit_register PORT MAP(D=>SW(0), 
							 RESET=>not SW(2),
							 CLK=>CLK,
							 ENABLE=>SW(1),
							 S=>LEDR(0)
							 );
END Behaviour;