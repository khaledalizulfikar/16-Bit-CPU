LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY n_bit_arithmetic_unit IS
	GENERIC (N: INTEGER := 4);  -- Generic parameter N with a default value of 4
	PORT (
		A, B: IN std_logic_vector(N-1 downto 0);  -- Input vectors for two N-bit numbers A and B
		CarryIn, SEL: IN std_logic;  -- Input signals for carry-in and SEL (1 for Subtraction)
		CarryOut: OUT std_logic;  -- Output carry-out signal
		S: OUT std_logic_vector(N-1 downto 0)  -- Output vector for the sum S
	);
END ENTITY;

ARCHITECTURE Behaviour OF n_bit_arithmetic_unit IS
	COMPONENT n_bit_full_adder IS
		GENERIC (N: INTEGER := 4);  -- Component for an N-bit full adder
		PORT (
			A, B: IN std_logic_vector(N-1 downto 0);  -- Inputs for two N-bit numbers A and B
			CarryIn: IN std_logic;  -- Input carry-in signal
			CarryOut: OUT std_logic;  -- Output carry-out signal
			S: OUT std_logic_vector(N-1 downto 0)  -- Output vector for the sum S
		);
	END COMPONENT;

	SIGNAL signalB: std_logic_vector(N-1 downto 0);  -- Signal to store the complement of B
	SIGNAL signalCin: std_logic;  -- Signal to control carry-in

	BEGIN
		-- Conditional assignment to signalB based on SEL value
		WITH SEL SELECT
			signalB <= not(B) WHEN '1',
					 B WHEN OTHERS;

		-- Conditional assignment to signalCin based on SEL value
		WITH CarryIn SELECT
			signalCin <= '1' WHEN '1',
						 '0' WHEN OTHERS;

		-- Instantiate an N-bit full adder component (fa1) and connect its ports
		fa1: n_bit_full_adder
			GENERIC MAP (N)
			PORT MAP (
				A => A,
				B => signalB,
				CarryIn => signalCin,
				CarryOut => CarryOut,
				S => S
			);
	END Behaviour;
