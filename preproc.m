% List of open inputs

order = [1 3 5 6 7 8 9 10 13 14 15 18 21 22 23];
type=["prememory"];
parfor n=1:15
    s=order(n);
    assignin('base','temp_s',s);
    for i=type
        assignin('base','temp',i);
        nrun = 1; % enter the number of runs here
        jobfile = {'/home/zmx/fMRI/preproc_job.m'};
        jobs = repmat(jobfile, 1, nrun);
        inputs = cell(0, nrun);
        for crun = 1:nrun
        end
        spm('defaults', 'FMRI');
        spm_jobman('run', jobs, inputs{:});
    end
end

