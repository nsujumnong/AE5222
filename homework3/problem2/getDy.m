function [ treat ] = getDy( x,y )
%GETDIR Summary of this function goes here
%   Detailed explanation goes here

delta = .0001;

treat = (getTreat( x, y ) - getTreat( x,y+delta) )/delta;

end