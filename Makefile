.PHONY: graph graph1 graph2

graph:
	terraform graph > assets/graph.dot
	dot -Tpng ./assets/graph.dot -o ./assets/graph.png

graph1:
	dot -Tpng ./assets/graph1.dot -o ./assets/graph1.png

graph2:
	dot -Tpng ./assets/graph2.dot -o ./assets/graph2.png