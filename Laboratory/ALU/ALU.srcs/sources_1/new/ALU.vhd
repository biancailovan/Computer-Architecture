----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.03.2020 19:12:56
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.STD_logic_arith.all;
use IEEE.STd_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
Port ( clk : in STD_LOGIC;
       btn : in STD_LOGIC_VECTOR (4 downto 0);
       sw : in STD_LOGIC_VECTOR (15 downto 0);
       led : out STD_LOGIC_VECTOR (15 downto 0);
       an : out STD_LOGIC_VECTOR (3 downto 0);
       cat : out STD_LOGIC_VECTOR (6 downto 0));
end ALU;

architecture Behavioral of ALU is
signal count: std_logic_vector(1 downto 0):="00";
signal en: std_logic;
signal add:std_logic_vector(15 downto 0);
signal sub:std_logic_vector(15 downto 0);
signal lsl:std_logic_vector(15 downto 0);
signal lsr:std_logic_vector(15 downto 0);
signal rez:std_logic_vector(15 downto 0);


component SSD is
    Port ( digit0 : in STD_LOGIC_VECTOR(3 downto 0);
    digit1 : in STD_LOGIC_VECTOR(3 downto 0);
    digit2 : in STD_LOGIC_VECTOR(3 downto 0);
    digit3 : in STD_LOGIC_VECTOR(3 downto 0);
    clk : in STD_LOGIC;
    cat : out STD_LOGIC_VECTOR(6 downto 0);
    an : out STD_LOGIC_VECTOR(3 downto 0));
end component;

component monoimpuls is
    Port ( input : in STD_LOGIC;
           clock : in STD_LOGIC;
           en : out STD_LOGIC);
end component;
begin

M1: monoimpuls port map(btn(0),clk, en);


process(clk)
begin
if clk'event and clk='1' then
    if en='1' then
        count<=count+1;
    end if;
end if;
end process;

add<=("000000000000"&sw(3 downto 0))+("000000000000"&sw(7 downto 4));
sub<=("000000000000"&sw(3 downto 0))-("000000000000"&sw(7 downto 4));
lsl<="000000"&sw(7 downto 0)&"00";
lsr<="0000000000"&sw(7 downto 2);

process(count,sw)
begin
 case count is
 when "00"=> rez<=add;
 when "01"=> rez<=sub;
 when "10"=> rez<=lsl;
 when "11"=> rez<=lsr;
 end case;
 end process;
 
 S: SSD port map(digit0=>rez(3 downto 0), digit1=>rez(7 downto 4), digit2=>rez(11 downto 8),digit3=>rez(15 downto 12),clk=>clk, cat=>cat,an=>an);
 
 led(7)<='1' when rez="000000000000000" else '0';

 
end Behavioral;
