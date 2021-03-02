----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2020 05:38:29 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

--Cerinta 1, Instruction Decoder

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--Instruction Decode

entity InstrDecode is
    Port (
    regWrite: in std_logic;
    instr: in std_logic_vector(15 downto 0);
    regDst: in std_logic;
    clk: in std_logic;
    en: in std_logic;
    extOp: in std_logic;
    wd: in std_logic_vector(15 downto 0);
    readData1: out std_logic_vector(15 downto 0);
    readData2: out std_logic_vector(15 downto 0);
    ext_Imm: out std_logic_vector(15 downto 0);
    func: out std_logic_vector(2 downto 0);
    sa: out std_logic);
end InstrDecode;

architecture Behavioral of InstrDecode is
signal readAddress1: std_logic_vector(2 downto 0):="000";
signal readAddress2: std_logic_vector(2 downto 0):="000";
signal writeAddress: std_logic_vector(2 downto 0):="000";
type register_file is array(0 to 7) of std_logic_vector(15 downto 0);
signal reg : register_file:=(others => x"0000");--initializare cu 0
begin

readAddress2<=instr(9 downto 7);
readAddress1<=instr(12 downto 10);

process(regDst, instr)
begin
    case(regDst) is
        when '1' => writeAddress<=instr(6 downto 4);
        when '0' => writeAddress<=instr(9 downto 7);
    end case;
end process;

process(extOp,instr)
begin
if extOp='1' and instr(6)='1' then
    ext_Imm<="111111111"&instr(6 downto 0);
    else 
    ext_Imm<="000000000"&instr(6 downto 0);
  end if;
  end process;

process(clk)
begin
if clk='1' and clk'event then
    if en='1' and regWrite='1' then
        reg(conv_integer(writeAddress))<=wd;--adr reg in care se scrie val de pe intrarea de date
    end if;
end if; 
end process;     

readData1<=reg(conv_integer(readAddress1));
readData2<=reg(conv_integer(readAddress2));
func<=instr(2 downto 0);
sa<=instr(3);

end Behavioral;
