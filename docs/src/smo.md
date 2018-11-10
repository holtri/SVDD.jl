<style>
.MathJax_Display {
  text-align: left !important;
}
</style>
# SMO

Sequential Minimal Optimization (SMO) is a decomposition method to solve quadratic optimization problems with a specific structure. The original SMO algorithm by John C. Platt has been proposed for Support Vector Machines (SVM). There are several modifications for other types of support vector machines. This section describes the implementation of SMO for Support Vector Data Description (SVDD).

## QP-Problem

SVDD is an optimization problem of the following form.

$$
  \begin{aligned}
  & \underset{R, a, \xi}{\text{minimize}}
  & & R^2 + \sum_i \xi_i  \\
  & \text{subject to}
  & & \left\Vert \phi(x_{i}) - a \right\Vert^2 \leq R^2 + \xi_i, \; ∀ i \\
  & & & \xi_i \geq 0, \; ∀ i
  \end{aligned}
$$

The Lagrangian is:

$$
\begin{aligned}
& \underset{\alpha}{\text{maximize}}
& & \sum_{i,j}\alpha_i\alpha_jK(i,j) + \sum_i \alpha_iK(i,i)  \\
& \text{subject to}
& & \sum_i\alpha_i = 1 \\
& & & 0 \leq \alpha_i \leq C, \; ∀ i \\
\end{aligned}
$$
Solving the Lagrangian gives an optimal $α$.

## Decomposition

The basic idea of SMO is to iteratively solve reduced versions of the Lagrangian.
In each iteration, the reduced version of the Lagrangian consists of only two decision variables, i.e., $\alpha_{i1}$ and $\alpha_{i2}$, while all other $\alpha_j, j∉\{i1, i2\}$ are fixed.
So one iteration of SMO consists of two steps:

1. Selecting $i1$ and $i2$
2. Solving the reduced Lagrangian for $\alpha_{i1}$ and $\alpha_{i2}$.

This iterative procedure converges to the global optimum.

### Solving the reduced Problem

## References
[1] J. Platt, "Sequential minimal optimization: A fast algorithm for training support vector machines", 1998.
