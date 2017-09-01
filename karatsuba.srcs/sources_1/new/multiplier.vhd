library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity karatsuba_multiplier is
generic (M: integer:= 163);
port (
  CLK: IN STD_LOGIC;
  a, b: in std_logic_vector(M-1 downto 0);
  d: out std_logic_vector(2*M-2 downto 0)
);
end karatsuba_multiplier;


architecture behav of karatsuba_multiplier is
  component polynom_multiplier is
  generic (M: integer:= 163);
  port (
    CLK: IN STD_LOGIC;
    a, b: in std_logic_vector(M-1 downto 0);
    d: out std_logic_vector(2*M-2 downto 0)
  );
  end component polynom_multiplier;

  constant half_M :integer := (M+1)/2;
  constant half_M_odd :integer := M/2;
  signal x0y0, x01y01: std_logic_vector(2*half_M-2 downto 0);
  signal x1y1: std_logic_vector(2*half_M_odd-2 downto 0);
  signal x0_p_X1, y0_p_y1: std_logic_vector(half_M-1 downto 0);
  signal aa, bb: std_logic_vector(2*half_M-1 downto 0);
  signal dd: std_logic_vector(2*M-2 downto 0);  

begin

  mult1: polynom_multiplier generic map(M => half_M)
            port map(CLK => CLK, a => aa(half_M-1 downto 0), 
                     b => bb(half_M-1 downto 0), d=> x0y0);

  mult2: polynom_multiplier generic map(M => half_M_odd)
            port map(CLK => CLK,a => aa(M-1 downto half_M), b => bb(M-1 downto half_M), d=> x1y1);

  mult3: polynom_multiplier generic map(M => half_M)
            port map(CLK => CLK,a => x0_p_X1, b => y0_p_y1, d=> x01y01);
process(CLK)
begin
if CLK'event and CLK = '1' then
  gen_x0x1y0y1: for i in 0 to half_M-1 loop
       x0_p_X1(i) <= aa(i) xor aa(i + half_M);
       y0_p_y1(i) <= bb(i) xor bb(i + half_M);       
  end loop;
  
  gen_prod1: for i in 0 to half_M-2 loop
    dd(half_M + i) <= x01y01(i) xor x0y0(i) xor x1y1(i) xor x0y0(i+half_M);
  end loop;
  dd(2*half_M-1) <= x01y01(half_M-1) xor x0y0(half_M-1) xor x1y1(half_M-1);
  gen_prod2: for i in half_M to 2*half_M_odd-2 loop
    dd(half_M + i) <= x01y01(i) xor x0y0(i) xor x1y1(i) xor x1y1(i-half_M) ;
  end loop;
  ifModd1: if M mod 2 = 1 then
      dd(3*half_M-3) <= x01y01(2*half_M-3) xor x0y0(2*half_M-3) xor x1y1(half_M-3) ;
      dd(3*half_M-2) <= x01y01(2*half_M-2) xor x0y0(2*half_M-2) xor x1y1(half_M-2) ;
  end if;  
  dd(3*half_M-1) <= x1y1(half_M-1);
  
  dd(half_M-1 downto 0) <= x0y0(half_M-1 downto 0);
  dd(2*M-2 downto 3*half_M) <= x1y1(2*half_M_odd-2 downto half_M);    

  ifModd: if M mod 2 = 1 then
  aa <= '0' & a; bb <= '0' & b; d <= dd;
  end if;
  ifMeven: if M mod 2 = 0 then
  aa <= a; bb <= b; d <= dd;
  end if;
  end if;
end process;
end behav;