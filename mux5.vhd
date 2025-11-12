library IEEE; 
use IEEE.STD_LOGIC_1164.all;

-- Multiplexador de duas entradas de t bits
entity mux5 is 
  port(d0, d1: in  STD_LOGIC_VECTOR(4 downto 0);
       s:      in  STD_LOGIC;
       y:      out STD_LOGIC_VECTOR(4 downto 0));
end;

architecture synth of mux5 is
begin
  y <= d1 when s = '1' else d0;
end;