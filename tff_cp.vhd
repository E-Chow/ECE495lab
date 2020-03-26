-- file: tff_cp.vhd
-- T flip-flop with asynchronous clear and preset
--
library ieee;
use ieee.std_logic_1164.all;

entity tff_cp is
port (t, clk, prn, clrn: in std_logic;
		q: out std_logic);
end tff_cp;

architecture behaviorial of tff_cp is
    signal tmp: std_logic := '0';
	 
begin
    process (clk, t, prn, clrn)
	 
    begin
      if (prn = '0' and clrn = '1') then 
        tmp <= '1';
      elsif (prn = '1' and clrn = '0') then
        tmp <= '0'; 
      elsif (prn = '1' and clrn = '1' and rising_edge(clk)) then
        tmp <= tmp xor t;
      else
        tmp <= tmp;
      end if;
    end process;
    q <= tmp;
	 
end behaviorial;