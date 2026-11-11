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
 	
  constant bins    : integer := 5;
  constant bitsPer : integer := 10;
 
  type mem is array (0 to bins-1) of std_logic_vector(bitsPer-1 downto 0);
   
  signal memory   : mem;
  --alias the mem into input and math op
 
  signal exe : std_logic;
 
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

  main_adder: process(clk_50_mhz, reset)
  begin
    if (reset = '1') then 
      
    elsif (clk_50_mhz'event and clk_50_mhz = '1') then
      -- set up so update address on button press
    end if;
  end process; 
  -- also need make process to make sure delay doesnt affect results
end arch;