----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2020 05:16:10 PM
-- Design Name: 
-- Module Name: InstrFetch - Behavioral
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

--Cerinta 1, laborator 5

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--Instruction Fetch

entity InstrFetch is
    Port ( jump: in std_logic;
           jumpAdress: in std_logic_vector(15 downto 0);
           PCSrc: in std_logic;
           branchAdress: in std_logic_vector(15 downto 0);
           en: in std_logic;
           rst: in std_logic;
           clk: in std_logic;
           instruction: out std_logic_vector(15 downto 0);
           nextInstr: out std_logic_vector(15 downto 0));
end InstrFetch;

architecture Behavioral of InstrFetch is
signal counter: std_logic_vector(15 downto 0):=x"0000";
signal outputMux1: std_logic_vector(15 downto 0):=x"0000";
signal outputMux2: std_logic_vector(15 downto 0):=x"0000";
signal outputCounter: std_logic_vector(15 downto 0):=x"0000";
type ROM_mem is array(0 to 15) of std_logic_vector(15 downto 0);

--memoria ROM cu adresele alese de mine
signal ROM: ROM_mem:=(
0=>B"001_000_001_0000011", --x"2083", addi $1, $0, 3, instructiunea initializeaza R1 cu 3
1=>B"001_000_011_0000101", --x"2185", addi $3, $0, 5, instructiunea initializeaza R3 cu 5
2=>B"000_011_001_010_0_010", --x"0CA2", sub $2, $3, $1, se pune in R2 valoarea R3-R1
3=>B"000_010_000_010_1_100", --x"082C", srl $2, $2, 1, deplaseaza R2 cu 2 la dr cu 1 bit
4=>B"001_000_100_0000100", --x"2204", addi $4, $0, 4, instructiunea initializeaza R4 cu 4
5=>B"000_001_100_101_0_001", --x"0651", add $5, $1, $4, se pune in R5 valoarea R1+R4
6=>B"000_001_000_101_1_011", --x"045B", sll $5, $1, 1, deplaseaza R5 cu 1 la stg cu 1 bit
7=>B"011_001_101_0000111", --x"6687", sw $5, 7($1), stocheaza in mem la adresa 7+R1 valoarea din R5
8=>B"010_011_110_0000010", --x"4F02", lw $6, 2($3), incarca din memorie in R6 de la adresa 2+R3
9=>B"110_0000000001011",--x"C00B", j 11, salt la instructiunea cu index 11
10=>B"100_010_010_0000010", --x"8902", beq $2, $2, 2, daca R2=R2 se sare cu 3 instruc --trece la linia urmatoare, dupa care sare 2 poz
11=>B"000_011_100_111_0_000", --x"0E70", xor $7, $3, $4, pune in R7 valoarea R3 xor R4
12=>B"110_0000000001010", --x"C00A", j 10, salt la instructiunea cu index 10
13=>B"000_001_011_101_0_001", --x"05D1", add $5, $1, $3, se pune in R5 valoarea R1 + R3
14=>B"011_000_100_0001000", --x"6208", sw $4, 8($0), stocheaza in mem la adresa 8 valoarea din R4
others=>x"0000");

begin

--pentru PC vom avea nevoie de un registru(bistabil d) cu reset sincron
process(clk)
begin
    if clk'event and clk ='1' then
        if rst = '1' then
            counter<=x"0000";
        elsif en = '1' then
            counter<=outputMux2;
        end if;
    end if;
end process;

process(outputMux2, counter)
begin
    nextInstr<=counter+1;
    instruction<=ROM(conv_integer(counter(3 downto 0)));
end process;

process(PCSrc, counter, branchAdress)
begin
    if PCSrc = '0' then
        outputMux1<=counter+x"0001";
    else
        outputMux1<=branchAdress;
    end if;
end process;

process(jump, jumpAdress, outputMux1)
begin
    if jump = '1' then
        outputMux2<=jumpAdress;
    else
        outputMux2<=outputMux1;
    end if;
end process;

end Behavioral;
