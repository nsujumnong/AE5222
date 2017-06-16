import Node
try:
    import Queue as Q  # ver. < 3.0
except ImportError:
    import queue as Q

x = [ (1,2),(2,2)]

print (1,2) in x
