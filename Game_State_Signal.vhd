library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity game_state_signal is
   generic (
      RESTART_G    : integer := 0;
      start        : integer := 1;
      play         : integer := 2;
      die          : integer := 3
   );
   port (
      clk          : in std_logic;
      rst          : in std_logic;
      btn1_press, btn2_press, btn3_press, btn4_press   : in std_logic;
      game_status  : out std_logic_vector(1 downto 0);
      hit_wall, hit_body     : in std_logic;
      die_flash    : out std_logic;
      restart      : out std_logic
   );
end game_state_signal;

architecture behaviroal of game_state_signal is
   
   signal clk_cnt           : integer;
   
   -- declare intermediate signals for referenced outputs
   signal game_status_int : std_logic_vector(1 downto 0);
begin
   -- drive referenced outputs
   game_status <= game_status_int;
   
   process (clk, rst)
   begin
      if rst = '0' then
         game_status_int <= std_logic_vector(to_unsigned(start, 2));
         clk_cnt <= 0;
         die_flash <= '1';
         restart <= '0';
      elsif (clk'event and clk = '1') then
         if game_status_int = std_logic_vector(to_unsigned(RESTART_G, 2)) then
            if (clk_cnt <= 5) then
               clk_cnt <= clk_cnt + 1;
               restart <= '1';
            else
               game_status_int <= std_logic_vector(to_unsigned(start, 2));
               clk_cnt <= 0;
               restart <= '0';
            end if;
         elsif game_status_int = std_logic_vector(to_unsigned(start, 2)) then
            if (btn1_press = '1' or btn2_press = '1' or btn3_press = '1' or btn4_press = '1') then
               game_status_int <= std_logic_vector(to_unsigned(play, 2));
            else
               game_status_int <= std_logic_vector(to_unsigned(start, 2));
            end if;
         elsif game_status_int = std_logic_vector(to_unsigned(play, 2)) then
            if (hit_wall = '1' or hit_body = '1') then
               game_status_int <= std_logic_vector(to_unsigned(die, 2));
            else
               game_status_int <= std_logic_vector(to_unsigned(play, 2));
            end if;
         elsif game_status_int = std_logic_vector(to_unsigned(die, 2)) then
            if (clk_cnt <=      200000000) then
               clk_cnt <= clk_cnt + 1;
               if (clk_cnt =     25000000) then
                  die_flash <= '0';
               elsif (clk_cnt =  50000000) then
                  die_flash <= '1';
               elsif (clk_cnt =  75000000) then
                  die_flash <= '0';
               elsif (clk_cnt = 100000000) then
                  die_flash <= '1';
               elsif (clk_cnt = 125000000) then
                  die_flash <= '0';
               elsif (clk_cnt = 150000000) then
                  die_flash <= '1';
               end if;
            else
               die_flash <= '1';
               clk_cnt <= 0;
               game_status_int <= std_logic_vector(to_unsigned(RESTART_G, 2));
            end if;
         end if;
      end if;
   end process;
   
   
end behaviroal;