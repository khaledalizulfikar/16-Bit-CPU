LIBRARY IEEE;
USE ieee.std_logic_1164.all;

-- Entity declaration for an N-bit Full Adder with a generic width N
ENTITY n_bit_full_adder IS
	GENERIC (N: INTEGER := 4);  -- Generic parameter N, default value is 4
	PORT (
		A, B: IN std_logic_vector(N-1 downto 0);  -- Input vectors for the two N-bit numbers
		CarryIn: IN std_logic;  -- Input carry-in signal
		CarryOut: OUT std_logic;  -- Output carry-out signal
		S: OUT std_logic_vector(N-1 downto 0)  -- Output vector for the sum
	);
END entity;

-- Architecture for the N-bit Full Adder
ARCHITECTURE Behaviour OF n_bit_full_adder IS
	COMPONENT one_bit_full_adder IS  -- Declare a component for a 1-bit Full Adder
		PORT (
			A, B, CarryIn: IN std_logic;  -- Inputs for two bits and carry-in
			S, CarryOut: OUT std_logic  -- Outputs for the sum and carry-out
		);
	END COMPONENT;

	SIGNAL carry: std_logic_vector(N-2 downto 0);  -- Define an internal signal to store intermediate carries
	BEGIN
		-- Generate loop for creating N instances of the 1-bit Full Adder component
		genloop: FOR i IN 0 TO N-1 GENERATE
			firstbit: IF i = 0 GENERATE
				-- First bit addition
				first: one_bit_full_adder PORT MAP (A(0), B(0), CarryIn, S(0), carry(0));
			END GENERATE firstbit;
			
			midbit: IF i > 0 AND i < N-1 GENERATE
				-- Intermediate bits addition
				middle: one_bit_full_adder PORT MAP (A(i), B(i), carry(i-1), S(i), carry(i));
			END GENERATE midbit;
			
			mostsigbit: IF i = N-1 GENERATE
				-- Most significant bit addition
				final: one_bit_full_adder PORT MAP (A(i), B(i), carry(i-1), S(i), CarryOut);
			END GENERATE mostsigbit;
		END GENERATE genloop;
	END Behaviour;
