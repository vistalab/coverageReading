## Directories

**figures**         - code that generates figures, including figures for papers, posters, presentations

**functions**       - all functions live here

**organization**    - scripts that keep track of the workflow, bookKeeping scripts

**tractography**    - tractography-related code

**tutorials**       - tutorials for preprocessing, for running a pRF model, etc

## Key Figures

**Individual FOV (with pRF centers and half max contour)**

figScript_coverage_individual.m
E.g. Figure 4 in FOV paper

**Group average FOV (with half max contour)**

figScript_coverage_contours_generic.m
E.g. Figure 3C in FOV paper

**Group average FOV with bootstrapped confidence interval**

figScript_coverage_bootstrapOverIndividuals.m
E.g. Figure 8B and D in FOV paper

**Variance explained for each subject**
summary_individual_varExp.m
E.g. Figure 6A in FOV paper

**Time series for a single voxel, multiple data types** 
tSeries_plotVoxelMultipleRms.m
E.g. Figure 6B in FOV paper

**ROI definition on the mesh**
meshimg_screenShot.m
E.g. Figure 7A in FOV paper

**Distribution of Relative_rmse in an ROI**
summary_modelPred_vs_testRetest.m
E.g. Figure 10C in FOV paper


### pRF paper
Le, R., Ben-Shachar, M., & Wandell, B. (2017). Le, R., Witthoft, N., Ben-Shachar, M., & Wandell, B. (2017). The field of view available to the ventral occipito-temporal reading circuitry. Journal of vision, 17(4), 6-6. In preparation. 


## Namespaces 

**check**       - Checks for the existence certan types of data (ret models, rois) across subjects

**coverage**    - Plots things related to the visual field coverage

**datatype**    - Manipulate (e.g. copy, remove last scan) a mrVista datatype

**explore**     - This probably shouldn't be here. Hashing , figuring things out

**fig**         - Generate a figure (not directly related to data). ie colorbar or polar gird

**files**       - Related to the naming and renaming of files. Maybe should have a different namespace 

**figEdit**     - Sometimes minor changes are made to a figure after it's been generated.
                E.g. colorbar, axes label size. These scripts change the default values.

**figScript**   - Generate figures to be used in a paper or presentation. 
                Especially mportant to keep track.

**ff**          - Functions

**gui**         - Open a mrVista gui and load things (pmap, ret model) for a given subject

**mshimg**      - Related to the visualization of a mesh

**parfiles**    - Parfiles (parameter files for for GLM) related code

**pmap**        - Parameter map related code

**pp**          - Preprocessing. Usually save a copy of these scripts into the subject's directory

**roi**         - Manipulate (e.g. combine, rename) a mrVista roi mat file

**rm**          - Ret model related code

**rmroi**       - Ret model data for an roi

**s**           - Stands for scripts. We like to save these into the subject's directory. 
                Includes things like the script used to prf models, info we want to keep around

**summary**     - Generate figures for exploratory purposes

**tSeries**     - tSeries related code.



