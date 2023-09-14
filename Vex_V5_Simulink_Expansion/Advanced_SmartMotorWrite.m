classdef Advanced_SmartMotorWrite < matlab.System & ...
        matlab.system.mixin.Propagates & ...
        coder.ExternalDependency & ...
        matlab.system.mixin.internal.CustomIcon
    %VEX Smart Motor
    %
    % This class implements the driver for VEX Smart Motor and provides a way to set the speed
    % of the Smart Motor.
    %
    % Copyright 2018 The MathWorks, Inc.
    
    %#codegen
    
    properties (Nontunable)
        
        motorPort = '1'; %Smart Port
        scaleFactor = '36:1';%Gearing Ratio
        MotorBrakeMode='Coast';%Braking Mode
        OperationMode='Velocity Control';%Control Mode
        
    end
    
    properties (Hidden,Transient,Constant)
        %Motor Channel pin drop-down menu
        motorPortSet = matlab.system.StringSet({'1','2','3','4','5','6','7','8','9','10','11','12',...
            '13','14','15','16','17','18','19','20','21'});
        scaleFactorSet = matlab.system.StringSet({'36:1','18:1','6:1'});
        MotorBrakeModeSet = matlab.system.StringSet({'Coast','Brake','Hold'});
        OperationModeSet= matlab.system.StringSet({'Velocity Control','Position Control','Advanced Control'});
    end
    
    % Public, non-tunable properties
    properties(Access = private, Nontunable,Dependent)
        %To store the selected channel number
        MotorBrakeModeEnum;
        scaleFactorSelectedEnum ;
    end
    
    properties (Hidden, Nontunable)
        %To store the selected channel number
        motorSelected = uint8(1);
    end
    
    methods
        % Constructor
        function obj = Advanced_SmartMotorWrite(varargin)
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
            header = matlab.system.display.Header('Title','Advanced Smart Motor Write',...
                'Text',DAStudio.message('vexv5:blocks:SmartMotorDescription'),...
                'ShowSourceLink',false);
        end
        
        function groups = getPropertyGroupsImpl(~)
            % Define section for properties in System block dialog box.
            Group = matlab.system.display.Section(...
                'PropertyList', {'motorPort','scaleFactor','MotorBrakeMode','OperationMode'});
            groups = Group;
        end
        
        function simMode = getSimulateUsingImpl(~)
            simMode = 'Interpreted execution';
        end
        
        function flag = showSimulateUsingImpl
            flag = false;
        end
    end
    
    methods
        function val = get.scaleFactorSelectedEnum(obj)
            if isequal(obj.scaleFactor,'36:1')
                val = 0;
            elseif isequal(obj.scaleFactor,'18:1')
                val = 1;
            elseif isequal(obj.scaleFactor,'6:1')
                val = 2;
                
            end
        end
        
        function val = get.MotorBrakeModeEnum(obj)
            if isequal(obj.MotorBrakeMode,'Coast')
                val = 0;
            elseif isequal(obj.MotorBrakeMode,'Brake')
                val = 1;
            elseif isequal(obj.MotorBrakeMode,'Hold')
                val = 2;
            end
        end
    end
    
    methods (Access = protected)
        function maskDisplayCmds = getMaskDisplayImpl(obj)
            
            inputs = getInputNames(obj);
            inputport_lable ='';
            for i = 1:length(inputs)
                inputport_lable = [inputport_lable 'port_label(''Input'',' num2str(i) ',''' inputs{i} ''');'  newline]; %#ok<AGROW>
            end
            
            maskDisplayCmds = { ...
                'color(''white'');',...
                'plot([100,100,100,100]*1,[100,100,100,100]*1);',...
                'plot([100,100,100,100]*0,[100,100,100,100]*0);',...
                'color(''black'');', ...
                'image(fullfile(codertarget.vexv5.internal.getSpPkgRootDir, ''resources'', ''vex-v5-motor2.png''),''center'');', ...
                'patch([0.8, 0.8, 1, 1], [0.82857, 1, 1, 0.82857], [1, 1, 1]);' ...
                'color(''blue'');', ...
                'text(99, 92, ''VEX V5 '', ''horizontalAlignment'', ''right'');' ...
                'color(''black'');', ...
                ['text(62,12,' ['''Port: ' num2str(obj.motorPort) ''',''horizontalAlignment'',''center'');' newline]],...
                inputport_lable};
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
                coder.ceval('DevicePresent',coder.opaque('V5_DeviceType','kDeviceTypeMotorSensor'),obj.motorSelected);
                coder.ceval('vexMotorBrakeModeSet',obj.motorSelected,obj.MotorBrakeModeEnum);
                coder.ceval('vexMotorGearingSet',obj.motorSelected,obj.scaleFactorSelectedEnum);
                coder.ceval('vexMotorPositionReset',obj.motorSelected);
                coder.ceval('vexMotorVoltageSet',obj.motorSelected,0);
            end
        end
        
        function InputNum = getNumInputsImpl(obj)
            %Specifying the number of inputs for the block
            if (strcmp(obj.OperationMode ,'Position Control'))
                InputNum =2;
            else
                InputNum =1;
            end
        end
        
        function varargout = getInputNamesImpl(obj)
            varargout{1} = 'Velocity';
            if (strcmp(obj.OperationMode ,'Advanced Control'))
                varargout{1} = 'Voltage(mV)';
            end
            if (obj.getNumInputs==2)
                varargout{2} = 'Position';
            end
        end
        
        function OutputNum = getNumOutputsImpl(~)
            %Specifying the number of outputs for the block
            OutputNum = 0;
        end
        
        function stepImpl(obj,varargin)
            % Implement algorithm.
            % Velocity is in rpm
            % range is nominally +/- 100 with 36:1 gearset, changing gears will increase
            % range accordingly.
            
            if coder.target ('Rtw')
                x = double(varargin{1});
                if (strcmp(obj.OperationMode ,'Advanced Control'))
                    % voltage range (-/+)12000mV
                    if(varargin{1}>12000)
                        x = 12000;
                    elseif(varargin{1}<-12000)
                        x = -12000;
                    end
                    
                    coder.ceval('vexMotorVoltageSet',obj.motorSelected,x);
                else
                    
                    if(varargin{1}>100)
                        x = 100;
                    elseif(varargin{1}<-100)
                        x = -100;
                    end
                    if (strcmp(obj.OperationMode ,'Position Control'))
                        %vexMotorAbsoluteTargetSet( uint32_t index, double position, int32_t velocity )
                        %Position the new motor target position
                        %Velocity the maximum motor velocity used
                        EncoderUnitTemp=coder.opaque('V5MotorEncoderUnits','kMotorEncoderCounts');
                        EncoderUnitTemp=coder.ceval('vexMotorEncoderUnitsGet',obj.motorSelected);
                        coder.ceval('vexMotorEncoderUnitsSet',obj.motorSelected,2);
                        coder.ceval('vexMotorAbsoluteTargetSet',obj.motorSelected,varargin{2},x);
                        coder.ceval('vexMotorEncoderUnitsSet',obj.motorSelected,EncoderUnitTemp);
                    else
                        coder.ceval('vexMotorVelocitySet',obj.motorSelected,x);
                    end
                end
            end
        end
        
        function releaseImpl(obj)
            %functions to be called in model terminate
            if coder.target('Rtw')% done only for code gen
                coder.ceval('vexMotorPositionReset',obj.motorSelected);
                coder.ceval('vexMotorVelocitySet',obj.motorSelected,0);
                coder.ceval('vexMotorVoltageSet',obj.motorSelected,0);
            end
        end
    end
    
    methods (Static)
        function name = getDescriptiveName()
            name = 'Smart Motor Write';
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
