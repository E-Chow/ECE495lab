library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2to1 is
    Port ( SEL, A, B : in  STD_LOGIC;
           X   : out STD_LOGIC);
end mux_2to1;

architecture Behavioral of mux_2to1 is
begin
    X <= A when (SEL = '1') else B;
end Behavioral;
