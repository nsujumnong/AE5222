function [ treat ] = getDxy( x,y )
%GETDIR Summary of this function goes here
%   Detailed explanation goes here

delta = .00001;

dx = (getTreat( x, y ) - getTreat( x+delta,y) )/delta;
dy =  (getTreat( x, y) - getTreat( x,y+delta) )/delta;
treat = [dx,dy];
end

