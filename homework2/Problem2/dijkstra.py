import csv
import Node
import numpy as np
import Queue as Q

class dijkstra:

    """dijkstra for a treat field"""
    def __init__(self, start, end, grid):

        ( self._grid, size) = self.makeList(grid)
        print size
        self._size = size - 1
        path =  self.dijkstra(start,end,self._grid)
        last = path[end]
        last2 = last._parent._parent
        print last._parent._treat
        print len(path)
        print last._cost
        print self.makePath(path,start,end)

    '''forms the drive in C sytle 2D matrix '''
    def makeList(self,grid):
        nodes = []
        with open(grid, 'rb') as f:
            reader = csv.reader(f)
            your_list = map(tuple,reader)
        grid =  map(list,map(None,*your_list))
        for element in grid:
            nodes.append(float(element[2]))
        N = len(nodes)
        grid = np.reshape(nodes, (np.sqrt(N),np.sqrt(N)))
        print  grid
        return ( grid, np.sqrt(N))

    '''does the actualy dijkstra'''
    def dijkstra(self, start, end,grid ):


        to_viste =  Q.PriorityQueue() # PriorityQueue for nodes to viste
        node = Node.Node(start, [],0 ) # create vist node
        node._cost = 0
        to_viste.put((0,node))
        visted = {}
        current = to_viste.get()[1]
        print current
        # keep going until it reachs the end
        while current._loc != end:

            # lowest cost node
            dist = current._cost # cost to get to that node
            neighbours = self.getNeighbours(current._loc) # get neighbours
            for loc in neighbours:
                if self.legal(loc): # in grid
                    treat = grid[loc[0],loc[1]] # get the treat at that node
                    if loc in visted.values(): # if we have visted
                        if visted[loc]._cost > dist + 0.5* (current._treat  + treat): # compare treats
                            visted[loc]._cost = dist + 0.5* (current._treat  + treat)
                            visted[loc]._parent = current
                    else: # if not in the queue add it
                        temp = Node.Node(loc,current,treat)
                        temp._cost = dist + 0.5* (current._treat  + treat)
                        to_viste.put((temp._cost,temp ))
            # get next node
            current = to_viste.get()[1]
            # add to visted list
            visted.update({current._loc : current})
        visted[end]._cost = visted[end]._cost + 0.5*visted[end]._treat
        return (visted)

    '''get the nodes'''
    def getNeighbours(self,loc):
        # Yes I know this is ugly
        neighbours = []
        neighbours.append ( (loc[0]+1,loc[1]) )
        neighbours.append ( (loc[0],loc[1]+1) )
        neighbours.append ( (loc[0]-1,loc[1]) )
        neighbours.append ( (loc[0],loc[1]-1) )
        return neighbours

    '''checks to see if a point is the grid'''
    def legal(self, loc):
        return loc[0] >=0 and loc[1] >=0 and loc[0] <= self._size and loc[1] <= self._size


    '''forms the path based on the node'''
    def makePath(self, nodes, start, end):
        path = []
        current =  nodes[end]
        path.append(current._treat)
        while current._loc != start:
            parent = current._parent
            print current
            path.append(parent._treat)
            current = parent

        return path


start = (0,0)
end = (2,2)
dijkstra(start, end,'data.csv')
