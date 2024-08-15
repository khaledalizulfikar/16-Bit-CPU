-- Library declaration to use standard logic libraries
Library IEEE;
use ieee.std_logic_1164.all;

-- Entity declaration for a one-bit register
ENTITY one_bit_register IS
	PORT(
		D, RESET, CLK, ENABLE: IN std_logic; -- Input signals
		S: OUT std_logic -- Output signal
	);
END entity;

-- Architecture for the behavior of the one-bit register
ARCHITECTURE Behaviour OF one_bit_register IS
BEGIN
    -- Process definition with sensitivity list (CLK and RESET)
    process(CLK, RESET)
    begin
        if RESET = '1' then
            -- If RESET signal is '1', set the output 'S' to '0'
            S <= '0';
        elsif rising_edge(CLK) then
            -- Check for the rising edge of the clock signal
            if ENABLE = '1' then
                -- If ENABLE is '1', update the output 'S' with the value of input 'D'
                S <= D;
            end if;
        end if;
    end process; -- End of the process
END Behaviour; -- End of the architecture
