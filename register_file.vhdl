library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
	port(
		-- Master clock
		clk   : in  std_logic;
		rst: in std_logic;
		-- First read
		outA  : out std_logic_vector(15 downto 0);
		selA  : in  std_logic_vector(2 downto 0);
		-- Second read
		outB  : out std_logic_vector(15 downto 0);
		selB  : in  std_logic_vector(2 downto 0);
		-- Write
		write : in  std_logic_vector(15 downto 0);
		wSel  : in  std_logic_vector(2 downto 0);
		wEN   : in  std_logic;
		-- R7 as PC control i/ps and o/ps
		PCin  : in  std_logic_vector(15 downto 0);
		PCout : out std_logic_vector(15 downto 0);
		wPC   : in  std_logic;

		R0	  : out std_logic_vector(15 downto 0);
		R1	  : out std_logic_vector(15 downto 0);
		R2	  : out std_logic_vector(15 downto 0);
		R3	  : out std_logic_vector(15 downto 0);
		R4	  : out std_logic_vector(15 downto 0);
		R5	  : out std_logic_vector(15 downto 0);
		R6	  : out std_logic_vector(15 downto 0)
	);
end register_file;

architecture behav of register_file is
	type registerArray is array (0 to 7) of std_logic_vector(15 downto 0);
	signal registers : registerArray;
begin
	-- Read
	outA  <= registers(to_integer(unsigned(selA)));
	outB  <= registers(to_integer(unsigned(selB)));
	PCout <= registers(7);
	R0	<= registers(0);
	R1	<= registers(1);
	R2	<= registers(2);
	R3	<= registers(3);
	R4	<= registers(4);
	R5	<= registers(5);
	R6	<= registers(6);
	regs : process(clk,rst) is
	begin
		if rst='1' then
		forg:	for i in 0 to 7 loop
				registers(i) <= (others => '0');
			end loop;
		elsif rising_edge(clk) then
			-- Write in R7 from PCin even if wSel selects R7 as write
			if wPC = '1' and wSel = "111" and wEN = '1' then
				registers(7) <= PCin;
			-- If its not the case, then write to both separately
			elsif wEN = '1' or wPC = '1' then
				if wEN = '1' then
					registers(to_integer(unsigned(wSel))) <= write;

				end if;
				if wPC = '1' then
					registers(7) <= PCin;
				end if;
			end if;
		end if;
	end process;
end behav;
