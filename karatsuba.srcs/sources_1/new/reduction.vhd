----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/28/2017 01:15:40 PM
-- Design Name: 
-- Module Name: reduction - Behavioral
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
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reduction is
generic (
         M: integer:= 283;
         BL: INTEGER:= 108;
         CL:INTEGER:= 47
         );
  Port ( 
   CLK: IN STD_LOGIC;
   RSTN : IN STD_LOGIC;
   IN0 : IN STD_LOGIC_VECTOR(2*M-2 DOWNTO 0);
   OUTPUT: OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0)
  );
end reduction;

architecture structural of reduction is
 signal d_result: STD_LOGIC_VECTOR(M-1 downto 0);
 signal T_1: STD_LOGIC_VECTOR(M-1 downto 0);
begin

process(CLK)
begin
 if clk'event and clk = '1' then
  for i in 0 to BL-2 loop
              T_1(i) <= IN0(i+2*BL+1) xor IN0(i+3*BL+2*CL);
  end loop;
 --GENERATE_T1: for i in 0 to BL-2 generate
 --             T_1(i) <= IN0(i+2*BL+1) xor IN0(i+3*BL+2*CL);
 --            end generate;
 for i in 0 to CL-1 loop
              d_result(i) <= IN0(i) xor T_1(i);
 end loop;
 --REDUCTION_1: for i in 0 to CL-1 generate
 --             d_result(i) <= IN0(i) xor T_1(i);
  --           end generate;
 for i in CL to BL-2 loop
              d_result(i) <= IN0(i) xor T_1(i) xor IN0(i+2*BL);
 end loop;
 --REDUCTION_2: for i in CL to BL-2 generate
 --            d_result(i) <= IN0(i) xor T_1(i) xor IN0(i+2*BL);
 --            end generate;
 
 d_result(BL-1) <= IN0(BL-1) xor IN0(3*BL+CL-1) xor IN0(3*BL -1);
 for i in BL to BL+CL-2 loop
               d_result(i) <= IN0(i) xor T_1(i-BL) xor IN0(i+2*BL);
 end loop;
-- REDUCTION_3: for i in BL to BL+CL-2 generate
 --              d_result(i) <= IN0(i) xor T_1(i-BL) xor IN0(i+2*BL);
 --             end generate;
 
-- d_result(BL+CL-1) <= IN0(BL+CL-1) xor IN0(3*BL+CL-1) xor T_1(CL-1);
 for i in BL+CL to 2*BL-2 loop
              d_result(i) <= IN0(i) xor T_1(i-BL) xor T_1(i-BL-CL); 
 end loop;
 
 --REDUCTION_4: for i in BL+CL to 2*BL-2 generate
 --             d_result(i) <= IN0(i) xor T_1(i-BL) xor T_1(i-BL-CL); 
 --             end generate;
 
d_result(2*BL-1) <= IN0(2*BL-1) xor IN0(3*BL+CL-1) xor T_1(BL-CL-1);

for i in 2*BL to 2*BL+CL-2 loop
               d_result(i) <= IN0(i) xor T_1(i-BL-CL)  xor IN0(i+BL+CL);
 end loop;
 
 --REDUCTION_5: for i in 2*BL to 2*BL+CL-2 generate
 --              d_result(i) <= IN0(i) xor T_1(i-BL-CL)  xor IN0(i+BL+CL);
 --             end generate;
 
 d_result(2*BL+CL-1) <= IN0(2*BL+CL-1) xor IN0(3*BL+CL-1) xor IN0(3*BL-1);
 
 for i in 0 to CL-1 loop
                d_result(i) <= d_result(i) xor IN0(i+3*BL+CL);
 end loop;
 
 --REDUCTION_6: for i in 0 to CL-1 generate
 --              d_result(i) <= d_result(i) xor IN0(i+3*BL+CL);
 --             end generate;
 for i in CL to BL+2*CL-2 loop
               d_result(i) <= d_result(i) xor IN0(i+3*BL);
 end loop;
 --REDUCTION_7: for i in CL to BL+2*CL-2 generate
 --              d_result(i) <= d_result(i) xor IN0(i+3*BL);
 --             end generate;

    OUTPUT <= d_result;
 end if;
end process;

end structural;



