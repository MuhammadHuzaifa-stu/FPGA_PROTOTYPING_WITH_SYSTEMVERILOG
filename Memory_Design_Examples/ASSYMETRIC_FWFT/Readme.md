### Assymetric FWFT

Used synchronous write and assynchronous read register file.
The output is availble before the rd_en asserted.
Controlling the register files wr,rd,wr/rd_addrs using fifo_controller to make it a buffer based on a circular queue.  
Output is half the width of input(write).