library ieee;
use ieee.std_logic_1164.all;

entity p_adder4 is
	port (a, b: in std_logic_vector(3 downto 0);
			c_in: in std_logic;
			sumSeg, c_outSeg: out std_logic_vector(0 to 6));
end p_adder4;

architecture dataflow of p_adder4 is
	component p_adder is
		generic (n : positive);
		port (a, b: in std_logic_vector(n-1 downto 0);
				c_in: in std_logic;
				sum: out std_logic_vector(n-1 downto 0);
				c_out: out std_logic);
	end component;
	
	signal s: std_logic_vector(0 to 3);
	signal c: std_logic;

begin

	adder4: p_adder generic map (n => 4)
						 port map (a => a, b => b, c_in => c_in,
									  sum => s, c_out => c);
									  
	SegProcess: process (c, s)
	begin							  
	
			case c is
				when '0' => c_outSeg <= "0000001";
				when '1' => c_outSeg <= "1001111";
				when others => c_outSeg <= "1111111";
			end case;

			case s is
				when "0000" => sumSeg <= "0000001"; ---0
				when "0001" => sumSeg <= "1001111"; ---1
				when "0010" => sumSeg <= "0010010"; ---2
				when "0011" => sumSeg <= "0000110"; ---3
				when "0100" => sumSeg <= "1001100"; ---4
				when "0101" => sumSeg <= "0100100"; ---5
				when "0110" => sumSeg <= "0100000"; ---6
				when "0111" => sumSeg <= "0001111"; ---7
				when "1000" => sumSeg <= "0000000"; ---8
				when "1001" => sumSeg <= "0000100"; ---9
				when "1010" => sumSeg <= "0001000"; ---A
				when "1011" => sumSeg <= "1100000"; ---B
				when "1100" => sumSeg <= "0110001"; ---C
				when "1101" => sumSeg <= "1000010"; ---D
				when "1110" => sumSeg <= "0110000"; ---E
				when "1111" => sumSeg <= "0111000"; ---F
				when others => sumSeg <= "1111111"; ---null
			end case;
		end process SegProcess;
end dataflow;
