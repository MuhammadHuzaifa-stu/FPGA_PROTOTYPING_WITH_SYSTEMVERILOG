**Binary to binary-coded-decimal converter.**

**PROCEDURE:**

*Initialize  :* Start with your binary input and a BCD register set to zero.
*Check/Adjust:* Examine each 4-bit BCD nibble. If a nibble is greater than 4 (i.e., $\ge 5$), add 3 to that nibble.
*Shift       :* Shift the entire combined register (Binary + BCD) left by 1 bit.
*Repeat      :* Repeat steps 2 and 3 until all input binary bits have been shifted into the BCD register. 