# SunQuarTeX Example - enart
sun123zxy
2023-08-10

# First

This is a reference \[1, p. 1\].

SunQuarTeX is powered by Quarto and LaTeX.

<div id="exm-rtimesn" class="theorem example">

<span class="theorem-title">**Example 1**</span> Prove that
$$
\mathbb R \times \mathbb N \approx \mathbb N \times \mathbb R \approx \mathbb R
$$

</div>

<div class="proof">

<span class="proof-title">*Proof*. </span>Obvious as follows
$$
\mathbb R \approx \mathbb R \times 2 \preccurlyeq \mathbb R \times \mathbb N \preccurlyeq \mathbb R \times \mathbb R \approx \mathbb R
\implies \mathbb R \times \mathbb N \approx \mathbb N \times \mathbb R \approx \mathbb R
$$

</div>

# Second

<div id="tbl-panel-unsolved">

<div id="tbl-cartesian-unsolved">

|                  |             |             |             |
|:----------------:|:-----------:|:-----------:|:-----------:|
| $L_i \times C_j$ |     $2$     | $\mathbb N$ | $\mathbb R$ |
|       $2$        |     $4$     | $\mathbb N$ | $\mathbb R$ |
|   $\mathbb N$    | $\mathbb N$ | $\mathbb N$ |      ?      |
|   $\mathbb R$    | $\mathbb R$ |      ?      | $\mathbb R$ |

(a) Cartesian (unsolved)

</div>

<div id="tbl-power-unsolved">

|             |             |             |                 |
|:-----------:|:-----------:|:-----------:|:---------------:|
| $L_i^{C_j}$ |     $2$     | $\mathbb N$ |   $\mathbb R$   |
|     $2$     |     $4$     | $\mathbb R$ | $2^{\mathbb R}$ |
| $\mathbb N$ | $\mathbb N$ |      ?      |        ?        |
| $\mathbb R$ | $\mathbb R$ |      ?      |        ?        |

(b) Power (unsolved)

</div>

Table 1: Some Cardinality Results

</div>

# Code

``` cpp
#include<bits/stdc++.h>
using namespace std;

int main(){
    return 0; // 返回 0
}
```

``` lean
example : (∀ x, p x → r) → ((∃ x, p x) → r) := by
  intro h ⟨a, hpa⟩ -- you may also `rcases` explicitly
  exact h a hpa
```

<div id="refs" class="references csl-bib-body" entry-spacing="0">

<div id="ref-deepface" class="csl-entry">

<span class="csl-left-margin">\[1\] </span><span class="csl-right-inline">Y. Taigman, M. Yang, M. Ranzato, and L. Wolf, “Closing the gap to human-level performance in face verification. deepface,” in *Proceedings of the IEEE computer vision and pattern recognition (CVPR)*, p. 6.</span>

</div>

</div>
