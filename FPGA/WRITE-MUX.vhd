Library ieee;
Use ieee.std_logic_1164.all;

Entity WRITE_MUX Is
    Port (
        Sel: In std_logic_vector(2 downto 0);  -- 3-bit select signal
        REG_ENABLE: Out std_logic_vector(7 downto 0)  -- Output register enable signals
    );
End Entity WRITE_MUX;

Architecture Behaviour Of WRITE_MUX Is
Begin
    -- Use the "Sel" signal to select the appropriate register enable signal
    -- For each possible value of "Sel," set one of the "REG_ENABLE" bits to '1'
    With Sel Select
        REG_ENABLE(0) <= '1'  When "000",  -- Select the first bit when Sel is "000"
                        '0'  When OTHERS;  -- Set to '0' for other cases

    With Sel Select
        REG_ENABLE(1) <= '1'  When "001",  -- Select the second bit when Sel is "001"
                        '0'  When OTHERS;  -- Set to '0' for other cases

    With Sel Select
        REG_ENABLE(2) <= '1'  When "010",  -- Select the third bit when Sel is "010"
                        '0'  When OTHERS;  -- Set to '0' for other cases

    With Sel Select
        REG_ENABLE(3) <= '1'  When "011",  -- Select the fourth bit when Sel is "011"
                        '0'  When OTHERS;  -- Set to '0' for other cases

    With Sel Select
        REG_ENABLE(4) <= '1'  When "100",  -- Select the fifth bit when Sel is "100"
                        '0'  When OTHERS;  -- Set to '0' for other cases

    With Sel Select
        REG_ENABLE(5) <= '1'  When "101",  -- Select the sixth bit when Sel is "101"
                        '0'  When OTHERS;  -- Set to '0' for other cases

    With Sel Select
        REG_ENABLE(6) <= '1'  When "110",  -- Select the seventh bit when Sel is "110"
                        '0'  When OTHERS;  -- Set to '0' for other cases

    With Sel Select
        REG_ENABLE(7) <= '1'  When "111",  -- Select the eighth bit when Sel is "111"
                        '0'  When OTHERS;  -- Set to '0' for other cases
End Architecture Behaviour;
