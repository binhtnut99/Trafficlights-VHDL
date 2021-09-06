library IEEE;                                                                                  --
use IEEE.STD_LOGIC_1164.ALL;                                                                   --
use IEEE.numeric_std.ALL;                                                                      --
--use IEEE.STD_LOGIC_ARITH.ALL;                                                                --
use IEEE.STD_LOGIC_UNSIGNED.ALL;                                                               --khai báo thư viện
entity control is                                                                              --
    Port ( clk_1  : in  STD_LOGIC;                                                             --tín hiệu clk_1 1 giây lấy từ toptraficclight
           rst ,but   : in  STD_LOGIC;                                                         --nút rst và đổi chế độ
																							   --
           D1     : out  STD_LOGIC_VECTOR (2 downto 0);                                        --3 đèn giao thông
           D2     : out  STD_LOGIC_VECTOR (2 downto 0);                                        --
           D3     : out  STD_LOGIC_VECTOR (2 downto 0);                                        --
           BCD_1CH : out unsigned(3 downto 0);                                                 --
		   BCD_1DV : out unsigned(3 downto 0);                                                 --
		   BCD_2CH:  out unsigned(3 downto 0);                                                 --đầu ra các led 7 thanh
		   BCD_2DV : out unsigned(3 downto 0);                                                 --
		   BCD_3CH: out unsigned(3 downto 0);                                                  --
		   BCD_3DV: out unsigned(3 downto 0));                                                 --
end control;                                                                                   --
																							   --
architecture Behavioral of control is                                                          --
   type states is (s0,s1,s2,s3,s4,s5,s6,s7);                                                   --khai báo máy trạng thái từ s0 đến s7
   signal state: states;                                                                       --
    signal dem1:  integer range 0 to 79; 	                                                   --biến đếm từ 0 đến 79
  signal dem:  integer;  	                                                                   --
   signal num110,num10: integer range 0 to 9;                                                  --
   signal num220,num20: integer range 0 to 9;                                                  --
   signal num330,num30: integer range 0 to 9;	                                               --
   signal bcd_1, bcd_11, bcd_2, bcd_22, bcd_3, bcd_33 : unsigned(3 downto 0) := (others=>'0'); --
begin                                                                                          --
																							   --
																							   --
p1:  process (clk_1,rst)                                                                       --chương trình đếm thời gian theo xung clk_1
         begin                                                                                 --
            if(rst='0' ) then                                                                  -- 
				        dem<=79;                                                               --nếu rst==0 thì đếm = 79
            elsif( falling_EDGE (clk_1))then                                                   --nếu rst==1 và có sườn lên xung clk_1 sau đó
                    if(dem=0 )then                                                             --nếu dem==0 thì 
                         dem <=79; 								                               --	dem==79
								 else                                                          --		ngược lại dem giảm 1 đơn vị
								  dem<=dem-1;                                                  --
																							   --
				        end if;                                                                --=> đoạn này sẽ giảm biến đếm từ 79 về 0. nếu =0 thì đặt lại bằng 79
				end if;                                                                        --
				if ( rst = '1' and but = '0') then                                             --nếu rst=1 và nút đổi chế độ =0 thì dem=0
																							   --
				        dem<=0;                                                                --
				end if;			                                                               --
		end process;                                                                           --
																							   --
p2: process(dem,rst,but)                                                                       --
      begin                                                                                    --
         if(rst='0' )then                                                                      --nếu rst=0 thì
           state<=s0;                                                                          --trạng thái chuyển sang s0
         elsif(dem>=65 and dem<=79)then                                                        --nếu đếm lớn hơn 65 và nhỏ hơn 79 thì
           state<=s1;                                                                          --trạng thái chuyển sang s1
         elsif(dem>=60 and dem<=65)then                                                        --nếu đếm lớn hơn 60 và nhỏ hơn 65 thì
           state<=s2;                                                                          --trạng thái chuuyển sang s2
         elsif(dem>=55 and dem<=60)then                                                        --
           state<=s3;                                                                          --
	      elsif(dem>=35 and dem<=55)then                                                       --
          state<=s4;                                                                           --
	      elsif(dem>=5 and dem<=35)then                                                        --
          state<=s5;                                                                           --
         elsif(dem>=1 and dem<=5)then                                                          --
          state<=s6;  	                                                                       --
		   elsif(dem=0)then                                                                    --
          state<=s7;                                                                           --
		end if;                                                                                --
																							   --
     end process;                                                                              --
																							   --
 p3: process(state)                                                                            --
     begin                                                                                     --
        case state is                                                                          --
          when s0=>D1<="000";                                                                  --khi trạng thái là s0 thì tắt hết các đèn giao thông
                   D2<="000";                                                                  --
				   D3<="000";                                                                  --
																							   --
          when s1=>D1<="001";                                                                  --khi trạng thái là s1 thì đèn D1 màu đỏ đèn D2 và D3 màu xanh
                   D2<="100";                                                                  --
				   D3<="100";                                                                  --
																							   --
          when s2=>D1<="001";                                                                  --
                   D2<="100";                                                                  --
				   D3<="010";                                                                  --
																							   --
          when s3=>D1<="001";                                                                  --
                   D2<="010";                                                                  --
				   D3<="001";				                                                   --
																							   --
          when s4=>D1<="001";                                                                  --
                   D2<="001";                                                                  --
				   D3<="001";                                                                  --
																							   --
          when s5=>D1<="100";                                                                  --
                   D2<="001";                                                                  --
				   D3<="001";                                                                  --
																							   --
          when s6=>D1<="010";                                                                  --
                   D2<="001";                                                                  --
				   D3<="001";                                                                  --
																							   --
		  when s7=>D1<="010";                                                                  --
                   D2<="010";                                                                  --
				   D3<="010";	                                                               --
																							   --
																							   --
    end case;                                                                                  --
    end process;                                                                               --
																							   --
p4:process(rst,dem)                                                                            --
  begin                                                                                        --
     if (rst='0') then                                                                         --
       num110<=0;  num10<=0;                                                                   --
	  elsif(dem<=79 and dem>=75)then                                                           --
       num110<=4;  num10<=dem-75;                                                              --chia lấy hàng chục và đơn vị (44,43,42,41,40)
     elsif(dem<=74 and dem>=65)then                                                            --
       num110<=3;  num10<=dem-65;                                                              --                             (39,38,37,36,35...30)
     elsif(dem<=64 and dem>=55)then                                                            --
       num110<=2;  num10<=dem-55;                                                              --
     elsif(dem<=54 and dem>=45)then                                                            --
       num110<=1;  num10<=dem-45;                                                              --
     elsif(dem<=44 and dem>=35)then                                                            --
       num110<=0;  num10<=dem-35;                                                              --
     elsif(dem<=34 and dem>=25)then                                                            --
       num110<=2;  num10<=dem-25;                                                              --
     elsif(dem<=24 and dem>=15)then                                                            --
       num110<=1;  num10<=dem-15;                                                              --
     elsif(dem<=14 and dem>=5)then                                                             --
       num110<=0;  num10<=dem-5;                                                               --
     elsif(dem>=0 and dem<5)then                                                               --
       num110<=0;  num10<=dem;                                                                 --
    end if;                                                                                    --
   end process;                                                                                --
																							   --
p5:process(num110)                                                                             --
 begin                                                                                         --
   case num110 is                                                                              --
       when 0 =>bcd_1<="0000" ;	                                                               --giải mã chuyển ra đầu ra hàng chục 
       when 1 =>bcd_1<="0001" ;                                                                --
       when 2 =>bcd_1<="0010" ;                                                                --
       when 3 =>bcd_1<="0011" ;                                                                --
       when 4 =>bcd_1<="0100" ;                                                                --
		 when 5 =>bcd_1<="0101" ;                                                              --
       when 6 =>bcd_1<="0110" ;                                                                --
       when 7 =>bcd_1<="0111" ;                                                                --
       when 8 =>bcd_1<="1000" ;                                                                --
       when 9 =>bcd_1<="1001" ;                                                                --
  when others =>bcd_1<="0000";                                                                 --
      end case;                                                                                --
 end process;                                                                                  --
																							   --
p6: process(num10)                                                                             --
 begin                                                                                         --
     case num10 is                                                                             --giải mã chuyển ra đầu ra hàng đơn vị
       when 0 =>bcd_11<="0000" ;	                                                           --
       when 1 =>bcd_11<="0001" ;                                                               --
       when 2 =>bcd_11<="0010" ;                                                               --
       when 3 =>bcd_11<="0011" ;                                                               --
       when 4 =>bcd_11<="0100" ;                                                               --
       when 5 =>bcd_11<="0101" ;                                                               --
       when 6 =>bcd_11<="0110" ;                                                               --
       when 7 =>bcd_11<="0111" ;                                                               --
       when 8 =>bcd_11<="1000" ;                                                               --
       when 9 =>bcd_11<="1001" ;                                                               --
       when others =>bcd_11<="0000" ;                                                          --
		 end case;                                                                             --
  end process;                                                                                 --
p7:process(rst,dem)                                                                            --
  begin                                                                                        --
     if (rst='0') then                                                                         --
       num220<=0;  num20<=0;                                                                   --
	  elsif(dem<=79 and dem>=70)then                                                           --
       num220<=1;  num20<=dem-70;                                                              --
     elsif(dem<=69 and dem>=60)then                                                            --
       num220<=0;  num20<=dem-60;                                                              --
     elsif(dem<=59 and dem>=55)then                                                            --
       num220<=0;  num20<=dem-55;                                                              --
     elsif(dem<=54 and dem>=50)then                                                            --
       num220<=5;  num20<=dem-50;                                                              --
     elsif(dem<=49 and dem>=40)then                                                            --
       num220<=4;  num20<=dem-40;                                                              --
     elsif(dem<=39 and dem>=30)then                                                            --
       num220<=3;  num20<=dem-30;                                                              --
     elsif(dem<=29 and dem>=20)then                                                            --
       num220<=2;  num20<=dem-20;                                                              --
     elsif(dem<=19 and dem>=10)then                                                            --
       num220<=1;  num20<=dem-10;                                                              --
     elsif(dem>=0 and dem<10)then                                                              --
       num220<=0;  num20<=dem;                                                                 --
    end if;                                                                                    --
   end process;                                                                                --
																							   --
p8:process(num220)                                                                             --
 begin                                                                                         --
   case num220 is                                                                              --
       when 0 =>bcd_2<="0000" ;	                                                               --
       when 1 =>bcd_2<="0001" ;                                                                --
       when 2 =>bcd_2<="0010" ;                                                                --
       when 3 =>bcd_2<="0011" ;                                                                --
       when 4 =>bcd_2<="0100" ;                                                                --
       when 5 =>bcd_2<="0101" ;                                                                --
		 when 6 =>bcd_2<="0110" ;                                                              --
       when 7 =>bcd_2<="0111" ;                                                                --
       when 8 =>bcd_2<="1000" ;                                                                --
       when 9 =>bcd_2<="1001" ;                                                                --
		 when others =>bcd_2<="0000";                                                          --
      end case;                                                                                --
 end process;                                                                                  --
p9:process(num20)                                                                              --
 begin                                                                                         --
   case num20 is                                                                               --
       when 0 =>bcd_22<="0000" ;	                                                           --
       when 1 =>bcd_22<="0001" ;                                                               --
       when 2 =>bcd_22<="0010" ;                                                               --
       when 3 =>bcd_22<="0011" ;                                                               --
       when 4 =>bcd_22<="0100" ;                                                               --
       when 5 =>bcd_22<="0101" ;                                                               --
       when 6 =>bcd_22<="0110" ;                                                               --
       when 7 =>bcd_22<="0111" ;                                                               --
       when 8 =>bcd_22<="1000" ;                                                               --
       when 9 =>bcd_22<="1001" ;                                                               --
      when others =>bcd_22<="0000";                                                            --
      end case;                                                                                --
 end process;                                                                                  --
 p10:process(rst,dem)                                                                          --
  begin                                                                                        --
     if (rst='0') then                                                                         --
       num330<=0;  num30<=0;                                                                   --
	  elsif(dem<=79 and dem>=75)then                                                           --
       num330<=1;  num30<=dem-75;                                                              --
     elsif(dem<=74 and dem>=65)then                                                            --
       num330<=0;  num30<=dem-65;                                                              --
     elsif(dem<=64 and dem>=60)then                                                            --
       num330<=0;  num30<=dem-60;                                                              --
     elsif(dem<=59 and dem>=50)then                                                            --
       num330<=5;  num30<=dem-50;                                                              --
     elsif(dem<=49 and dem>=40)then                                                            --
       num330<=4;  num30<=dem-40;                                                              --
     elsif(dem<=39 and dem>=30)then                                                            --
       num330<=3;  num30<=dem-30;                                                              --
     elsif(dem<=29 and dem>=20)then                                                            --
       num330<=2;  num30<=dem-20;                                                              --
     elsif(dem<=19 and dem>=10)then                                                            --
       num330<=1;  num30<=dem-10;                                                              --
     elsif(dem>=0 and dem<10)then                                                              --
       num330<=0;  num30<=dem;                                                                 --
    end if;                                                                                    --
   end process;                                                                                --
																							   --
p11:process(num330)                                                                            --
 begin                                                                                         --
   case num330 is                                                                              --
       when 0 =>bcd_3<="0000" ;	                                                               --
       when 1 =>bcd_3<="0001" ;                                                                --
       when 2 =>bcd_3<="0010" ;                                                                --
       when 3 =>bcd_3<="0011" ;                                                                --
       when 4 =>bcd_3<="0100" ;                                                                --
       when 5 =>bcd_3<="0101" ;                                                                --
		 when 6 =>bcd_3<="0110" ;                                                              --
       when 7 =>bcd_3<="0111" ;                                                                --
       when 8 =>bcd_3<="1000" ;                                                                --
       when 9 =>bcd_3<="1001" ;                                                                --
  when others =>bcd_3<="0000";                                                                 --
      end case;                                                                                --
 end process;                                                                                  --
																							   --
p12: process(num30)                                                                            --
 begin                                                                                         --
     case num30 is                                                                             --
       when 0 =>bcd_33<="0000" ;	                                                           --
       when 1 =>bcd_33<="0001" ;                                                               --
       when 2 =>bcd_33<="0010" ;                                                               --
       when 3 =>bcd_33<="0011" ;                                                               --
       when 4 =>bcd_33<="0100" ;                                                               --
       when 5 =>bcd_33<="0101" ;                                                               --
       when 6 =>bcd_33<="0110" ;                                                               --
       when 7 =>bcd_33<="0111" ;                                                               --
       when 8 =>bcd_33<="1000" ;                                                               --
       when 9 =>bcd_33<="1001" ;                                                               --
		 when others =>bcd_33<="0000";                                                         --
 end case;                                                                                     --
  end process;                                                                                 --
   BCD_1CH  <= bcd_1;                                                                          --
	BCD_1DV<= bcd_11;                                                                          --
	BCD_2CH <= bcd_2;                                                                          --
	BCD_2DV<= bcd_22;                                                                          --
	BCD_3CH <= bcd_3;                                                                          --
	BCD_3DV <= bcd_33;                                                                         --
																							   --
end Behavioral;                                                                                --
