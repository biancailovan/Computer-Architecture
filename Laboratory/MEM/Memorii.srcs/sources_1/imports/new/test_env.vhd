----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.02.2020 20:52:33
-- Design Name: 
-- Module Name: test_env - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
signal count: std_logic_vector(15 downto 0):=x"0000";
--signal count: std_logic_vector(3 downto 0):="0000";
signal enable: std_logic;
signal temp: std_logic_vector(15 downto 0):=x"0000";
signal digit1: std_logic_vector(15 downto 0):=x"0000";
signal digit2: std_logic_vector(15 downto 0):=x"0000";
signal digits: std_logic_vector(15 downto 0):=x"0000";
signal countR: std_logic_vector(7 downto 0):="00000000"; --pt memoria ROM
type ROM_mem is array(15 downto 0) of std_logic_vector(15 downto 0);

signal ROM: ROM_mem:=(
0=>B"001_000_001_0000011", --x"2083", addi $1, $0, 3, instructiunea initializeaza R1 cu 3
1=>B"001_000_011_0000101", --x"2185", addi $3, $0, 5, instructiunea initializeaza R3 cu 5
2=>B"000_011_001_010_0_010", --x"0CA2", sub $2, $3, $1, se pune in R2 valoarea R3-R1
3=>B"000_010_000_010_1_100", --x"082C", srl $2, $2, 1, deplaseaza R2 cu 2 la dr cu 1 bit
4=>B"001_000_100_0000100", --x"2204", addi $4, $0, 4, instructiunea initializeaza R4 cu 4
5=>B"000_001_100_101_0_001", --x"0651", add $5, $1, $4, se pune in R5 valoarea R1+R4
6=>B"000_010_000_010_1_100", --x"082C", sll $5, $1, 1, deplaseaza R5 cu 1 la stg cu 1 bit
7=>B"011_001_101_0000111", --x"6687", sw $5, 7($1), stocheaza in mem la adresa 7+R1 valoarea din R5
8=>B"010_011_110_0000010", --x"4F02", lw $6, 2($3), incarca din memorie in R6 de la adresa 2+R3
9=>B"100_010_101_0000001", --x"8A81", beq $2, $5, 1, daca R2=R5 se sare cu 2 instruc
10=>B"001_0000000000110", --x"2006", j 6, salt la instructiunea cu index 6
11=>B"000_011_100_111_0_111", --x"0E77", xor $7, $3, $4, pune in R7 valoarea R3 xor R4
12=>B"011_000_100_0001000", --x"6208", sw $4, 8($0), stocheaza in mem la adresa 8 valoarea din R4
others=>x"0000");

--type mem is array(0 to 15) of std_logic_vector(15 downto 0);
--signal mem_array: mem:=(x"0001",x"0010",x"0040", others=>x"0000");
--signal rsta: std_logic;
--signal wr: std_logic;

component monoimpuls is
    Port ( input : in STD_LOGIC;
           clock : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component SSD is
    Port ( digit : in STD_LOGIC_VECTOR(15 downto 0);
    clk : in STD_LOGIC;
    cat : out STD_LOGIC_VECTOR(6 downto 0);
    an : out STD_LOGIC_VECTOR(3 downto 0));
end component;


begin

M1: monoimpuls port map(btn(0), clk, enable);

process(clk)
begin
    if clk'event and clk='1' then
        if enable='1' then
            if sw(0)='1' then
                countR<=countR+1;
            else
                countR<=countR-1;
            end if;
        end if;
    end if;
end process;

--Lab1,2
--S: SSD port map(count, clk, cat, an);
--Lab3
S: SSD port map(count, clk, cat, an);

--S2:SSD port map(digits, clk, cat, an);
--digits<=digit1+digit2;

count<=ROM(conv_integer(countR));
--led <=count;
--an <=btn(3 downto 0);
--cat <=(others=>'0');

end Behavioral;
