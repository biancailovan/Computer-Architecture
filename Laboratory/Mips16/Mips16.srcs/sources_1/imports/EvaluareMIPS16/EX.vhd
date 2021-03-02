----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2020 06:37:12 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
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
end EX;

architecture Behavioral of EX is
signal ALUCtrl: std_logic_vector(2 downto 0):="000";
signal isZero: std_logic;
signal outputMux: std_logic_vector(15 downto 0):=x"0000";
signal ALURess: std_logic_vector(15 downto 0):=x"0000";

begin

BranchAddress<=NextInstr+Ext_Imm;

process(ALUSrc, Rd2, Ext_Imm)
begin
	case ALUSrc is
		when '0'=>outputMux<=Rd2;
		when '1'=>outputMux<=Ext_Imm;
	end case;
end process;

process(ALUCtrl, Rd1, outputMux)
begin	
	case ALUCtrl is
	when "000"=>ALURess<=Rd1 xor outputMux;
	when "001"=>ALURess<=Rd1+outputMux;
	when "010"=>ALURess<=Rd1-outputMux;
	when "011"=>if sa='1' then ALURess<=outputMux(14 downto 0)&'0';
	            else ALURess<=outputMux;
	            end if;
	when "100"=>if sa='1' then ALURess<='0'&outputMux(15 downto 1);
	            else ALURess<=outputMux;
	            end if;
	when "101"=>ALURess<=Rd1 and outputMux;
	when "110"=>ALURess<=Rd1 or outputMux;
	when "111"=>
		if sa='1' then ALURess<=outputMux(15)&outputMux(15 downto 1);
		else ALURess<=outputMux;
		end if;
	when others=>ALURess<=x"0000";
end case;
end process;

process(ALURess)
begin
if ALURess=x"0000" then
    isZero<='1';
else
    isZero<='0';
end if;
end process;
zero<=isZero;
ALURes<=ALURess;

ALUControl: process(ALUOp, func)
begin
	case ALUOp is
	when "001"=> --intstructiuni de tip R
	case func is
		when "000"=>ALUCtrl<="000";--xor
		when "001"=>ALUCtrl<="001";--add
		when "010"=>ALUCtrl<="010";--sub
		when "011"=>ALUCtrl<="010";--sll
		when "100"=>ALUCtrl<="010";--srl
		when "101"=>ALUCtrl<="101";--and
		when "110"=>ALUCtrl<="110";--or
		when "111"=>ALUCtrl<="111";--sra
	end case;
	when "010"=>ALUCtrl<="110";--cod pentru ori(tip I)
	when "011"=>ALUCtrl<="001";--cod pentru adunare(instr addi, lw, sw)
	when "100"=>ALUCtrl<="010";--cod pentru scadere(instr beq)
	when "101"=>ALUCtrl<="101";--cod pentru andi(tip I)
	when others=>ALUCtrl<="000";--instuctiunea tip J
	end case;
end process;

end Behavioral;
