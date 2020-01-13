% List of open inputs
global index type
type=[7:27 30]; 
for i=type
    index=i;
    nrun = 1; % enter the number of runs here
    jobfile = {'/home/zmx/fMRI/preproc_job.m'};
    jobs = repmat(jobfile, 1, nrun);
    inputs = cell(0, nrun);
    for crun = 1:nrun
    end
    spm('defaults', 'FMRI');
    spm_jobman('run', jobs, inputs{:});
end

