function [cog_orig,obj_labs,cog_trans] = calc_cog(H,transmat)

% Author: Jeffrey M. Spielberg (jspielb2@gmail.com)
% Version: 12.27.13
% 
% WARNING: This is a beta version. There no known bugs, but only limited 
% testing has been perfomed. This software comes with no warranty (even the
% implied warranty of merchantability or fitness for a particular purpose).
% Therefore, USE AT YOUR OWN RISK!!!
%
% Copyleft 2014. Software can be modified and redistributed, but modifed, 
% redistributed versions must have the same rights

obj_labs = unique(H);
obj_labs = obj_labs(obj_labs ~= 0);
numobjs = length(obj_labs);
numdims = ndims(H);
cog_orig = zeros(numobjs,numdims);

for curr_obj = 1:numobjs
    curr_obj_lab = obj_labs(curr_obj);
    sing_obj = zeros(size(H));
    sing_obj(H == curr_obj_lab) = H(H == curr_obj_lab);
    for curr_dim = 1:numdims
        if numdims > 1
            sum_dims = 1:numdims;
            sum_dims = sum_dims(~ismember(sum_dims,curr_dim));
            summed_sing_obj = sing_obj;
            for curr_sum_dim = 1:length(sum_dims)
                summed_sing_obj = sum(summed_sing_obj,sum_dims(curr_sum_dim));
            end
        else
            summed_sing_obj = sing_obj;
        end
        summed_sing_obj = squeeze(summed_sing_obj);
        if size(summed_sing_obj,2) > size(summed_sing_obj,1)
            summed_sing_obj = summed_sing_obj';
        end
        cog_orig(curr_obj,curr_dim) = ((1:length(summed_sing_obj))*summed_sing_obj)/sum(summed_sing_obj);
    end
end

if exist('transmat','var')
    cog_trans = zeros(size(cog_orig));
    if size(transmat,1) == size(transmat,2)
        for curr_obj = 1:numobjs
            cog_trans(curr_obj,:) = cog_orig*transmat;
        end
    else
        transmat_mult = transmat(:,1:3);
        transmat_add = transmat(:,4);
        for curr_obj = 1:numobjs
            cog_trans(curr_obj,:) = cog_orig(curr_obj,:)*transmat_mult + transmat_add';
        end
    end
    cog_trans = round(cog_trans);
end

cog_orig = round(cog_orig);
