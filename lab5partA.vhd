-- mod10.vhd
library ieee;
use ieee.std_logic_1164.all;

entity mod10 is
	port (clk: 	in std_logic;
			clr: 	in std_logic;
			q: 	out std_logic_vector(3 downto 0);
			cout: out std_logic);
end mod10;

architecture structure of mod10 is
	component tff_cp
		port (t, clk, prn, clrn: in std_logic;
				q: out std_logic);
	end component;

	signal pwr: std_logic := '1';
	signal tmp: std_logic_vector(3 downto 0) := "0000";
	
begin
	Bit0: tff_cp port map(t=>pwr, prn=>pwr, q=>tmp(0), clk=>clk,	 clrn=> ((tmp(1) and tmp(3)) xor clr));
	Bit1: tff_cp port map(t=>pwr, prn=>pwr, q=>tmp(1), clk=>not tmp(0), clrn=> ((tmp(1) and tmp(3)) xor clr));
	Bit2: tff_cp port map(t=>pwr, prn=>pwr, q=>tmp(2), clk=>not tmp(1), clrn=> ((tmp(1) and tmp(3)) xor clr));
	Bit3: tff_cp port map(t=>pwr, prn=>pwr, q=>tmp(3), clk=>not tmp(2), clrn=> ((tmp(1) and tmp(3)) xor clr));
	cout <= tmp(1) and tmp(3);
	q<=tmp;
	
end structure;
