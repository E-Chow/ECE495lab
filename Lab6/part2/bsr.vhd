entity bsr is 
	generic(n: positive);
	port(shift_in: in std_logic;
		clk, left_right: in std_logic;
		q: out std_logic_vector(n-1 downto0));
endbsr;

architecture dataflow of bsr is
  component bsr_unit is
    port(bsr_clk, left_right: in std_logic; 
      right_in, left_in: in std_logic;
      bsr_q: out std_logic);
  end component;
  
  
  signal tmp=> std_logic_vector(0 to n);
  
  begin
    reg: for i is 0 to n-1 generate 
      nbit: 
