
### Generating Clocking Wizard
In order to generate a clocking wizard of 200MHz input to 100MHz output. First place the clocking_wizard IP into ypur project using IP_block_generator then run the following command:

set_property -dict [list CONFIG.PRIM_IN_FREQ {200.000} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.000}] [get_ips *clk_wiz*]