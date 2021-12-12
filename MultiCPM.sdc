set sys_clk   "${topmodule}pll|altpll_component|auto_generated|pll1|clk[0]"
set mem_clk   "${topmodule}pll|altpll_component|auto_generated|pll1|clk[2]"
set sdram_clk "${topmodule}pll|altpll_component|auto_generated|pll1|clk[3]"


#create_clock -name baud_clk -period 20.000  {Microcomputer:v_top|BRG:brg1|baud_clk}
#create_clock -name IORQ_n_clk -period 20.000  {Microcomputer:v_top|T80s:cpu1|IORQ_n}
#create_clock -name cpuClock -period 20.000  {Microcomputer:v_top|cpuClock}


# Decouple asynchronous clocks
set_clock_groups -asynchronous -group [get_clocks ${hostclk}] -group [get_clocks $sys_clk]
set_clock_groups -asynchronous -group [get_clocks {spiclk}] -group [get_clocks $sys_clk]
set_clock_groups -asynchronous -group [get_clocks {spiclk}] -group [get_clocks $mem_clk]

# Input delays

set_input_delay -clock [get_clocks $sdram_clk] -reference_pin [get_ports ${RAM_CLK}] -max 6.4 [get_ports ${RAM_IN}]
set_input_delay -clock [get_clocks $sdram_clk] -reference_pin [get_ports ${RAM_CLK}] -min 3.2 [get_ports ${RAM_IN}]

# Output delays

set_output_delay -clock [get_clocks $sdram_clk] -reference_pin [get_ports ${RAM_CLK}] -max 1.5 [get_ports ${RAM_OUT}]
set_output_delay -clock [get_clocks $sdram_clk] -reference_pin [get_ports ${RAM_CLK}] -min -0.8 [get_ports ${RAM_OUT}]

set_output_delay -clock [get_clocks $sys_clk] -max 0 [get_ports ${VGA_OUT}]
set_output_delay -clock [get_clocks $sys_clk] -min -5 [get_ports ${VGA_OUT}]


# false paths

set_false_path -to [get_ports ${FALSE_OUT}]
set_false_path -from [get_ports ${FALSE_IN}]

# Multicycles

set_multicycle_path -from [get_clocks $sys_clk] -to [get_clocks $mem_clk] -setup 2
set_multicycle_path -from [get_clocks $sys_clk] -to [get_clocks $mem_clk] -hold 1

set_multicycle_path -from [get_clocks $sdram_clk] -to [get_clocks $mem_clk] -setup 2
set_multicycle_path -from [get_clocks $sdram_clk] -to [get_clocks $mem_clk] -hold 1

set_multicycle_path -to ${VGA_OUT} -setup 2
set_multicycle_path -to ${VGA_OUT} -hold 1


