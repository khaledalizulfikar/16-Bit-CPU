Library IEEE;
Use ieee.std_logic_1164.all;

Entity Test_ROM IS
	PORT( HEX0, HEX1, HEX2, HEX3:OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
			LEDR:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
			KEY:IN STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
End Entity Test_ROM;

Architecture arch Of Test_ROM Is
	
	Component Decod7Seg Is 
		Port( C:In std_logic_vector(3 downto 0);
				hex:Out std_logic_vector(6 downto 0)
		  );
	End Component;
	
	Component Counter Is 
		port( 		
			aclr		: IN STD_LOGIC ;
			clock		: IN STD_LOGIC ;
			updown		: IN STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
		);
	End Component;
	
	Component ROM IS
		PORT( address		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
				clock		: IN STD_LOGIC  := '1';
				q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	End Component;
	
	Signal DIN_S:std_logic_vector(15 downto 0);
	Signal addre:std_logic_vector(4 downto 0);
Begin
	count_address:Counter Port map(not(KEY(1)),KEY(0),'1',addre);
	
	LEDR<=addre;
	
	ROM_map:ROM Port map(addre,KEY(0),DIN_S);
	
	map_Decod7Seg1:Decod7Seg Port map(DIN_S(3 downto 0),HEX0);
	map_Decod7Seg2:Decod7Seg Port map(DIN_S(7 downto 4),HEX1);
	map_Decod7Seg3:Decod7Seg Port map(DIN_S(11 downto 8),HEX2);
	map_Decod7Seg4:Decod7Seg Port map(DIN_S(15 downto 12),HEX3);
End Architecture arch;