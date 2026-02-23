**Implemented a FIFO using FWFT (First Word Fall Through)**

This design uses a synchronous write and asynchronous read register file. The output becomes available even before the `rd_en` signal is asserted. The `fifo_controller` manages the register file's `wr`, `rd`, and `wr/rd_addrs` signals, enabling the buffer to function as a circular queue.

**Note:**
FIFO and FWFT are similar, with the key difference being that FIFO registers read data, while FWFT provides data asynchronously. So,  a FIFO can be achieved by registering the output read of FWFT.
