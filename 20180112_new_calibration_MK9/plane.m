function pm = plane(X, Y, Z)

	% First, remove NaNs. All the NaN (if any) will be in the same places,
	% so we need do only one test. Testing each of X,Y,Z leads to confusion
	% and leads to the expectation that the NaNs are NOT in the same places
	% with some potential.
	k = isfinite(X);
	if all(k(:))
	  % in this case there were no nans, so reshape the arrays into vectors
	  % While X(k) would convert an array into a column vector anyway in
	  % this case, it seems far more sane to do the reshape explicitly,
	  % rather than let X(k) do it implicitly. Again, a source of ambiguity
	  % removed.
	  X = X(:);
	  Y = Y(:);
	  Z = Z(:);
	else
	  X = X(k);
	  Y = Y(k);
	  Z = Z(k);
	end

	% Combine X,Y,Z into one array
	XYZ = [X,Y,Z];

	% column means. This will allow us to do the fit properly with no
	% constant term needed. It is necessary to do it this way, as
	% otherwise the fit would not be properly scale independent
	cm = mean(XYZ,1);

	% subtract off the column means
	XYZ0 = bsxfun(@minus,XYZ,cm);

	% The "regression" as a planar fit is now accomplished by SVD.
	% This presumes errors in all three variables. In fact, it makes
	% presumptions that the noise variance is the same for all the
	% variables. Be very careful, as this fact is built into the model.
	% If your goal is merely to fit z(x,y), where x and y were known
	% and only z had errors in it, then this is the wrong way
	% to do the fit.
	[U,S,V] = svd(XYZ0,0);

	% The singular values are ordered in decreasing order for svd.
	% The vector corresponding to the zero singular value tells us
	% the direction of the normal vector to the plane. Note that if
	% your data actually fell on a straight line, this will be a problem
	% as then there are two vectors normal to your data, so no plane fit.
	% LOOK at the values on the diagonal of S. If the last one is NOT
	% essentially small compared to the others, then you have a problem
	% here. (If it is numerically zero, then the points fell exactly in
	% a plane, with no noise.)
	%diag(S)

	% Assuming that S(3,3) was small compared to S(1,1), AND that S(2,2)
	% is significantly larger than S(3,3), then we are ok to proceed.
	% See that if the second and third singular values are roughly equal,
	% this would indicate a points on a line, not a plane.
	% You do need to check these numbers, as they will be indicative of a
	% potential problem.
	% Finally, the magnitude of S(3,3) would be a measure of the noise
	% in your regression. It is a measure of the deviations from your
	% fitted plane.

	% The normal vector is given by the third singular vector, so the
	% third (well, last in general) column of V. I'll call the normal
	% vector P to be consistent with the question notation.
	P = V(:,3);
	a = P(1);
	b = P(2);
	c = P(3);
	d = -P(1) * cm(1) - P(2) * cm(2) - P(3) * cm(3);
	pm = planeModel([a, b, c, d]);

	% The equation of the plane for ANY point on the plane [x,y,z]
	% is given by
	%
	%    dot(P,[x,y,z] - cm) == 0
	%
	% Essentially this means we subtract off the column mean from our
	% point, and then take the dot product with the normal vector. That
	% must yield zero for a point on the plane. We can also think of it
	% in a different way, that if a point were to lie OFF the plane,
	% then this dot product would see some projection along the normal
	% vector.
	%
	% So if your goal is now to predict Z, as a function of X and Y,
	% we simply expand that dot product.
	% 
	%   dot(P,[x,y,z]) - dot(P,cm) = 0
	%
	%   P(1)*X + P(2)*Y + P(3)*Z - dot(P,cm) = 0
	%
	% or simply (assuming P(3), the coefficient of Z) is not zero...

	%Zhat = (dot(P,cm) - P(1)*X) - P(2)*Y)/P(3);
	
end