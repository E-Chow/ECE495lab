library ieee;
use ieee. std_logic_1164.all;
use ieee. std_logic_arith.all;
use ieee. std_logic_unsigned.all;
 
entity d_ff is
port( d,clk: in std_logic;
     q: out std_logic);
end d_ff;
 
architecture behavioral of d_ff is
begin
 
process(d,clk)
begin 
     if rising_edge(clk) then
          q <= d;
     end if;
end process;
      
end behavioral;
