----------------------------------------------------------------------------
-- Polynomial Multiplier (Poly_multiplier.vhd)
--
-- Computes the polynomial multiplication 
-- 
----------------------------------------------------------------------------

------------------------------------------------------------
-- polynom_multiplier
------------------------------------------------------------
library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity polynom_multiplier is
generic (M: integer:= 163);
port (
  CLK: IN STD_LOGIC;
  a, b: in std_logic_vector(M-1 downto 0);
  d: out std_logic_vector(2*M-2 downto 0)
);
end polynom_multiplier;


architecture simple of polynom_multiplier is
  type matrix_ands is array (0 to 2*M-2) of STD_LOGIC_VECTOR(2*M-2 downto 0);
  signal a_by_b: matrix_ands;
  signal c: std_logic_vector(2*M-2 downto 0);
begin

process(CLK)
variable aux : std_logic;
begin
if clk'event and clk = '1' then
  gen_ands: for k in 0 to M-1 loop
    l1: for i in 0 to k loop
       a_by_b(k)(i) <= A(i) and B(k-i);
    end loop;
  end loop;

  gen_ands2: for k in M to 2*M-2 loop
    l2: for i in k to 2*M-2 loop
       a_by_b(k)(i) <= A(k-i+(M-1)) and B(i-(M-1));
    end loop;
  end loop;

  d(0) <= a_by_b(0)(0);
  gen_xors: for k in 1 to 2*M-2 loop
    --l3: process(a_by_b(k),c(k)) 
        --variable aux: std_logic;
        --begin
        if (k < M) then
          aux := a_by_b(k)(0);
          for i in 1 to k loop aux := a_by_b(k)(i) xor aux; end loop;
        else
          aux := a_by_b(k)(k);
          for i in k+1 to 2*M-2 loop aux := a_by_b(k)(i) xor aux; end loop;
        end if;
        d(k) <= aux;
    --end process;
  end loop;


  
  --OREGISTER : PROCESS(CLK)
    --  BEGIN
      --    IF RISING_EDGE(CLK) THEN
        --      if(get(0) == 1) THEN
          --      d0 <= d(31 DOWNTO 0);
           --   ELSE IF (get(1) == 1) THEN
            --    d0 <= d(63 DOWNTO 32);
             -- end if;
          --END IF;
      --END PROCESS;
 end if;
end process;
end simple;