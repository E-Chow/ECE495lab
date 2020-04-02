library IEEE;
use IEEE.std_logic_1164.all;

entity bsr_unit is
	
port(bsr_clk, left_right: in std_logic; 
	right_in, left_in: in std_logic;
	bsr_q: out std_logic);
end bsr_unit;
	
architecture structure of bsr_unit is
	
	component mux_2to1 is
		Port ( sel,a,b : in  STD_LOGIC;
         		x   : out STD_LOGIC);
	end component;

	component d_ff is
		port( d, clk: in std_logic;
		     q: out std_logic);
	end component;
	
	signal tmp: STD_LOGIC;
	
	begin
		
	Mux: mux_2to1 port map(a=>left_in, b=>right_in, sel=>left_right, x=>tmp);
	ff: d_ff port map(d=>tmp, clk=>bsr_clk, q=>bsr_q);
		
end structure;
