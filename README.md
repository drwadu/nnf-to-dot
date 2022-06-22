![](examples/8_queens_std_ccg.png)
# nnf2dot
Converts NNF or counting graph to graphviz input.

# Usage 
```console
$ nnf2dot file | dot -Tpng > file.png
```

# Customize Style
To customize node styles, go to [Main.hs](Main.hs) and change either of 
```haskell
andNodeStyle   = "[label=∧ shape=box width=0.5]"
orNodSetyle    = "[label=∨ shape=box width=0.5]"
plusNodeStyle  = "[label=\"+\" shape=box fontsize=16 width=0.5]"
timesNodeStyle = "[label=\"✕\" shape=box fontsize=20 width=0.5]"
```
See [graphviz docs](https://graphviz.org/documentation/) for more.