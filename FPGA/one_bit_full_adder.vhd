LIBRARY IEEE;
USE ieee.std_logic_1164.all;

ENTITY one_bit_full_adder IS
	PORT (
		A, B, CarryIn : IN std_logic;  -- Input signals for two bits and carry-in
		S, CarryOut : OUT std_logic   -- Output signals for the sum and carry-out
	);
END entity;

-- Architecture for the 1-bit Full Adder
ARCHITECTURE Behaviour OF one_bit_full_adder IS
BEGIN
	-- Combinational logic to compute the carry-out and sum
	CarryOut <= (A and B) or ((A xor B) and CarryIn);
	S <= A xor B xor CarryIn;
END Behaviour;
