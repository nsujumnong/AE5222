import csv
import Node
import numpy as np

class dijkstra:

    """docstring for ."""
    def __init__(self, grid):

        self._grid = grid
        points = self.makeList(self._grid)
        self.makeNode(points)

    def makeList(self,grid):
        with open(grid, 'rb') as f:
            reader = csv.reader(f)
            your_list = map(tuple,reader)
        new_list =  map(list,map(None,*your_list))
        #print new_list
        return new_list
        pass

    def makeNode(self,grid):
        nodes = []
        for element in grid:
            temp = Node.Node( [ float(element[0]),float(element[1])], 0, float(element[2])  )
            nodes.append(temp)
        print nodes[1]._loc
        print nodes[1]._treat




dijkstra('data.csv')
