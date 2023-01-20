classdef E2 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        SegemntConvertedPanel    matlab.ui.container.Panel
        RecogniseButton          matlab.ui.control.Button
        EntertextEditField       matlab.ui.control.EditField
        EntertextEditFieldLabel  matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: RecogniseButton
        function RecogniseButtonPushed(app, ~)

                    % --SEGMENT NUMBER (in hexadecimal)--
                    % 1 2 3 4 5 6 7 8 9 A B C D E
            values = [1 1 1 0 1 1 0 0 0 1 1 0 0 0; %A
                      1 0 0 1 1 1 0 1 0 0 1 0 1 0; %B
                      1 1 1 1 0 0 0 0 0 0 0 0 0 0; %C
                      1 0 0 1 1 1 0 1 0 0 0 0 1 0; %D
                      1 1 1 1 0 0 0 0 0 1 0 0 0 0; %E
                      1 1 1 0 0 0 0 0 0 1 0 0 0 0; %F
                      1 1 1 1 0 1 0 0 0 0 1 0 0 0; %G
                      0 1 1 0 1 1 0 0 0 1 1 0 0 0; %H
                      1 0 0 1 0 0 0 1 0 0 0 0 1 0; %I
                      0 0 1 1 1 1 0 0 0 0 0 0 0 0; %J
                      0 1 1 0 0 0 0 0 1 1 0 0 0 1; %K
                      0 1 1 1 0 0 0 0 0 0 0 0 0 0; %L
                      0 1 1 0 1 1 1 0 1 0 0 0 0 0; %M
                      0 1 1 0 1 1 1 0 0 0 0 0 0 1; %N
                      1 1 1 1 1 1 0 0 0 0 0 0 0 0; %0
                      1 1 1 0 1 0 0 0 0 1 1 0 0 0; %P
                      1 1 1 1 1 1 0 0 0 0 0 0 0 1; %Q
                      1 1 1 0 1 0 0 0 0 1 1 0 0 1; %R
                      0 1 0 1 0 1 0 0 0 1 1 0 0 0; %S (Flip first segment. Original representation is "1 1 0 1 0 1 0 0 0 1 1 0 0 0" but this is reserved for 5)
                      1 0 0 0 0 0 0 1 0 0 0 0 1 0; %T
                      0 1 1 1 1 1 0 0 0 0 0 0 0 0; %U
                      0 1 1 0 0 0 0 0 1 0 0 1 0 0; %V
                      0 1 1 0 1 1 0 0 0 0 0 1 0 1; %W
                      0 0 0 0 0 0 1 0 1 0 0 1 0 1; %X
                      0 0 0 0 0 0 1 0 1 0 0 0 1 0; %Y
                      1 0 0 1 0 0 0 0 1 0 0 1 0 0; %Z
                      0 0 0 0 1 1 0 0 1 0 0 0 0 0; %1
                      1 0 1 1 1 0 0 0 0 1 1 0 0 0; %2
                      1 0 0 1 1 1 0 0 0 0 1 0 0 0; %3
                      0 1 0 0 1 1 0 0 0 1 1 0 0 0; %4
                      1 1 0 1 0 1 0 0 0 1 1 0 0 0; %5
                      1 1 1 1 0 1 0 0 0 1 1 0 0 0; %6
                      1 0 0 0 1 1 0 0 0 0 0 0 0 0; %7
                      1 1 1 1 1 1 0 0 0 1 1 0 0 0; %8
                      1 1 0 1 1 1 0 0 0 1 1 0 0 0; %9
                      1 1 1 1 1 1 0 0 1 0 0 1 0 0]; %0
            
            values = transpose(values);
            
            T = eye(36, 36); % n by n matrix of one-hot encoded vectors
            
            % Train the network
            net = perceptron;
            net.trainParam.epochs = 75; % around 70 epochs to minimise loss function
            net = train(net, values, T);
            x = app.EntertextEditField.Value; % text entered by the user

            % create the figure to display characters and their 14-segment
            % representation
            f = figure;
            f.Position = [350 350 700 140];

            for i = 1:length(x)

                subplot(1, length(x), i);
             
                data =x(i); % get the i-th character of the input text

                if (x(i) == 'S')
                    duplicate = true;
                else
                    duplicate = false;
                end
            
                % convert the character into its corresponding 14-segment
                % format
                if x(i) == 'A'
                    data = values(:,1);
                elseif x(i) == 'B'
                    data = values(:,2);
                elseif x(i) == 'C'
                    data = values(:,3);
                elseif x(i) == 'D'
                    data = values(:,4);
                elseif x(i) == 'E'
                    data = values(:,5);
                elseif x(i) == 'F'
                    data = values(:,6);
                elseif x(i) == 'G'
                    data = values(:,7);
                elseif x(i) == 'H'
                    data =  values(:,8);
                elseif x(i) == 'I'
                    data = values(:,9);
                elseif x(i) == 'J'
                    data = values(:,10);
                elseif x(i) == 'K'
                    data = values(:,11);
                elseif x(i) == 'L'
                    data = values(:,12);
                elseif x(i) == 'M'
                    data = values(:,13);
                elseif x(i) == 'N'
                    data = values(:,14);
                elseif x(i) == 'O'
                    data = values(:,15);
                elseif x(i) == 'P'
                    data = values(:,16);
                elseif x(i) == 'Q'
                    data = values(:,17);
                elseif x(i) == 'R'
                    data = values(:,18);
                elseif x(i) == 'S'
                    data = values(:,19);
                elseif x(i) == 'T'
                    data = values(:,20);
                elseif x(i) == 'U'
                    data = values(:,21);
                elseif x(i) == 'V'
                    data = values(:,22);
                elseif x(i) == 'W'
                    data = values(:,23);
                elseif x(i) == 'X'
                    data = values(:,24);
                elseif x(i) == 'Y'
                    data = values(:,25);
                elseif x(i) == 'Z'
                    data = values(:,26);
                elseif x(i) == '1'
                    data = values(:,27);
                elseif x(i) == '2'
                    data = values(:,28);
                elseif x(i) == '3'
                    data = values(:,29);
                elseif x(i) == '4'
                    data = values(:,30);
                elseif x(i) == '5'
                    data = values(:,31);
                elseif x(i) == '6'
                    data = values(:,32);
                elseif x(i) == '7'
                    data = values(:,33);
                elseif x(i) == '8'
                    data = values(:,34);
                elseif x(i) == '9'
                    data = values(:,35);
                elseif x(i) == '0'
                    data = values(:,36);
                else
                    errordlg('Invalid character found. Application accepts only capital letters and numbers.', 'InputError');
                    break;
                end

                axis off;        % Hide axis
                xlim([0 0.5]);   % Set dimensions
                linewidth = 4;   % Set linewidth
                color = 'r';     % Set color to red

                % LINES THAT SHOW THE INDIVIDUAL SEGMENTS IN LIGHT BLACK COLOUR
                % USEFUL FOR DEBUGGING
                line([0 0.5], [1 1], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-1
                line([0 0],[0.5 1], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-2
                line([0 0],[0 0.5], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-3
                line([0 0.5], [0 0], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-4
                line([0.5 0.5],[0.5 1], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-5
                line([0.5 0.5],[0 0.5], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-6
                line([0 0.25], [1 0.55], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-7
                line([0.25 0.25], [1 0.55], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-8
                line([0.5 0.25], [1 0.55], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-9
                line([0 0.25], [0.5 0.5], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-10
                line([0.25 0.5], [0.5 0.5], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-11
                line([0 0.25],[0 0.45], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-12
                line([0.25 0.25],[0 0.45], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-13
                line([0.5 0.25],[0 0.45], 'Color', [0 0 0 0.1], 'LineWidth', linewidth); %segment-14
            
                % mark segments with red colour
                % draw the 14-segment display of the characters
                if duplicate % if character is 'S' then colour first segment reds
                    yline(1, 'Color', color, 'LineWidth', linewidth);
                end
                if data(1) == 1
                    yline(1, 'Color', color, 'LineWidth', linewidth);
                end
                if data(2) == 1
                    line([0 0],[0.5 1], 'Color', color, 'LineWidth', linewidth);
                end
                if data(3) == 1
                    line([0 0],[0 0.5], 'Color', color, 'LineWidth', linewidth);
                end
                if data(4) == 1
                    yline(0, 'Color', color, 'LineWidth', linewidth);
                end
                if data(5) == 1
                    line([0.5 0.5],[0.5 1], 'Color', color, 'LineWidth', linewidth);
                end
                if data(6) == 1
                    line([0.5 0.5],[0 0.5], 'Color', color, 'LineWidth', linewidth); 
                end
                if data(7) == 1
                    line([0 0.25], [1 0.55], 'Color', color, 'LineWidth', linewidth);
                end
                if data(8) == 1
                    line([0.25 0.25], [1 0.55], 'Color', color, 'LineWidth', linewidth);
                end
                if data(9) == 1
                    line([0.5 0.25], [1 0.55], 'Color', color, 'LineWidth', linewidth);
                end
                if data(10) == 1
                    line([0 0.25], [0.5 0.5], 'Color', color, 'LineWidth', linewidth);
                end
                if data(11) == 1
                    line([0.25 0.5], [0.5 0.5], 'Color', color, 'LineWidth', linewidth);
                end
                if data(12) == 1
                    line([0 0.25],[0 0.45], 'Color', color, 'LineWidth', linewidth);
                end
                if data(13) == 1
                    line([0.25 0.25],[0 0.45], 'Color', color, 'LineWidth', linewidth);
                end
                if data(14) == 1
                    line([0.5 0.25],[0 0.45], 'Color', color, 'LineWidth', linewidth);
                end
            
                % get character predicted by perceptron in one-hot vector
                % format
                c = net(data);
            
                % Convert predicted one-hot vector into its
                % corresponding character
                if c(1) == 1
                    c = 'A';
                elseif c(2) == 1
                    c = 'B';
                elseif c(3) == 1
                    c = 'C';
                elseif c(4) == 1
                    c = 'D';
                elseif c(5) == 1
                    c = 'E';
                elseif c(6) == 1
                    c = 'F';  
                elseif c(7) == 1
                    c = 'G';
                elseif c(8) == 1
                    c = 'H';
                elseif c(9) == 1
                    c = 'I';
                elseif c(10) == 1
                    c = 'J';
                elseif c(11) == 1
                    c = 'K';
                elseif c(12) == 1
                    c = 'L';
                elseif c(13) == 1
                    c = 'M';
                elseif c(14) == 1
                    c = 'N';
                elseif c(15) == 1
                    c = 'O';
                elseif c(16) == 1
                    c = 'P';
                elseif c(17) == 1
                    c = 'Q';
                elseif c(18) == 1
                    c = 'R';
                elseif c(19) == 1
                    c = 'S';
                elseif c(20) == 1
                    c = 'T';
                elseif c(21) == 1
                    c = 'U';
                elseif c(22) == 1
                    c = 'V';
                elseif c(23) == 1
                    c = 'W';
                elseif c(24) == 1
                    c = 'X';
                elseif c(25) == 1
                    c = 'Y';
                elseif c(26) == 1
                    c = 'Z';
                elseif c(27) == 1
                    c = '1';
                elseif c(28) == 1
                    c = '2';
                elseif c(29) == 1
                    c = '3';
                elseif c(30) == 1
                    c = '4';
                elseif c(31) == 1
                    c = '5';
                elseif c(32) == 1
                    c = '6';
                elseif c(33) == 1
                    c = '7';
                elseif c(34) == 1
                    c = '8';
                elseif c(35) == 1
                    c = '9';
                elseif c(36) == 1
                    c = '0';
                end
   
                % display predicted character
                title(string(c), 'FontSize', 22);
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create SegemntConvertedPanel
            app.SegemntConvertedPanel = uipanel(app.UIFigure);
            app.SegemntConvertedPanel.Title = '14-Segemnt Converted';
            app.SegemntConvertedPanel.FontName = 'Lucida Console';
            app.SegemntConvertedPanel.FontWeight = 'bold';
            app.SegemntConvertedPanel.FontSize = 16;
            app.SegemntConvertedPanel.Position = [73 131 514 221];

            % Create EntertextEditFieldLabel
            app.EntertextEditFieldLabel = uilabel(app.SegemntConvertedPanel);
            app.EntertextEditFieldLabel.HorizontalAlignment = 'right';
            app.EntertextEditFieldLabel.FontName = 'Lucida Sans Unicode';
            app.EntertextEditFieldLabel.FontSize = 14;
            app.EntertextEditFieldLabel.Position = [21 94 71 22];
            app.EntertextEditFieldLabel.Text = 'Enter text';

            % Create EntertextEditField
            app.EntertextEditField = uieditfield(app.SegemntConvertedPanel, 'text');
            app.EntertextEditField.FontName = 'Lucida Sans Unicode';
            app.EntertextEditField.FontSize = 14;
            app.EntertextEditField.Position = [107 94 100 22];

            % Create RecogniseButton
            app.RecogniseButton = uibutton(app.SegemntConvertedPanel, 'push');
            app.RecogniseButton.ButtonPushedFcn = createCallbackFcn(app, @RecogniseButtonPushed, true);
            app.RecogniseButton.FontName = 'Georgia';
            app.RecogniseButton.FontSize = 14;
            app.RecogniseButton.FontAngle = 'italic';
            app.RecogniseButton.Position = [224 93 100 25];
            app.RecogniseButton.Text = 'Recognise';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = E2

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end