library ieee;
use ieee.std_logic_1164.all;

entity bsr_test8 is
port (shift_in: in std_logic;
      clk, left_right: in std_logic;
      q: out std_logic_vector(7 downto 0)
);
end bsr_test8;

architecture testing of bsr_test8 is 

component bsr is 
generic (n: positive:=8);
	Port(shift_in:in std_logic;
	     clk, left_right: in std_logic;
	     q: out std_logic_vector(n-1 downto 0));
end component;

begin
	bits: bsr generic map(n=>8) port map(shift_in=>shift_in, clk=>clk, left_right=>left_right, q=>q);

end testing;
