function GNI=Rest2GNI_edit(RestData,WBMaskName,nVoxelPerSectionMax)
% function GNI=Rest2GNI(RestData,WBMaskName)
%
% Purpose:
%   Calculate GNI from preprocessed resting state data and a whole brain mask
%   if GNI>3, global signal regression may not be necessary
%
% reference:  
%   Chen G, Chen GY, Xie C, Ward BD, Li W, Antuono P and Li SJ. 
%   A Method to Determine the Necessity for Global Signal Regression in Resting-State fMRI Studies 
%   Magn Reson Med; doi: 10.1002/mrm.24201(2012)
%   Please cite the reference if you found the method useful.
%
% Author: Gang Chen
% Date:   25 May 2012
% Version: 1, initial release, limited function, limited testing has been performed. use at your own risk.
% 
% Requirement: 
%   You have to make sure "load_nii.m" and/or "BrikLoad.m" work in your matlab.
%   Google them, you may find the address where you can download them. You can
%   also send an email (gachen@mcw.edu) to me if you have questions. 
% 
% Input:
%   RestData: 
%       full path and name of the 4-D preprocessed resting state data,
%       the program will accept .nii and .BRIK + .HEAD format
%   WBMaskName:
%       full path and name of the 3-D whole brain mask, must align to the
%       RestData and have the same matrix size in the first three dimention
%       the program will accept .nii and .BRIK + .HEAD format
%   nVoxelPerSectionMax:
%       This is determined by the memory size of your computer
%       at 100 this program will take less than 1GB memory
%       at 1000 this program will take more memory but runs faster, adjust as
%       needed
% 
% example usage:
% clear;
% clc
% ResultFolder=['D:\Work\ADNI\LFTC\'];
% % dir([ResultFolder '*LFTC_NGR*.nii']);
% RestFiles=dir([ResultFolder '*LFTC_NGR*.nii']);
% WBMaskName='wWBMask4mm.nii';
% for i=1:numel(RestFiles)
%   disp(num2str(i))
%   RestData=[ResultFolder RestFiles(i).name];
%   GNI(i)=Rest2GNI(RestData,WBMaskName,100);
%   if GNI(i)<3
%     disp([RestFiles(i).name ' needs global signal regression'])
%   end
% end

if strcmpi(RestData(end-6:end),'.nii.gz')
  nii=load_nii_gz(RestData);
  WBTC=nii.img;
  nii=load_nii_gz(WBMaskName);
  WBMask=nii.img;
elseif strcmpi(RestData(end-3:end),'orig')
  [~, WBTC   , ~, ~] = BrikLoad(RestData);
  [~, WBMask   , ~, ~] = BrikLoad(WBMaskName);
else
  error('unknown data format')
end
nTP=size(WBTC,4);
if nTP<=1
  error('RestData is not a 4-D file')
end
nvoxel=size(WBTC,1)*size(WBTC,2)*size(WBTC,3);
WBTC=reshape(WBTC,[nvoxel nTP]);
GSTC=WBTC(WBMask==1,:);
GSTC=DeNaNInf(GSTC); % remove NaN value, sometimes the mask is outside of brain
GSTC=mean(GSTC,1);
% % GSTC=mean(WBTC(WBMask==1,:),1);
[R,P]=MyCorrcoefSmallLarge(GSTC.',WBTC.',nVoxelPerSectionMax);
P(P>=0.05)=1;
Z=p2z(P).*sign(R);
WBMask=double(WBMask);
Z3D=WBMask;
Z3D(:)=Z;
GSConMask=double(Z3D<-1.96).*double(WBMask);
nGSConVoxel=sum(GSConMask(:));
GNI=100*nGSConVoxel./sum(WBMask(:));

function [R,P]=MyCorrcoefSmallLarge(TC_Small,TC_Large,nTC_SectionMax)
% by default one colume of TC represent one time course.
% % For testing
% TC_Small = rand(141,10);
% TC_Large = rand(141,1079);
% nTC_SectionMax=500;
% tic;[R,P]=MyCorrcoefSmallLarge(TC_Small,TC_Large,nTC_SectionMax);toc
% size(R)
% [R2,P2]=mycorrcoef(TC_Small,TC_Large);
% sum(abs(R(:)-R2(:)))
% sum(abs(P(:)-P2(:)))

if nargin==2
  nTC_SectionMax=1000;
end
nTC=size(TC_Large,2);
nSection=ceil(nTC/nTC_SectionMax);
nTC_OneSection=ceil(nTC/nSection);
R=zeros(size(TC_Small,2),size(TC_Large,2));
P=R;
for iSection=1:nSection-1
  [r,p]=mycorrcoef(TC_Small,TC_Large(:,1+(iSection-1)*nTC_OneSection:iSection*nTC_OneSection));
  R(:,1+(iSection-1)*nTC_OneSection:iSection*nTC_OneSection)=r;
  P(:,1+(iSection-1)*nTC_OneSection:iSection*nTC_OneSection)=p;
end  
[r,p]=mycorrcoef(TC_Small,TC_Large(:,1+(nSection-1)*nTC_OneSection:end));
R(:,1+(nSection-1)*nTC_OneSection:end)=r;
P(:,1+(nSection-1)*nTC_OneSection:end)=p;
return

function [r,p]=mycorrcoef(TC1,TC2)
if nargout<=1 % Quickly dispose of most common case.
  %by default one colume of TC represent one time course.
  if size(TC1,1)==size(TC2,1) && size(TC1,1)~=1
    TC=[TC1 TC2];
    [CC]=corrcoef(TC);
    r=CC(1:size(TC1,2),size(TC1,2)+1:size(TC1,2)+size(TC2,2));
  elseif size(TC1,2)==size(TC2,2)
    TC=[TC1;TC2];
    [CC]=corrcoef(TC.');
    r=CC(1:size(TC1,1),size(TC1,1)+1:size(TC1,1)+size(TC2,1));
  end
  p=[];
else
  %by default one colume of TC represent one time course.
  if size(TC1,1)==size(TC2,1) && size(TC1,1)~=1
    TC=[TC1 TC2];
    [CC,P]=corrcoef(TC);
    r=CC(1:size(TC1,2),size(TC1,2)+1:size(TC1,2)+size(TC2,2));
    p=P(1:size(TC1,2),size(TC1,2)+1:size(TC1,2)+size(TC2,2));
  elseif size(TC1,2)==size(TC2,2)
    TC=[TC1;TC2];
    [CC,P]=corrcoef(TC.');
    r=CC(1:size(TC1,1),size(TC1,1)+1:size(TC1,1)+size(TC2,1));
    p=P(1:size(TC1,1),size(TC1,1)+1:size(TC1,1)+size(TC2,1));
  end
end


function m=DeNaNInf(m,Opt)
if nargin==1
  Opt.Display=0;
  Opt.Fast=0;
end
if ~isfield(Opt,'Fast')
  Opt.Fast=0;
end
if ~isfield(Opt,'Display')
  Opt.Display=0;
end
if Opt.Fast
  if Opt.Display
    nNotFinite=sum(~isfinite(m(:)));
  end
  m(~isfinite(m))=mean(m(isfinite(m)));
  if Opt.Display
    disp([num2str(nNotFinite) ' Non-finite elements (' num2str(100*nNotFinite/numel(m)) '%) replaced by the mean'])
  end
  return
end
nNaN=sum(isnan(m(:)));
m(isnan(m))=mean(m(~isnan(m)));
if Opt.Display
  disp([num2str(nNaN) ' NaN elements (' num2str(100*nNaN/numel(m)) '%) replaced by the mean'])
end

nInf=sum(isinf(m(:)));
m(isinf(m))=mean(m(~isinf(m)));
if Opt.Display
  disp([num2str(nInf) ' Inf elements (' num2str(100*nInf/numel(m)) '%) replaced by the mean'])
end

function z=p2z(p)
% See also z2p, normcdf, norminv, ranksum
z=-norminv(p/2);
