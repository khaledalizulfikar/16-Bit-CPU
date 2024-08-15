-- Library declaration to use standard logic libraries
Library IEEE;
use ieee.std_logic_1164.all;

-- Entity declaration for a generic N-bit register
ENTITY n_bit_register IS
	GENERIC (N: INTEGER := 4); -- Define a generic integer N with a default value of 4
	PORT (
		D: IN std_logic_vector(N-1 downto 0); -- Input data vector of N bits
		RESET, CLK, ENABLE: IN std_logic; -- Input control signals (Reset, Clock, and Enable)
		S: OUT std_logic_vector(N-1 downto 0) -- Output data vector of N bits
	);
END entity;

-- Architecture for the generic N-bit register
ARCHITECTURE Behaviour OF n_bit_register IS
	COMPONENT one_bit_register IS -- Declare a component for a 1-bit register
		PORT (
			D, RESET, CLK, ENABLE: IN std_logic; -- Input data, reset, clock, and enable signals
			S: OUT std_logic -- Output data
		);
	END COMPONENT;

	BEGIN
		genloop: FOR i IN 0 TO N-1 GENERATE -- Generate N instances of the 1-bit register component
			onebitreg: one_bit_register PORT MAP (D(i), RESET, CLK, ENABLE, S(i)); -- Connect inputs and outputs for each instance
		END GENERATE genloop; -- End of the generate loop
END Behaviour;
