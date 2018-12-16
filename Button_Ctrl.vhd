library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Realise snake movement control through 
-- BTNC(rst),BTNU(up),BTNL(left),BTNR(right) and BTND(down)
-- on NEXYS4 board
entity button_ctrl is
port (
   clk                                                            : in std_logic;
   rst                                                            : in std_logic;
   left, right, up ,down                                          : in std_logic;
   left_btn_press, right_btn_press, up_btn_press, down_btn_press  : out std_logic
);
end button_ctrl;

architecture behavioral of button_ctrl is
signal clk_cnt        : std_logic_vector(31 downto 0);
signal left_btn_last  : std_logic;
signal right_btn_last : std_logic;
signal up_btn_last    : std_logic;
signal down_btn_last  : std_logic;
begin
process (clk, rst)
begin
   -- initial
   if rst = '1' then
      clk_cnt <= (others => '0');
      left_btn_press <= '0';
      left_btn_last <= '0';
      --
      right_btn_press <= '0';
      right_btn_last <= '0';
      --
      up_btn_press <= '0';
      up_btn_last <= '0';
      --
      down_btn_press <= '0';
      down_btn_last <= '0';
   elsif rising_edge(clk) then
      -- button scan, every 50,000 clk cycle, 0.0005 second
      if clk_cnt = std_logic_vector(to_unsigned(50000,32)) then
         clk_cnt <= (others => '0');
         
         left_btn_last <= left;
         right_btn_last <= right;
         up_btn_last <= up;
         down_btn_last <= down;
         if (left_btn_last = '0' and left = '1') then
            left_btn_press <= '1';
         end if;
         if (right_btn_last = '0' and right = '1') then
            right_btn_press <= '1';
         end if;
         if (up_btn_last = '0' and up = '1') then
            up_btn_press <= '1';
         end if;
         if (down_btn_last = '0' and down = '1') then
            down_btn_press <= '1';
         end if;
      else
         clk_cnt <= clk_cnt + 1;
         left_btn_press <= '0';
         right_btn_press <= '0';
         up_btn_press <= '0';
         down_btn_press <= '0';
      end if;
   end if;
end process;


end behavioral;