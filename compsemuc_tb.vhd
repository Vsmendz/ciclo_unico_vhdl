library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity compsemuc_tb is
end compsemuc_tb;

architecture sim of compsemuc_tb is

-- Importando o componente
component compsemuc is
  port(
    clk, reset, jump, branch, mem_to_reg, alu_src, reg_dst, reg_write, mem_write: in std_logic;
    alu_control: out std_logic_vector(2 downto 0)
  );
end component;

-- sinais para interagir com o componente
signal clk, reset, jump, branch, mem_to_reg, alu_src, reg_dst, reg_write, mem_write: std_logic;
signal alu_control : std_logic_vector(2 downto 0);

begin
  -- instanciando o UUT
  uut : compsemuc port map(
    clk => clk, reset => reset, jump => jump, branch => branch, mem_to_reg => mem_to_reg,
    alu_src => alu_src, reg_dst => reg_dst, reg_write => reg_write, mem_write => mem_write,
    alu_control => alu_control
  );

  -- Clock process
  process
  begin
      clk <= '0';
      wait for 10ns;
      clk <= '1';
      wait for 10ns;
  end process;

  -- Stimulus process
  process
  begin
    reset <= '1';
    wait for 20ns;
    reset <= '0';

    -- 0x00: addi v0, zero, 5
    reg_dst <= '0';
    alu_src <= '1';
    mem_to_reg <= '0';
    reg_write <= '1';
    mem_write <= '0';
    branch <= '0';
    jump <= '0';
    alu_control <= "010";
    wait for 20ns;

    -- 0x04: addi v1, zero, 12
    reg_dst <= '0';
    alu_src <= '1';
    mem_to_reg <= '0';
    reg_write <= '1';
    mem_write <= '0';
    branch <= '0';
    jump <= '0';
    alu_control <= "010";
    wait for 20ns;

    -- 0x08: addi a3, v1, -9
    reg_dst <= '0';
    alu_src <= '1';
    mem_to_reg <= '0';
    reg_write <= '1';
    mem_write <= '0';
    branch <= '0';
    jump <= '0';
    alu_control <= "010";
    wait for 20ns;

    -- 0x0C: or a0, a3, v0
    reg_dst <= '1';
    alu_src <= '0';
    mem_to_reg <= '0';
    reg_write <= '1';
    mem_write <= '0';
    branch <= '0';
    jump <= '0';
    alu_control <= "001";
    wait for 20ns;

    -- 0x10: and v1, a0, a1
    reg_dst <= '1';
    alu_src <= '0';
    mem_to_reg <= '0';
    reg_write <= '1';
    mem_write <= '0';
    branch <= '0';
    jump <= '0';
    alu_control <= "000";
    wait for 20ns;
	 
    -- 0x14: add a1, a1, a0
    reg_dst <= '1';
    alu_src <= '0';
    mem_to_reg <= '0';
    reg_write <= '1';
    mem_write <= '0';
    branch <= '0';
    jump <= '0';
    alu_control <= "010";
    wait for 20ns;


    -- 0x18: beq a1, a3, 10
    reg_dst <= '0';
    alu_src <= '0';
    mem_to_reg <= '0';
    reg_write <= '0';
    mem_write <= '0';
    branch <= '1';
    jump <= '0';
    alu_control <= "010";
    wait for 20ns;

    -- 0x1C: slt a0, v1, a0
    reg_dst <= '1';
    alu_src <= '0';
    mem_to_reg <= '0';
    reg_write <= '1';
    mem_write <= '0';
    branch <= '0';
    jump <= '0';
    alu_control <= "111";
    wait for 20ns;

    -- 0x20: beq a0, zero, 1
    reg_dst <= '0';
    alu_src <= '0';
    mem_to_reg <= '0';
    reg_write <= '0';
    mem_write <= '0';
    branch <= '1';
    jump <= '0';
    alu_control <= "110";
    wait for 20ns;

    -- 0x24: addi a1, zero, 0
    reg_dst <= '0';
    alu_src <= '1';
    mem_to_reg <= '0';
    reg_write <= '1';
    mem_write <= '0';
    branch <= '0';
    jump <= '0';
    alu_control <= "010";
    wait for 20ns;

    -- 0x28: slt v0, a3, a0
    reg_dst <= '1';
    alu_src <= '0';
    mem_to_reg <= '0';
    reg_write <= '1';
    mem_write <= '0';
    branch <= '0';
    jump <= '0';
    alu_control <= "111";
    wait for 20ns;

    -- 0x2C: add a1, a0, a3
    reg_dst <= '1';
    alu_src <= '0';
    mem_to_reg <= '0';
    reg_write <= '1';
    mem_write <= '0';
    branch <= '0';
    jump <= '0';
    alu_control <= "010";
    wait for 20ns;

    -- 0x30: sub a3, a3, v0
    reg_dst <= '1';
    alu_src <= '0';
    mem_to_reg <= '0';
    reg_write <= '1';
    mem_write <= '0';
    branch <= '0';
    jump <= '0';
    alu_control <= "111";
    wait for 20ns;

    -- 0x34: sw a3, 68(v1)
    reg_dst <= '0';
    alu_src <= '1';
    mem_to_reg <= '0';
    reg_write <= '0';
    mem_write <= '1';
    branch <= '0';
    jump <= '0';
    alu_control <= "010";
    wait for 20ns;

    -- 0x38: lw v0, 80(zero)
    reg_dst <= '0';
    alu_src <= '1';
    mem_to_reg <= '1';
    reg_write <= '1';
    mem_write <= '0';
    branch <= '0';
    jump <= '0';
    alu_control <= "010";
    wait for 20ns;

    -- 0x3C: j +17
    reg_dst <= '0';
    alu_src <= '0';
    mem_to_reg <= '0';
    reg_write <= '0';
    mem_write <= '0';
    branch <= '0';
    jump <= '1';
    alu_control <= "010";
    wait for 20ns;

    -- 0x40: addi v1, zero, 1
    reg_dst <= '0';
    alu_src <= '1';
    mem_to_reg <= '0';
    reg_write <= '1';
    mem_write <= '0';
    branch <= '0';
    jump <= '0';
    alu_control <= "010";
    wait for 20ns;

    -- 0x44: sw v1, 64(zero)
    reg_dst <= '0';
    alu_src <= '1';
    mem_to_reg <= '0';
    reg_write <= '0';
    mem_write <= '1';
    branch <= '0';
    jump <= '0';
    alu_control <= "010";
    wait;

  end process;

end sim;
