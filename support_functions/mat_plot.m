function [] = mat_plot(A, color_bar, show_ticks, font_size, caxis_lim)
% Plot a matrix with optional colorbar, axis ticks, font size, and color limits
%
% Inputs:
%   A          : Matrix to plot
%   color_bar  : 'T' to show colorbar (default: 'F')
%   show_ticks : 'T' to show axis ticks (default: 'F')
%   font_size  : Font size for axes and colorbar (default: MATLAB default)
%   caxis_lim  : [cmin cmax] color axis limits (default: auto)

% Defaults
if nargin < 2, color_bar = 'F'; end
if nargin < 3, show_ticks = 'F'; end
if nargin < 4, font_size = []; end
if nargin < 5, caxis_lim = []; end

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

    % Only customize ticks if caxis is manual
    if ~isempty(caxis_lim)
        cmin = caxis_lim(1);
        cmax = caxis_lim(2);

        ticks = linspace(cmin, cmax, 5);  % min, 1/4, mid, 3/4, max

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

