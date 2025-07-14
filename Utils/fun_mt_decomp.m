function varargout = fun_mt_decomp(mt,varargin)
% decompose a moment tensor in different coordinate system
% input:  mt is the input moment tensor (array with 6 elements)
%         varargin{1} = 'coordsys' is the coordinate system of input mt
% output: [fclvd, fiso, eigvec, lambda] defined in voigt (SEU) system
% the default coordinate system is voigt (SEU)
% 2017-10-06 By Jiaxuan Li
if nargin >= 2
    coordsys = lower(varargin{1});
    switch coordsys
        case 'cmt';
            mt = Change_mt_coordinate(mt,1);
        case 'jma';
            mt = Change_mt_coordinate(mt,2);
        case 'voigt'
        otherwise
            disp('Coordinate system not recignized!');return;
    end
end
mt0 = [mt(1),mt(6),mt(5)
       mt(6),mt(2),mt(4)
       mt(5),mt(4),mt(3)];
[vec,lambda_diag] = eig(mt0);
lambda = diag(lambda_diag);
if ~issorted(lambda)
    [~,I] = sort(lambda);
    vec = vec(:, I);
end
fclvd = -lambda(2)/max(abs(lambda(1)),abs(lambda(3)));
switch nargout
    case 1
        varargout{1} = fclvd; 
    case 2
        fiso  = (1/3)*lambda(2)/max(abs(lambda));
        varargout{1} = fclvd; 
        varargout{2} = fiso;
    case 3
        fiso  = (1/3)*lambda(2)/max(abs(lambda));
        varargout{1} = fclvd; 
        varargout{2} = fiso;
        varargout{3} = vec;
    case 4
        fiso  = (1/3)*lambda(2)/max(abs(lambda));
        varargout{1} = fclvd; 
        varargout{2} = fiso;
        varargout{3} = vec;
        varargout{4} = lambda;
    otherwise
        disp('Too many output arguments!'); return;
end
end