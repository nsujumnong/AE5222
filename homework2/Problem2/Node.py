
class Node:
    """docstring for ."""

    def __init__(self, loc, parent, treat):
        self._loc = loc
        self._parent = parent
        self._treat = treat
        self._cost = float("inf")
