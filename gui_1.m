function varargout = gui_1(varargin)
% GUI_1 MATLAB code for gui_1.fig
%      GUI_1, by itself, creates a new GUI_1 or raises the existing
%      singleton*.
%
%      H = GUI_1 returns the handle to a new GUI_1 or the handle to
%      the existing singleton*.
%
%      GUI_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_1.M with the given input arguments.
%
%      GUI_1('Property','Value',...) creates a new GUI_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_1

% Last Modified by GUIDE v2.5 30-May-2018 04:49:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_1_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_1 is made visible.
function gui_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_1 (see VARARGIN)

%preprocessing
set(handles.rbOriginal, 'value', 1);
set(handles.rbLena, 'value', 1);
set(handles.rbSI, 'value', 0);
set(handles.rb2I, 'value', 0);
setEnableVisibleStates(handles);

handles.valRot = 0;
handles.valRes = 1.0;

handles = loadImageData(handles);

% Choose default command line output for gui_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rbORG = get(handles.rbOriginal, 'value');
rbLP = get(handles.rbLPFilter, 'value');
rbDS = get(handles.rbDSampling, 'value');
rbEQH = get(handles.rbEQHist, 'value');
rbFFT = get(handles.rbFFT, 'value');
rbPIM = get(handles.rbPolarImg, 'value');
rbPFFTIM = get(handles.rbPolarImgFFT, 'value');

if rbORG == 1
    axes(handles.axes1)
    imshow(handles.img_original);
elseif rbLP == 1
    axes(handles.axes1)
    imshow(handles.im_lpf);
elseif rbDS == 1
    axes(handles.axes1)
    imshow(handles.im_ds);   
elseif rbEQH == 1
    axes(handles.axes1)
    imagesc(handles.im_eqh); axis image;  
elseif rbFFT == 1
    axes(handles.axes1)
    imagesc(log(abs(handles.im_fft)+1)); axis image;
elseif rbPIM == 1
    axes(handles.axes1)
    imagesc(handles.pcimg); axis image;
elseif rbPFFTIM == 1
    axes(handles.axes1)
    imagesc(log(abs(handles.fpcimg)+1)); axis image;
end


% --- Executes when selected object is changed in uibuttongroup2.
function uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.rbOriginal, 'value', 1);
handles = loadImageData(handles);

% Update handles structure
guidata(hObject, handles);

%*********************************************
%*****************************Vlad Functions *
%MY functions for gui interface              *
%*****************************Description End*
%*********************************************

%Get the current name of the selected image from Image panel
function outData = getImageName(handles)

rbLena = get(handles.rbLena, 'value');
rbT1 = get(handles.rbTest1, 'value');
rbT2 = get(handles.rbTest2, 'value');

if rbLena == 1
    handles.imageName = 'lena.png';
elseif rbT1 == 1
    handles.imageName = 'lena_rot90.png';
elseif rbT2 == 1
    handles.imageName = '1.png';
end

outData = handles;
return;

%Compute data for curret selected image
function outData = loadImageData(handles)

handles = getImageName(handles);

[ handles.im_lpf, handles.im_ds, handles.im_eqh, handles.im_fft, handles.pcimg, handles.fpcimg ] = vlad_preprocStage(handles.imageName);

handles.img_original = imread(handles.imageName);

axes(handles.axes1)
imshow(handles.img_original);

outData = handles;
return;

%Initialize all postprocessing ui controls for processing data
function outData = setEnableVisibleStates(handles)

    set(handles.btnLI1, 'enable', 'off');
    set(handles.lblI1, 'visible', 'off');
    set(handles.btnLI2, 'enable', 'off');
    set(handles.lblI2, 'visible', 'off');
    set(handles.sliderRot, 'enable', 'off');
    set(handles.sliderRes, 'enable', 'off');
    set(handles.lblval1, 'visible', 'off');
    set(handles.lblval2, 'visible', 'off');
    set(handles.btnProcess, 'enable', 'off');
    
return;

%*********************************************
%*****************************Vlad Functions *
%End for functions here*
%*****************************Description End*
%*********************************************


% --- Executes on button press in btnLoadImage.
function btnLoadImage_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path] = uigetfile('*.png');
if isequal(file,0)
   disp('User selected Cancel! Nothing happend');
else
   disp(['User selected ', fullfile(path,file)]);
   handles.imageName = file;
   
   set(handles.rbLena, 'value', 0);
   set(handles.rbTest1, 'value', 0);
   set(handles.rbTest2, 'value', 0);
   set(handles.lblImgName, 'String', file);
   
   set(handles.rbOriginal, 'value', 1);

   [ handles.im_lpf, handles.im_ds, handles.im_eqh, handles.im_fft, handles.pcimg, handles.fpcimg ] = vlad_preprocStage(handles.imageName);

   handles.img_original = imread(handles.imageName);

   axes(handles.axes1)
   imshow(handles.img_original);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnLI1.
function btnLI1_Callback(hObject, eventdata, handles)
% hObject    handle to btnLI1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.png');
if isequal(file,0)
   disp('User selected Cancel! Nothing happend');
else
   disp(['User selected ', fullfile(path,file)]);
   handles.imageName1 = file;
   
   set(handles.lblI1, 'String', file);
   
   img = imread(file);
   handles.img1 = img;
   axes(handles.axes2)
   imshow(img);
end


% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnLI2.
function btnLI2_Callback(hObject, eventdata, handles)
% hObject    handle to btnLI2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file,path] = uigetfile('*.png');
if isequal(file,0)
   disp('User selected Cancel! Nothing happend');
else
   disp(['User selected ', fullfile(path,file)]);
   handles.imageName2 = file;
   
   set(handles.lblI2, 'String', file);
   
   img = imread(file);
   handles.img2 = img;
   axes(handles.axes3)
   imshow(img);
end


% Update handles structure
guidata(hObject, handles);


% --- Executes when selected object is changed in uibuttongroup3.
function uibuttongroup3_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup3 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rbSI = get(handles.rbSI, 'value');
rb2I = get(handles.rb2I, 'value');

set(handles.lblres, 'String', 'nothing');

set(handles.btnLI1, 'enable', 'on');
set(handles.lblI1, 'visible', 'on');

set(handles.lblI1, 'String', 'img');
set(handles.lblI2, 'String', 'img');

handles.imageName1 = 'none';
handles.imageName2 = 'none';
cla(handles.axes2, 'reset');
cla(handles.axes3, 'reset');

if rbSI == 1
    set(handles.btnLI2, 'enable', 'off');
    set(handles.lblI2, 'visible', 'off');
    set(handles.sliderRot, 'enable', 'on');
    set(handles.sliderRes, 'enable', 'on');
    set(handles.lblval1, 'visible', 'on');
    set(handles.lblval2, 'visible', 'on');
    
    set(handles.btnProcess, 'enable', 'off');
elseif rb2I == 1
    set(handles.btnLI2, 'enable', 'on');
    set(handles.lblI2, 'visible', 'on');
    set(handles.sliderRot, 'enable', 'off');
    set(handles.sliderRes, 'enable', 'off');
    set(handles.lblval1, 'visible', 'off');
    set(handles.lblval2, 'visible', 'off');
    
    set(handles.btnProcess, 'enable', 'on');
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on slider movement.
function sliderRes_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = hObject.Value;
valStr = num2str(val);
handles.valRes = val;

set(handles.lblval2, 'String', valStr);

% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderRes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderRot_Callback(hObject, eventdata, handles)
% hObject    handle to sliderRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = hObject.Value;
valStr = num2str(val);
valStr = strcat(valStr, ' deg');
handles.valRot = val;

set(handles.lblval1, 'String', valStr);

% Update handles structure
guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderRot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btnApply.
function btnApply_Callback(hObject, eventdata, handles)
% hObject    handle to btnApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rb2I = get(handles.rb2I, 'value');

if rb2I
    return;
end

if strcmp(handles.imageName1, 'none')
    disp('Nothing to process');
    return;
end

rot = handles.valRot;
res = handles.valRes;
img = handles.img1;

imgp = imrotate(img, rot);
imgp = imresize(imgp, res);
axes(handles.axes3)
imshow(imgp);
handles.img2 = imgp;
handles.imageName2 = 'ceva';

set(handles.btnProcess, 'enable', 'on');


% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnProcess.
function btnProcess_Callback(hObject, eventdata, handles)
% hObject    handle to btnProcess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(handles.imageName1, 'none')
    disp('Not enough data');
    return;
end
if strcmp(handles.imageName2, 'none')
    disp('Not enough data');
    return;
end

%process the actual image and calculate the hamming distance

%Final decision

%Input data
i_name1 = handles.imageName1;
i_name2 = handles.imageName2;
FFT_Prec = 1024;
K = 360;
precision = 8;
precisionFactor = 0.62;


%Read images and convert to grayscale
i_1 = handles.img1;
i_2 = handles.img2;
if size(i_1,3) == 3
    i_1 = rgb2gray(i_1);
end
if size(i_2,3) == 3
    i_2 = rgb2gray(i_2);
end

rbSI = get(handles.rbSI, 'value');
if rbSI
    precisionFactor = 2.73;
end


%LOW PASS FILTERING
i_1 = apply_low_pass(i_1);
i_2 = apply_low_pass(i_2);


%DOWNSAMPLING
i_1 = downsample_image(i_1);
i_1 = double(i_1) / 255;
i_2 = downsample_image(i_2);
i_2 = double(i_2) / 255;


%EQUALISE HISTOGRAM
i_1 = histeq(i_1);
i_2 = histeq(i_2);


%FFT2 the preprocessed image
I_1 = fftshift(fft2(i_1, FFT_Prec, FFT_Prec));
I_2 = fftshift(fft2(i_2, FFT_Prec, FFT_Prec));


%Images in polar coordonates
I_1_PC = imgpolarcoord(I_1); I_1_PC = abs(I_1_PC);
min_I = min(I_1_PC(:)); I_1_PC = I_1_PC - min_I;
max_I = max(I_1_PC(:)); I_1_PC = I_1_PC / max_I;
I_2_PC = imgpolarcoord(I_2); I_2_PC = abs(I_2_PC);
min_I = min(I_2_PC(:)); I_2_PC = I_2_PC - min_I;
max_I = max(I_2_PC(:)); I_2_PC = I_2_PC / max_I;


%Extract feature for images
beta = get_rbytes('asdf1234', 11, K);
[rho_length, ~] = size(I_1_PC);
h1=zeros(rho_length, 1);
h2=zeros(rho_length, 1);
for j=1:1:rho_length
    for i=1:1:K
        h1(j) = h1(j) + I_1_PC(j, i);
        h2(j) = h2(j) + I_2_PC(j, i);
    end;
end;

min_h = min(h1); h1 = h1 - min_h; max_h = max(h1); h1 = h1 / max_h;
min_h = min(h2); h2 = h2 - min_h; max_h = max(h2); h2 = h2 / max_h;
h1 = floor(h1 * (2^precision - 1));
h2 = floor(h2 * (2^precision - 1));


%Gray code
h1_g = bin2gray(h1, 'fsk', 2^precision);
h2_g = bin2gray(h2, 'fsk', 2^precision);

%Hamming distance
[r, ~] = size(h1);
D = 0;
D_g = 0;

for i=1:r
    toAdd = abs(h1(i) - h2(i));
    D = D + toAdd;
    
    toAdd = abs(h1_g(i) - h2_g(i));
    D_g = D_g + toAdd;
end

D = D / r;
D = D / precisionFactor;
D_g = D_g / r;

D_str = num2str(D);
set(handles.lblres, 'String', D_str);


clear max_h, clear min_h, clear max_I, clear min_I , clear i_name1, clear i_name2;
clear i, clear j, clear i_1, clear i_2;



% Update handles structure
guidata(hObject, handles);
