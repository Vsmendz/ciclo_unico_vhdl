library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_mem is
   port(
      a: in std_logic_vector(31 downto 0);   -- Endereço de leitura
      rd: out std_logic_vector(31 downto 0)  -- Barramento de dados
   );
end instruction_mem;

architecture synth of instruction_mem is

   type rom_type is array (0 to 63) of std_logic_vector(31 downto 0);
   signal mem: rom_type := (
	
      0  => X"20020005",  -- addi v0, zero, 5
      1  => X"2003000C",  -- addi v1, zero, 12
      2  => X"2067FFF7",  -- addi a3, v1, -9
      3  => X"00E22025",  -- or a0, a3, v0
      4  => X"00642824",  -- and v1, a0, a1
      5  => X"00A42820",  -- add a1, a1, a0
      6  => X"10A7000A",  -- beq a1, a3, 10
      7  => X"0064202A",  -- slt a0, v1, a0
      8  => X"10800001",  -- beq a0, zero, 1
      9  => X"20050000",  -- addi a1, zero, 0
      10 => X"00E2202A",  -- slt v0, a3, a0
      11 => X"00853820",  -- add a1, a0, a3
      12 => X"00E23822",  -- sub a3, a3, v0
      13 => X"AC670044",  -- sw a3, 68(v1)
      14 => X"8C020050",  -- lw v0, 80(zero)
      15 => X"08000011",  -- j +17
      16 => X"20020001",  -- addi v1, zero, 1
      17 => X"AC020054"   -- sw v1, 64(zero)
   );

begin

   -- Leitura combinacional
   rd <= mem(to_integer(unsigned(a(7 downto 2))));

end synth;
