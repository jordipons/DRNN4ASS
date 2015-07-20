#!/bin/bash

#$ -N run_train_noNorm_run1
#$ -cwd
#$ -q default.q
#$ -e $HOME/error
#$ -o $HOME/output
#$ -M idrojsnop@gmail.com
#$ -m bea
#$ -pe smp 12 -l mem_free=70G 
# --------------------------------
# Start script
# --------------------------------
#printf "Starting execution of job $JOB_ID from user $SGE_O_LOGNAME\n"
#printf "Starting at `date`\n"
#printf "Calling Matlab now\n"
#printf "---------------------------\n"

/soft/MATLAB/R2013b/bin/matlab -nojvm -nodisplay -r "run_train_noNorm_run1;quit"

#printf "---------------------------\n"
#printf "Matlab processing done.\n"
#printf "Job done. Ending at `date`\n"
