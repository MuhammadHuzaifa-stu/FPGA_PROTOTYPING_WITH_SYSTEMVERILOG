This project implements a rotating square wave generator. The functionality is controlled by two signals:

- **`en` (Enable Signal):** Determines whether the wave is active or paused.  
    - `1`: The wave runs.  
    - `0`: The wave stops at its current position.

- **`rot` (Rotation Direction):** Specifies the direction of rotation.  
    - `0`: Counter-clockwise rotation.  
    - `1`: Clockwise rotation.

This design is ideal for applications requiring directional control of square wave patterns.