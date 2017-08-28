library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


ENTITY karatsuba_pol IS
    GENERIC (M: integer:= 9);
PORT (
    clk: in STD_LOGIC;
    a: in std_logic_vector(M-1 downto 0);
    b: in std_logic_vector(M-1 downto 0);
    get: in STD_LOGIC_VECTOR(31 DOWNTO 0);
    d: out std_logic_vector(2*M-2 downto 0);
);
END karatsuba_pol;


ARCHITECTURE simple OF karatsuba_pol IS

  component mul;
  is generic (M: integer:9);
  port(
     clk: in STD_LOGIC;
     a: in std_logic_vector(M-1 downto 0);
     b: in std_logic_vector(M-1 downto 0);
     get: in STD_LOGIC_VECTOR(31 DOWNTO 0);
     d: out std_logic_vector(2*M-2 downto 0);
 
  );
  end component mul;
  
  constant half_M :integer := (M+1)/2;
  constant half_M_odd :integer := M/2;
  signal x0y0, x01y01: std_logic_vector(2*half_M-2 downto 0);
  signal x1y1: std_logic_vector(2*half_M_odd-2 downto 0);
  signal x0_p_X1, y0_p_y1: std_logic_vector(half_M-1 downto 0);
  signal aa, bb: std_logic_vector(2*half_M-1 downto 0);
  signal dd: std_logic_vector(2*M-2 downto 0);  


begin

  mult1: mul generic map(M => half_M)
            port map(clk => clk, a => aa(half_M-1 downto 0), b => bb(half_M-1 downto 0), get => get , d=> x0y0 );

  mult2: mul generic map(M => half_M_odd)
            port map(clk => clk, a => aa(M-1 downto half_M), b => bb(M-1 downto half_M),get=>get, d=> x1y1);

  mult3: mul generic map(M => half_M) 
                            port map(clk => clk, a => x0_p_X1, b => y0_p_y1, get => get, d=> x01y01);

  gen_x0x1y0y1: for i in 0 to half_M-1 generate
       x0_p_X1(i) <= aa(i) xor aa(i + half_M);
       y0_p_y1(i) <= bb(i) xor bb(i + half_M);       
  end generate;
  
  gen_prod1: for i in 0 to half_M-2 generate
    dd(half_M + i) <= x01y01(i) xor x0y0(i) xor x1y1(i) xor x0y0(i+half_M);
  end generate;
  
  dd(2*half_M-1) <= x01y01(half_M-1) xor x0y0(half_M-1) xor x1y1(half_M-1);
  gen_prod2: for i in half_M to 2*half_M_odd-2 generate
    dd(half_M + i) <= x01y01(i) xor x0y0(i) xor x1y1(i) xor x1y1(i-half_M) ;
  end generate;
  ifModd1: if M mod 2 = 1 generate
      dd(3*half_M-3) <= x01y01(2*half_M-3) xor x0y0(2*half_M-3) xor x1y1(half_M-3) ;
      dd(3*half_M-2) <= x01y01(2*half_M-2) xor x0y0(2*half_M-2) xor x1y1(half_M-2) ;
  end generate;  
  dd(3*half_M-1) <= x1y1(half_M-1);
  
  dd(half_M-1 downto 0) <= x0y0(half_M-1 downto 0);
  dd(2*M-2 downto 3*half_M) <= x1y1(2*half_M_odd-2 downto half_M);    

  ifModd: if M mod 2 = 1 generate
  aa <= '0' & a; bb <= '0' & b; d <= dd;
  end generate;
  ifMeven: if M mod 2 = 0 generate
  aa <= a; bb <= b; d <= dd;
  end generate;
end simple;
