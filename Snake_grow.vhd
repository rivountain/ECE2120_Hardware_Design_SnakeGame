library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- realise snake length growing after eating food 
-- and food random position shown on monitor
entity snake_grow is
port (
   clk       : in std_logic;
   rst       : in std_logic;
   
   head_x, head_y    : in std_logic_vector(5 downto 0);
   food_x    : out std_logic_vector(5 downto 0);
   food_y    : out std_logic_vector(4 downto 0);
   add_block  : out std_logic
);
end snake_grow;

architecture behavioral of snake_grow is
signal clk_cnt       : integer;
signal random_num    : std_logic_vector(10 downto 0);

signal food_x_int : std_logic_vector(5 downto 0);
signal food_y_int : std_logic_vector(4 downto 0);

begin
-- drive referenced outputs
food_x <= food_x_int;
food_y <= food_y_int;

process (clk)
begin
   if rising_edge(clk) then
      random_num <= random_num + std_logic_vector(to_unsigned(999, 11));
   end if;
end process;

process (clk, rst)
variable x_zero_correct:std_logic_vector(5 downto 0);
variable y_zero_correct:std_logic_vector(4 downto 0);
begin
   -- prepare food random position parameters
   if random_num(10 downto 5) = "000000" then
      x_zero_correct := "000001";
   else
      x_zero_correct := random_num(10 downto 5);
   end if;
   
   if random_num(4 downto 0) = "00000" then
      y_zero_correct := "00001";
   else
      y_zero_correct := random_num(4 downto 0);
   end if;
   
   if rst = '0' then
      clk_cnt <= 0;
      food_x_int <= "011000";
      food_y_int <= "01010";
      add_block <= '0';
   elsif rising_edge(clk) then
      clk_cnt <= clk_cnt + 1;
      if (clk_cnt = 250000) then
         clk_cnt <= 0;
         if (food_x_int = head_x and ('0' & food_y_int) = head_y) then
            add_block <= '1';
            if random_num(10 downto 5) > "100110" then
                food_x_int <= random_num(10 downto 5) - "011001";
            else
                food_x_int <= x_zero_correct;
            end if;
            
            if random_num(4 downto 0) > "11100" then
                food_y_int <= random_num(4 downto 0) - "00011";
            else
                food_y_int <= y_zero_correct;
            end if;

         else
            add_block <= '0';
         end if;
      end if;
   end if;
end process;

end behavioral;