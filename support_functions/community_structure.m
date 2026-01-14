function[] = community_structure(ave_fcmat, IM, color_bar)
% community_structure classifies and visualizes community interaction structure
%
% Inputs:
%   ave_fcmat : averaged functional connectivity matrix
%   IM        : structure containing community information
%               IM.key(:,2) -> community labels
%               IM.cMap     -> community colormap
%
% This function:
%   1) Computes mean connectivity between communities
%   2) Classifies interactions (assortative, disassortative, core, periphery)
%   3) Visualizes the community-level interaction matrix

% Default option for showing colorbar
if nargin < 3
    color_bar = 'F';
end

% Number of communities (maximum community label)
K = max(max(IM.key(:,2)));

% Compute mean connectivity between all community pairs
mean_mat = community_mean(ave_fcmat, IM);

% Initialize interaction indicator matrix
ind_mat = zeros(K,K);

for k1 = 1:K 
    for k2 = 1:K
        if k1 == k2
            % Diagonal: within-community connectivity
            ind_mat(k1,k2) = 6;
            
        elseif min(mean_mat(k1,k1), mean_mat(k2,k2)) > mean_mat(k1,k2)
            % Assortative: within-community connectivity is stronger
            ind_mat(k1,k2) = 5;
            
        elseif (mean_mat(k1,k2) > min(mean_mat(k1,k1), mean_mat(k2,k2))) && ...
                (mean_mat(k1,k2) < max(mean_mat(k1,k1), mean_mat(k2,k2)))
            % Intermediate case: classify as core or periphery
            
            if abs(mean_mat(k1,k2) - max(mean_mat(k1,k1), mean_mat(k2,k2))) < ...
                    abs(mean_mat(k1,k2) - min(mean_mat(k1,k1), mean_mat(k2,k2)))
                % Core
                ind_mat(k1,k2) = 4;
            else
                % Periphery
                ind_mat(k1,k2) = 3;
            end
        elseif mean_mat(k1,k2) > max(mean_mat(k1,k1), mean_mat(k2,k2)) 
            % Disassortative: between-community connectivity dominates
            ind_mat(k1,k2) = 2;
        else
            % Undetermined or unexpected relationship
            ind_mat(k1,k2) = 1;
        end
    end
end
clear k1 k2;

% Define colors for each interaction category
colors = [
    1.00 1.00 1.00   % Undetermined (1)
    0.96 0.64 0.61   % Disassortative (2)
    0.36 0.65 0.26   % Periphery (3)
    0.74 0.88 0.57   % Core (4)
    0.22 0.49 0.72   % Assortative (5)
    0.72 0.85 0.92   % On-diagonal (6)
    ];

% Indicator values corresponding to interaction types
vals = 1:6;

% Labels for the colorbar
color_labels = ["Undetermined" "Disassortative" "Periphery" "Core" "Assortative" "On-diagoaonal"];

% Identify unique interaction labels
uni_label = unique(ind_mat);

% Plot the community interaction matrix
figure();
set(gcf, 'color', 'w');
imagesc(ind_mat)
axis image;
hold on;
colormap(colors)
caxis([0.5 6.5]);

% Show colorbar if requested
if color_bar == 'T'
    cb = colorbar;
    cb.Ticks = 1:numel(vals);
    cb.TickLabels = color_labels;
    cb.FontSize = 24;
    %cb.TickLabelRotation = 90;
 
end

% Draw colored bars to indicate community identities
for k = 0:(K-1)
    rectangle('Position', [(0.5+k) (K+0.5) 1 0.25], "FaceColor", IM.cMap(k+1,:));
    rectangle('Position', [0.25 (0.5+k) 0.25 1], "FaceColor", IM.cMap(k+1,:));
end
set(gca, 'XTick', [], 'YTick', []);
hold off;


end