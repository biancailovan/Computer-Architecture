----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.03.2020 22:22:54
-- Design Name: 
-- Module Name: test_new - Behavioral
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_new is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR(15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_new;

architecture Behavioral of test_new is
signal en1: std_logic;
signal count: std_logic_vector(2 downto 0):="000";
signal rez: std_logic_vector(7 downto 0):="00000000";

component monoimpuls is
    Port ( input : in STD_LOGIC;
           clock : in STD_LOGIC;
           en : out STD_LOGIC);
end component;
begin

M2: monoimpuls port map(btn(0), clk, en1);

process(clk)
begin
if clk'event and clk='1' then
    if en1='1' then
        count<=count+1;
    end if;
end if;
end process;

process(count)
begin
    case count is
        when "000"=>rez<="00000001";
        when "001"=>rez<="00000010";
        when "010"=>rez<="00000100";
        when "011"=>rez<="00001000";
        when "100"=>rez<="00010000";
        when "101"=>rez<="00100000";
        when "110"=>rez<="01000000";
        when "111"=>rez<="10000000";
     end case;
end process;

--led<=sw;
--an<=btn(3 downto 0);
--cat<=(others=>'0');

led(7)<=rez(7);
led(6)<=rez(6);
led(5)<=rez(5);
led(4)<=rez(4);
led(3)<=rez(3);
led(2)<=rez(2);
led(1)<=rez(1);
led(0)<=rez(0);
end Behavioral;
