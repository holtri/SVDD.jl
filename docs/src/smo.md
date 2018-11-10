<style>
.MathJax_Display {
  text-align: left !important;
}
</style>
# SMO

Sequential Minimal Optimization (SMO) is a decomposition method to solve quadratic optimization problems with a specific structure. The original SMO algorithm by John C. Platt has been proposed for Support Vector Machines (SVM). There are several modifications for other types of support vector machines. This section describes the implementation of SMO for Support Vector Data Description (SVDD) [2].

The implementation of SMO for SVDD bases on an adaption of SMO for one-class classification [3]. Therefore, this documentation focuses on the specific adaptions required for SVDD. The following descriptions assume familarity with the basics of SMO [1] and its adaption to one-class SVM [3], and of SVDD [2].

## QP-Problem

SVDD is an optimization problem of the following form.

```math
  \begin{aligned}
  P: \ & \underset{R, a, \xi}{\text{minimize}}
  & & R^2 + \sum_i \xi_i  \\
  & \text{subject to}
  & & \left\Vert \phi(x_{i}) - a \right\Vert^2 \leq R^2 + \xi_i, \; ∀ i \\
  & & & \xi_i \geq 0, \; ∀ i
  \end{aligned}
```

The Lagrangian Dual is:

```math
\begin{aligned}
D: \ & \underset{\alpha}{\text{maximize}}
& & \sum_{i,j}\alpha_i\alpha_jK(i,j) + \sum_i \alpha_iK(i,i)  \\
& \text{subject to}
& & \sum_i\alpha_i = 1 \\
& & & 0 \leq \alpha_i \leq C, \; ∀ i \\
\end{aligned}
```
Solving the Lagrangian gives an optimal $α$.

## Decomposition

The basic idea of SMO is to solve reduced versions of the Lagrangian iteratively.
In each iteration, the reduced version of the Lagrangian consists of only two decision variables, i.e., $\alpha_{i1}$ and $\alpha_{i2}$, while $\alpha_j, j∉\{i1, i2\}$ are fixed.
An iteration of SMO consists of two steps:

1. Select $i1$ and $i2$.
  * The search for a good $i2$ are implemented in [`SVDD.smo`](@ref)
  * There are several heuristics to select $i1$ based on the choice for $i2$. These heuristics are implemented in [`SVDD.examineExample!`](@ref)
2. Solving the reduced Lagrangian for $\alpha_{i1}$ and $\alpha_{i2}$.
  * Implemented in [`SVDD.takeStep!`](@ref)

The iterative procedure converges to the global optimum.

### Step 2: Solving the reduced Lagrangian

The following describes how to infer the optimal solution for a given $\alpha_{i1}$ and $\alpha{i2}$ analytically.

First, $\alpha_{i1}$ and $\alpha_{i2}$ can only be changed in a limited range.
The reason is that after the optimization step, they still have to obey the constraints of the Lagrangian.
From $\sum_i\alpha_i = 1$, one can infer that $Δ = \alpha_{i1} + \alpha_{i2}$ remains constant for one optimization step.
This is, if we add some value to $\alpha_{i2}$, we must remove the same value from $\alpha_{i1}$.
We also know that $\alpha{i} \geq 0$ and $\alpha{i} \leq C$.
From this, one can infer the maximum and minumum value that one can much can add/substract from $\alpha_{i2}$, i.e., one can calculate the lower and the upper bound:

```math
\begin{aligned}
  L &= max(0, \alpha_{i1} + \alpha_{i2} - C)\\
  H &= min(C, \alpha_{i1} + \alpha_{i2})
\end{aligned}
```

(Note: This is slightly different to the original SMO, as one does not need to discern between different labels $y_i \in \{1,-1\}$.)

Second, the optimal value for $\alpha_{i2}$ can be derived analytically by setting the Lagrangian D to 0.

```math
\frac{∇\text{D}}{\delta \alpha_{i2}} = 0
\iff  \alpha*_{i2} = \dots
```

The resulting value is _clipped_ to the feasible interval.

```
if α*_i2 > H
    α'_i2 = H
elseif α*_i2 < L
    α'_i2 = L
end
```
where `α'_i2` is the updated value of `α_2` after the optimization step.   
It follows that

```
  α'_i1 = Δ - α'_i2
```

To allow the algorithm to converge, one has to decide on a threshold whether the updates to the alpha values has been significant, i.e., if the difference between the old and the new value is above a specified precision.
The implementation uses the decision rule from the original SMO [1, p.10], i.e., update alpha values only if

```math
\lvert\alpha_{i2} - \alpha'_{i2} \rvert > \text{opt_precision} * (\alpha_{i2} + \alpha'_{i2} + \text{opt_precision})
```

where `opt_precision` is a parameter of the optimization algorithm.

## Internal API
```@docs
SVDD.examineExample!
```
```@docs
SVDD.smo
```
```@docs
SVDD.takeStep!
```
## References
[1] J. Platt, "Sequential minimal optimization: A fast algorithm for training support vector machines," 1998.

[2] D. M. J. Tax and R. P. W. Duin, "Support Vector Data Description,"" Mach. Learn., 2004.

[3] B. Schölkopf, J. C. Platt, J. Shawe-Taylor, A. J. Smola, and R. C. Williamson, "Estimating the support of a high-dimensional distribution,"" Neural Comput., 2001.