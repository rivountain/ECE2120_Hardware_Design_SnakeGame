library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- top of the game, connection of each component
entity snake_game is
  Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        
        left : in STD_LOGIC;
        right : in STD_LOGIC;
        up : in STD_LOGIC;
        down : in STD_LOGIC;
        
        hsync : out STD_LOGIC;
        vsync : out STD_LOGIC;
        color : out STD_LOGIC_VECTOR(11 downto 0);
        output_seg7 : out STD_LOGIC_VECTOR(7 downto 0);
        an : out STD_LOGIC_VECTOR(3 downto 0));
end snake_game;

architecture Behavioral of snake_game is

component segment_ctrl is
generic (
   restart      : integer
);
port (
   clk          : in std_logic;
   rst          : in std_logic;
   add_block     : in std_logic;
   game_state  : inout std_logic_vector(1 downto 0);
   output_seg7      : out std_logic_vector(7 downto 0);
   an          : out std_logic_vector(3 downto 0)
);
end component;

component button_ctrl is
port (
   clk              : in std_logic;
   rst              : in std_logic;
   left, right, up ,down  : in std_logic;
   left_btn_press, right_btn_press, up_btn_press, down_btn_press   : out std_logic
);
end component;

component snake_grow is
port (
   clk       : in std_logic;
   rst       : in std_logic;
   
   head_x, head_y    : in std_logic_vector(5 downto 0);
   food_x    : out std_logic_vector(5 downto 0);
   food_y    : out std_logic_vector(4 downto 0);
   add_block : out std_logic
);
end component;

component vga_ctrl is
generic (
   none        : integer;
   snake_head  : integer;
   snake_body  : integer;
   wall        : integer;
   head_color  : std_logic_vector(11 downto 0);
   body_color  : std_logic_vector(11 downto 0)
);
port (
   clk_25mHz   : in std_logic;
   rst         : in std_logic;
   snake       : in std_logic_vector(1 downto 0);
   food_x      : in std_logic_vector(5 downto 0);
   food_y      : in std_logic_vector(4 downto 0);
   x_coord, y_coord       : out std_logic_vector(9 downto 0);
   hsync, vsync           : out std_logic;
   color       : out std_logic_vector(11 downto 0)
);
end component;

component game_state_signal is
   generic (
      RESTART_G    : integer;
      start        : integer;
      play         : integer;
      die          : integer
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
end component;

component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_25mHz         : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

component snake is
   generic (
      up           : integer;
      down         : integer;
      left         : integer;
      right        : integer;
      
      none         : integer;
      snake_head         : integer;
      snake_body   : integer;
      wall         : integer;
      
      restart      : integer;
      play         : integer
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
      add_block     : in std_logic;
      game_status  : in std_logic_vector(1 downto 0);
      block_num     : out std_logic_vector(6 downto 0);
      hit_body     : out std_logic;
      hit_wall     : out std_logic;
      die_flash    : in std_logic
   );
end component;

signal clk_25mHz:std_logic;
signal add_block:std_logic;
signal game_state:std_logic_vector(1 downto 0);
signal rst_neg:std_logic;
signal left_btn_press, right_btn_press, up_btn_press, down_btn_press:std_logic;
signal snake:std_logic_vector(1 downto 0);
signal x_coord, y_coord:std_logic_vector(9 downto 0);
signal food_x:std_logic_vector(5 downto 0);
signal food_y:std_logic_vector(4 downto 0);
signal head_x,head_y:std_logic_vector(5 downto o);
signal body_crash, wall_crash, die_blink, restart:std_logic;

begin

rst_neg <= not rst;

clk_gen:clk_wiz_0 port map (clk_in1 => clk,
                           reset => rst,
                           clk_25mHz => clk_25mHz);
                           
seg_display:segment_ctrl port map (clk => clk,
                                  rst => rst_neg,
                                  add_block => add_block,
                                  game_state => game_state,
                                  output_seg7 => output_seg7,
                                  an => an);
                                 
btn_ctrl:button_ctrl port map (clk => clk,
                              rst => rst_neg,
                              add_block => add_block,
                              left => left,
                              right => right,
                              up => up,
                              down => down,
                              left_btn_press => left_btn_press,
                              right_btn_press => lright_btn_press,
                              up_btn_press => up_btn_press,
                              down_btn_press => down_btn_press);
                              
snake_growth:snake_grow port map (clk => clk,
                                 rst => rst_neg,
                                 food_x => food_x,
                                 food_y => food_y,
                                 body_x => head_x,
                                 body_y => head_y,
                                 add_block => add_block);

VGA_ouput:vga_ctrl port map (clk_25mHz => clk_25mHz,
                            rst => rst,
                            snake => snake,
                            food_x => food_x,
                            food_y => food_y,
                            x_coord => x_coord,
                            y_coord => y_coord,
                            hsync => hsync,
                            vsync => vsync,
                            color => color);
                            
snake_entity:snake port map (clk => clk,
                            rst => rst_neg,
                            left_press => left_btn_press,
                            right_press => right_btn_press,
                            up_press => up_btn_press,
                            down_press => down_btn_press,
                            snake => snake,
                            x_coord => x_coord,
                            y_coord => y_coord,
                            head_x => head_x,
                            head_y => head_y,
                            add_block => add_block,
                            game_state => game_state,
                            hit_body => body_crash,
                            hit_wall => wall_crash,
                            die_flash => die_blink);
                            
controller: game_state_signal port map(clk => clk,
                                      rst => rst_neg,
                                      btn1_press => left_btn_press,
                                      btn2_press => right_btn_press,
                                      btn3_press => up_btn_press,
                                      btn4_press => down_btn_press,
                                      game_state => game_state,
                                      hit_wall => wall_crash,
                                      hit_body => body_crash,
                                      die_flash => die_blink,
                                      restart => restart);
end Behavioral;
