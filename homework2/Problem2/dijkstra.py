import csv
import Node
import numpy as np

class dijkstra:

    """docstring for ."""
    def __init__(self, grid):

        self._grid = self.makeList(grid)


    def makeList(grid):
        nodes = []
        with open(grid, 'rb') as f:
            reader = csv.reader(f)
            your_list = map(tuple,reader)
        grid =  map(list,map(None,*your_list))
        for element in grid:
            nodes.append(float(element[2]))
        N = len(nodes)
        return np.flipud(np.reshape(nodes, (np.sqrt(N),np.sqrt(N))))

    def dijkstra(self, start, end ):

        current = start
        
        while current != end:

            neighbours = getNeighbours(node._loc)

            node =

            pass

    def getNeighbours(loc):
        neighbours = []
        neighbours.append ( (loc[0]+1,loc[1]) )
        neighbours.append ( (loc[0],loc[1]+1) )
        neighbours.append ( (loc[0]-1,loc[1]) )
        neighbours.append ( (loc[0],loc[1]-1) )
        return neighbours



    def makeNode(self,grid):
        pass



dijkstra('data.csv')
