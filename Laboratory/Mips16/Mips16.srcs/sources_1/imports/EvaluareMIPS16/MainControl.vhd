----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/01/2020 07:13:48 PM
-- Design Name: 
-- Module Name: MainControl - Behavioral
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
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--Main Control

entity MainControl is
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
end MainControl;

architecture Behavioral of MainControl is

begin
process(instr(15 downto 13))
begin
    regDst<='0';extOp<='0';ALUSrc<='0';
    branch<='0';jump<='0';memWrite<='0';
    memToReg<='0';regWrite<='0';ALUOp<="000";
    case instr(15 downto 13) is
        when "000"=>--R type
            regDst<='1'; 
            regWrite<='1';
            ALUOp<="001";
        when "001"=>--ADDI
            --regDst<='0';
            regWrite<='1';
            ALUSrc<='1';
            extOp<='1';
            ALUOp<="011";--(+)
        when "010"=>--LW
            regWrite<='1';
            ALUSrc<='1';
            extOp<='1';
            memToReg<='1';
            ALUOp<="011";--(+)
        when "011"=>--SW
            --regWrite<='0';
            ALUSrc<='1';
            extOp<='1';
            memWrite<='1';--scriere in memorie
            ALUOp<="011";--(+)
        when "100"=>--BEQ
            --regWrite<='0';
            extOp<='1';
            branch<='1';
            ALUOp<="100";--(-)
        when "101"=>--ANDI
            regWrite<='1';
            ALUSrc<='1';
            ALUOP<="101";--and
        when "111"=>--ORI
            regWrite<='1';
            ALUSrc<='1';
            ALUOp<="110";--si
        when "110"=>--J
            jump<='1';
     end case;
end process;

end Behavioral;
