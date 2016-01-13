%--------------------------------------------------------------------------
%This functions determines the least cost path through our matrix of freqs
%
%Inputs:
%fmatrix - Matrix of the frequencies obtained from fmatrixpgram size(N by r)
%        - The rth column of this matrix contain the N peaks in the Rth frame   
%        - determines the min cost path from frame 1 to frame r where the
%        cost from the rth frame to the (r-1)th frame is given by the
%        square of the difference of the frequencies. 
%
%Outputs: 
%        - The least cost path in the matrix given as frequencies. 
%--------------------------------------------------------------------------

function path = leastcostENF(fmatrix);

%extract the size of the frequency matrix
[peakno, frameno] = size(fmatrix);

%make a cost matrix of the same size
cmatrix = zeros(peakno, frameno);
%make a matrix to keep track of the index of the freq of the parent frame.
parent_matrix = zeros(peakno, frameno);

% i is the frame counter
% j is the index counter in the parent frame
% l is the index counter in the current frame
for i = 1:(frameno-1)                                                                                                   
    for j = 1:peakno    
        %initialise the cost to the cost of jumping to the frist frequency
        %in the parent frame. and initialise the index also to 1. 
        cmatrix(j, frameno-i) = (fmatrix(j, frameno-i) - fmatrix(1, frameno-i+1))^2 + cmatrix(1, frameno-i+1);          
        parent_matrix(j, frameno-i) = 1;
        %starting from the second, do comparisons  and store the min cost
        for l = 2:peakno                                                                                             
            trans_cost = (fmatrix(j, frameno-i) - fmatrix(l, frameno-i+1))^2 + cmatrix(l, frameno-i+1);             
            if trans_cost < cmatrix(j, frameno-i)
                cmatrix(j, frameno-i) = trans_cost;
                parent_matrix(j, frameno-i) = l;
            end
        end
    end
end

%we defined 3 matrices: fmatrix, cmatrix, parent_matrix all of same size.
%create a vector with length = no of frames.
pathindex = zeros(1, frameno);
%find the minimum total cost in our cost matrix
leastcost = find(cmatrix==min(cmatrix(:,1)));

%if multiple have the same cost (more frequent than i had originally
%assumed, we take the first one? Put this as an issue. 
%--------------------------------------------------------------
if length(leastcost) > 1
    leastcost = leastcost(1);
end
ref_index = leastcost;
%---------------------------------------------------------------

%Use the parent matrix to trace the entire path
for i = 1:frameno;
    pathindex(i) = ref_index;
    ref_index = parent_matrix(ref_index, i);
end

%get the frequencies from fmatrix. 
for i = 1:frameno
   path(i) = fmatrix(pathindex(i), i);    
end

%path % to see you path that you get. 
           
end