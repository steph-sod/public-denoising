function [S U sv tol] = hosvd(T, dim, tol)
%HOSVD High Order SVD of a multidimensional array
%	[S U sv tol] = HOSVD(T)
%	[S U sv tol] = HOSVD(T, dim)
%	[S U sv tol] = HOSVD(T, dim, tol)
%	
%	T    - multidimensional array
%	dim  - bools: hosvd is applied in these dimensions (default: ones())
%	tol  - tolerance for each dimensions (default: eps * ones())
%	
%	S    - decomposed core tensor so that T==tprod(S, U)
%	U    - matrices for each dimension (U{n}==[] if dim(n) was 0)
%	sv   - n-mode singular values (or [] if dim(n) was 0)
%	tol  - larges dropped singular value (hosvd truncates small sv)
%
%	eg. [S, U, sv, tol] = hosvd(ones(3,4,5), [1 0 1])
%
%	See also TPROD, SVDTRUNC

M = size(T);
P = length(M);
if nargin < 2
	dim = ones(1,P);
end
if nargin < 3
	tol = eps;
end
if numel(tol) == 1
	tol = tol*ones(1,P);
end
U = cell(1,P);    % pre-allocate cells
UT = cell(1,P);   % pre-allocate cells 
sv = cell(1,P);   % pre-allocate cells
for i = 1:P       % for all b values
	if dim(i)
		A = ndim_unfold(T, i);    % reshapes data into 2D, lays out every slice for every b value
		% SVD based reduction of the current dimension (i)
		[Ui svi toli] = svdtrunc(A, tol(i));
		U{i} = Ui;
		UT{i} = Ui';
		sv{i} = svi;
		tol(i) = toli;
	else
		U{i} = [];
		UT{i} = [];
		sv{i} = [];
		tol(i) = 0;
	end
end
S = tprod(T, UT);
