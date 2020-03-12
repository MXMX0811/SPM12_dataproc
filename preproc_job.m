%-----------------------------------------------------------------------
% Job saved on 03-Dec-2019 16:18:26 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7487)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
%%

sub=evalin('base','temp_s');
if sub<10
    sub=['0',num2str(sub)];
else
    sub=num2str(sub);
end

index=evalin('base','temp');

pathname1=['/home/zmx/ds002311/sub-',sub,'/func/',char(index)]
sdir1=dir([pathname1,'/sub-',sub,'*.nii']);

TR=2;

for i=1:length(sdir1)
    imgfile{i,1}=[pathname1,'/',sdir1(i).name];
end

T1path=[];
sdir2=dir(['/home/zmx/ds002311/sub-',sub,'/anat/sub-',sub,'*.nii']);
T1path=['/home/zmx/ds002311/sub-',sub,'/anat/',sdir2.name];

matlabbatch{1}.spm.temporal.st.scans = {imgfile};
matlabbatch{1}.spm.temporal.st.nslices = 36;
matlabbatch{1}.spm.temporal.st.tr = TR;
matlabbatch{1}.spm.temporal.st.ta = TR-(TR/36);
matlabbatch{1}.spm.temporal.st.so = [2:2:36 1:2:36];
matlabbatch{1}.spm.temporal.st.refslice = 18;
matlabbatch{1}.spm.temporal.st.prefix = 'a';

matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.interp = 4;
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';

matlabbatch{3}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
matlabbatch{3}.spm.spatial.coreg.estimate.source = {T1path};
matlabbatch{3}.spm.spatial.coreg.estimate.other = {''};
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

matlabbatch{4}.spm.spatial.normalise.estwrite.subj.vol(1) = cfg_dep('Coregister: Estimate: Coregistered Images', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','cfiles'));
matlabbatch{4}.spm.spatial.normalise.estwrite.subj.resample(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.tpm = {'/home/zmx/spm12/tpm/TPM.nii'};
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
matlabbatch{4}.spm.spatial.normalise.estwrite.woptions.bb = [-90 -126 -72
        90 90 108];
matlabbatch{4}.spm.spatial.normalise.estwrite.woptions.vox = [3 3 3];
matlabbatch{4}.spm.spatial.normalise.estwrite.woptions.interp = 4;

matlabbatch{5}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Estimate & Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{5}.spm.spatial.smooth.fwhm = [6 6 6];
matlabbatch{5}.spm.spatial.smooth.dtype = 0;
matlabbatch{5}.spm.spatial.smooth.im = 0;
matlabbatch{5}.spm.spatial.smooth.prefix = 's';


