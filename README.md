## Directories

**figures**         - code that generates figures, including figures for papers, posters, presentations

**functions**       - all functions live here

**organization**    - scripts that keep track of the workflow, bookKeeping scripts

**tractography**    - tractography-related code

**tutorials**       - tutorials for preprocessing, for running a pRF model, etc



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

**summary**     - Generate figures for exploratory purposes. Similar to _figScript_ but not as intense

**tSeries**     - tSeries related code.



