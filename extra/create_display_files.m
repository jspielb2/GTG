function create_display_files(mean_conmat,labels,coords,outname,disp_type,mod_grps,thr_val)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: 04.09.14
% 
% WARNING: This is a beta version. There no known bugs, but only limited 
% testing has been perfomed. This software comes with no warranty (even the
% implied warranty of merchantability or fitness for a particular purpose).
% Therefore, USE AT YOUR OWN RISK!!!
%
% Copyleft 2014. Software can be modified and redistributed, but modifed, 
% redistributed versions must have the same rights

if size(labels,2) < size(labels,1)
    labels = labels';
end
if size(coords,2) > size(coords,1)
    coords = coords';
end
if size(mod_grps,2) > size(mod_grps,1)
    mod_grps = mod_grps';
end

if sign(thr_val) ~= -1
    mean_conmat(mean_conmat < 0) = 0;
    mean_conmat = threshold_proportional(mean_conmat,thr_val);
end

degrees = degrees_und(mean_conmat);
if size(degrees,2) > size(degrees,1)
    degrees = degrees';
end

if disp_type == 1 % Create output for BrainNet Viewer
    labels = strrep(labels,'-','');
    labels = strrep(labels,'_','');
    labels = strrep(labels,' ','');
    labels = strrep(labels,'.','');

    nodeinfo = [num2cell([coords,mod_grps,degrees]');labels];
    
    dlmwrite([outname '.edge'],mean_conmat,'\t');
    fid = fopen([outname '.node'],'w');
    fprintf(fid,'%i\t%i\t%i\t%i\t%i\t%s\n',nodeinfo{:});
    fclose(fid);
elseif disp_type == 2 % Create output for SONIA
    [mod_colors, ~, mod_color_inds] = unique(mod_grps);
    cc_mod = hsv(numel(mod_colors)+1);
    nodeinfo = [num2cell(1:length(labels));labels;num2cell(10*degrees');repmat({'ellipse'},1,length(labels));num2cell(cc_mod(mod_color_inds,1))';num2cell(cc_mod(mod_color_inds,2))';num2cell(cc_mod(mod_color_inds,3))';repmat({'black'},1,length(labels));repmat({'40'},1,length(labels));repmat({'black'},1,length(labels));repmat({'0'},1,length(labels));repmat({'1'},1,length(labels))];
    [r,c] = find(triu(mean_conmat~=0));
    arc_colors = (cc_mod(mod_color_inds(r),:) + cc_mod(mod_color_inds(c),:))/2;
    arcinfo = [num2cell([r,c,(100*abs(mean_conmat(triu(mean_conmat)~=0)))]');num2cell(arc_colors(:,1))';num2cell(arc_colors(:,2))';num2cell(arc_colors(:,3))';repmat({'0'},1,length(r));repmat({'1'},1,length(r))];
    
    fid = fopen([outname '.son'],'w');
    fprintf(fid,'NodeId\tLabel\tNodeSize\tNodeShape\tRedRGB\tGreenRGB\tBlueRGB\tLabelColor\tLabelSize\tBorderColor\tStartTime\tEndTime\n');
    fprintf(fid,'%i\t%s\t%i\t%s\t%f\t%f\t%f\t%s\t%s\t%s\t%s\t%s\n',nodeinfo{:});
    fprintf(fid,'FromId\tToId\tArcWeight\tRedRGB\tGreenRGB\tBlueRGB\tStartTime\tEndTime\n');
    fprintf(fid,'%i\t%i\t%f\t%f\t%f\t%f\t%s\t%s\n',arcinfo{:});
    fclose(fid);
elseif disp_type == 3 % Create simulated anealing circle graph
    [mean_conmat_reord_simanneal,simanneal_ind] = reorder_matrix(abs(mean_conmat),'circ',0);
    mean_conmat_reord_simanneal = mean_conmat_reord_simanneal.*sign(mean_conmat(simanneal_ind,simanneal_ind));
    simanneal_labels = labels(simanneal_ind);
    circ_graph_jms(mean_conmat_reord_simanneal,simanneal_labels,outname);
elseif disp_type == 4 % Create diagonal organization circle graph
    [mean_conmat_reord_mat,mat_ind] = reorderMAT(abs(mean_conmat),100,'circ');
    mean_conmat_reord_mat = mean_conmat_reord_mat.*sign(mean_conmat(mat_ind,mat_ind));
    mat_labels = labels(mat_ind);
    circ_graph_jms(mean_conmat_reord_mat,mat_labels,outname);
elseif disp_type == 5 % Create modular circle graph
    labels = strrep(labels,'_','');
    outname = [outname '_mod_circ'];
    [mod_ind,mean_conmat_reord_mod] = reorder_mod(abs(mean_conmat),mod_grps);
    mean_conmat_reord_mod = abs(mean_conmat_reord_mod).*sign(mean_conmat(mod_ind,mod_ind));
    mod_labels = labels(mod_ind);
    mod_grps = mod_grps(mod_ind);
    circ_graph_jms(mean_conmat_reord_mod,mod_labels,outname,mod_grps);
end
