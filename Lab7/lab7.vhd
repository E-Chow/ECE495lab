library ieee;
use ieee.std_logic_1164.all;
library lpm;
use lpm.lpm_components.all;

entity lab7 is
	port (clk, clear: in std_logic;
			useqEnOut: out std_logic;
			ctrlSignals: out std_logic_vector(0 to 7));
end lab7;

architecture structure of lab7 is

	component exp7_useq is
		generic (uROM_width: integer;
					uROM_file: string);
		port (opcode: in std_logic_vector(3 downto 0);
				uop: out std_logic_vector(1 to (uROM_width-9));
				enable, clear: in std_logic;
				clock: in std_logic);
	end component;
					
	signal useqEnable, useqClear: std_logic;
	signal uop: std_logic_vector(0 to 7);
	
begin
	delay: lpm_counter generic map(lpm_width=>2)
							 port map(clock=>clk, cout=>useqEnable);
	useqClear <= clear;
	useqEnOut <= useqEnable;
	labelG: for i in 0 to 7 generate
		ctrlSignals(i) <= uop(i) and useqEnable;
	end generate;
	
	useq: exp7_useq generic map (uROM_width=>17, uROM_file=>"uROM_file.mif")
							 port map (uop=>uop,enable=>useqEnable,
										  clear=>useqClear, clock=>clk,opcode=>"0011");
	
end structure;
