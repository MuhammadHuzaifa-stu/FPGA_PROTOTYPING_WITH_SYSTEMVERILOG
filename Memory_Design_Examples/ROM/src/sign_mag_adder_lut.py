import os

def sign_mag_add(a_bits, b_bits):
    # Extract sign (bit 3) and magnitude (bits 2:0)
    a_sign = (a_bits >> 7) & 1
    a_mag  = a_bits & 0x7F
    
    b_sign = (b_bits >> 7) & 1
    b_mag  = b_bits & 0x7F

    # Convert to signed integers for calculation
    val_a = a_mag if a_sign == 0 else -a_mag
    val_b = b_mag if b_sign == 0 else -b_mag
    
    res_int = val_a + val_b
    
    # Convert back to Sign-Magnitude
    if res_int >= 0:
        res_sign = 0
        res_mag = abs(res_int)
    else:
        res_sign = 1
        res_mag = abs(res_int)
        
    return (res_sign << 7) | res_mag

file_name = "rom_table.txt"

with open(file_name, "w") as f:
    f.write("case(address)\n")
    for i in range(65536):
        a = (i >> 8) & 0xFF
        b = i & 0xFF
        result = sign_mag_add(a, b)
        f.write(f"    16'h{i:04X}: data_out = 8'h{result:X};\n")
    f.write("    default: data_out = 8'h0;\n")
    f.write("endcase\n")

print(f"Success! '{file_name}' created in: {os.getcwd()}")