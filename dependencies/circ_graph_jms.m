function circ_graph_jms(graph,roi,G,varargin)

% input: 
%       graph: nroi*nroi binary matrix including network connections
%       roi: 1*nroi cell array including roi names
%       G: group name (string)

if ~isempty(varargin)
    mod_grps = varargin{1};
end

nroi = size(roi,2);

theta = linspace(0,2*pi,nroi+1);

theta = theta(1:end-1);

[x,y] = pol2cart(theta,1);

% [ind1,ind2] = find(graph);
% plot([x(ind1); x(ind2)],[y(ind1); y(ind2)],'b'); 

if exist('mod_grps','var')
    [mod_colors, ~, mod_color_inds] = unique(mod_grps);
    cc_mod = hsv(numel(mod_colors));
    colormap(hsv);
    %figure;
    for q = 1:nroi
        plot(x(q),y(q),'.k','markersize',50,'color',cc_mod(mod_color_inds(q),:));hold on
    end
    
    xlim([min(x)-.1 max(x)+.1])
    ylim([min(y)-.1 max(y)+.1])
    
    for q = 1:round(nroi/4)
        text(x(q), y(q), strcat({'  '}, roi(1,q), {'  '}), 'VerticalAlignment','bottom', 'HorizontalAlignment','left','fontsize',20,'color',cc_mod(mod_color_inds(q),:));
    end
    
    for q = round(nroi/4)+1:round(nroi/2)
        text(x(q), y(q), strcat({'  '}, roi(1,q), {'  '}), 'VerticalAlignment','bottom', 'HorizontalAlignment','right','fontsize',20,'color',cc_mod(mod_color_inds(q),:));
    end
    
    for q = round(nroi/2)+1:round(3*nroi/4)
        text(x(q), y(q), strcat({'  '}, roi(1,q), {'  '}), 'VerticalAlignment','top', 'HorizontalAlignment','right','fontsize',20,'color',cc_mod(mod_color_inds(q),:));
    end
    
    for q = round(3*nroi/4)+1:nroi
        text(x(q), y(q), strcat({'  '}, roi(1,q), {'  '}), 'VerticalAlignment','top', 'HorizontalAlignment','left','fontsize',20,'color',cc_mod(mod_color_inds(q),:));
    end
    set(gcf,'color','black')
    set(gcf, 'InvertHardCopy', 'off')
else
    %figure;
    plot(x,y,'.k','markersize',50);hold on
    xlim([min(x)-.1 max(x)+.1])
    ylim([min(y)-.1 max(y)+.1])
    
    text(x(1:round(nroi/4)), y(1:round(nroi/4)), strcat(repmat({' '},1,round(nroi/4)), roi(1,1:round(nroi/4)), repmat({' '},1,round(nroi/4))), 'VerticalAlignment','bottom', 'HorizontalAlignment','left','fontsize',20);
    text(x(round(nroi/4)+1:round(nroi/2)), y(round(nroi/4)+1:round(nroi/2)), strcat(repmat({' '},1,length(round(nroi/4)+1:round(nroi/2))), roi(1,round(nroi/4)+1:round(nroi/2)), repmat({' '},1,length(round(nroi/4)+1:round(nroi/2)))), 'VerticalAlignment','bottom', 'HorizontalAlignment','right','fontsize',20);
    text(x(round(nroi/2)+1:round(3*nroi/4)), y(round(nroi/2)+1:round(3*nroi/4)), strcat(repmat({' '},1,length(round(nroi/2)+1:round(3*nroi/4))), roi(1,round(nroi/2)+1:round(3*nroi/4)), repmat({' '},1,length(round(nroi/2)+1:round(3*nroi/4)))), 'VerticalAlignment','top', 'HorizontalAlignment','right','fontsize',20);
    text(x(round(3*nroi/4)+1:nroi), y(round(3*nroi/4)+1:nroi), strcat(repmat({' '},1,length(round(3*nroi/4)+1:nroi)), roi(1,round(3*nroi/4)+1:nroi), repmat({' '},1,length(round(3*nroi/4)+1:nroi))), 'VerticalAlignment','top', 'HorizontalAlignment','left','fontsize',20);
    [unique_colors, ~, unique_color_inds] = unique(graph);
    unique_color_inds=reshape(unique_color_inds, nroi, nroi);
    cc=hsv(numel(unique_colors)+1);
    colormap(hsv);
end


graphNorm = abs(graph)/max(max(abs(graph)));
line_widths = graphNorm.*4;

% % Move the range of values so they start at 0.001 (if we set them to start at 0, the lowest correlation value would be seen as no connection)
% graphNorm = (graph + abs(min(min(graph))) + 0.001);
% % Normalise the correlation values, but keep the sign
% graphNorm2 = graphNorm/max(max(abs(graphNorm)));
% % Set the 0 connections back to 0
% graphNorm2(logical(graph==0)) = 0;

% There cannot be 0 values for line width, so set 0 to 0.0000000000001
line_widths(logical(line_widths==0)) = 0.0000000000001;


% Draw lines depicting each ROI-ROI connection

for i=1:nroi
    for j=i+1:nroi
        if graph(i,j) ~= 0
            if exist('mod_grps','var')
                line_col = (cc_mod(mod_color_inds(i),:) + cc_mod(mod_color_inds(j),:))/2;
                h2=plot([x(1,i) x(1,j)],[y(1,i) y(1,j)],'color', line_col, 'LineWidth', line_widths(i,j));
            else
                h2=plot([x(1,i) x(1,j)],[y(1,i) y(1,j)],'color', cc(unique_color_inds(i,j),:), 'LineWidth', line_widths(i,j));
            end
        end
    end
end

axis equal off
set(gca,'YTick',[])
set(gca,'YColor','w')
set(gcf, 'Position', [1 70 2560 1437])
saveas(gcf,[G '.tif']);

% FIG = ['circgraph_' G ];
% print('-dtiff','-r600',FIG)
