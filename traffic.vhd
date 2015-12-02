-- Example 62: traffic lights
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity traffic is
	 port (clk: in STD_LOGIC;
		clr: in STD_LOGIC;
		btn: in STD_LOGIC;
		lights: out STD_LOGIC_VECTOR(11 downto 0)
		);
end traffic;

architecture traffic of traffic is

type state_type is (s0, s1, s2, s3, s4, s5);
signal state: state_type;
signal count: STD_LOGIC_VECTOR(3 downto 0);
signal aptbtn: Boolean := false ;
constant SEC5: STD_LOGIC_VECTOR(3 downto 0) := "1111";
constant SEC1: STD_LOGIC_VECTOR(3 downto 0) := "0011";

begin
	process(clk, clr)
	begin
		 if clr = '1' then
			 state <= s0;
			 count <= X"0";
		 elsif clk'event and clk = '1' then
			 case state is
				 when s0 =>
					 if count < SEC5 then
						 state <= s0;
						 count <= count + 1;
					else
					 state <= s1;
					 count <= X"0";
					end if;
				 when s1 =>
					 if count < SEC1 then
						 state <= s1;
						 count <= count + 1;
					 else
						 state <= s2;
						 count <= X"0";
					 end if;
				 when s2 =>
					 if count < SEC5 then
						 state <= s3;
						 count <= count + 1;
					 else
						 state <= s3;
						 count <= X"0";
					 end if; 
				 when s3 =>
					 if count < SEC1 then
						 state <= s3;
						 count <= count + 1;
					 else
							if aptbtn then
								state <= s4;
							else
								state <= s0;
							end if;
						count <= X"0";
					 end if;
				 when s4 =>
					 if count < SEC1 then
						 state <= s4;
						 count <= count + 1;
					 else
						 state <= s5;
						 count <= X"0";
					 end if;
				 when s5 =>
					 if count < SEC1 then
						 state <= s5;
						 count <= count + 1;
					 else
						 state <= s0;
						 count <= X"0";
					 end if;
				 when others =>
					state <= s0;
			 end case;
		 end if;
	end process; 
-- lights bit mapping TC1-Vm, TC1-Am, TC1-Vd, TC2-Vm, TC2-Am, TC2-Vd, TP1-Vm, TP1-Vd, TP2-Vm, TP2-Vd, TP34-Vm, TP34-Vd
	C2: process(state)
	begin
		case state is
			 when s0 => lights <= "001100100110";
			 when s1 => lights <= "010100100110";
			 when s2 => lights <= "100001011010";
			 when s3 => lights <= "100010011010";
			 when s4 => lights <= "100100010101";
			 when s5 => lights <= "100100010101";
			 when others => lights <= "111111111111";
		end case;
	end process;
	
	C3: process(btn,aptbtn)
	begin
		if btn = '1' and state /= s4 then
			aptbtn <= true;
		end if;
		if state = s4 then
			aptbtn <= false;
		end if;
	end process;
end traffic; 