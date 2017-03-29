def getNeighbours(loc):
    neighbours = []
    neighbours.append ( (loc[0]+1,loc[1]) )
    neighbours.append ( (loc[0],loc[1]+1) )
    neighbours.append ( (loc[0]-1,loc[1]) )
    neighbours.append ( (loc[0],loc[1]-1) )
    return neighbours

loc = (0,2)


print getNeighbours(loc)
