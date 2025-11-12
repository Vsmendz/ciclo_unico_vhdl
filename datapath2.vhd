library IEEE; 
use IEEE.STD_LOGIC_1164.all;  
use IEEE.NUMERIC_std.all; 

-- entidade do datapath
entity datapath is 
	port(instr,data : in std_logic_vector(31 downto 0); -- entradas da memoria
		  pc_out,alu_out,wr_data : out std_logic_vector (31 downto 0); -- saidas para as memorias
		  clk, reset,reg_dst,reg_write,alu_src,men_to_reg,jump,pc_src : in std_logic; -- sinais de controle
		  alu_control : in std_logic_vector(2 downto 0) := "000";
		  zero : out std_logic);
end;

architecture synth of datapath is

component pc is -- registrador pc
  port(clk, reset: in  STD_LOGIC;
       d:          in  STD_LOGIC_VECTOR(31 downto 0);
       q:          out STD_LOGIC_VECTOR(31 downto 0));
end component;

component regfile is -- banco de registradores
  port(clk:          in  STD_LOGIC;
       we:           in  STD_LOGIC;
       ra1, ra2, wa: in  STD_LOGIC_VECTOR(4 downto 0);   -- enderecos de leitura e gravação
       wd:           in  STD_LOGIC_VECTOR(31 downto 0);  -- conteudo a ser gravado
       rd1, rd2:     out STD_LOGIC_VECTOR(31 downto 0)); -- portas de leitura
end component;

component mux2 is -- mux
  port(d0, d1: in  STD_LOGIC_VECTOR(31 downto 0);
       s:      in  STD_LOGIC;
       y:      out STD_LOGIC_VECTOR(31 downto 0));
end component;

component signext is -- extensor de bit
  port(a: in  STD_LOGIC_VECTOR(15 downto 0);
       y: out STD_LOGIC_VECTOR(31 downto 0));
end component;

component rcadder is -- somador
  port(a, b: in  STD_LOGIC_VECTOR(31 downto 0);
       y:    out STD_LOGIC_VECTOR(31 downto 0));
end component rcadder;

component ula is -- ula
  port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0);
       alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
       result:     buffer STD_LOGIC_VECTOR(31 downto 0);
       zero:       out STD_LOGIC);
end component;

component sl2 is
  port(a: in  STD_LOGIC_VECTOR(31 downto 0);
       y: out STD_LOGIC_VECTOR(31 downto 0));
end component;

component mux5 is 
  port(d0, d1: in  STD_LOGIC_VECTOR(4 downto 0);
       s:      in  STD_LOGIC;
       y:      out STD_LOGIC_VECTOR(4 downto 0));
end component;


signal src_a,src_b,result_ula,imm_extend,result_wd3,pc_in,pc_in2,pc_jump_sl2: std_logic_vector(31 downto 0);
signal mux_ula_srcb,pc_out_sig,result_pcplus4,imm_sl2,result_pcbranch,result_jump_sl2,final_pcjump: std_logic_vector(31 downto 0);
signal wa_instr : std_logic_vector(4 downto 0);

begin

	ula_main : ula port map(a => src_a,b => mux_ula_srcb,alucontrol => alu_control,result => result_ula,zero => zero);
	
	sign_extend : signext port map(a => instr(15 downto 0),y => imm_extend);
	
	mux_srcb : mux2 port map(s => alu_src,d0 => src_b,d1 => imm_extend,y => mux_ula_srcb);
	
	alu_out <= result_ula;
	
	mux_result : mux2 port map(d0 => result_ula,d1 => data,s => men_to_reg,y => result_wd3);
	
	mux_wa : mux5 port map(d0 => instr(20 downto 16), d1 => instr(15 downto 11),s => reg_dst, y => wa_instr);
	
	banco_reg : regfile port map(clk => clk,we => reg_write,ra1 => instr(25 downto 21),ra2 => instr(20 downto 16),
	wa => wa_instr,wd => result_wd3,rd1 => src_a,rd2 => src_b);

	reg_pc : pc port map(reset => reset, d => pc_in2,q => pc_out_sig,clk => clk);
	pc_out <= pc_out_sig;
	
	pcplus4 : rcadder port map(a => x"00000004",b => pc_out_sig,y => result_pcplus4);
	imm_shift : sl2 port map(a => imm_extend,y => imm_sl2);
	
	pcbranch : rcadder port map(a => result_pcplus4, b => imm_sl2,y => result_pcbranch);
	
	pc_jump_sl2 <= ("111111" & instr(25 downto 0)) when instr(25) = '1' else ("000000" & instr(25 downto 0));
	pc_jump : sl2 port map(a => pc_jump_sl2,y => result_jump_sl2);	
	
	final_pcjump <= (result_pcplus4(31 downto 28) & result_jump_sl2(27 downto 0)); 
	
	mux_pc_1 : mux2 port map(d0 => result_pcplus4,d1 => result_pcbranch,s => pc_src,y => pc_in);
	mux_px_2 : mux2 port map(d0 => pc_in,d1 => final_pcjump,s => jump,y => pc_in2);
	
end;

