entity bsr is 
	generic(n: positive);
	port(shift_in: in std_logic;
		clk, left_right: in std_logic;
		q: out std_logic_vector(n-1 downto 0));
endbsr;

architecture dataflow of bsr is
	component bsr_unit is
	port(bsr_clk, left_right: in std_logic; 
	     right_in, left_in: in std_logic;
	     bsr_q: out std_logic);
	end component;
	
	signal direction => std_logic := left_right;

begin
	zbit: bsr_unit port map( right_in=>q(1), left_in=> shift_in, bsr_q=>q(0), left_right=>direction, bsr_clk=>clk);
	reg: for i is 1 to n-2 generate
		rbit: bsr_unit port map( right_in=>q(i+1), left_in=> q(i-1), bsr_q=>q(i), left_right=>direction, bsr_clk=>clk);
	end generate;
	nbit: bsr_unit port map( right_in=>shift_in, left_in=> q(n-2), bsr_q=>q(n-1), left_right=>direction, bsr_clk=>clk);
end dataflow;
