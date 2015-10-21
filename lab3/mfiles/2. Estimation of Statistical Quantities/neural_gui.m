%NOTES:
%REFER TO mathworks solution number 1-19BCA   if gui crashes when messing with the axes. 
%         (big headache, I hate matlab) Ricardo

function varargout = neural_gui(varargin)
% NEURAL_GUI M-file for neural_gui.fig
%      NEURAL_GUI, by itself, creates a new NEURAL_GUI or raises the existing
%      singleton*.
%
%      H = NEURAL_GUI returns the handle to a new NEURAL_GUI or the handle to
%      the existing singleton*.
%
%      NEURAL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEURAL_GUI.M with the given input arguments.
%
%      NEURAL_GUI('Property','Value',...) creates a new NEURAL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before neural_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop_button.  All inputs are passed to neural_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE'screen Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help neural_gui

% Last Modified by GUIDE v2.5 09-Oct-2004 14:14:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @neural_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @neural_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before neural_gui is made visible.
function neural_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to neural_gui (see VARARGIN)

% global variable to stop_button training
global NN_USER_STOP_TRAIN
NN_USER_STOP_TRAIN=0;

% Choose default command line output for neural_gui
handles.output = hObject;

% our data
global NNDATA

if nargin>3
  [nndata_in type]=gui_interpret_input(varargin{1});
  switch(type)
   case 'unknown'
    disp('Not a neural gui data structure');
    guidata(hObject, handles);
    close(hObject);
    return
   case 'struct'
    if(~isfield(nndata_in,'ninputs'))
      disp('Not a neural gui data structure');
      guidata(hObject, handles);
      close(hObject);
      return
    end
    NNDATA=nndata_in;
   otherwise
    if(~isfield(nndata_in,'NNDATA'))
      disp('Not a neural gui data structure');
      guidata(hObject, handles);
      close(hObject);
      return
    end
    NNDATA=nndata_in.NNDATA;
  end

else
  NNDATA=gui_netdefine; %pop up dialog box asking initial network
end

%setup screen preferences
axes(handles.screen);
axis ij
axis([0 499 0 249])

gui_draw_display_net(NNDATA); %draw standard net on screen


%initialize stop button to off
set(handles.stop_button, 'Enable', 'off');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes neural_gui wait for user response (see UIRESUME)
% uiwait(handles.neural_gui);


% --- Outputs from this function are returned to the command line.
function varargout = neural_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if(~isempty(handles))
  varargout{1} = handles.output;
end
  

% --- Executes on button press in create_net_button.
function create_net_button_Callback(hObject, eventdata, handles)
% hObject    handle to create_net_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global NNDATA

%choose axes to draw on
axes(handles.screen);

NNDATA=gui_netdefine(NNDATA); %modify network

%draw it on screen
gui_draw_display_net(NNDATA);

% --- Executes on mouse press over axes background.
function screen_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to screen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%this will be the "heart" of the program. The user pressed the screen, need to
%interpret what he wants
persistent LAST_BUTTON_CLICK     %we need to save which button was last clicked du to 'SelectionType' implementation
global NNDATA

if(isempty('LAST_BUTTON_CLICK')) %the first time around need to initialize the variable
    LAST_BUTTON_CLICK=0;
end

pos=get(hObject, 'CurrentPoint'); %get screen coordinates
pos=pos(1,1:2);                   

%get mouse button pressed
b=get(gcf,'SelectionType');
switch b          %decode the button press
    case 'open'
        button=LAST_BUTTON_CLICK;
    case 'normal'
        button=1;
    case 'extend'
        button=2;
    case 'alt'
        button=3;
end
LAST_BUTTON_CLICK=button;     %save it for future reference.

%find object clicked
obj=gui_find_clicked_object(NNDATA,pos);

if(isempty(obj))  %nothing was clicked
    return
end

need_plot=get(handles.plot_button,'Value'); %check if "plot" button is pressed and
set(handles.plot_button,'Value',0);         %reset it

switch(obj(1))
    case 0 %a layer was clicked
      if(button==3) %right button
        
        layer=NNDATA.layer{obj(2)}; 
        
        layer=gui_change_layer(layer); %call dialog box with layer options
        
        if(NNDATA.layer{obj(2)}.nunits~=layer.nunits) %did the number of units change?
          NNDATA.layer{obj(2)}=layer;    %save layer changes 
          NNDATA=gui_reset_net(NNDATA);   %reset net to update weights.
        else
          NNDATA.layer{obj(2)}=layer;    %save layer
        end
        
        
        gui_draw_display_net(NNDATA);  %display it on screen
        
      end
      
      if(button==1)
        disp('------------------------------------------');
        input=gui_propagate(1);
        if(isempty(input))
          return
        end
        
        %show output 
        layer_output=NNDATA.layer{obj(2)}.outputactivation;
        
        if(need_plot)
          figure
          plot(layer_output');
          title('Layer output');
          xlabel('sample');
          ylabel('output');
        else
          layer_output
        end

      end
      

    case 1 %a synapse was clicked
      
      if(button==1)
        disp('------------------------------------------');
        input=gui_propagate(1);
        if(isempty(input))
          return
        end
        
        %show output 
        weight=NNDATA.layer{obj(2)}.weight
      end
      
    case 2 %input layer was clicked
        if(button==3) %right button click
          NNDATA.gui.input.ninputs=NNDATA.ninputs;   %populate buttons
          NNDATA.gui.input.noutputs=NNDATA.layer{end}.nunits;          
          NNDATA.gui.input=gui_choose_input(NNDATA.gui.input);
          
          %check if something changed
          if((NNDATA.ninputs~=NNDATA.gui.input.ninputs)|(NNDATA.layer{end}.nunits~=NNDATA.gui.input.noutputs))
            NNDATA.ninputs=NNDATA.gui.input.ninputs;
            NNDATA.layer{end}.nunits=NNDATA.gui.input.noutputs;
            NNDATA=gui_reset_net(NNDATA);
          end
          
          %redraw net on screen since user might have changed input type
          gui_draw_display_net(NNDATA);
          
        end
        
        if(button==1)
          disp('------------------------------------------');
          [input, desired_output]=gui_propagate(0);
          
          if (isempty(input))
            return
          end
          
          %show it
          if(need_plot)
            figure
            subplot(2,1,1)
            plot(input');
            title('Input');
            xlabel('sample');
            ylabel('Value');
            
            subplot(2,1,2)
            plot(desired_output');
            title('Desired output');
            xlabel('sample');
            ylabel('Value');
          else  %show it
            input
            desired_output
          end

        end
    case 3 %error was clicked
        if(button==1)
          disp('------------------------------------------');
          [input, desired_output]=gui_propagate(1);
          if(isempty(input))
            return
          end
          
          sample_error = NNDATA.layer{end}.outputactivation - desired_output; 
          
          if(need_plot) %need plot?
            figure(1)
            plot(sample_error','x');
            title('Sample Error');
            xlabel('sample');
            ylabel('Error');
			holdflag = ishold;								% see if hold is on
			hold on
			plot([0 numel(sample_error)], [0 0], 'k')		% draw the horizontal axis
			if ~holdflag
				hold off									% reset the hold state
			end
	    
	    if(NNDATA.ninputs==1 & size(NNDATA.layer{end}.outputactivation,1)==1)
	      figure(2)
	      plot(input,desired_output','xr', input, NNDATA.layer{end}.outputactivation,'b-');
	      xlabel('input');
	      ylabel('output');
	      legend('desired output', 'MLP''s output');
	    end
	    
          else
            sample_error  %show it 
          end
        end
      case 4 %training was clicked
        if(button==1)
          disp('------------------------------------------');
          iteration_cost=NNDATA.train.cost;
          
          if(need_plot) %plot it
            figure
            plot(iteration_cost');
            title('Iteration Cost');
            xlabel('Iteration');
            ylabel('Cost');
          else
            if(~isempty(iteration_cost))
              training_cost=iteration_cost(end)   %show only the variable
            end

            %test data
            if(~isempty(NNDATA.gui.input.test))
              [input, desired_output]=gui_propagate(0,'test');                            
              testing_cost=test_cost(NNDATA,input,desired_output)
            end
            
          end
        end
        
        if button==3
          NNDATA.train=gui_traindefine(NNDATA.train);
          gui_draw_display_net(NNDATA);  %display it on screen (cost function might have changed)
                  
        end
        

    otherwise
        disp('TODO: UNKNOWN OBJECT TYPE CLICKED');
end


% --- Executes on button press in train_button.
function train_button_Callback(hObject, eventdata, handles)
% hObject    handle to train_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NNDATA
global NN_USER_STOP_TRAIN

[input, desired_output]=gui_propagate(0);
if(isempty(input))
  return
end

set(handles.plot_button,'Value',0);
set(handles.stop_button, 'Enable', 'on');
set(handles.train_button, 'Enable', 'off');
set(handles.epoch_button, 'Enable', 'off');
set(handles.reset_button, 'Enable', 'off');

NN_USER_STOP_TRAIN=0; %just to make sure...
NNDATA=trainbatch(NNDATA, input,desired_output);
set(handles.stop_button, 'Enable', 'off');
set(handles.train_button, 'Enable', 'on');
set(handles.epoch_button, 'Enable', 'on');
set(handles.reset_button, 'Enable', 'on');
NN_USER_STOP_TRAIN=0;


% --- Executes on button press in epoch_button.
function epoch_button_Callback(hObject, eventdata, handles)
% hObject    handle to epoch_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NNDATA
set(handles.plot_button,'Value',0);
%the following should be put in a function called here and by trainbatch.m
[input,desired_output]=gui_propagate(0);
if(isempty(input))
    return
end
NNDATA=dobatchepoch(NNDATA, input, desired_output); 
report(NNDATA, input,desired_output);


% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_button


% --- Executes on button press in reset_button.
function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NNDATA
set(handles.plot_button,'Value',0);
NNDATA=gui_reset_net(NNDATA);


% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global NN_USER_STOP_TRAIN
set(handles.plot_button,'Value',0);
NN_USER_STOP_TRAIN=1;



function nndata=gui_reset_net(nndata)
  nndata=reset_net(nndata);  %recreate weights and outputs with correct dimensions
  nndata.gui.display_net=gui_create_display_net(nndata); %recreate display net
  
  
function [input, desired_output]=gui_propagate(n,typ)
  %n indicates how far we need to go. n=0 get only the input; n=1 propagate input
  global NNDATA

  if(nargin<2)
    typ='training';
  end
  

  input=[];
  desired_output=[];
  if(strcmp(typ,'test'))
    input_data=gui_interpret_input(NNDATA.gui.input.test);
  else
    input_data=gui_interpret_input(NNDATA.gui.input.value);    
  end
  
  if(isempty(input_data))            %check if interpret_input succeeded 
    errordlg([ typ ' data unknown'],'Error','modal');
    return;
  end
  
  %now need to check if dimensions are correct
  if(size(input_data,1)~=NNDATA.ninputs+NNDATA.layer{end}.nunits)
    errordlg([typ ' data size is not correct'],'Error','modal');
    return;
  end

  
  input=input_data(1:NNDATA.ninputs,:);
  desired_output=input_data(1+NNDATA.ninputs:end,:);

  input=normalize(input,NNDATA.gui.input.normalize); %if normalize's range is not given nothing is done
  desired_output=normalize(desired_output,NNDATA.gui.input.normalize); 
  
  
  if n<1
    return 
  end
  
  NNDATA=forward(NNDATA, input);
  
  if n<2
    return
  end
  
  %anything else? maybe backprop?


% --- Executes on button press in classification.
function classification_Callback(hObject, eventdata, handles)
% hObject    handle to classification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global NNDATA

set(handles.plot_button,'Value',0);
set(handles.neural_gui,'Visible','off');
gui_pattern_classification(NNDATA);
set(handles.neural_gui,'Visible','on');


% --- Executes on button press in confusion_button.
function confusion_button_Callback(hObject, eventdata, handles)
% hObject    handle to confusion_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of confusion_button
global NNDATA

set(handles.plot_button,'Value',0);

disp('       TRAINING SET');
[input, desired_output]=gui_propagate(1);
if(~isempty(input))
  print_confusion_matrix(NNDATA, input,desired_output);
end

if(~isempty(NNDATA.gui.input.test))
  disp('       TEST SET');
  [input, desired_output]=gui_propagate(0,'test');
  print_confusion_matrix(NNDATA, input,desired_output);
end
                        
            


% --- Executes on button press in show_image.
function show_image_Callback(hObject, eventdata, handles)
% hObject    handle to show_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global NNDATA
set(handles.plot_button,'Value',0);
set(handles.neural_gui,'Visible','off');
picture_show(NNDATA);
set(handles.neural_gui,'Visible','on');
