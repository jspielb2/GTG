function convert_NBSoutput_for_display(nbs,outname,disp_type,varargin)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: 04.10.14
% 
% WARNING: This is a beta version. There no known bugs, but only limited 
% testing has been perfomed. This software comes with no warranty (even the
% implied warranty of merchantability or fitness for a particular purpose).
% Therefore, USE AT YOUR OWN RISK!!!
%
% Copyleft 2014. Software can be modified and redistributed, but modifed, 
% redistributed versions must have the same rights

if ~isempty(varargin)
    orig_init_mod_grps = varargin{1};
end

for net = 1:nbs.NBS.n
    labels = nbs.NBS.node_label(logical(sum(full(nbs.NBS.con_mat{1,net})+full(nbs.NBS.con_mat{1,net})') > 0));
    if size(labels,2) < size(labels,1)
        labels = labels';
    end
    labels = strrep(labels,'Right','R');
    labels = strrep(labels,'Left','L');
    
    coords = nbs.NBS.node_coor(logical(sum(full(nbs.NBS.con_mat{1,net})+full(nbs.NBS.con_mat{1,net})') > 0),:);
    
    mask = (full(nbs.NBS.con_mat{1,net})+full(nbs.NBS.con_mat{1,net})');
    pvals = cdf('t',nbs.GLM.contrast(logical(nbs.GLM.contrast~=0))*nbs.NBS.test_stat, size(nbs.GLM.X,1)-size(nbs.GLM.X,2));
    zmat = icdf('norm',pvals,0,1).*mask;
    zmat = zmat(logical(sum(full(nbs.NBS.con_mat{1,net})+full(nbs.NBS.con_mat{1,net})') > 0),logical(sum(full(nbs.NBS.con_mat{1,net})+full(nbs.NBS.con_mat{1,net})') > 0));
    degrees = degrees_und(zmat)';
    
    % If an empty modularity variable is input by the user, assign all to one
    % group. If no modularity grouping is input by user, create one based on
    % input matrix.
    if exist('orig_init_mod_grps','var')
        init_mod_grps = orig_init_mod_grps;
        if isempty(init_mod_grps)
            init_mod_grps = ones(size(degrees));
        elseif length(init_mod_grps) > length(degrees)
            init_mod_grps = init_mod_grps(logical(sum(full(nbs.NBS.con_mat{1,net})+full(nbs.NBS.con_mat{1,net})') > 0),:);
        end
    else
        init_mod_grps = modularity_und(abs(zmat));
    end
    
    grp_labels = unique(init_mod_grps);
    grpinds = zeros(length(grp_labels),1);
    for q = 1:length(grp_labels)
        curr_label = grp_labels(q);
        grpinds(q) = find(init_mod_grps == curr_label,1);
    end
    [~,reinds] = sort(grpinds);
    mod_grps = zeros(size(init_mod_grps));
    for q = 1:length(grp_labels)
        curr_label = grp_labels(reinds(q));
        mod_grps(logical(init_mod_grps == curr_label),1) = grp_labels(q);
    end
    
    if disp_type == 1 % Create output for BrainNet Viewer
        labels = strrep(labels,'-','');
        labels = strrep(labels,'_','');
        labels = strrep(labels,' ','');
        labels = strrep(labels,'.','');
        nodeinfo = [num2cell([coords,mod_grps,degrees]');labels];
        if nbs.NBS.n > 1
            dlmwrite([outname,'_',num2str(net),'.edge'],zmat,'\t');
            fid = fopen([outname,'_',num2str(net),'.node'],'w');
        else
            dlmwrite([outname,'.edge'],zmat,'\t');
            fid = fopen([outname,'.node'],'w');
        end
        fprintf(fid,'%i\t%i\t%i\t%i\t%i\t%s\n',nodeinfo{:});
        fclose(fid);
    elseif disp_type == 2 % Create output for SONIA
        [mod_colors, ~, mod_color_inds] = unique(mod_grps);
        cc_mod = hsv(numel(mod_colors)+1);
        nodeinfo = [num2cell(1:length(labels));labels;num2cell(10*degrees');repmat({'ellipse'},1,length(labels));num2cell(cc_mod(mod_color_inds,1))';num2cell(cc_mod(mod_color_inds,2))';num2cell(cc_mod(mod_color_inds,3))';repmat({'black'},1,length(labels));repmat({'40'},1,length(labels));repmat({'black'},1,length(labels));repmat({'0'},1,length(labels));repmat({'1'},1,length(labels))];
        [r,c] = find(triu(zmat~=0));
        arc_colors = (cc_mod(mod_color_inds(r),:) + cc_mod(mod_color_inds(c),:))/2;
        arcinfo = [num2cell([r,c,(100*abs(zmat(triu(zmat)~=0)))]');num2cell(arc_colors(:,1))';num2cell(arc_colors(:,2))';num2cell(arc_colors(:,3))';repmat({'0'},1,length(r));repmat({'1'},1,length(r))];
        if nbs.NBS.n > 1
            fid = fopen([outname,'_',num2str(net),'.son'],'w');
        else
            fid = fopen([outname,'.son'],'w');
        end
        fprintf(fid,'NodeId\tLabel\tNodeSize\tNodeShape\tRedRGB\tGreenRGB\tBlueRGB\tLabelColor\tLabelSize\tBorderColor\tStartTime\tEndTime\n');
        fprintf(fid,'%i\t%s\t%i\t%s\t%f\t%f\t%f\t%s\t%s\t%s\t%s\t%s\n',nodeinfo{:});
        fprintf(fid,'FromId\tToId\tArcWeight\tRedRGB\tGreenRGB\tBlueRGB\tStartTime\tEndTime\n');
        fprintf(fid,'%i\t%i\t%f\t%f\t%f\t%f\t%s\t%s\n',arcinfo{:});
        fclose(fid);
    elseif disp_type == 3 % Create simulated anealing circle graph
        [zmat_reord_simanneal,simanneal_ind] = reorder_matrix(abs(zmat),'circ',0);
        zmat_reord_simanneal = zmat_reord_simanneal.*sign(zmat(simanneal_ind,simanneal_ind));
        simanneal_labels = labels(simanneal_ind);
        circ_graph_jms(zmat_reord_simanneal,simanneal_labels,outname);
    elseif disp_type == 4 % Create diagonal organization circle graph
        [zmat_reord_mat,mat_ind] = reorderMAT(abs(zmat),100,'circ');
        zmat_reord_mat = zmat_reord_mat.*sign(zmat(mat_ind,mat_ind));
        mat_labels = labels(mat_ind);
        circ_graph_jms(zmat_reord_mat,mat_labels,outname);
    elseif disp_type == 5 % Create modular circle graph
        labels = strrep(labels,'_','');
        if nbs.NBS.n > 1
            outname_temp = [outname,'_mod_circ_',num2str(net)];
        else
            outname_temp = [outname,'_mod_circ'];
        end
        [mod_ind,zmat_reord_mod] = reorder_mod(abs(zmat),mod_grps);
        zmat_reord_mod = abs(zmat_reord_mod).*sign(zmat(mod_ind,mod_ind));
        mod_labels = labels(mod_ind);
        mod_grps = mod_grps(mod_ind);
        figure;
        circ_graph_jms(zmat_reord_mod,mod_labels,outname_temp,mod_grps);
    end
end

% %%% To create a modular structure based on the full mean matrix
% tempcoords  = repmat(logical(triu(ones(length(nbs.NBS.node_label))-diag(ones(size(nbs.NBS.node_label))),1)),[1,1,size(nbs.GLM.y,1)]);
% full_conmat = zeros(length(nbs.NBS.node_label),length(nbs.NBS.node_label),size(nbs.GLM.y,1));
% full_conmat(tempcoords) = shiftdim(nbs.GLM.y,1);
% full_conmat = full_conmat + permute(full_conmat,[2 1 3]);
% mean_full_conmat = create_mean_corrmats(full_conmat);
% 
% mean_full_conmat = threshold_proportional(mean_full_conmat,0.1);
% 
% labels = nbs.NBS.node_label;
% mod_grps = modularity_und(abs(mean_full_conmat));
% [mod_ind conmat_reord_mod] = reorder_mod(abs(mean_full_conmat),mod_grps);
% conmat_reord_mod = conmat_reord_mod.*sign(mean_full_conmat(mod_ind,mod_ind));
% mod_labels = labels(mod_ind);
% mod_grps = mod_grps(mod_ind);
% circ_graph(conmat_reord_mod,mod_labels','Modular',mod_grps);

