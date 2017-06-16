
'''
Yes I know this is over kill and stupied as a class, I was having a lot of trouble and got very confused
by the time I figures it out I had already creatd the class and did not want to get ride of it

'''

class TravlingSalesman():
    """docstring for travlingSalesman."""

    def __init__(self, start,  grid):

        self._grid = grid # list
        self._start = start # int

        self._size = len(self._grid)
        self.dijkstra()

    ''' do dijkstra '''
    def dijkstra(self):

        current = self._start
        visited = []
        visited.append(current)
        while len(visited) < self._size:

            prev_treat = float("inf") # set cost to ing
            node = None
            for ii in range(self._size): # go through every city
                #print ii
                if  ii not in visited : # skip current city

                    treat = self._grid[ii][current] # get cost

                    if prev_treat > treat: # compare treats,if new cost is less save it
                        prev_treat = treat
                        node = ii

            visited.append(node)

        visited.append(self._start)
        print visited
        print self.get_cost(visited)

    '''Get the cost of a path'''
    def get_cost(self,path):
        cost = 0
        for ii in range(len(path)-1):
            cost = cost + self._grid[ path[ii] ][path[ii+1]]
        return cost

grid = [ [ 0, 51,217,169,454],
         [ 51, 0,182,163,449],
         [217,182, 0, 151,373],
         [169,163,151, 0,289],
          [454,449,373,289,0] ]


TravlingSalesman(0,grid)
# TravlingSalesman(1,grid)
# TravlingSalesman(2,grid)
# TravlingSalesman(3,grid)
# TravlingSalesman(4,grid)
