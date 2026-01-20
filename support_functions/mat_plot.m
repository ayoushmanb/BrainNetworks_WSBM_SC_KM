function [] = mat_plot(A, color_bar, show_ticks, font_size, n_caxis_ticks, caxis_lim)
% Plot a matrix with optional colorbar, axis ticks, font size, and color limits
%
% Inputs:
%   A             : Matrix to plot
%   color_bar     : 'T' to show colorbar (default: 'F')
%   show_ticks    : 'T' to show axis ticks (default: 'F')
%   font_size     : Font size for axes and colorbar (default: MATLAB default)
%   n_caxis_ticks : Number of colorbar ticks (default: [])
%   caxis_lim     : [cmin cmax] color axis limits (default: auto)

% Defaults
if nargin < 2, color_bar = 'F'; end
if nargin < 3, show_ticks = 'F'; end
if nargin < 4, font_size = []; end
if nargin < 5, n_caxis_ticks = []; end
if nargin < 6, caxis_lim = []; end

% Plot
figure();
set(gcf, 'color', 'w');
colormap(jet(256));
imagesc(A);
axis image;

% Apply manual color axis limits ONLY if provided
if ~isempty(caxis_lim)
    caxis(caxis_lim);
end

% Font size (axes)
if ~isempty(font_size)
    set(gca, 'FontSize', font_size);
end

% Colorbar
if color_bar == 'T'
    cb = colorbar;

    % Set colorbar ticks if requested
    if ~isempty(n_caxis_ticks)
        if isempty(caxis_lim)
            clim = caxis;        % automatic limits
        else
            clim = caxis_lim;    % manual limits
        end

        ticks = linspace(clim(1), clim(2), n_caxis_ticks);
        set(cb, 'Ticks', ticks, ...
                'TickLabels', arrayfun(@num2str, ticks, 'UniformOutput', false));
    end

    if ~isempty(font_size)
        set(cb, 'FontSize', font_size);
    end
end

% Axis ticks
if show_ticks == 'F'
    set(gca, 'XTick', [], 'YTick', []);
end

end
