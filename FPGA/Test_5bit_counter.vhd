Library IEEE;
use ieee.std_logic_1164.all;

Entity Test_5bit_counter Is
	PORT( SW:IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		   LEDR:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
			KEY:IN STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
End Entity Test_5bit_counter;

Architecture Behaviour Of Test_5bit_counter Is

	Component Counter Is 
		port( 		
			aclr		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			updown		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
		);
	End Component;
	
Begin
	Count_map:Counter PORT MAP(not KEY(1),KEY(0),SW(0),LEDR);
End Architecture Behaviour;