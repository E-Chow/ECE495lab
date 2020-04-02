library ieee;
use ieee.std_logic_1164.all;

entity bsr is 
	generic(n: positive :=3);
	port(shift_in: in std_logic;
		clk, left_right: in std_logic;
		q: out std_logic_vector(n-1 downto 0));
end bsr;

architecture dataflow of bsr is
	component bsr_unit is
	port(bsr_clk, left_right: in std_logic; 
	     right_in, left_in: in std_logic;
	     bsr_q: out std_logic);
	end component;
	
	signal direction : std_logic := left_right;
	signal tmp: std_logic_vector(n-1 downto 0);

begin
	zbit: bsr_unit port map( right_in=>tmp(1), left_in=> shift_in, bsr_q=>tmp(0), left_right=>direction, bsr_clk=>clk);
	
	reg: for i in 1 to n-2 generate
		rbit: bsr_unit port map( right_in=>tmp(i+1), left_in=> tmp(i-1), bsr_q=>tmp(i), left_right=>direction, bsr_clk=>clk);
	end generate;
	
	nbit: bsr_unit port map( right_in=>shift_in, left_in=> tmp(n-2), bsr_q=>tmp(n-1), left_right=>direction, bsr_clk=>clk);
	
	q<=tmp;
end dataflow;
