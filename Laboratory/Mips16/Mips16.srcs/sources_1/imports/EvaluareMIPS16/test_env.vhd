----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2020 06:50:59 PM
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

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
signal enable: std_logic;
signal digits: std_logic_vector(15 downto 0):=x"0000";
signal rst: std_logic;
signal jmp: std_logic_vector(15 downto 0):=x"0000";
signal branch: std_logic_vector(15 downto 0):=x"0CA2";
signal instruc: std_logic_vector(15 downto 0):=x"0000";
signal nextInstruc: std_logic_vector(15 downto 0):=x"0000";
signal regWrite: std_logic;
signal extOp: std_logic;
signal ALUOp: std_logic_vector(2 downto 0):="000";
signal ALURes: std_logic_vector(15 downto 0):=x"0000";
signal ALUSrc: std_logic;
signal regDst: std_logic;
signal rd1: std_logic_vector(15 downto 0):=x"0000";--read data 1
signal rd2: std_logic_vector(15 downto 0):=x"0000";--read data 2
signal wd: std_logic_vector(15 downto 0):=x"0000";
signal memWrite: std_logic;
signal memToReg: std_logic;
signal ext_IMM: std_logic_vector(15 downto 0):=x"0000";
signal br: std_logic; --for branch
signal jump: std_logic;
signal func: std_logic_vector(2 downto 0);
signal sa: std_logic;
signal sum: std_logic_vector(15 downto 0):=x"0000";
signal zero: std_logic;
signal PCSrc: std_logic;
signal ALUResOut: std_logic_vector(15 downto 0):=x"0000";
signal memData: std_logic_vector(15 downto 0):=x"0000";
signal jumpAdr: std_logic_vector(15 downto 0):=x"0000";
signal branchh: std_logic;

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

component InstrFetch is
    Port ( jump: in std_logic;
           jumpAdress: in std_logic_vector(15 downto 0);
           PCSrc: in std_logic;
           branchAdress: in std_logic_vector(15 downto 0);
           en: in std_logic;
           rst: in std_logic;
           clk: in std_logic;
           instruction: out std_logic_vector(15 downto 0);
           nextInstr: out std_logic_vector(15 downto 0));
end component;

component InstrDecode is
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
end component;

component MainControl is
    Port ( 
    instr: in std_logic_vector(15 downto 0);
    regDst: out std_logic; --1bit
    extOp: out std_logic;--1bit
    ALUSrc: out std_logic;--1bit
    branch: out std_logic;--1bit
    jump: out std_logic;--1bit
    ALUOp: out std_logic_vector(2 downto 0);--am avut nevoie de 3biti
    memWrite: out std_logic;--1bit
    memToReg: out std_logic;--1bit
    regWrite: out std_logic);--1bit
end component;

component EX is
	   Port(Rd1 : in STD_LOGIC_VECTOR (15 downto 0);
	       ALUSrc : in STD_LOGIC;
           Rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           Ext_Imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (2 downto 0);
           NextInstr : in STD_LOGIC_VECTOR (15 downto 0);
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
	       Zero: out STD_LOGIC;
           BranchAddress : out STD_LOGIC_VECTOR (15 downto 0));
end component; 

component MEM is
      Port(MemWrite : in STD_LOGIC;
           ALUResIn : in STD_LOGIC_VECTOR (15 downto 0);
           Rd2 : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALUResOut : out STD_LOGIC_VECTOR (15 downto 0));
end component;
begin

M1: monoimpuls port map(btn(0), clk, enable);
M2: monoimpuls port map(btn(1), clk, rst);
--I: InstrFetch port map(sw(0),jmp,sw(1),branch,enable,rst,clk,instruc, nextInstruc);
I: InstrFetch port map(jump,jumpAdr,PCSrc,branch,enable,rst,clk,instruc, nextInstruc);

ID: InstrDecode port map(regWrite,instruc,regDst,clk,enable,extOp,wd,rd1,rd2,ext_IMM,func,sa);
MC: MainControl port map(instruc,regDst,extOp,ALUsrc,br,jump,ALUOp,memWrite,memToReg,regWrite);
--sum<=rd1+rd2;

EX1: EX port map(rd1, ALUsrc, rd2, ext_IMM, sa, func, ALUOp, nextInstruc, ALURes, zero, branch);
MEM1: MEM port map(memWrite, ALUres, rd2, clk, enable, memData, ALUResOut);
--digits<=instruc when sw(7) = '0' else nextInstruc;
S: SSD port map(digits, clk, cat, an);

led(0)<=regWrite;
led(1)<=memToReg;
led(2)<=memWrite;
led(3)<=jump;
led(4)<=br;
led(5)<=ALUSrc;
led(6)<=extOp;
led(7)<=regDst;
led(10 downto 8)<=ALUOp;

process(instruc, nextInstruc, rd1,ext_IMM, rd2,ALURes,MemData, wd, sw(7 downto 5))
begin
    case sw(7 downto 5) is
        when "000" =>digits<=instruc;
        when "001" =>digits<=nextInstruc;
        when "010" =>digits<=rd1;
        when "011" =>digits<=rd2;
        when "100" =>digits<=ext_IMM;
        when "101" =>digits<= ALURes;
        when "110" =>digits<= MemData;
        when "111" =>digits<= wd;
    end case;   
end process;

jumpAdr<=nextInstruc(15 downto 13)&instruc(12 downto 0);

process(br)
begin
    if br='1' and zero='1' then
        PCSrc<='1';
    else
        PCSrc<='0';
    end if;
end process;

wd<=memData when memToReg='1' else ALUReS;

end Behavioral;
