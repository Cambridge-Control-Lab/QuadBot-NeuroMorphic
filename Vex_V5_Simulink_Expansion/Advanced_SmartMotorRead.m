

classdef Advanced_SmartMotorRead< vexv5.vexSampleTime & ...
        matlab.system.mixin.Propagates & ...
        coder.ExternalDependency & ...
        matlab.system.mixin.internal.CustomIcon
    %VEX Smart Motor
    %
    % This class implements the driver for VEX Smart Motor encoder module.
    % This block outputs the Encoder output ,Velocity ,Fault
    %
    % Copyright 2018 The MathWorks, Inc.
    
    %#codegen
    
    properties (Nontunable)
        
        motorPort = '1'; %Smart Port
        EncoderUnit='Counts'; %Encoder Unit
        resetOption = 'No reset';%Reset Mode
        
    end
    
    properties (Hidden,Transient,Constant)
        %Motor Channel pin drop-down menu
        motorPortSet = matlab.system.StringSet({'1','2','3','4','5','6','7','8','9','10','11','12',...
            '13','14','15','16','17','18','19','20','21'});
    end
    
    % Public, non-tunable properties
  
    
    properties (Hidden, Nontunable)
        %To store the selected channel number
        motorSelected = uint8(1);
    end
    
    properties(Nontunable, Logical)
        %Output Velocity and Fault  
        additionalOutput=false;
    end
    
    methods
        % Constructor
        function obj = Advanced_SmartMotorRead(varargin)
            %This would allow the code generation to proceed with the
            %p-files in the installed location of the support package.
            coder.allowpcode('plain');
            % Support name-value pair arguments when constructing the
            % object.
            setProperties(obj,nargin,varargin{:});
        end
        
   
        
    end
    
    methods(Static, Access = protected)
        function header = getHeaderImpl
            % Define header panel for System block dialog
            header = matlab.system.display.Header('Title','Advanced Smart Motor Read',...
                'Text','vexv5 Advanced read block',...
                'ShowSourceLink',false);
        end
        
        function groups = getPropertyGroupsImpl(~)
            % Define section for properties in System block dialog box.
            requiredProps = matlab.system.display.Section(...
                'PropertyList', {'motorPort','additionalOutput','SampleTime'});
            groups = requiredProps;
        end
        
        function simMode = getSimulateUsingImpl(~)
            simMode = 'Interpreted execution';
        end
        
        function flag = showSimulateUsingImpl
            flag = false;
        end
    end
    
    methods (Access = protected)
        function maskDisplayCmds = getMaskDisplayImpl(obj)
            outport_label = '';
            outputs = getOutputNames(obj);
            inputs = getInputNames(obj);
            inputport_label='';
            if obj.getNumInputs
                inputport_label = ['port_label(''Input'',' num2str(1) ',''' inputs{1} ''');'  newline];
            end
            for i = 1:length(outputs)
                outport_label = [outport_label 'port_label(''output'',' num2str(i) ',''' outputs{i} ''');' newline]; %#ok<AGROW>
            end
            
            maskDisplayCmds = { ...
                'color(''white'');',...
                'plot([100,100,100,100]*1,[100,100,100,100]*1);',...
                'plot([100,100,100,100]*0,[100,100,100,100]*0);',...
                'color(''black'');', ...
                'image(fullfile(codertarget.vexcommon.internal.getRootDir, ''resources'', ''encoder.jpg''),''center'');', ...
                'patch([0.8, 0.8, 1, 1], [0.82857, 1, 1, 0.82857], [1, 1, 1]);' ...
                'color(''blue'');', ...
                'text(75, 92, ''VEX V5 '', ''horizontalAlignment'', ''right'');' ...
                'color(''black'');', ...
                ['text(50,15,' ['''Port: ' num2str(obj.motorPort) ''',''horizontalAlignment'',''center'');' newline]],...
                inputport_label,outport_label};
        end
        
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            motorVal=uint8(obj.motorPort(1:end)-48); % 48 is the ASCII value for '0'
            if  (length(motorVal)>1)
                obj.motorSelected =(10*motorVal(end-1) + motorVal(end))-1; %internal numbering ranges from 0 to 20.
            else
                obj.motorSelected= motorVal-1;
            end
            if coder.target ('Rtw')
                coder.cinclude('MW_SupportFunc_Wrapper.h');
              
                coder.ceval('DevicePresent',coder.opaque('V5_DeviceType','kDeviceTypeMotorSensor'),obj.motorSelected)
            end
        end
        
        
        
        function NumInputs = getNumInputsImpl(obj)
            %Specifying the number of inputs for the block
           
                NumInputs=0;
            
            
        end
        
     
        
        function OutputNum = getNumOutputsImpl(obj)
            %Specifying the number of outputs for the block
            if obj.additionalOutput
                OutputNum = 8;
            else
                OutputNum = 6;
            end
        end
        
        function [varargout] = getOutputNamesImpl(obj)
            varargout{1} = 'Voltage';
            varargout{2} = 'Current';
            varargout{3} = 'Power';
            varargout{4} = 'Torque';
            varargout{5} = 'Efficiency';
            varargout{6} = 'Temperature';
            if (obj.getNumOutputs==8)
                
                varargout{7} = 'Velocity';
                varargout{8} = 'Fault';
            else
                
            end
        end
        
        
        function varargout = isOutputFixedSizeImpl(obj)
            varargout{1} = true;
            varargout{2} = true;
            varargout{3} = true;
            varargout{4} = true;
            varargout{5} = true;
            varargout{6} = true;
               
            if (obj.getNumOutputs==3)
                
                varargout{7}= true;
                varargout{8}= true;
            else
                
            end
        end
        
        function varargout = getOutputSizeImpl(obj)
            varargout{1} = [1 1];
            varargout{2} = [1 1];
            varargout{3} = [1 1];
            varargout{4} = [1 1];
            varargout{5} = [1 1];
            varargout{6} = [1 1];
            if (obj.getNumOutputs==3)
                
                varargout{7}= [1 1];
                varargout{8}= [1 1];
                
            end
        end
        
        function varargout = getOutputDataTypeImpl(obj)
         
            varargout{1} = 'double';
            varargout{2} = 'double';
            varargout{3} = 'double';
            varargout{4} = 'double';
            varargout{5} = 'double';
            varargout{6} = 'double';
            if (obj.getNumOutputs==3)
                
                varargout{7}= 'double';
                varargout{8}= 'uint8';
                
            end
        end
        
        function varargout = isOutputComplexImpl(obj)
            varargout{1} = false;
            varargout{2} = false;
            varargout{3} = false;
            varargout{4} = false;
            varargout{5} = false;
            varargout{6} = false;
            if (obj.getNumOutputs==3)
                
                varargout{7}= false;
                varargout{8}= false;
                
            end
        end
        
        function [Voltage,Current,Power,Torque,Efficeincy,Temperature,Velocity,Fault] = stepImpl(obj,varargin)
            % Implement algorithm.
            Voltage =double(0);
            Current =double(0);
            Torque =double(0);
            Efficeincy =double(0);
            Temperature =double(0);
            Velocity = double(0);
            Fault = uint8(0);
            Power= double(0);
            if coder.target ('Rtw')
                Voltage=coder.ceval('vexMotorVoltageGet',obj.motorSelected);
                Current=coder.ceval('vexMotorCurrentGet',obj.motorSelected);
                Power=coder.ceval('vexMotorPowerGet',obj.motorSelected);
                Torque=coder.ceval('vexMotorTorqueGet',obj.motorSelected);
                Efficeincy=coder.ceval('vexMotorEfficiencyGet',obj.motorSelected);
                Temperature=coder.ceval('vexMotorTemperatureGet',obj.motorSelected);
               
                if obj.additionalOutput
                    Fault1= uint8(0);
                    Fault2= uint8(0);
                    Velocity = coder.ceval('vexMotorActualVelocityGet',obj.motorSelected);
                    Fault1 = coder.ceval('vexMotorCurrentLimitFlagGet',obj.motorSelected);
                    Fault2 = coder.ceval('vexMotorOverTempFlagGet',obj.motorSelected);
                    Fault =bitor((bitshift(Fault2,1)),Fault1);
                end
            end
        end
        
        function releaseImpl(obj)
            %functions to be called in model terminate
            
        end
        
    end
    
    methods (Static)
        function name = getDescriptiveName()
            name = 'Smart Motor Read';
        end
        
        function tf = isSupportedContext(ctx)
            if ctx.isCodeGenTarget('rtw')
                tf = true;
            else
                error('Not supported for this target');
            end
        end
        
        function updateBuildInfo(buildInfo,ctx)
            if ctx.isCodeGenTarget('rtw')
                sppkgroot = codertarget.vexv5.internal.getSpPkgRootDir();
                buildInfo.addIncludePaths(fullfile(sppkgroot,'include'));
            end
        end
    end
end
