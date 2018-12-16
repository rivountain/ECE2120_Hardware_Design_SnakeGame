library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Realise snake shape, movement behavior
entity snake is
   generic (
      up           : integer := 0;
      down         : integer := 1;
      left         : integer := 2;
      right        : integer := 3;
      
      none         : integer := 0;
      snake_head         : integer := 1;
      snake_body   : integer := 2;
      wall         : integer := 3;
      
      restart      : integer := 0;
      play         : integer := 2
   );
   port (
      clk          : in std_logic;
      rst          : in std_logic;
      left_press   : in std_logic;
      right_press  : in std_logic;
      up_press     : in std_logic;
      down_press   : in std_logic;
      snake        : out std_logic_vector(1 downto 0);
      x_coord, y_coord        : in std_logic_vector(9 downto 0);
      head_x       : out std_logic_vector(5 downto 0);
      head_y       : out std_logic_vector(5 downto 0);
      add_block    : in std_logic;
      game_status  : in std_logic_vector(1 downto 0);
      block_num    : out std_logic_vector(6 downto 0);
      hit_body     : out std_logic;
      hit_wall     : out std_logic;
      die_flash    : in std_logic
   );
end snake;

architecture behavioral of snake is
   type two_D_array is array (15 downto 0) of std_logic_vector(5 downto 0);
   
   
   signal clk_cnt             : integer;
   
   signal direct          : std_logic_vector(1 downto 0);
   signal direct_r        : std_logic_vector(1 downto 0);
   signal direct_next     : std_logic_vector(1 downto 0);
   
   signal change_to_left  : std_logic;
   signal change_to_right : std_logic;
   signal change_to_up    : std_logic;
   signal change_to_down  : std_logic;
   
   signal block_x         : two_D_array;
   signal block_y         : two_D_array;
   signal is_exist        : std_logic_vector(15 downto 0);
   
   signal addcube_state   : std_logic;
   
   signal lox             : std_logic_vector(3 downto 0);
   signal loy             : std_logic_vector(3 downto 0);
   
   signal block_num_int  : std_logic_vector(6 downto 0);
begin
   block_num <= block_num_int;
   direct <= direct_r;
   head_x <= block_x(0);
   head_y <= block_y(0);
   process (clk, rst)
   begin
      if rst = '0' then
         direct_r <= std_logic_vector(to_unsigned(right, 2));
      elsif rising_edge(clk) then
         if game_status = std_logic_vector(to_unsigned(restart, 2)) then
            direct_r <= std_logic_vector(to_unsigned(right, 2));
         else
            direct_r <= direct_next;
         end if;
      end if;
end process;

process (clk)
begin
   if rising_edge(clk) then
      if (left_press = '1') then
         change_to_left <= '1';
      elsif (right_press = '1') then
         change_to_right <= '1';
      elsif (up_press = '1') then
         change_to_up <= '1';
      elsif (down_press = '1') then
         change_to_down <= '1';
      else
         change_to_left <= '0';
         change_to_right <= '0';
         change_to_up <= '0';
         change_to_down <= '0';
      end if;
   end if;
end process;
   
process (clk, rst)
begin
   -- initialize snake (3 block including head)
   if rst = '0' then
      clk_cnt <= 0 ;
      block_x(0)  <= "001010";
      block_y(0)  <= "000101";
      block_x(1)  <= "001001";
      block_y(1)  <= "000101";
      block_x(2)  <= "001000";
      block_y(2)  <= "000101";
      block_x(3)  <= (others => '0');
      block_y(3)  <= (others => '0');
      block_x(4)  <= (others => '0');
      block_y(4)  <= (others => '0');
      block_x(5)  <= (others => '0');
      block_y(5)  <= (others => '0');
      block_x(6)  <= (others => '0');
      block_y(6)  <= (others => '0');
      block_x(7)  <= (others => '0');
      block_y(7)  <= (others => '0');
      block_x(8)  <= (others => '0');
      block_y(8)  <= (others => '0');
      block_x(9)  <= (others => '0');
      block_y(9)  <= (others => '0');
      block_x(10) <= (others => '0');
      block_y(10) <= (others => '0');
      block_x(11) <= (others => '0');
      block_y(11) <= (others => '0');
      block_x(12) <= (others => '0');
      block_y(12) <= (others => '0');
      block_x(13) <= (others => '0');
      block_y(13) <= (others => '0');
      block_x(14) <= (others => '0');
      block_y(14) <= (others => '0');
      block_x(15) <= (others => '0');
      block_y(15) <= (others => '0');
      hit_wall <= '0';
      hit_body <= '0';
   -- restart state
   elsif rising_edge(clk) then
      if game_status = std_logic_vector(to_unsigned(restart, 2)) then
         clk_cnt <= 0;
         block_x(0)  <= "001010";
         block_y(0)  <= "000101";
         block_x(1)  <= "001001";
         block_y(1)  <= "000101";
         block_x(2)  <= "001000";
         block_y(2)  <= "000101";
         block_x(3)  <= (others => '0');
         block_y(3)  <= (others => '0');
         block_x(4)  <= (others => '0');
         block_y(4)  <= (others => '0');
         block_x(5)  <= (others => '0');
         block_y(5)  <= (others => '0');
         block_x(6)  <= (others => '0');
         block_y(6)  <= (others => '0');
         block_x(7)  <= (others => '0');
         block_y(7)  <= (others => '0');
         block_x(8)  <= (others => '0');
         block_y(8)  <= (others => '0');
         block_x(9)  <= (others => '0');
         block_y(9)  <= (others => '0');
         block_x(10) <= (others => '0');
         block_y(10) <= (others => '0');
         block_x(11) <= (others => '0');
         block_y(11) <= (others => '0');
         block_x(12) <= (others => '0');
         block_y(12) <= (others => '0');
         block_x(13) <= (others => '0');
         block_y(13) <= (others => '0');
         block_x(14) <= (others => '0');
         block_y(14) <= (others => '0');
         block_x(15) <= (others => '0');
         block_y(15) <= (others => '0');
         hit_wall <= '0';
         hit_body <= '0';
      else
         clk_cnt <= clk_cnt + 1;

         -- 12,500,000 clk cycle, 0.125 second
         if (clk_cnt = 12500000) then
            clk_cnt <= 0;
            if game_status = std_logic_vector(to_unsigned(play, 2)) then

               -- game over check before moving
               if (direct = std_logic_vector(to_unsigned(up, 2)) and block_y(0) = "000001") or 
               (direct = std_logic_vector(to_unsigned(down, 2)) and block_y(0) = "011100") or 
               (direct = std_logic_vector(to_unsigned(left, 2)) and block_x(0) = "000001") or 
               (direct = std_logic_vector(to_unsigned(right, 2)) and block_x(0) = "100110") then
                  hit_wall <= '1';
               elsif ((block_y(0) = block_y(1) and block_x(0) = block_x(1) and is_exist(1) = '1') 
                    or (block_y(0) = block_y(2) and block_x(0) = block_x(2) and is_exist(2) = '1') 
                    or (block_y(0) = block_y(3) and block_x(0) = block_x(3) and is_exist(3) = '1') 
                    or (block_y(0) = block_y(4) and block_x(0) = block_x(4) and is_exist(4) = '1') 
                    or (block_y(0) = block_y(5) and block_x(0) = block_x(5) and is_exist(5) = '1') 
                    or (block_y(0) = block_y(6) and block_x(0) = block_x(6) and is_exist(6) = '1') 
                    or (block_y(0) = block_y(7) and block_x(0) = block_x(7) and is_exist(7) = '1') 
                    or (block_y(0) = block_y(8) and block_x(0) = block_x(8) and is_exist(8) = '1') 
                    or (block_y(0) = block_y(9) and block_x(0) = block_x(9) and is_exist(9) = '1') 
                    or (block_y(0) = block_y(10) and block_x(0) = block_x(10) and is_exist(10) = '1') 
                    or (block_y(0) = block_y(11) and block_x(0) = block_x(11) and is_exist(11) = '1') 
                    or (block_y(0) = block_y(12) and block_x(0) = block_x(12) and is_exist(12) = '1') 
                    or (block_y(0) = block_y(13) and block_x(0) = block_x(13) and is_exist(13) = '1') 
                    or (block_y(0) = block_y(14) and block_x(0) = block_x(14) and is_exist(14) = '1') 
                    or (block_y(0) = block_y(15) and block_x(0) = block_x(15) and is_exist(15) = '1')) then
                  hit_body <= '1';

               -- snake move forward, later block take position of former block
               else
                  block_x(1) <= block_x(0);
                  block_y(1) <= block_y(0);
                  block_x(2) <= block_x(1);
                  block_y(2) <= block_y(1);
                  block_x(3) <= block_x(2);
                  block_y(3) <= block_y(2);
                  block_x(4) <= block_x(3);
                  block_y(4) <= block_y(3);
                  block_x(5) <= block_x(4);
                  block_y(5) <= block_y(4);
                  block_x(6) <= block_x(5);
                  block_y(6) <= block_y(5);
                  block_x(7) <= block_x(6);
                  block_y(7) <= block_y(6);
                  block_x(8) <= block_x(7);
                  block_y(8) <= block_y(7);
                  block_x(9) <= block_x(8);
                  block_y(9) <= block_y(8);
                  block_x(10) <= block_x(9);
                  block_y(10) <= block_y(9);
                  block_x(11) <= block_x(10);
                  block_y(11) <= block_y(10);
                  block_x(12) <= block_x(11);
                  block_y(12) <= block_y(11);
                  block_x(13) <= block_x(12);
                  block_y(13) <= block_y(12);
                  block_x(14) <= block_x(13);
                  block_y(14) <= block_y(13);
                  block_x(15) <= block_x(14);
                  block_y(15) <= block_y(14);

                  -- game over check after next move
                  if direct = std_logic_vector(to_unsigned(up, 2)) then
                     if (block_y(0) = "000001") then
                        hit_wall <= '1';
                     else
                        block_y(0) <= block_y(0) - 1;
                     end if;
                  elsif direct = std_logic_vector(to_unsigned(down, 2)) then
                     if (block_y(0) = "011100") then
                        hit_wall <= '1';
                     else
                        block_y(0) <= block_y(0) + 1;
                     end if;
                  elsif direct = std_logic_vector(to_unsigned(left, 2)) then
                     if (block_x(0) = "000001") then
                        hit_wall <= '1';
                     else
                        block_x(0) <= block_x(0) - 1;
                     end if;
                  elsif direct = std_logic_vector(to_unsigned(right, 2)) then
                     if (block_x(0) = "100110") then
                        hit_wall <= '1';
                     else
                        block_x(0) <= block_x(0) + 1;
                     end if;
                  end if;
               end if;
            end if;
         end if;
      end if;
   end if;
end process;
   
process (direct, change_to_left, change_to_right, change_to_up, change_to_down)
begin
   direct_next <= direct;
   if direct = std_logic_vector(to_unsigned(up, 2)) then
     if (change_to_left = '1') then
        direct_next <= std_logic_vector(to_unsigned(left, 2));
     elsif (change_to_right = '1') then
        direct_next <= std_logic_vector(to_unsigned(right, 2));
     else
        direct_next <= std_logic_vector(to_unsigned(up, 2));
     end if;
   elsif direct = std_logic_vector(to_unsigned(down, 2)) then
     if (change_to_left = '1') then
        direct_next <= std_logic_vector(to_unsigned(left, 2));
     elsif (change_to_right = '1') then
        direct_next <= std_logic_vector(to_unsigned(right, 2));
     else
        direct_next <= std_logic_vector(to_unsigned(down, 2));
     end if;
   elsif direct = std_logic_vector(to_unsigned(left, 2)) then
     if (change_to_up = '1') then
        direct_next <= std_logic_vector(to_unsigned(up, 2));
     elsif (change_to_down = '1') then
        direct_next <= std_logic_vector(to_unsigned(down, 2));
     else
        direct_next <= std_logic_vector(to_unsigned(left, 2));
     end if;
   elsif direct = std_logic_vector(to_unsigned(right, 2)) then
     if (change_to_up = '1') then
        direct_next <= std_logic_vector(to_unsigned(up, 2));
     elsif (change_to_down = '1') then
        direct_next <= std_logic_vector(to_unsigned(down, 2));
     else
        direct_next <= std_logic_vector(to_unsigned(right, 2));
     end if;
   end if;
end process;

process (clk, rst)
begin
   if rst = '0' then
      is_exist <= "0000000000000111";
      block_num_int <= "0000011";
      addcube_state <= '0';
   elsif rising_edge(clk) then
      if game_status = std_logic_vector(to_unsigned(restart, 2)) then
         is_exist <= "0000000000000111";
         block_num_int <= "0000011";
         addcube_state <= '0';
      else
         case addcube_state is
            when '0' =>
               if add_block = '1' then
                  block_num_int <= block_num_int + 1;
                  is_exist(to_integer(unsigned(block_num_int))) <= '1';
                  addcube_state <= '1';
               end if;
            when '1' =>
               if add_block = '0' then
                  addcube_state <= '0';
               end if;
         end case;
      end if;
   end if;
end process;

process (x_coord, y_coord)
begin
   if (x_coord >= "0000000000" and x_coord < "1010000000" and y_coord >= "0000000000" and y_coord < "0111100000") then
      if (x_coord(9 downto 4) = "000000" or y_coord(9 downto 4) = "000000" or x_coord(9 downto 4) = "100111" or y_coord(9 downto 4) = "011101") then
         snake <= std_logic_vector(to_unsigned(wall, 2));
      elsif (x_coord(9 downto 4) = block_x(0) and y_coord(9 downto 4) = block_y(0) and is_exist(0) = '1') then
         if die_flash = '1' then
             snake <= std_logic_vector(to_unsigned(snake_head, 2));
         else
             snake <= std_logic_vector(to_unsigned(none, 2));
         end if;
      elsif ((x_coord(9 downto 4) = block_x(1) and y_coord(9 downto 4) = block_y(1) and is_exist(1) = '1')
             or (x_coord(9 downto 4) = block_x(2) and y_coord(9 downto 4) = block_y(2) and is_exist(2) = '1') 
             or (x_coord(9 downto 4) = block_x(3) and y_coord(9 downto 4) = block_y(3) and is_exist(3) = '1') 
             or (x_coord(9 downto 4) = block_x(4) and y_coord(9 downto 4) = block_y(4) and is_exist(4) = '1') 
             or (x_coord(9 downto 4) = block_x(5) and y_coord(9 downto 4) = block_y(5) and is_exist(5) = '1') 
             or (x_coord(9 downto 4) = block_x(6) and y_coord(9 downto 4) = block_y(6) and is_exist(6) = '1') 
             or (x_coord(9 downto 4) = block_x(7) and y_coord(9 downto 4) = block_y(7) and is_exist(7) = '1') 
             or (x_coord(9 downto 4) = block_x(8) and y_coord(9 downto 4) = block_y(8) and is_exist(8) = '1') 
             or (x_coord(9 downto 4) = block_x(9) and y_coord(9 downto 4) = block_y(9) and is_exist(9) = '1') 
             or (x_coord(9 downto 4) = block_x(10) and y_coord(9 downto 4) = block_y(10) and is_exist(10) = '1') 
             or (x_coord(9 downto 4) = block_x(11) and y_coord(9 downto 4) = block_y(11) and is_exist(11) = '1') 
             or (x_coord(9 downto 4) = block_x(12) and y_coord(9 downto 4) = block_y(12) and is_exist(12) = '1') 
             or (x_coord(9 downto 4) = block_x(13) and y_coord(9 downto 4) = block_y(13) and is_exist(13) = '1') 
             or (x_coord(9 downto 4) = block_x(14) and y_coord(9 downto 4) = block_y(14) and is_exist(14) = '1') 
             or (x_coord(9 downto 4) = block_x(15) and y_coord(9 downto 4) = block_y(15) and is_exist(15) = '1')) then
         if die_flash = '1' then
             if die_flash = '1' then
                 snake <= std_logic_vector(to_unsigned(snake_body, 2));
             else
                 snake <= std_logic_vector(to_unsigned(none, 2));
             end if;
         end if;
      else
         snake <= std_logic_vector(to_unsigned(none, 2));
      end if;
  end if;
end process;
   
   
end behavioral;
