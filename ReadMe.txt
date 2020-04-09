Pattern search finds a local minimum of an objective function by the following method, called polling. In this description, words describing pattern search quantities are in bold. The search starts at an initial point, which is taken as the *current point* in the first step:
 
1. Generate a *pattern* of points, typically plus and minus the  coordinate directions, times a *mesh size*, and center this pattern on the *current point*.
 
2. Evaluate the objective function at every point in the *pattern*.
 
3. If the minimum objective in the *pattern* is lower than the value at the *current point*, then the poll is *successful*, and the following
happens:
 
3a. The minimum point found becomes the *current point*.
 
3b. The *mesh size* is doubled.
 
3c. The algorithm proceeds to Step 1.
 
4. If the poll is not *successful*, then the following happens:
 
4a. The *mesh size* is halved.
 
4b. If the *mesh size* is below a threshold, the iterations stop.
 
4c. Otherwise, the *current point* is retained, and the algorithm proceeds at Step 1.
 
This simple algorithm, with some minor modifications, provides a robust and straightforward method for optimization. It requires no gradients of the objective function. It lends itself to constraints, too, but this example and description deal only with unconstrained problems.

