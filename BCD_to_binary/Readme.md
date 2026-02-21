**BCD to Binary converter (Reverse Double Dabble)**

**PROCEDURE:**

`Initialize  :` Start with your BCD input and a Binary register set to zero.
`Shift       :` Shift the entire combined register (BCD + Binary) right by 1 bit. (The LSB of the BCD moves into the Binary register).
`Check/Adjust:` Examine each 4-bit BCD nibble. If a nibble is $\ge 8$, subtract 3 from that nibble.
`Repeat      :` Repeat steps 2 and 3 until all binary bits have been shifted into the Binary register.