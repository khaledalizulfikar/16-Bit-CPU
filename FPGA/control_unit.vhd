Library IEEE;
use ieee.std_logic_1164.all;

ENTITY control_unit IS
	PORT(
		Din: IN std_logic_vectOR(15 downto 0); -- 16-bit input data
		RUN, RESET, CLK: IN std_logic; -- Control inputs
		DONE, A_REGENABLE, OUT_REGENABLE, INSTRUCTION_REGENABLE: OUT std_logic; -- Output signals
		WRITEMUX, ALU_OPER: OUT std_logic_vectOR (2 downto 0); -- WRITE, ALU Control outputs
		READMUX: OUT std_logic_vectOR (3 downto 0); -- READ Multiplexer selection
		JUMPADDRESS: OUT std_logic_vectOR (4 downto 0); --JUMP ADDress
		JUMPENABLE: OUT std_logic --JUMP enable
	);
END ENTITY control_unit;

-- Define the architecture of the entity "UC"
ARCHITECTURE Behaviour OF control_unit IS
	-- Define a custom type "states" to represent different states of the finite state machine (FSM)
	Type states is (initial, state1, state2, final);
	signal present_state, future_state: states; -- Define state signals

	BEGIN
	-- Process to determine the future state based on the current state and input data (Din)
	code_future_state: PROCESS(present_state, Din)
		BEGIN
			CASE present_state IS
				-- State 0: Write Din into INSTRUCTION REG
				When initial =>
					-- Check the upper 4 bits of Din
					case Din(15 downto 12) IS
										when "0000" => future_state<=final;--MV
										when "0001" => future_state<=final;--DMV
										when "0010" => future_state<=state1;--ADD
										when "0011" => future_state<=state1;--Sub
										when "0100" => future_state<=final;--LD1
										when "0101" => future_state<=state1;--And
										when "0110" => future_state<=state1;--OR
										when "0111" => future_state<=state1;--XOR
										when "1000" => future_state<=state1;--Not
										when "1001" => future_state<=state1;--DADD
										when "1010" => future_state<=state1;--DSUB
										when "1011" => future_state<=final;--JUMP
										when "1100" => future_state<=state1;--DAND
										when "1101" => future_state<=state1;--DOR
										when "1110" => future_state<=state1;--DXOR
										when "1111" => future_state<=state1;--DNOT
										when others => future_state<=initial;
									end case;
						
				-- State 1: Write Reg OR Din into A
				When state1 => future_state <= state2;

				-- State 2: Calculate A with Reg OR Din and write into OUT
				When state2 => future_state <= final;

				-- State 3: Write G, Reg, OR Din into Reg (Register)
				When final => future_state <= initial;
			END CASE;
	END PROCESS code_future_state;

	-- Process to update the current state based on the clock (CLK) and reset (RESET) signals
	state_register: PROCESS(CLK,RUN)
		Begin
      IF (clk'EVENT AND clk='1' AND RESET = '1') THEN
				present_state <= initial;
		ELSIF (clk'EVENT AND clk='1' AND RUN='1') THEN
            CASE present_state IS
                WHEN initial =>
                    present_state <= future_state;
                WHEN state1 =>
                    present_state <= future_state;
                WHEN state2 =>
                    present_state <= future_state;
                WHEN final =>
                    present_state <= future_state;						  
            END CASE;

				
       ELSIF (clk='1' AND clk'EVENT) THEN
				present_state <= initial;		
		end if;
	END PROCESS state_register;

	-- Process to determine the outputs based on the current state and RUN signal
	output_code: PROCESS(present_state)
		Begin
			Case present_state IS
				-- State 0: Initial state
				When initial =>
					DONE <= '0'; -- Initialize DONE to 0
					A_REGENABLE <= '0';
					OUT_REGENABLE <= '0';
					INSTRUCTION_REGENABLE <= '1';
					WRITEMUX <= (others => '0'); -- Initialize to all zeros
					ALU_OPER <= (others => '1'); -- Initialize to all ones
					READMUX <= (others => '1'); -- Initialize to all ones

				When state1 => 	A_REGENABLE <= '1';
										INSTRUCTION_REGENABLE <= '0';
										JUMPENABLE <= '0';
									Case Din(15 downto 12) is
										when "0010" => READMUX <= Din(11 downto 8);--ADD
										when "0011" => READMUX <= Din(11 downto 8);--Sub
										when "0101" => READMUX <= Din(11 downto 8);--And
										when "0110" => READMUX <= Din(11 downto 8);--OR
										when "0111" => READMUX <= Din(11 downto 8);--XOR
										when "1000" => READMUX <= Din(11 downto 8);--Not
										when "1001" => READMUX <= Din(11 downto 8);--DADD
										when "1010" => READMUX <= Din(11 downto 8);--DSUB
										when "1100" => READMUX <= Din(11 downto 8);--DAND
										when "1101" => READMUX <= Din(11 downto 8);--DOR
										when "1110" => READMUX <= Din(11 downto 8);--DXOR
										when "1111" => READMUX <= "0001";--DNOT
										when others => NULL;
									end case;
									
				-- State 2: Calculate A with Reg OR Din and write into OUT
				When state2 => 	A_REGENABLE <= '0';
										OUT_REGENABLE <= '1';
									Case Din(15 downto 12) is
										when "0010" => READMUX <= Din(7 downto 4);--ADD
															ALU_OPER <= "000";
										when "0011" => READMUX <= Din(7 downto 4);--Sub
															ALU_OPER <= "001";
										when "0101" => READMUX <= Din(7 downto 4);--And
															ALU_OPER <= "011";
										when "0110" => READMUX <= Din(7 downto 4);--OR
															ALU_OPER <= "100";
										when "0111" => READMUX <= Din(7 downto 4);--XOR
															ALU_OPER <= "110";
										when "1000" => READMUX <= (others=>'1');
															ALU_OPER <= "101";--Not
										when "1001" => READMUX <= "0001";--DADD
															ALU_OPER <= "000";
										when "1010" => READMUX <= "0001";--DSUB
															ALU_OPER <= "001";
										when "1100" => READMUX <= "0001";--DAND
															ALU_OPER <= "011";
										when "1101" => READMUX <= "0001";--DOR
															ALU_OPER <= "100";
										when "1110" => READMUX <= "0001";--DXOR
															ALU_OPER <= "110";
										when "1111" => ALU_OPER <= "101";--DNOT
															READMUX <= (others=>'1');
										when others => NULL;
									end case;
									
				-- State 3: Write G, Reg, OR Din into Reg
				When final =>		DONE <= '1';
										OUT_REGENABLE <= '0';
										INSTRUCTION_REGENABLE <= '0';
									Case Din(15 downto 12) is
										when "0000" => READMUX <= Din(11 downto 8);--Mov
															WRITEMUX <= Din(7 downto 5);
										when "0001" => READMUX <= "0010";--DMV
															WRITEMUX <= Din(11 downto 9);
										when "0010" => READMUX <= "0000";--ADD
															WRITEMUX <= Din(3 downto 1);
										when "0011" => READMUX <= "0000";--Sub
															WRITEMUX <= Din(3 downto 1);
										when "0100" => READMUX <= "0001";--LD1
															WRITEMUX <= Din(11 downto 9);
										when "0101" => READMUX <= "0000";--And
															WRITEMUX <= Din(3 downto 1);
										when "0110" => READMUX <= "0000";--OR
															WRITEMUX <= Din(3 downto 1);
										when "0111" => READMUX <= "0000";--XOR
															WRITEMUX <= Din(3 downto 1);
										when "1000" => READMUX <= "0000";--Not
															WRITEMUX <= Din(7 downto 5);
										when "1001" => READMUX <= "0000";--DADD
															WRITEMUX <= Din(7 downto 5);
										when "1010" => READMUX <= "0000";--DSUB
															WRITEMUX <= Din(7 downto 5);
										when "1011" => JUMPADDRESS <=Din(11 downto 7);--JUMP	
															JUMPENABLE <= '1';
										when "1100" => READMUX <= "0000";--DAND
															WRITEMUX <= Din(7 downto 5);
										when "1101" => READMUX <= "0000";--DOR
															WRITEMUX <= Din(7 downto 5);
										when "1110" => READMUX <= "0000";--DXOR
															WRITEMUX <= Din(7 downto 5);
										when "1111" => READMUX <= "0000";--DNOT
															WRITEMUX <= Din(11 downto 9);
										when others => NULL;
									end case;
			end case;
	END PROCESS output_code;
	
END ARCHITECTURE Behaviour;