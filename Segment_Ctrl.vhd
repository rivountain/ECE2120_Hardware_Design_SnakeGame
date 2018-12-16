library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Calculating score and show it on 7-segment display
entity segment_ctrl is
generic (
   restart      : integer := 0
);
port (
   clk          : in std_logic;
   rst          : in std_logic;
   add_block     : in std_logic;
   game_state  : inout std_logic_vector(1 downto 0);
   output_seg7      : out std_logic_vector(7 downto 0);
   an          : out std_logic_vector(3 downto 0)
);
end segment_ctrl;

architecture behavioral of segment_ctrl is

signal score         : std_logic_vector(15 downto 0);
signal clk_cnt       : integer;

signal block_state : std_logic;
begin
process (clk, rst)
begin
   if rst = '0' then
      score <= (others => '0');
      output_seg7 <= (others => '0');
      block_state <= '0';
      clk_cnt <= 0;
      an <= "0000";
   elsif rising_edge(clk) then
      if game_state = std_logic_vector(to_unsigned(restart, 2)) then
         score <= (others => '0');
         output_seg7 <= (others => '0');
         clk_cnt <= 0;
         block_state <= '0';
         an <= "0000";
      else
         case block_state is
            when '0' =>
               if add_block = '1' then
                  if (score(3 downto 0) < "1001") then
                     score(3 downto 0) <= score(3 downto 0) + "0001";
                  else
                     score(3 downto 0) <= "0000";
                     if (score(7 downto 4) < "1001") then
                        score(7 downto 4) <= score(7 downto 4) + "0001";
                     else
                        score(7 downto 4) <= "0000";
                        if (score(11 downto 8) < "1001") then
                           score(11 downto 8) <= score(11 downto 8) + "0001";
                        else
                           score(11 downto 8) <= "0000";
                           score(15 downto 12) <= score(15 downto 12) + "0001";
                        end if;
                     end if;
                  end if;
                  block_state <= '1';
               end if;
            when '1' =>
               if add_block = '0' then
                  block_state <= '0';
               end if;
         end case;
         -- refresh the 7-segment every 200,000 clk cycle, 200 us
         if clk_cnt <= 200000 then
            clk_cnt <= clk_cnt + 1;
            -- the first bit of four 7-segment
            if clk_cnt = 50000 then
               an <= "0111";
               case score(3 downto 0) is
                  when "0000" =>
                     output_seg7 <= "11000000";       -- 0
                  when "0001" =>
                     output_seg7 <= "11111001";       -- 1
                  when "0010" =>
                     output_seg7 <= "10100100";       -- 2
                  when "0011" =>
                     output_seg7 <= "10110000";       -- 3
                  when "0100" =>
                     output_seg7 <= "10011001";       -- 4
                  when "0101" =>
                     output_seg7 <= "10010010";       -- 5
                  when "0110" =>
                     output_seg7 <= "10000010";       -- 6
                  when "0111" =>
                     output_seg7 <= "11111000";       -- 7 
                  when "1000" =>
                     output_seg7 <= "10000000";       -- 8
                  when "1001" =>
                     output_seg7 <= "10010000";       -- 9
                  when others =>
               end case;

            -- the second bit of four 7-segment
            elsif (clk_cnt = 100000) then
               an <= "1011";
               case score(7 downto 4) is
                  when "0000" =>
                     output_seg7 <= "11000000";       -- 0
                  when "0001" =>
                     output_seg7 <= "11111001";       -- 1
                  when "0010" =>
                     output_seg7 <= "10100100";       -- 2
                  when "0011" =>
                     output_seg7 <= "10110000";       -- 3
                  when "0100" =>
                     output_seg7 <= "10011001";       -- 4
                  when "0101" =>
                     output_seg7 <= "10010010";       -- 5
                  when "0110" =>
                     output_seg7 <= "10000010";       -- 6
                  when "0111" =>
                     output_seg7 <= "11111000";       -- 7
                  when "1000" =>
                     output_seg7 <= "10000000";       -- 8
                  when "1001" =>
                     output_seg7 <= "10010000";       -- 9
                  when others =>
               end case;

            -- the third bit of four 7-segment
            elsif (clk_cnt = 150000) then
               an <= "1101";
               case score(11 downto 8) is
                  when "0000" =>
                     output_seg7 <= "11000000";
                  when "0001" =>
                     output_seg7 <= "11111001";
                  when "0010" =>
                     output_seg7 <= "10100100";
                  when "0011" =>
                     output_seg7 <= "10110000";
                  when "0100" =>
                     output_seg7 <= "10011001";
                  when "0101" =>
                     output_seg7 <= "10010010";
                  when "0110" =>
                     output_seg7 <= "10000010";
                  when "0111" =>
                     output_seg7 <= "11111000";
                  when "1000" =>
                     output_seg7 <= "10000000";
                  when "1001" =>
                     output_seg7 <= "10010000";
                  when others =>
               end case;
            
            -- the last bit of 7-segment
            elsif (clk_cnt = 200000) then
               an <= "1110";
               case score(15 downto 12) is
                  when "0000" =>
                     output_seg7 <= "11000000";
                  when "0001" =>
                     output_seg7 <= "11111001";
                  when "0010" =>
                     output_seg7 <= "10100100";
                  when "0011" =>
                     output_seg7 <= "10110000";
                  when "0100" =>
                     output_seg7 <= "10011001";
                  when "0101" =>
                     output_seg7 <= "10010010";
                  when "0110" =>
                     output_seg7 <= "10000010";
                  when "0111" =>
                     output_seg7 <= "11111000";
                  when "1000" =>
                     output_seg7 <= "10000000";
                  when "1001" =>
                     output_seg7 <= "10010000";
                  when others =>
               end case;
            end if;
         else
            clk_cnt <= 0;
         end if;
      end if;
   end if;
end process;

end behavioral;
