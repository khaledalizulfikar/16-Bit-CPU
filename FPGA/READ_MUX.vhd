Library ieee;
Use ieee.std_logic_1164.all;

Entity READ_MUX Is
    Port (
        SEL: In std_logic_vector(3 downto 0);  -- 4-bit select signal
        OUT_REG, DIN, R0, R1, R2, R3, R4, R5, R6, R7: In std_logic_vector(15 downto 0);  -- Input data sources
        S: Out std_logic_vector(15 downto 0)  -- Output selected data
    );
End Entity READ_MUX;

Architecture Behaviour Of READ_MUX Is
Begin
    -- Use the "SEL" signal to select the appropriate data source
    With SEL Select
        S <=  OUT_REG                   When "0000",                  -- Select OUT_REG
              "0000000000000001"        when "0001",                  -- Select constant '0000000000000001'
              DIN                        When "0010",                  -- Select DIN
              R0                         When "0011",                  -- Select R0
              R1                         When "0100",                  -- Select R1
              R2                         When "0101",                  -- Select R2
              R3                         When "0110",                  -- Select R3
              R4                         When "0111",                  -- Select R4
              R5                         When "1000",                  -- Select R5
              R6                         When "1001",                  -- Select R6
              R7                         When "1011",                  -- Select R7
              "1010110111101101"        When OTHERS;                 -- Default to a specific constant for unhandled cases
End Architecture Behaviour;
