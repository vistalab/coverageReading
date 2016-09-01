%% GOOD ===================================================================================

goodLog.dtiInitLog.params

                     bvalue: []
               gradDirsCode: []
                    clobber: 0
                dt6BaseName: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/dti96trilin'
               flipLrApFlag: 0
        numBootStrapSamples: 500
                  fitMethod: 'ls'
                      nStep: 50
                eddyCorrect: 1
                excludeVols: []
          bsplineInterpFlag: 0
             phaseEncodeDir: []
                    dwOutMm: [0.8594 0.8594 2]
          rotateBvecsWithRx: 0
    rotateBvecsWithCanXform: 1
                  bvecsFile: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/DTI_2mm_96dir_2x_b2000_run1/dti.bvec'
                  bvalsFile: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/DTI_2mm_96dir_2x_b2000_run1/dti.bval'
            noiseCalcMethod: 'b0'
                     outDir: ''


goodDt6.xformVAnatToAcpc

    0.0001    0.0001    1.0000  -91.0152
   -0.0000   -1.0000    0.0001   90.9955
   -1.0000    0.0000    0.0001  108.9921
         0         0         0    1.0000


goodDt6.params

     nBootSamps: 500
      buildDate: '2015-07-27 16:51'
        buildId: 'rkimle on Matlab R2012b (GLNXA64)'
     rawDataDir: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri'
    rawDataFile: 'dti_aligned_trilin.nii'
         subDir: '/sni-storage/wandell/data/reading_prf/ad'


goodDt6.files

                b0: 'dti96trilin/bin/b0.nii.gz'
         brainMask: 'dti96trilin/bin/brainMask.nii.gz'
            wmMask: 'dti96trilin/bin/wmMask.nii.gz'
            wmProb: 'dti96trilin/bin/wmProb.nii.gz'
           tensors: 'dti96trilin/bin/tensors.nii.gz'
            vecRgb: 'dti96trilin/bin/vectorRGB.nii.gz'
             faStd: 'dti96trilin/bin/faStd.nii.gz'
             mdStd: 'dti96trilin/bin/mdStd.nii.gz'
           pddDisp: 'dti96trilin/bin/pddDispersion.nii.gz'
                t1: 't1.nii.gz'
      alignedDwRaw: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/dti_aligned_trilin.nii.gz'
    alignedDwBvecs: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/dti_aligned_trilin.bvecs'
    alignedDwBvals: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/dti_aligned_trilin.bvals'

    
%% BAD ===========================================================================

badLog.dtiInitLog.params

                     bvalue: []
               gradDirsCode: []
                    clobber: 0
                dt6BaseName: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/dti96trilin_run2_res2'
               flipLrApFlag: 0
        numBootStrapSamples: 500
                  fitMethod: 'ls'
                      nStep: 50
                eddyCorrect: 1
                excludeVols: []
          bsplineInterpFlag: 0
             phaseEncodeDir: []
                    dwOutMm: [0.8594 0.8594 2]
          rotateBvecsWithRx: 0
    rotateBvecsWithCanXform: 1
                  bvecsFile: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/DTI_2mm_96dir_2x_b2000_run2/dti.bvec'
                  bvalsFile: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/DTI_2mm_96dir_2x_b2000_run2/dti.bval'
            noiseCalcMethod: 'b0'
                     outDir: ''


badDt6.xformVAnatToAcpc

     1     0     0   -91
     0     1     0  -127
     0     0     1   -73
     0     0     0     1


badDt6.params

     nBootSamps: 500
      buildDate: '2015-08-31 15:15'
        buildId: 'rkimle on Matlab R2012b (GLNXA64)'
     rawDataDir: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri'
    rawDataFile: 'dti_aligned_trilin.nii'
         subDir: '/sni-storage/wandell/data/reading_prf/ad'


badDt6.files

                b0: 'dti96trilin_run1_res2/bin/b0.nii.gz'
         brainMask: 'dti96trilin_run1_res2/bin/brainMask.nii.gz'
            wmMask: 'dti96trilin_run1_res2/bin/wmMask.nii.gz'
            wmProb: 'dti96trilin_run1_res2/bin/wmProb.nii.gz'
           tensors: 'dti96trilin_run1_res2/bin/tensors.nii.gz'
            vecRgb: 'dti96trilin_run1_res2/bin/vectorRGB.nii.gz'
             faStd: 'dti96trilin_run1_res2/bin/faStd.nii.gz'
             mdStd: 'dti96trilin_run1_res2/bin/mdStd.nii.gz'
           pddDisp: 'dti96trilin_run1_res2/bin/pddDispersion.nii.gz'
                t1: 't1.nii.gz'
      alignedDwRaw: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/dti96trilin_run1_res2/bin/dti_aligned_trilin.nii.gz'
    alignedDwBvecs: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/dti96trilin_run1_res2/bin/dti_aligned_trilin.bvecs'
    alignedDwBvals: '/sni-storage/wandell/data/reading_prf/ad/20150717_dti_qmri/dti96trilin_run1_res2/bin/dti_aligned_trilin.bvals'


%% the t1 (ad)
niiT1.qto_xyz

ans =

     1     0     0   -91
     0     1     0  -127
     0     0     1   -73
     0     0     0     1