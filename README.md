# SPM12数据处理流程
__Auther: [Mingxin Zhang](https://github.com/nkMengXin)__

在MATLAB中输入spm fmri打开SPM。

## 一、数据准备：
SPM12使用.img/.hdr格式或.nii格式数据。这里使用nifti（.nii）格式。首先将要处理的*.dcm格式的数据转换为*.nii，可使用SPM的“DICOM Import”工具进行格式转换。在DICOM files中选择需要转换格式的.dcm文件，在Output directory中选择输出路径。输出图像格式为Single file（nii）NIfTI。点击运行。

## 二、预处理：
为便于处理以及后续操作，以下将预处理与个体水平分析、组水平分析分开。SPM中可进行批处理操作，便于同时进行一系列处理步骤。点击Batch打开Batch Editor，这里先将预处理步骤存入一个Batch。

### 1. Slice Timing（若实验设计为事件相关则需要进行，block设计跳过此步）:
Slice Timing用于校正层与层之间扫描时间的差异。点击SPM - Temporal - Slice Timing添加步骤。

双击Data，在Session中选择要输入的nifti文件。Number of Slices为层数（nifti文件为三维或四维图像，三维图像的维度表示了图像的尺寸，其中第三个维度即为此处需要的层数。四维图像由若干三维图像拼接而成，第四个维度为包含的三维图像的数量，即为序列时间），TR为扫描的时间间隔（s），TA由TA=TR-(TR/nslices)计算而得。以上参数由原始数据的头文件（其中存有各种参数）获得。可使用mricron打开图像后点击Window – Information得（如图），若安装了MRtrix也可输入命令mrinfo xxx.nii得到数据信息。

Slice order为扫描顺序。一般使用顺序扫描或间隔扫描。顺序扫描即为逐层扫描，从第一层依次扫至最后一层，例如图中数据为74×74×48，共有48层，因此此处填写1:48。若为间隔扫描即为先单数层再双数层，因此填写1:2:48 2:2:48。具体扫描顺序由数据采集时的情况决定。一般来说，如果图像获取是隔层进行的，则要先Slice Timing再进行Realign，如果图像各层是连续获取的，则要先进行Realign再做Slice Timing。Reference Slice为参考层，选择中间一层，即nslice/2。
可修改Prefix（输出文件的前缀，默认Slice Timing前缀为a）。

### 2. 头动校正
点击SPM – Spatial – Realign - Realign (Est & Res)。此步为了校正扫描过程中头部的移动造成的影响。

双击Data，点击Session，点击Dependency可选择前面步骤生成的数据（如果前面有步骤的话），选择“Slice Timing: Slice Timing Corr. Images (Sess 1)”。这样的话，这一步的输入数据即为上一步Slice Timing的结果。如果没有做Slice Timing，则在Session中选择原始的nifti数据。

在Resliced images中的Reslice Options中选择All Images + Mean Image，运行后生成r开头的文件（校正过的每帧图像）和一个mean开头的文件（所有图像的平均）。此外还会生成一个文本文件，其中时整个时间序列内的头动参数，一般为6参数，即为位置和转动。

### 3. 配准
选择Coregister（Estimate）。这一步是为了将功能像与结构像对准。

点击Dependency选择前面生成的结果：在参考像中选择“Realign: Estimate & Reslice: Mean Image”；在source中选择T1结构像。


### 4. Normalise：
点击SPM – Spatial – Normalise - Normalise (Estimate & Write)。这一步为的是将所有功能像对齐到同一个标准空间。

双击Data新建Subject。点击Dependency选择前面生成的结果：在Image to Align中选择“Coregister: Estimate: Coregistered Images”；在Images to Write中选择“Realign: Estimate & Reslice: Resliced Images (Sess 1)”。

在Writing Options中修改体素大小Voxel Size。本例为[3  3  3]（改为3×3×3后图像大小成为61×73×61）。

Bounding Box根据图像大小更改。默认尺寸一般偏小，一般使用[-90 -126 -72 
90 90 108]。

### 5. Smooth：
点击SPM – Spatial – Smooth。

Images to Smooth中选择”Normalise: Estimate & Write: Normalised Images (Subj 1)”。

FWHM：设为[6  6  6]（即为体素大小的二倍）。

至此，数据预处理的步骤已经完成，可将此Batch保存以备重复使用。点击绿色箭头可运行Batch。这样就会依次生成以上各步骤的结果文件。最终结果前缀为swr（若进行了Slice Timing则前缀为swra）。另外，Batch还可以保存为MATLAB脚本，以便于进行更多的操作。

点击File – Save Batch and Script即可保存脚本。保存结果为两个.m文件，_job后缀文件内是各步骤参数，运行另一个文件可运行Batch。可以在脚本内修改输入文件等参数实现数据的批量处理。

## 三、个体水平统计：
新建一个Batch。以下步骤为对每个个体进行分析。

### 1. fMRI model specification:
点击SPM – Stats – fMRI model specification。在Directory中选择输出位置（输出一SPM.mat文件）。

Units for design决定Condition中时间单位，是时间点或者秒。若以扫描的时间点（即次数）作为时间单位则选择Scans，若以秒作为单位则选择Seconds。Interscan interval即为TR，本例中为0.75。

新建Subject/Session，在Scans中选择完成预处理的文件。

Conditions为任务条件，即为block设计中的各组块。实验设计中有几种状态就建立几个Condition。点击Conditions – New: Condition新建Condition。本例中只有做任务与否的两个状态，因此建立两个Condition。

在Name中输入状态的名称。Onsets代表该状态的启动时间，Durations为该状态的持续时间（若是事件相关设计此处填0）。注意单位应与Units for design一致。本例为组块设计，两状态交替进行，各持续30s，TR为0.75s。任务态先开始，因此任务态Onsets为[1  81  161  241  321  401  481  561]，不做任务的Onsets为[41  121  201  281  361  441  521  601]，两个Condition的Durations都为40（以Scans为单位）。若Units for design选择Seconds，则任务态Onsets为[1 61 121 ……]以此类推，Durations都为30。

Multiple regressors选择前面的头动参数文件，即rp开头的txt文件。

### 2. Estimate:
点击SPM – Stats – Model estimation。选择Select SPM.mat，点击Dependency，选中”fMRI model specification: SPM.mat File”。

### 3. Contrast Manager：
点击SPM – Stats – Contrast Manager。选择Select SPM.mat，点击Dependency，选中”Model estimation: SPM.mat File”。
新建T-contrast。

根据任务进行顺序依次排列Weights vector：如第一段状态为1，第二段[0  1]，第三段[0  0  1]，以此类推。本例中有两个状态，两个状态分别为1与[0 1]。
若有加减运算则将要操作的两个Weights vector互作加减，例如任务态先开始则为1。

不做任务的状态在任务态之后为[0  1]，TASK-REST则为[1  0]与[0  1]相减得[1 -1]。

点击“Save Batch and Script”，得到个体水平统计的Batch脚本。运行脚本后，在SPM菜单点击Results，选中每个个体生成的SPM.mat。选中一个contrast，点击Done
apply masking选择none，p value选择FWE，使用默认的值0.05，& extent threshold {voxels} 使用默认值0。

在Graphics中可查看结果。在Display中点击overlays...选择sections，选择标准脑模板可将结果标注在标准脑上。
也可在其他结果统计软件中如DPABI或Restplus中查看spmT00x.nii（x为contrast的序号，spmT001即为第一个Contrast），选择其他统计方法（如GRF）得到激活区域。

## 四、组水平分析：
点击Specify 2nd-level。在Directory中选择组分析的结果输出目录。Design选择默认，One-sample t-test。在Scans中选择想要分析的Contrast在个体水平分析的结果。例如，想要得到个体水平分析时第一个contrast在组水平的结果，就在Scans中选择所有个体的con_0001.nii。本例中共有20个个体，想要分析TASK-REST的组水平结果，TASK-NAVI在个体水平分析时是第三个Contrast，因此选择20个个体各自的con_0003.nii。

Estimation与个体水平分析相同，添加此步骤，点击Select SPM.mat，点击Dependency选择“Factorial design specification: SPM.mat File”（上一步的结果）。
点击SPM – Stats – Contrast Manager。选择Select SPM.mat，点击Dependency，选中”Model estimation: SPM.mat File”。新建T-contrast，填写Name，Weights matrix填入1。

组水平分析步骤完成，保存脚本运行，得到组水平分析结果。查看组水平分析结果并得到激活区域的方法与个体水平相同。

以上为SPM12进行数据处理的基本流程，步骤或许与其他教程有出入，还需要根据任务以及实验设计具体情况而定。
