library ieee;
use ieee.std_logic_1164.all;

entity p_adder is
	generic (n: positive := 2);					--2 bit carry adder by default
	port (a, b: in std_logic_vector(n-1 downto 0);
	      c_in: in std_logic;
			sum: out std_logic_vector(n-1 downto 0);
			c_out: out std_logic);
end p_adder;

architecture dataflow of p_adder is
	component full_adder is
		port (a, b, c_in: in std_logic;
				sum, c_out: out std_logic);
	end component;

	signal c: std_logic_vector(0 to n);			--Signal to store all carry values, input and output
		
begin
		c(0) <= c_in;									--Store first c_in value to beginning of carry signal vector
	adder: for i in 0 to n-1 generate			--Generate n adders
		dbit: full_adder port map (a=>a(i), b=>b(i), c_in=>c(i),
											sum=>sum(i), c_out=>c(i+1));
	end generate;
		c_out <= c(n);									--Store final carry signal vector value to p_adder c_out bit
end dataflow;
