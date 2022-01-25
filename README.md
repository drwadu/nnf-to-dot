# nnf-to-dot (nnftd)
![8queens-acg](8_queens_acgstd.png)

transforms (answer set) counting graph of nnf or nnf file to .dot file

# Usage
## nnf 
```command
$ nnftd example.nnf | dot -Tpng > example_nnf.png
```
![nnf](example_nnf.png)
## counting graph 
```command
$ nnftd example.cg | dot -Tpng > graph.png
```
![cg](example_cg.png)

## answer set counting graph 
```command
$ nnftd example.cg | dot -Tpng > graph.png
```
![acg](example_acg.png)
