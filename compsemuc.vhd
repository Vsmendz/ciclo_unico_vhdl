library IEEE; 
use IEEE.STD_LOGIC_1164.all;

entity compsemuc is
  port(clk,reset,jump,branch,men_to_reg,alu_src,reg_dst,reg_write,men_write: in  STD_LOGIC;
		 alu_control : in std_logic_vector(2 downto 0));
end;

architecture synth of compsemuc is

component datapath is 
	port(instr,data : in std_logic_vector(31 downto 0); -- entradas da memoria
		  pc_out,alu_out,wr_data : out std_logic_vector (31 downto 0); -- saidas para as memorias
		  clk, reset,reg_dst,reg_write,alu_src,men_to_reg,jump,pc_src : in std_logic; -- sinais de controle
		  alu_control : in std_logic_vector(2 downto 0);
		  zero : out std_logic);
end component;

component data_mem is
  port(clk, we: in std_logic;
         a, wd: in std_logic_vector(31 downto 0);
			   rd: out std_logic_vector(31 downto 0));
end component data_mem;

component instruction_mem is
   port(a: in std_logic_vector(31 downto 0);   -- Parramento de end.
	     rd: out std_logic_vector(31 downto 0)); -- Barramento de dados
end component instruction_mem;

signal pc_src,zero : std_logic;
signal pc_out,alu_out,wr_data,instr,data: std_logic_vector(31 downto 0) := x"00000000";

begin

	pc_src <= zero and branch;
	
	datapath_main : datapath port map(clk => clk,reset => reset, reg_dst => reg_dst, reg_write => reg_write,alu_src => alu_src,men_to_reg => men_to_reg,
	jump => jump,pc_src => pc_src,alu_control => alu_control,zero => zero,pc_out => pc_out,alu_out => alu_out,wr_data => wr_data,instr => instr,data => data);

	instr_mem_main : instruction_mem port map(a => pc_out,rd => instr);
	
	data_main : data_mem port map(clk => clk,we => men_write,a => alu_out,wd => wr_data,rd => data);
	
end;