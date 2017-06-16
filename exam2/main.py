
import travelingsalesman
import Node
grid = [ [ 0, 51,217,169,454],[ 51, 0,182,163,449],[217,182, 0, 151,373],[169,163,151, 0,289],[454,449,373,289,0] ]
cities = []

for ii in range(5):
    temp = Node.Node(ii, [],0)
    cities.append(temp)


travelingsalesman.TravlingSalesman(0,cities,grid)
