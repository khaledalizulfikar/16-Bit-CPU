LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY SIXTEEN_BIT_ALU IS
	PORT (
		A, B: IN std_logic_vector(15 downto 0);  -- Input vectors A and B, each 16 bits wide
		OPER: IN std_logic_vector(2 downto 0);  -- Input operation code (3 bits)
		S: OUT std_logic_vector(15 downto 0);  -- Output vector for the result, 16 bits wide
		Overflow: OUT std_logic  -- Output for the overflow flag
	);
END ENTITY SIXTEEN_BIT_ALU;

ARCHITECTURE Behaviour OF SIXTEEN_BIT_ALU IS
	-- Declare a component for an n-bit arithmetic unit
	COMPONENT n_bit_arithmetic_unit IS
		GENERIC (N: INTEGER := 4);
		PORT (
			A, B: IN std_logic_vector(N-1 downto 0);  -- Inputs for two N-bit numbers A and B
			CarryIn, SEL: IN std_logic;  -- Input carry-in signal and select signal
			CarryOut: OUT std_logic;  -- Output carry-out signal
			S: OUT std_logic_vector(N-1 downto 0)  -- Output vector for the sum S
		);
	END COMPONENT;

	-- Signals for intermediate results and carry flags
	SIGNAL ADDSIG, SUBSIG, ANDSIG, ORSIG, NOTSIG, XORSIG: std_logic_vector(15 downto 0);
	SIGNAL ADDCARRY, SUBCARRY: std_logic;
	
BEGIN
	-- Instantiate the n-bit arithmetic units for addition and subtraction, both with 16-bit width
	add: n_bit_arithmetic_unit GENERIC MAP (16) PORT MAP (A, B, '0', '0', ADDCARRY, ADDSIG);
	sub: n_bit_arithmetic_unit GENERIC MAP (16) PORT MAP (A, B, '0', '1', SUBCARRY, SUBSIG);
	
	-- Perform bitwise logical operations (AND, OR, NOT, XOR)
	ANDSIG <= A and B;
	ORSIG <= A or B;
	NOTSIG <= not (A);
	XORSIG <= A xor B;
	
	-- Select the result based on the value of the OPER input
	WITH OPER SELECT
		S <= ADDSIG WHEN "000",
			  SUBSIG WHEN "001",
			  ANDSIG WHEN "011",
			  ORSIG WHEN "100",
			  NOTSIG WHEN "101",
			  XORSIG WHEN "110",
			  (others => 'X') WHEN OTHERS;
	
	-- Determine the overflow flag based on the value of the OPER input
	WITH OPER SELECT
		Overflow <= ADDCARRY WHEN "000",
					SUBCARRY WHEN "001",
					'0' WHEN OTHERS;  -- '0' for no overflow
END ARCHITECTURE Behaviour;
