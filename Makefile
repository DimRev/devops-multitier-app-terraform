.PHONY: graph

graph:
	terraform graph > assets/graph.dot
	dot -Tpng assets/graph.dot > assets/graph.png