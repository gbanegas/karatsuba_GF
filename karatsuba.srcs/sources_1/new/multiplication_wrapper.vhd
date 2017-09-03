----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/28/2017 11:10:42 AM
-- Design Name: 
-- Module Name: MultiWraper - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MultiWraper is
--  Port ( );
generic (M: INTEGER:= 163);
PORT ( CLK: IN STD_LOGIC;
       RSTN : IN STD_LOGIC;
       SET : IN STD_LOGIC;
       GET : IN STD_LOGIC;
       SEL : IN STD_LOGIC_VECTOR(31 DOWNTO 0);  
       IN0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
       IN1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
       OUT0: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
      );

end MultiWraper;

ARCHITECTURE Behavioral OF MultiWraper IS

COMPONENT karatsuba_multiplier
generic (M: integer:= 163);
port (
    CLK: IN STD_LOGIC;
    a, b: in std_logic_vector(M-1 downto 0);
  d: out std_logic_vector(2*M-2 downto 0)
);
end component;

COMPONENT reduction
generic (M: INTEGER:= 163;
         BL: INTEGER:= 63;
         CL: INTEGER:= 37);
port(
   CLK: IN STD_LOGIC;
   RSTN : IN STD_LOGIC; 
   IN0 : IN STD_LOGIC_VECTOR(2*M-2 DOWNTO 0);
   OUTPUT: OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0)
);
end component;


SIGNAL A, B	: STD_LOGIC_VECTOR (M-1 DOWNTO 0);
SIGNAL RESULT: STD_LOGIC_VECTOR (2*M-2 DOWNTO 0);
SIGNAL RESULT_REG: STD_LOGIC_VECTOR (M-1 DOWNTO 0);

BEGIN

    MULT: karatsuba_multiplier 
    GENERIC MAP ( M => M)
    PORT MAP(
        CLK => CLK,
        a => A,
        b => B,
        d => RESULT
    );
    
    RED: reduction GENERIC MAP ( M => M, BL => 63, CL => 37)
         PORT MAP(
            CLK => CLK,
            RSTN => RSTN,   
            IN0 => RESULT,
            OUTPUT => RESULT_REG
    );     
    
    IREGISTERS : PROCESS(CLK)
        BEGIN
            IF RISING_EDGE(CLK) THEN
                 if(SET = '1') THEN
                case SEL is
                  when "001" =>   
                   A(31 DOWNTO 0)            <= IN0; 
                   B(31 DOWNTO 0)            <= IN1; 
                  when "010" =>   
                  A(63 DOWNTO 32)            <= IN0; 
                  B(63 DOWNTO 32)            <= IN1; 
                  when "011" =>   
                  A(95 DOWNTO 64)            <= IN0; 
                  B(95 DOWNTO 64)            <= IN1; 
                  when "100" =>   
                  A(127 DOWNTO 96)            <= IN0;
                  B(127 DOWNTO 96)            <= IN1;
                  when "101" =>   
                  A(159 DOWNTO 128)            <= IN0;
                  B(159 DOWNTO 128)            <= IN1;
                  when "111" =>   
                  A(162 DOWNTO 160)            <=  IN0(2 DOWNTO 0);
                  B(162 DOWNTO 160)            <= IN1(2 DOWNTO 0);
                  when others => 
                  A            <= A;
                  B            <= B;
                end case;
                end if;
            END IF;
        END PROCESS;
        
        
           
        
        OREGISTER : PROCESS(CLK)
         BEGIN
                   IF RISING_EDGE(CLK) THEN
                        if(GET = '1') THEN
                       case SEL is
                         when "001" =>   
                          OUT0            <= RESULT_REG(31 DOWNTO 0); --& A(6 DOWNTO 32);Z <= A;
                         when "010" =>   
                         OUT0          <= RESULT_REG(63 DOWNTO 32); --& A(6 DOWNTO 32);Z <= A;
                         when "011" =>   
                         OUT0           <= RESULT_REG(95 DOWNTO 64); --& A(6 DOWNTO 32);Z <= A;
                         when "100" =>   
                         OUT0            <= RESULT_REG(127 DOWNTO 96)   ; --& A(6 DOWNTO 32);Z <= A;
                         when "101" =>   
                         OUT0            <= RESULT_REG(159 DOWNTO 128); --& A(6 DOWNTO 32);Z <= A;
                         when "111" =>   
                         OUT0            <= "00000000000000000000000000000" & RESULT_REG(162 DOWNTO 160); --& A(6 DOWNTO 32);Z <= A;
                         when others => 
                         OUT0            <= (OTHERS => '0');
                       end case;
                       end if;
                   END IF;
               END PROCESS;
    
     

END Behavioral;
