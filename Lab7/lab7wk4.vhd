library ieee;
use ieee.std_logic_1164.all;
library lpm;
use lpm.lpm_components.all;

entity lab7wk4 is
	port (clk, clear: in std_logic;
			useqEnOut: out std_logic;
			AC, Rres, DR, IR, PC, MAR, MEMo, MUXout: out std_logic_vector(7 downto 0);
			ACseg1, ACseg2, Rseg1, Rseg2, SPseg1, SPseg2: out std_logic_vector(0 to 6);
			ctrlSignals: out std_logic_vector(0 to 20));
end lab7wk4;

architecture structure of lab7wk4 is

	component exp7_useq is
		generic (uROM_width: integer;
					uROM_file: string);
		port (opcode: in std_logic_vector(3 downto 0);
				uop: out std_logic_vector(1 to (uROM_width-9));
				enable, clear: in std_logic;
				clock: in std_logic);
	end component;

	component seven_seg is
		port (valin : in STD_LOGIC_VECTOR (3 downto 0);
				Seven_Segment : out STD_LOGIC_VECTOR (0 to 6));
	end component;
	
	component exp7_alu is
		port (a, b: in std_logic_vector(7 downto 0);
      op: in std_logic_vector(0 downto 0);   
      result: out std_logic_vector(7 downto 0));
	end component;

	signal useqEnable, useqClear: std_logic;
	signal uop: std_logic_vector(0 to 20);
	signal PCout, DRin, DRout, SPin, SPout, MARin, MARout: std_logic_vector(7 downto 0);			--component ins/outs
	signal MEMout, ACin, ACout, ALU1out, ALU2out, Rout, irop: std_logic_vector(7 downto 0);		--component ins/outs
	signal Vres: std_logic;																								--component ins/outs
	signal MUX1sel: std_logic_vector(0 to 1);																		--component controls
	signal ALU1op, Zin, Zout, MUX2sel, MUX3sel, MUX4sel, MUX5sel: std_logic_vector(0 to 0);		--component controls
	signal MUX1data: std_logic_2D(2 downto 0, 7 downto 0);													--MUX data signals
	signal MUX2data, MUX3data, MUX4data: std_logic_2D(1 downto 0, 7 downto 0);							--MUX data signals
	signal MUX5data: std_logic_2D(1 downto 0, 0 downto 0);													--MUX data signals
	signal MARload, MEMwe, DRload, PCclr, PCload, PCinc, IRload: std_logic;								--component controls
	signal ACload, SPdir, SPload, SPcnt, Rload, Zload, cond, Jump: std_logic;							--component controls

begin
	delay: lpm_counter generic map (lpm_width=>2)
							 port map	 (clock=>clk, cout=>useqEnable);

	useqClear <= clear;
	useqEnOut <= useqEnable;
	labelG: for i in 0 to 20 generate
		ctrlSignals(i) <= uop(i) and useqEnable;
	end generate;
	
	ACload	<= uop(0) and useqEnable;
	ALU1op(0)	<= uop(1) and useqEnable;
	cond		<= uop(2) and useqEnable;
	DRload	<= uop(3) and useqEnable;
	IRload	<= uop(4) and useqEnable;
	MARload	<= uop(5) and useqEnable;
	MEMwe		<= uop(6) and useqEnable;
	MUX1sel(0)	<= uop(7) and useqEnable;
	MUX1sel(1)	<= uop(8) and useqEnable;
	MUX2sel(0)	<= uop(9) and useqEnable;
	MUX3sel(0)	<= uop(10) and useqEnable;
	MUX4sel(0)	<= uop(11) and useqEnable;
	MUX5sel(0)	<= (NOT irop(0)) and useqEnable;
	PCclr		<= uop(13) and useqEnable;
	PCinc		<= uop(14) and useqEnable;
	Jump	<= uop(15) and useqEnable;
	Rload		<= uop(16) and useqEnable;
	SPcnt		<= uop(17) and useqEnable;
	SPdir		<= uop(18) and useqEnable;
	SPload	<= uop(19) and useqEnable;
	Zload		<= uop(20) and useqEnable;
	
	MUX_label: for i in 0 to 7 generate
		MUX1data(0, i) <= PCout(i);
		MUX1data(1, i) <= DRout(i);
		MUX1data(2, i) <= SPout(i);
		MUX2data(0, i) <= MEMout(i);
		MUX2data(1, i) <= ACout(i);
		MUX3data(0, i) <= DRout(i);
		MUX3data(1, i) <= ALU1out(i);
		MUX4data(0, i) <= DRout(i);
		MUX4data(1, i) <= ALU2out(i);
	end generate;
	
		Vres <= ACout(0) or ACout(1) or ACout(2) or ACout(3) or ACout(4) or ACout(5) or ACout(6) or ACout(7);
		MUX5data(0, 0) <= Vres;
		MUX5data(1, 0) <= NOT Vres;
		PCload <= Jump or (Zout(0) and cond);

	useq: exp7_useq
				generic map (uROM_width=>30, uROM_file=> "uROM_file.mif")
				port map		(uop=>uop, enable=>useqEnable,
								 clear=>useqClear, clock=>clk, opcode=>irop(7 downto 4));

	MUX1: lpm_mux
				generic map (lpm_width=>8, lpm_size=>3, lpm_widths=>2)
				port map		(result=>MARin, data=> MUX1data, sel=>MUX1sel);

	MUX2: lpm_mux
				generic map	(lpm_width=>8, lpm_size=>2, lpm_widths=>1)
				port map		(result=>DRin, data=> MUX2data, sel=>MUX2sel);

	MUX3: lpm_mux
				generic map (lpm_width=>8, lpm_size=>2, lpm_widths=>1)
				port map		(result=>ACin, data=> MUX3data, sel=>MUX3sel);

	MUX4: lpm_mux
				generic map (lpm_width=>8, lpm_size=>2, lpm_widths=>1)
				port map		(result=>SPin, data=> MUX4data, sel=>MUX4sel);

	MUX5: lpm_mux
				generic map (lpm_width=>1, lpm_size=>2, lpm_widths=>1)
				port map		(result=>Zin, data=> MUX5data, sel=>MUX5sel);

	marReg: lpm_ff
				generic map (lpm_width=>8)
				port map		(clock=>clk, enable=>MARload, q=>MARout, data=>MARin);

	mem: lpm_ram_dq
				generic map (lpm_width=>8, lpm_widthad=>8, lpm_file=>"exp7_ram_11_14.mif")
				port map		(inclock=>clk, outclock=>clk, we=>MEMwe, address=>MARout, data=>DRout, q=>MEMout);

	drReg: lpm_ff
				generic map (lpm_width=>8)
				port map		(clock=>clk, enable=>DRload, q=>DRout, data=>DRin);
	
	pcReg: lpm_counter
				generic map (lpm_width=>8)
				port map		(clock=>clk, q=>PCout, cnt_en=>PCinc, sclr=>PCclr, sload=>PCload, data=>DRout);

	irReg: lpm_ff
				generic map (lpm_width=>8)
				port map		(clock=>clk, enable=>IRload, data=>DRout, q=>irop);

	ALU1: exp7_alu
				port map 	(a=>Rout, b=>ACout, op=>ALU1op, result=>ALU1out);

	ALU2: lpm_add_sub
				generic map (lpm_width=>8)
				port map 	(dataa=>DRout, datab=>SPout, result=>ALU2out);

	acReg: lpm_ff
				generic map (lpm_width=>8)
				port map		(clock=>clk, enable=>ACload, q=>ACout, data=>ACin);

	rReg: lpm_ff
				generic map (lpm_width=>8)
				port map		(clock=>clk, enable=>Rload, q=>Rout, data=>ACout);

	spReg: lpm_counter
				generic map (lpm_width=>8)
				port map 	(clock=>clk, q=> SPout, cnt_en=>SPcnt, sload=>SPload, updown=>SPdir, data=>SPin);

	zReg: lpm_ff
				generic map (lpm_width=>1)
				port map 	(clock=>clk, enable=> Zload, q=>Zout, data=>Zin);
				
	ACdisp1: seven_seg
				port map		(valin=>ACout(7 downto 4), Seven_Segment=>ACseg1);
				
	ACdisp2: seven_seg
				port map		(valin=>ACout(3 downto 0), Seven_Segment=>ACseg2);
				
	Rdisp1: seven_seg
				port map		(valin=>Rout(7 downto 4), Seven_Segment=>Rseg1);
				
	Rdisp2: seven_seg
				port map		(valin=>Rout(3 downto 0), Seven_Segment=>Rseg2);
				
	SPdisp1: seven_seg
				port map		(valin=>SPout(7 downto 4), Seven_Segment=>SPseg1);
				
	disp2: seven_seg
				port map		(valin=>SPout(3 downto 0), Seven_Segment=>SPseg2);
				
	AC <= ACout;
	DR <= DRout;
	IR <= irop;
	PC <= PCout;
	MAR <= MARout;
	MEMo <= MEMout;
	MUXout <= DRin;

end structure;
