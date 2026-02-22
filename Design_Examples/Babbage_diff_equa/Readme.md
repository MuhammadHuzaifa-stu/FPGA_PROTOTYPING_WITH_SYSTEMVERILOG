# Babbage Difference Engine Implementation
**Target Equation:** $f(n) = 2n^2 + 3n + 5$

## 📐 Overview
This module implements a quadratic equation solver using the **Method of Finite Differences**, famously utilized by Charles Babbage. By breaking down a quadratic into recursive additions, we eliminate the need for hardware multipliers (DSP slices), resulting in a highly area-efficient design.

## 🧠 Mathematical Decomposition
The quadratic is broken down into two levels of recursive equations:

### 1. The First Difference: $g(n)$
Calculates the variable rate of change.
* **Base Case:** $g(1) = 5$
* **Recursive Step:** $g(n) = g(n-1) + 4$ 
> *Note: '4' is the constant second difference ($2 \times a$) for any $an^2$ term.*

### 2. The Final Value: $f(n)$
Accumulates the changes to find the quadratic result.
* **Base Case:** $f(0) = 5$
* **Recursive Step:** $f(n) = f(n-1) + g(n)$

---

## 📝 Example Trace
For an input of **$n = 2$**:
1. **Initial:** $f = 5$.
2. **Step 1 ($n=1$):** $f = 5 + g(1) = 10$.
3. **Step 2 ($n=2$):** $g$ becomes $5 + 4 = 9$. $f = 10 + 9 = 19$.
4. **Result:** $f(2) = 19$.