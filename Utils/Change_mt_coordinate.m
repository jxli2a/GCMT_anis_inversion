function mt = Change_mt_coordinate(mt0,flag)
%% Usage: mt = Change_mt_coordinate(mt0,flag)
% Change moment tensor mt between 2 different coordinate systems
% voigt: mt = [m11,m22,m33,m23,m13,m12] 1 is south, 2 is east, 3 is up;
% cmt:   mt = [mrr,mtt,mpp,mrt,mrp,mtp] t is south, p is east, r is up;
% jma:   mt = [mxx,myy,mzz,mxy,mxz,myz] x is north, y is east, z is down;
% flag = 1: input: cmt to output: voigt, flag = -1: input:voigt to output:cmt
% flag = 2: input: jma to output: voigt,
% flag = 3: input: jma to output: cmt  ,
% By Jiaxuan Li Email: lijiaxuanmail@gmail.com
% Modified -2017-03-01- Add JMA coordinate
% Modified -2017-10-15- syntex changes
mt = mt0;
switch flag
    case 1
        mt = mt0([2,3,1,5,4,6]);
    case -1
        mt = mt0([3,1,2,5,4,6]);
    case 2
        mt(1) =  mt0(1); mt(2) =  mt0(2); mt(3) =  mt0(3);
        mt(4) = -mt0(6); mt(5) =  mt0(5); mt(6) = -mt0(4);
    case 3
        mt(1) =  mt0(3); mt(2) =  mt0(1); mt(3) =  mt0(2);
        mt(4) =  mt0(5); mt(5) = -mt0(6); mt(6) = -mt0(4);
    otherwise
        return;
end
end