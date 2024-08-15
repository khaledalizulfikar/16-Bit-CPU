-- Import necessary libraries
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Define the entity for the testbench
ENTITY Test_CPUROM IS
    PORT (
        LEDR: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);  -- Output LEDs
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- Seven-segment display outputs
        SW: IN STD_LOGIC_VECTOR(1 DOWNTO 0);  -- Input switches
        KEY: IN STD_LOGIC_VECTOR(1 DOWNTO 0)  -- Input keys
    );
END ENTITY Test_CPUROM;

-- Define the architecture of the testbench
ARCHITECTURE Behaviour OF Test_CPUROM IS
    -- Declare the component for the CPU
    COMPONENT CPU IS
        PORT (
            CLK, RUN, RESET: IN STD_LOGIC;  -- Control signals for clock, run, and reset
            DIN: IN STD_LOGIC_VECTOR(15 DOWNTO 0);  -- 16-bit input data
            DONE, Overflow: OUT STD_LOGIC;  -- Output signals for done and overflow
            CPU_BUS: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Output bus for CPU data
            MUX: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Output multiplexer selection
            JumpAdr: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);  -- Output jump memory address
            JumpEn: OUT STD_LOGIC  -- Output jump enable
        );
    END COMPONENT;

    -- Declare the component for a seven-segment display decoder
    COMPONENT seven_segment_decoder IS
        PORT (
            BCD: IN STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Input BCD (Binary Coded Decimal)
            SEG: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- Output segment display control
        );
    END COMPONENT;

    -- Declare the component for a counter
    COMPONENT Counter IS
        PORT (
            aclr: IN STD_LOGIC;  -- Input asynchronous clear
            aload: IN STD_LOGIC;  -- Input asynchronous load
            clock: IN STD_LOGIC;  -- Input clock
            data: IN STD_LOGIC_VECTOR(4 DOWNTO 0);  -- Input data
            updown: IN STD_LOGIC;  -- Input direction (up/down)
            q: OUT STD_LOGIC_VECTOR(4 DOWNTO 0)  -- Output count
        );
    END COMPONENT;

    -- Declare the component for a ROM
    COMPONENT ROM IS
        PORT (
            address: IN STD_LOGIC_VECTOR(4 DOWNTO 0);  -- Input memory address
            clock: IN STD_LOGIC := '1';  -- Input clock (default to '1')
            q: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)  -- Output data from ROM
        );
    END COMPONENT;

    -- Signals and variables declaration
    Signal BUS_0, DIN_S:std_logic_vector(15 downto 0);
	 SIGNAL MEMADDRE, jmpad: STD_LOGIC_VECTOR(4 DOWNTO 0);  -- Memory address and jump address
    SIGNAL READMX: STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Output multiplexer selection
    SIGNAL done, jmpen: STD_LOGIC;  -- Output signals for done and jump enable

BEGIN
    -- Instantiate and connect the components
    FIVE_BIT_COUNTER: Counter PORT MAP(SW(1), jmpen, done, jmpad, '1', MEMADDRE);
    INSTRUCTION_ROM: ROM PORT MAP(MEMADDRE, done, DIN_S);
    MAIN_CPU: CPU PORT MAP(NOT KEY(0), SW(0), SW(1), DIN_S, done, LEDR(1), BUS_0, READMX, jmpad, jmpen);

    -- Connect the LEDs
    LEDR(0) <= done;

    -- Instantiate seven-segment decoders for displaying CPU data and other information
    DISPLAY_0: seven_segment_decoder PORT MAP(BUS_0(3 DOWNTO 0), HEX0);
    DISPLAY_1: seven_segment_decoder PORT MAP(BUS_0(7 DOWNTO 4), HEX1);
    DISPLAY_2: seven_segment_decoder PORT MAP(BUS_0(11 DOWNTO 8), HEX2);
    DISPLAY_3: seven_segment_decoder PORT MAP(BUS_0(15 DOWNTO 12), HEX3);
    DISPLAY_4: seven_segment_decoder PORT MAP(READMX, HEX4);
    DISPLAY_5: seven_segment_decoder PORT MAP(MEMADDRE(3 DOWNTO 0), HEX5);
END ARCHITECTURE Behaviour;
