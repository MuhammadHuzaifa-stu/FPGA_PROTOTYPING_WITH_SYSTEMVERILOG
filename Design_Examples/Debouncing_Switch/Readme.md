Description

### Input:
- **Key3**: Mapped to `button[0]` -> clear -> keys are active low (default fpga sees `1` on press it sees `0`)
- **Key2**: Mapped to `button[1]` -> button_input -> keys are active low (default fpga sees `1` on press it sees `0`)

### Output:
- **First Four Digital Tubes**:
    - **Leftmost Two Tubes**: Display the counter for the **level detector**.
    - **Second Two Tubes**: Display the counter for the **debounced switch**.

This setup ensures clear visualization of both the level detection and debouncing functionality.
You'll notice, level counter (leftmost two tubes) are showing random values, it is because due to button debounces counter increments so fast(since frequency=200MHz) that it appears the tube is showing random numbers but that is not the case. While on the other hand on each button press you'll see the debouncer counter (next two tubes) is incrementing once per buttin click.   

Also, an early debounce detection code is available in the `./src1` for reference.