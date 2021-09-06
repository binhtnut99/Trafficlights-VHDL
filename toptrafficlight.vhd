library ieee;                                                                                 --
use ieee.std_logic_1164.ALL;                                                                  --
use ieee.numeric_std.ALL;                                                                     -- khai báo sử dụng thư viện
                                                                                              --
entity toptrafficlight is                                                                     -- 
   port (                                                                                     -- thực thể chính
          clk           : in    std_logic;                                                    -- clock hệ thống
          rst  ,but         : in    std_logic;                                                -- nút nhấn reset và nút đổi trạng thái
          to_LED : out unsigned(6 downto 0);                                                  -- tín hiệu quét 7 thanh led
          Selected_digit : out unsigned(5 downto 0);                                          -- tín hiệu chọn led sáng
            Dot : out std_logic;                                                              -- tín hiệu dấu chấm trên led
          D1            : out   std_logic_vector (2 downto 0);                                -- đèn giao thông (xanh)
          D2            : out   std_logic_vector (2 downto 0);                                -- đèn giao thông (vàng)
          D3            : out   std_logic_vector (2 downto 0));                               -- đèn giao thông (đỏ)
end toptrafficlight;                                                                          --
                                                                                              --
architecture BEHAVIORAL of toptrafficlight is                                                 --
  signal bcd_1, bcd_11, bcd_2, bcd_22, bcd_3, bcd_33 : unsigned(3 downto 0) := (others=>'0'); -- tín hiệu mã led
  signal     clk_5M,clk_1hz : std_logic;                                                      -- tín hiệu clock
  BEGIN                                                                                       --
                                                                                              --
chia10ena : entity  work.CHIA_10ENA                                                           -- gọi chương trình CHIA_10ENA
      port map                                                                                --
       (                                                                                      --
        Clock => Clk,                                                                         -- nối clk hệ thống đến Clock của CHIA_10ENA
        ENA1HZ=> clk_1hz,                                                                     -- nối tín hiệu ENA1HZ đến clk_1hz để đếm thời gian (1 giây)
        ENA5MHZ => clk_5M);                                                                   -- nối tín hiệu ENA5MHZ đến clk_5M để quét led 7 thanh
SEG7: entity work.Seven_segment                                                               -- gọi chương trình Seven_segment
        port map                                                                              --
        (                                                                                     --
            clock => clk_5M,                                                                  -- nối clock từ Seven_segment đến clk_5M
            bcd_1 => bcd_1,                                                                   -- nối bcd_1 từ toptrafficligt đến bcd_1 Seven_segment ( tùy theo in hoặc out)
            bcd_11 => bcd_11,                                                                 -- 
            bcd_2 => bcd_2,                                                                   --
            bcd_22 => bcd_22,                                                                 --
            bcd_3 => bcd_3,                                                                   --
            bcd_33 => bcd_33,                                                                 --
            to_LED => to_LED,                                                                 --
            Selected_digit => Selected_digit,                                                 --
            Dot => Dot                                                                        --
        );                                                                                    --
CONTROLLER: entity work.control                                                               -- gọi chương trình control
 PORT MAP(                                                                                    --
        clk_1 => clk_1hz,                                                                     -- nối clk_1 từ control đến clk_1hz ở optrafficlight
        rst=>rst,                                                                             --
        but=>but,                                                                             --
        D1=>D1,                                                                               --
        D2=>D2,                                                                               --
        D3=>D3,                                                                               --
        BCD_1CH => bcd_11,                                                                    --
        BCD_1DV => bcd_1,                                                                     --
        BCD_2CH => bcd_22,                                                                    --
        BCD_2DV => bcd_2,                                                                     --
        BCD_3CH => bcd_33,                                                                    --
        BCD_3DV => bcd_3                                                                      --
    );                                                                                        --
end BEHAVIORAL;                                                                               --
