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
        self._start = start
        self._end =end
        path =  self.dijkstra()
        print path
        last = path[end]
        last2 = last._parent._parent
        print last._parent._treat
        print len(path)
        print last._cost
        print self.makePath(path)

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
        print N
        grid = np.reshape(nodes, (np.sqrt(N),np.sqrt(N)))
        print  grid
        return ( grid, np.sqrt(N))

    '''does the actualy dijkstra'''
    def dijkstra(self  ):


        to_viste =  Q.PriorityQueue() # PriorityQueue for nodes to viste
        node = Node.Node(self._start, [],0 ) # create vist node
        node._cost = 0
        to_viste.put((0,node))
        visted = {}
        current = to_viste.get()[1]
        visted.update({current._loc : current})
        print current
        # keep going until it reachs the self._end
        while current._loc != self._end :
            #raw_input("step")
            # lowest cost node
            dist = current._cost # cost to get to that node
            neighbours = self.getNeighbours(current._loc) # get neighbours
            #print neighbours
            for loc in neighbours:

                #print "here:", current
                if self.legal(loc): # in grid
                    treat = self._grid[loc[0],loc[1]] # get the treat at that node
                    if loc in visted: # if we have visted
                        #print "neighbor was visited "
                        #print visted
                        if visted[loc]._cost > dist + 0.5* (current._treat  + treat): # compare treats
                            new_cost=visted[loc]._cost = dist + 0.5* (current._treat  + treat)
                            #print "new_cost:", new_cost
                            visted[loc]._cost = new_cost
                            visted[loc]._parent = current
                    else: # if not in the queue add it
                        #print "never been here before"
                        temp = Node.Node(loc,current,treat)
                        temp._cost = dist + 0.5* (current._treat  + treat)#visted[loc]._cos
                        to_viste.put((temp._cost,temp ))
            # get next node
            #print "beifore, ", to_viste.qsize()
            print "before ",current._loc
            print "before ",current

            current._visted = 1
            visted.update({current._loc : current})
            current = to_viste.get()[1]

            #print current
            #nt self.getLoc(visted.values())
            while current._loc in self.getLoc(visted.values()):
                #print "hello"
                current = to_viste.get()[1]

            #print "after, ", to_viste.qsize()
            # add to visted list

            #print(visted)
            print "after ",current._loc
            print "after ",current
        visted.update({current._loc : current})
        visted[self._end]._cost = visted[self._end]._cost + 0.5*visted[self._end]._treat
        return (visted)

    def getLoc(self,nodes):
        x =  [ _._loc for _ in nodes]

        return x
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
    def makePath(self, nodes):
        path = []
        current =  nodes[self._end]
        path.append(current._treat)
        while current._loc != self._start:
            parent = current._parent
            print current
            path.append(parent._treat)
            current = parent

        return path


start = (0,0)
end = (14,14)
dijkstra(start, end,'data15.csv')
