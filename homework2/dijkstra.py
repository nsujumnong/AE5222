#!/usr/bin/env python
import numpy


def dijkstra(v_s,v_g,graph):
	#initialize
	#each v_i is a list of fields including label, marker, and backpointer
	V = numpy.zeros(len(graph))
	v_i = v_s
	V[0] = v_i
	P = numpy.array([v_i])
	for j in range (1,len(graph)-1):
		V[j] = numpy.array([float("inf"),'U',numpy.array([])])

	#stop condition: v_s == v_g
	#main
	while v_i != v_g:
		P.remove(v_i)
		v_i = numpy.array([float("inf"),'C',numpy.array([])])
		for j in range (0,len(V)-1):
			if  && V[j][]
				if v_i[0]+avg_cost(v_i,V[j]) < V[j][0]:
					V[j][0] = v_i[0] + avg_cost(v_i,V[j])
					V[j][2] = v_i
					V[j][1] = 'V'
					P.append(V[j])


def avg_cost(v_i,v_j):

	g = (v_i[0]+v_j[0])/2

	return g 
