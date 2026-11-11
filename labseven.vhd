-------------------------------------------------------------------------------
-- nate ralston
-- lab7 top
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity labseven is
  port (
    clk_50_mhz   : in  std_logic;
    reset        : in  std_logic;
    pb           : in  std_logic;
    state_out    : out std_logic_vector(3 downto 0);
    hex0_out     : out std_logic_vector(6 downto 0);
    hex1_out     : out std_logic_vector(6 downto 0); 
	hex2_out     : out std_logic_vector(6 downto 0)
  );  
end labseven;  

architecture arch of labseven is

component top is 
 port (
    clk_50_mhz   : in  std_logic;
    reset        : in  std_logic;
    pb           : in  std_logic;
    math_op      : in  std_logic_vector(1 downto 0);
    sw           : in  std_logic_vector(7 downto 0);
    state_out    : out std_logic_vector(3 downto 0);
    hex0_out     : out std_logic_vector(6 downto 0);
    hex1_out     : out std_logic_vector(6 downto 0); 
	hex2_out     : out std_logic_vector(6 downto 0)
  );
end component;

component rising_edge_synchronizer is 
  port (
    clk               : in std_logic;
    reset             : in std_logic;
    input             : in std_logic;
    edge              : out std_logic
  );
  
end component;
  	
  constant bins    : integer := 5;
  constant bitsPer : integer := 10;
  
 
 
  type mem is array (0 to bins-1) of std_logic_vector(bitsPer-1 downto 0);
   
  signal memory   : mem;
  --alias the mem into input and math op
 
  signal exe : std_logic;
  signal pb_s : std_logic;
  signal reset_s : std_logic;
  signal start : std_logic := '0';
  signal flag : std_logic := '1';
  signal flagChange : std_logic := '0';
  signal i : std_logic_vector(bins-1 downto 0) := (others => '0');
  signal zero : std_logic_vector(bins-1 downto 0) := (others => '0');
  signal sum_temp   : std_logic_vector(bins downto 0);
  
  signal mem_curr : std_logic_vector(bitsPer-1 downto 0);
  
  alias opcode    : std_logic_vector(1 downto 0) is mem_curr(9 downto 8);
  alias sw_input  : std_logic_vector(7 downto 0) is mem_curr(7 downto 0); 
  

begin	

lab6_uut: top
    port map(
      clk_50_mhz   => clk_50_mhz,
      reset        => reset,
      pb           => exe,
      math_op      => opcode,
      sw           => sw_input,
      state_out    => state_out,
      hex0_out     => hex0_out,
      hex1_out     => hex1_out,
	  hex2_out     => hex2_out
    );

redge_inst_pb_add: rising_edge_synchronizer
    port map(
      reset  => '0',
      clk    => clk_50_mhz,
      input  => pb,
	  edge   => pb_s
    );
	  
redge_inst_reset: rising_edge_synchronizer
    port map(
      reset  => '0',
      clk    => clk_50_mhz,
      input  => reset,
	  edge   => reset_s
    );	
	  
  mem_init: process(start)
  begin
  if (flag = '1') then
	for k in 0 to bins-1 loop
		memory(k) <= "0000000001";
	end loop;
	flag <= '0';
   end if;
 end process; 
  
--  memory(0) <= "0000000001";
--  memory(1) <= "0000000001";
--  memory(2) <= "0000000001";
--  memory(3) <= "0000000001";
--  memory(4) <= "0000000001";
  
  -- process to make sure delay doesnt affect results
  mem_change_detect: process(clk_50_mhz, reset_s)
  begin
    if (reset_s = '1') then 
      exe <= '1';
    elsif (clk_50_mhz'event and clk_50_mhz = '1') then
	  if (flagChange = '1') then
	    exe <= '0';
	  else
	    exe <= '1';
	  end if;
    end if;
  end process;

  main_adder: process(clk_50_mhz, reset_s)
  begin
    if (reset_s = '1') then 
	  mem_curr <= memory(0);
    elsif (clk_50_mhz'event and clk_50_mhz = '1') then
	--start <= '1';
      -- set up so update address on button press
	  if (pb_s = '1') then
		mem_curr <= memory(to_integer(unsigned(i)));
		sum_temp <= std_logic_vector(unsigned('0' & i) + unsigned(zero & '1'));
		i <= sum_temp(bins-1 downto 0);
		flagChange <= '1';
	  end if;
	  if (exe = '0') then
		flagChange <= '0';
	  end if;
    end if;
  end process;   
end arch;