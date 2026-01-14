function[mean_mat] = community_mean(ave_fcmat, IM)
% community_mean computes the mean connectivity between communities
%
% Inputs:
%   ave_fcmat : averaged functional connectivity matrix
%   IM        : structure containing community information
%               IM.key(:,2) -> community labels
%               IM.order    -> node reordering index
%
% Output:
%   mean_mat  : K x K matrix of mean connectivity between communities

% Number of communities (maximum community label)
K = max(max(IM.key(:,2)));

% Reorder the connectivity matrix according to IM.order
ave_fcmat = ave_fcmat(IM.order,IM.order);

% Set diagonal (self-connections) to zero
ave_fcmat(logical(eye(size(ave_fcmat)))) = 0;

% Initialize the community-by-community mean matrix
mean_mat = zeros(K,K);

for k1 = 1:K 
    for k2 = 1:K
        % Indices of nodes belonging to community k1 and k2
        idx1 = find(IM.key(:,2) == k1);
        idx2 = find(IM.key(:,2) == k2);
        
        % Sum of connectivity values between the two communities
        sum_val = sum(ave_fcmat(idx1, idx2'), 'all');
        
        if k1 == k2 % If within the same community, exclude self-connections
           mean_mat(k1,k2) =  sum_val/(numel(idx1)*numel(idx1) - numel(idx1));
        else % Between-community mean connectivity
           mean_mat(k1,k2) = sum_val/(numel(idx1)*numel(idx2));
        end
    end
end
clear idx1 idx2 k1 k2 sum_val;

end