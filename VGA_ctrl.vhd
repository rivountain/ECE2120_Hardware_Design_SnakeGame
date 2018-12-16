library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity vga_ctrl is
generic (
   none        : integer := 0;
   snake_head  : integer := 1;
   snake_body  : integer := 2;
   wall        : integer := 3;
   head_color  : std_logic_vector(11 downto 0) := "000011110000";
   body_color  : std_logic_vector(11 downto 0) := "000011111111"
);
port (
   clk_25mHz   : in std_logic;
   rst         : in std_logic;
   snake       : in std_logic_vector(1 downto 0);
   food_x      : in std_logic_vector(5 downto 0);
   food_y      : in std_logic_vector(4 downto 0);
   x_coord, y_coord        : out std_logic_vector(9 downto 0);
   hsync, vsync            : out std_logic;
   color       : out std_logic_vector(11 downto 0)
);
end vga_ctrl;

architecture behavioral of vga_ctrl is
signal clk_cnt     : std_logic_vector(19 downto 0);
signal line_cnt    : std_logic_vector(9 downto 0);

signal lox         : std_logic_vector(3 downto 0);
signal loy         : std_logic_vector(3 downto 0);

signal location : std_logic_vector(7 downto 0);

-- declare intermediate signals for referenced outputs
signal x_coord_int : std_logic_vector(9 downto 0);
signal y_coord_int : std_logic_vector(9 downto 0);
begin
-- drive referenced outputs
x_coord <= x_coord_int;
y_coord <= y_coord_int;


location <= loy & lox;

process (clk_25mHz, rst)
begin
   if rst = '1' then
      clk_cnt <= (others => '0');
      hsync <= '1';
      line_cnt <= (others => '0');
      
      vsync <= '1';
   elsif rising_edge(clk_25mHz) then
   
      x_coord_int <= clk_cnt - std_logic_vector(to_unsigned(144, 10));
      y_coord_int <= line_cnt - std_logic_vector(to_unsigned(33, 10));
      
      if clk_cnt = 0 then
         hsync <= '0';
         clk_cnt <= clk_cnt + 1;
         
      elsif clk_cnt = std_logic_vector(to_unsigned(96, 20)) then
         hsync <= '1';
         clk_cnt <= clk_cnt + 1;
      elsif clk_cnt = std_logic_vector(to_unsigned(799, 20)) then
         line_cnt <= line_cnt + 1;
         clk_cnt <= (others => '0');
      else
         clk_cnt <= clk_cnt + 1;
      end if;
      
      if line_cnt = "0000000000" then
         vsync <= '0';
      elsif line_cnt = "0000000010" then
         vsync <= '1';
      elsif line_cnt = "1000001001" then
         line_cnt <= (others => '0');
         vsync <= '0';
      end if;
      
      if (x_coord_int >= "0000000000" and x_coord_int < "1010000000" and y_coord_int >= "0000000000" and y_coord_int < "0111100000") then
         lox <= x_coord_int(3 downto 0);
         loy <= y_coord_int(3 downto 0);
         if (x_coord_int(9 downto 4) = food_x and y_coord_int(9 downto 4) = ('0' & food_y)) then
            case location is
               when "00000000" =>
                  color <= (others => '0');
               when others =>
                  color <= "000000001111";
            end case;
         elsif snake = std_logic_vector(to_unsigned(none, 2)) then
            color <= "000000000000";
         elsif snake = std_logic_vector(to_unsigned(wall, 2)) then
            color <= "000000000101";
         elsif snake = std_logic_vector(to_unsigned(snake_head, 2)) or snake = std_logic_vector(to_unsigned(snake_body, 2)) then
            case location is
               when "00000000" =>
                  color <= (others => '0');
               when others =>
                  if snake = std_logic_vector(to_unsigned(snake_head, 2)) then
                    color <= head_color;
                  else
                    color <= body_color;
                  end if;
            end case;
         end if;
      else
         color <= (others => '0');
      end if;
   end if;
end process;


end behavioral;
