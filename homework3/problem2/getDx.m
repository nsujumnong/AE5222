function [ treat ] = getDx( x,y )
%GETDIR Summary of this function goes here
%   Detailed explanation goes here

delta = .0001;

treat = (getTreat( x, y ) - getTreat( x+delta,y) )/delta;

end

