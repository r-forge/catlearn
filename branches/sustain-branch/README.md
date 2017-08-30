SUSTAIN

---

# TODO

- [x] Make st
    - [x] ```solved``` ~~What about stimuli's dimensions? Should it be specified in st for supervised learning? how does it work for unsupervised learning?~~
- [x] Create training matrix from nosof94train in catlearn
- [x] Create training matrix from billman and knutson 1996
- [x] Create st for each tr

## Input Parameters

### TR
**x<sub>1</sub>, x<sub>2</sub>, x<sub>3</sub>** - stimulus' dimensions
**stim** - stimulus' number
**cat or feedback?** - classification category; either present (_supervised_, e.g. A, B, C, ...) or not present (_unsupervised_, 0)
**m<sub>1</sub>, m<sub>2</sub>, m<sub>3</sub>** - missing dimensions and category label - _might be able to use value 2 in x<sub>n</sub>_

### ST
- [x] weights?

### Output
- [x] mode of cluster with highest activation and which cluster
- [x] number of clusters recruited with cluster's positions in stimuli space
- [x] winning H<sub>j</sub> with its H<sub>j</sub><sup>act</sup>


### Code
- [x] ~~**cluster is a three dimensional array**~~
- [x] ~~dims (v<sub>i</sub>) contain the list of the numbers of possible nominal values for each stimuli dimension, for example~~

\[ v_{i} = \left| \begin{array}{ccc}
\ 3 \ (square, circle, triangle) \\
\ 2 \ (light, dark)\\
\ 2 \ (large, small) \end{array} \right|\]

  - [x] if cluster = 0,  then the initial cluster is created according to number of possible values available on given stimulus' dimension. _for example, according to the ~~above dims~~ **input representation**_

  \[ H_{j}^{pos_{ik}} = \left| \begin{array}{ccc}
   \ 0 & 1 & 1 \\
   \ 1 & 0 & 0 \\
   \ 0 & NA & NA \end{array} \right|\]

- [x] extract things from **st**
- [x] not all parameters have to be present (e.g. lambda, tau), so should they be specified in st or in the command?
    - [x] ```solved``` ~~**lambda** not always specified~~ if it is zero, than lambda<sub>i</sub> = 1.0
    - [x] ```solved``` ~~**tau** _threshold_ is not always present~~ set to zero && only use tau if tr["t"] = 0


#### Input Representation
- [x] `solved` ~~I<sup>pos<sub>ik</sub></sup> can have different lengths within the same stimuli and I don't know how to engineer it in R yet~~
    - `solved` ~~_99_ is treated as a missing value or should it be just _NA_?~~
- [x] `solved` ~~Padded slp representation~~

| a1  | a2  | a3 | b1 | b2 | c1 | c2 |
|---|---|---|---|---|---|---|
|  0 |  1 | 0 | 0 | 1 | 1 | 0 |

- [x] `solved`~~in an unsupervised learning situation with quired dimension?~~

---

### Equations

- [x] ~~Equation 4~~
    - [x] `solved` ~~dimension's position in a given cluster: _**j**th's position of **k** cluster is put into **k** row and **j** coloumn_~~
    - [x] `solved` ~~**absolute** value or **length** or what else?~~ \| I<sup>pos<sub>ik</sub></sup> - H<sub>j</sub><sup>pos<sub>ik</sub></sup> \|
    - [x] ~~input representation within the framework of slp will change how it is engineered~~
    - [x] rewrite EQ4 to accomodate
- [x] ~~Equation 5~~
    - [x] correct mu dimensions (cluster = row; dimension = coloumn)
    - [x] lambda<sub>i</sub> to the power, the power is messy and incorrect
- [x] Equation 6
    - [x] `competing clusters reduces the confidence in chose one` ~~**the activation of the winning cluter is less??**~~
    - [x] select winning H<sub>j</sub>
    - [x] formulate equation
    - [x] update H<sub>j</sub><sup>out</sup> with ```if (cond) expr```
    - [x] if there is only one cluster: _H<sub>j</sub><sup>act</sup> = H<sub>j</sub><sup>out</sup>_
- [x] Equation 7
    - [x] ~~!!! **try either _lapply/sapply_ or _add.scope_**~~
    - [x] ~~do we have separate set of weights for each cluster?~~
        - **if not**
        - ~~_then remove third dimension (dimension j) from array C.out and w_~~
        - **if yes**
        - [x] ~~then have a cherry pie :)~~
    - [x] ~~queried dimension? unidimensional? omnidimensional?~~
    - [x] ~~do we multiple the non-winning cluster's weights with a non-zero~~ ~~output or something else?~~
    - [x] what if it is unsupervised?
- [x] Equation 8
    - [x] what to do with it? print it in xtdo?
- [x] Equation 9
    - [x] dependent on questions in EQ7
- [x] Equation 10
    - [x] if C.out for each nominal value is the same, tzk with highest is miscalculated
- [x] Equation 11
  - [x] not much there
- [x] Equation 12
    - [x] cluster's position can be minus:: **let it be the absolute value**
    - [x] update only winning
    - [x] reimplement Equation 4 first, after use that implementation to calculate this
- [x] Equation 13
    - [x] update only winning cluster
- [x] Equation 14
    - [x] adjust weights of winning cluster

# Remaining ISSUES

- [ ] recognise missing quired dimensions?
- how to handle and what to do with the probabilities of making correct response? how to handle it in unsupervised? **maybe use fac.queried??**
    - [ ] use it for error probabilities maybe in xtdo?
    - [ ] but in case of an unsupervised learning task, how?
