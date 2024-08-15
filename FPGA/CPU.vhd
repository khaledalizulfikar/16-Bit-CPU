Library ieee;
Use ieee.std_logic_1164.all;

Entity CPU Is
    Port (
        CLK, RUN, RESET: In std_logic;  -- Control signals for clock, run, and reset
        DIN: In std_logic_vector(15 downto 0);  -- 16-bit input data
        DONE, Overflow: Out std_logic;  -- Output signals for done and overflow
        CPU_BUS: Out std_logic_vector(15 downto 0);  -- Output bus for CPU data
        MUX: Out std_logic_vector(3 downto 0);  -- Output multiplexer selection
        JumpAdr: Out std_logic_vector(4 downto 0);  -- Output jump address
        JumpEn: Out std_logic  -- Output jump enable
    );
End Entity CPU;

Architecture Behaviour Of CPU Is
    Component control_unit Is
        Port (
            Din: In std_logic_vector(15 downto 0);  -- 16-bit input data
            RUN, RESET, CLK: In std_logic;  -- Control inputs
            DONE, A_REGENABLE, OUT_REGENABLE, INSTRUCTION_REGENABLE: Out std_logic;  -- Output signals
            WRITEMUX, ALU_OPER: Out std_logic_vector(2 downto 0);  -- WRITE, ALU Control outputs
            READMUX: Out std_logic_vector(3 downto 0);  -- READ Multiplexer selection
            JUMPADDRESS: Out std_logic_vector(4 downto 0);  -- Jump address
            JUMPENABLE: Out std_logic  -- Jump enable
        );
    End Component;

    Component SIXTEEN_BIT_ALU Is
        Port (
            A, B: In std_logic_vector(15 downto 0);  -- Input vectors A and B, each 16 bits wide
            OPER: In std_logic_vector(2 downto 0);  -- Input operation code (3 bits)
            S: Out std_logic_vector(15 downto 0);  -- Output vector for the result, 16 bits wide
            Overflow: Out std_logic  -- Output for the overflow flag
        );
    End Component;

    Component READ_MUX Is
        Port (
            SEL: In std_logic_vector(3 downto 0);  -- 4-bit select signal
            OUT_REG, DIN, R0, R1, R2, R3, R4, R5, R6, R7: In std_logic_vector(15 downto 0);  -- Input data sources
            S: Out std_logic_vector(15 downto 0)  -- Output selected data
        );
    End Component;

    Component WRITE_MUX Is
        Port (
            Sel: In std_logic_vector(2 downto 0);  -- 3-bit select signal
            REG_ENABLE: Out std_logic_vector(7 downto 0)  -- Output register enable signals
        );
    End Component;

    Component n_bit_register Is
        Generic (N: INTEGER := 4);
        Port (
            D: In std_logic_vector(N-1 downto 0);
            RESET, CLK, ENABLE: In std_logic;
            S: Out std_logic_vector(N-1 downto 0)
        );
    End Component;

    -- Declare custom type for an array of 8 16-bit vectors
    Type A_REGM_TYPE Is Array(7 downto 0) Of std_logic_vector(15 downto 0);

    Signal R: A_REGM_TYPE;  -- Array of 8 registers
	 
    Signal INSTRUCTION_REG, ALU_OUT, OUT_REG_SIG, BUS_SIG, ALU_SIG: std_logic_vector(15 downto 0);
    Signal A_REG, OUTPUT_REG, IN_REG: std_logic;
    Signal RegCtrl_S, AluSel: std_logic_vector(2 downto 0);
    Signal READ_REG_SIG: std_logic_vector(3 downto 0);
    Signal RegSel: std_logic_vector(7 downto 0);

Begin
    -- Instantiate the control unit and connect its ports
    CONTROL: control_unit Port map(
        INSTRUCTION_REG, RUN, RESET, CLK, DONE, A_REG, OUTPUT_REG, IN_REG, RegCtrl_S, AluSel, READ_REG_SIG, JumpAdr, JumpEn
    );

    -- Instantiate the READ_MUX module to select data sources
    READ_MULTIPLEXER: READ_MUX Port map(
        READ_REG_SIG, OUT_REG_SIG, DIN, R(0), R(1), R(2), R(3), R(4), R(5), R(6), R(7), BUS_SIG
    );

    -- Instantiate the ALU and connect its ports
    AR_LO_U: SIXTEEN_BIT_ALU Port map(ALU_SIG, BUS_SIG, AluSel, ALU_OUT, Overflow);

    -- Instantiate the WIN_REGTE_MUX module to enable registers
    WIN_REGTE_ENABLE_MULTIPLEXER: WRITE_MUX Port map(RegCtrl_S, RegSel);

    -- Instantiate and connect 8 n-bit registers (RAM) using a generate statement
    RAM: For i In 0 To 7 Generate
        REG: n_bit_register Generic map(16) Port map(D => BUS_SIG, RESET => RESET, CLK => CLK, ENABLE => RegSel(i), S => R(i));
    End Generate RAM;

    -- Connect the output of the ALU to the A_REG register
    OPEA_REGND_REGISTER: n_bit_register Generic map(16) Port map(D => BUS_SIG, RESET => RESET, CLK => CLK, ENABLE => A_REG, S => ALU_SIG);

    -- Connect the output of the ALU to the OUTPUT_REG register
    OUTPUT_REGISTER: n_bit_register Generic map(16) Port map(D => ALU_OUT, RESET => RESET, CLK => CLK, ENABLE => OUTPUT_REG, S => OUT_REG_SIG);

    -- Connect the input data DIN to the INSTRUCTION_REG register
    INSTRUCTION_REGISTER: n_bit_register Generic map(16) Port map(D => DIN, RESET => RESET, CLK => CLK, ENABLE => IN_REG, S => INSTRUCTION_REG);

    -- Assign output signals
    CPU_BUS <= BUS_SIG;
    MUX <= READ_REG_SIG;

End Architecture Behaviour;
