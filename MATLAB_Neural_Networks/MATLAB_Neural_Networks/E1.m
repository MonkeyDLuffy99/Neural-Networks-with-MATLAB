classdef E1 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        NetworkStructurePanel    matlab.ui.container.Panel
        UIAxes                   matlab.ui.control.UIAxes
        TruthTablePanel          matlab.ui.container.Panel
        UITable                  matlab.ui.control.Table
        ChooseaGatePanel         matlab.ui.container.Panel
        TrainandDisplayButton    matlab.ui.control.Button
        SelectGateDropDown       matlab.ui.control.DropDown
        SelectGateDropDownLabel  matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: TrainandDisplayButton
        function TrainandDisplayButtonPushed(app, ~)
            gate=app.SelectGateDropDown.Value;
            cla(app.UIAxes,'reset'); %clear network every time we use a new gate
            switch(gate)
                case {'OR'}
                    data=[0 0 0; 0 1 1; 1 0 1; 1 1 1];
                    inputs=data(:,1:2)';
                    targets=data(:,3)';
                    net=perceptron;
                    net.trainParam.showWindow = 0;
                    net.trainParam.epochs = 5;
                    net = train(net,inputs,targets);
                    table = net(inputs);
                    table=[inputs' table'];
                    app.UITable.Data=table;
                    wb=getwb(net);
                case {'AND'}
                    data=[0 0 0; 0 1 0; 1 0 0; 1 1 1];
                    inputs=data(:,1:2)';
                    targets=data(:,3)';
                    net=perceptron;
                    net.trainParam.showWindow = 0;
                    net.trainParam.epochs = 5;
                    net = train(net,inputs,targets);
                    table = net(inputs);
                    table=[inputs' table'];
                    app.UITable.Data=table;
                    wb=getwb(net);
                    biases = net.b;
                    weights = net.IW;
                    disp(weights);
                    disp(biases);
                case {'NAND'}
                    data=[0 0 1; 0 1 1; 1 0 1; 1 1 0];
                    inputs=data(:,1:2)';
                    targets=data(:,3)';
                    net=perceptron;
                    net.trainParam.showWindow = 0;
                    net.trainParam.epochs = 5;
                    net = train(net,inputs,targets);
                    table = net(inputs);
                    table=[inputs' table'];
                    app.UITable.Data=table;
                    wb=getwb(net);
                case {'XOR'}
                    data_or=[0 0 0; 0 1 1; 1 0 1; 1 1 1];
                    data_nand=[0 0 1; 0 1 1; 1 0 1; 1 1 0];
                    data_and=[0 0 0; 0 1 0; 1 0 0; 1 1 1];
                    inputs=data_or(:,1:2)';
                    targets_or=data_or(:,3)';
                    targets_nand=data_nand(:,3)';
                    targets_and=data_and(:,3)';
                    net=perceptron;
                    net.trainParam.showWindow = 0;
                    net.trainParam.epochs = 5;
                    net_or=train(net,inputs,targets_or); % train perceptron for 'or' operation
                    net_nand=train(net,inputs,targets_nand); % train perceptron for 'nand' operation
                    net_and=train(net,inputs,targets_and); % train perceptron for 'and' operation
                    xor_first_column=net_or(inputs); % first column are the targets of 'or' operation
                    xor_second_column=net_nand(inputs); % second column are the targets of 'nand' operation
                    xor_inputs=[xor_first_column;xor_second_column]; % inputs for perceptron for 'xor'
                    table= net_and(xor_inputs); % target of XOR = target_or AND target_nand
                    table=[inputs' table'];
                    app.UITable.Data=table;
                    wb=getwb(net_and);
                case {'IMPLY'}
                    data=[0 0 1; 0 1 1; 1 0 0; 1 1 1];
                    inputs=data(:,1:2)';
                    targets=data(:,3)';
                    net=perceptron;
                    net.trainParam.showWindow = 0;
                    net.trainParam.epochs = 5;
                    net = train(net,inputs,targets);
                    table = net(inputs);
                    table=[inputs' table'];
                    app.UITable.Data=table;
                    wb=getwb(net);
            end
                app.UIAxes.XLim=[-5 40];
                app.UIAxes.YLim=[2 47];
                rectangle(app.UIAxes,'Position',[10 15 15 15], 'Curvature',[1,1], 'LineWidth',1.5, 'EdgeColor', [0 0 0]); %node1
                line(app.UIAxes,[0 9.7],[27 25],'color',[0 0 0],'Marker','>','MarkerIndices',2,'MarkerFaceColor',[0 0 0]);% x1-node1
                line(app.UIAxes,[0 9.7],[18 20],'color',[0 0 0],'Marker','>','MarkerIndices',2,'MarkerFaceColor',[0 0 0]) %x2-node1
                line(app.UIAxes,[17 17],[40 31],'color',[0 0 0],'Marker','v','MarkerIndices',2,'MarkerFaceColor',[0 0 0]) %bias-node1
                line(app.UIAxes,[25 35],[22.5 22.5],'color',[0 0 0],'Marker','>','MarkerIndices',2,'MarkerFaceColor',[0 0 0]) %y-node1
                line(app.UIAxes, [17.5 17.5], [30 15], 'color', [0 0 0 ], 'LineWidth', 1.5); % split the node in two parts
                line(app.UIAxes, [18 20.5], [21 21], 'color', [0 0.1 1], 'LineWidth', 1.5); % line used for activation function
                line(app.UIAxes, [20.5 20.5], [21 25], 'color', [0 0.1 1], 'LineWidth', 1.5); % line used for activation function
                line(app.UIAxes, [20.5 23], [25 25], 'color', [0 0.1 1], 'LineWidth', 1.5); % line used for activation function
                text(app.UIAxes,36.3,22.5, "y",'Rotation',0,'FontSize',14); %y-output
                text(app.UIAxes,-2.7,18.2, "x2",'Rotation',0,'FontSize',14); %x2-output
                text(app.UIAxes,-2.7,27.2, "x1",'Rotation',0,'FontSize',14); %x1-output
                text(app.UIAxes, 15, 42, strcat("b=", sprintf("%d", wb(1))), 'Rotation',0,'FontSize',14) %bias
                text(app.UIAxes, 2, 28, strcat("w1=", sprintf("%d", wb(2))), 'Rotation',-10,'FontSize',14) %x1
                text(app.UIAxes, 2, 20, strcat("w2=", sprintf("%d", wb(3))), 'Rotation',10,'FontSize',14) %x2
                text(app.UIAxes, 11.5, 22.5, "\Sigma", 'FontSize',36); 
                axis(app.UIAxes, "off");
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

            % Create ChooseaGatePanel
            app.ChooseaGatePanel = uipanel(app.UIFigure);
            app.ChooseaGatePanel.Title = 'Choose a Gate';
            app.ChooseaGatePanel.FontName = 'Bookman Old Style';
            app.ChooseaGatePanel.FontWeight = 'bold';
            app.ChooseaGatePanel.FontSize = 14;
            app.ChooseaGatePanel.Position = [45 359 552 100];

            % Create SelectGateDropDownLabel
            app.SelectGateDropDownLabel = uilabel(app.ChooseaGatePanel);
            app.SelectGateDropDownLabel.HorizontalAlignment = 'right';
            app.SelectGateDropDownLabel.FontName = 'Arial';
            app.SelectGateDropDownLabel.Position = [21 28 71 22];
            app.SelectGateDropDownLabel.Text = 'Select Gate:';

            % Create SelectGateDropDown
            app.SelectGateDropDown = uidropdown(app.ChooseaGatePanel);
            app.SelectGateDropDown.Items = {'AND', 'OR', 'NAND', 'XOR', 'IMPLY'};
            app.SelectGateDropDown.FontName = 'Arial';
            app.SelectGateDropDown.Position = [107 28 100 22];
            app.SelectGateDropDown.Value = 'AND';

            % Create TrainandDisplayButton
            app.TrainandDisplayButton = uibutton(app.ChooseaGatePanel, 'push');
            app.TrainandDisplayButton.ButtonPushedFcn = createCallbackFcn(app, @TrainandDisplayButtonPushed, true);
            app.TrainandDisplayButton.FontName = 'Bookman Old Style';
            app.TrainandDisplayButton.Position = [367 28 120 22];
            app.TrainandDisplayButton.Text = 'Train and Display';

            % Create TruthTablePanel
            app.TruthTablePanel = uipanel(app.UIFigure);
            app.TruthTablePanel.Title = 'Truth Table';
            app.TruthTablePanel.FontName = 'Bookman Old Style';
            app.TruthTablePanel.FontWeight = 'bold';
            app.TruthTablePanel.FontSize = 14;
            app.TruthTablePanel.Position = [45 147 207 195];

            % Create UITable
            app.UITable = uitable(app.TruthTablePanel);
            app.UITable.ColumnName = {'x1'; 'x2'; 'y'};
            app.UITable.ColumnWidth = {50, 50, 50};
            app.UITable.RowName = {};
            app.UITable.CellEditCallback = createCallbackFcn(app, @UITableCellEdit, true);
            app.UITable.Position = [27 7 153 153];

            % Create NetworkStructurePanel
            app.NetworkStructurePanel = uipanel(app.UIFigure);
            app.NetworkStructurePanel.Title = 'Network Structure';
            app.NetworkStructurePanel.FontName = 'Bookman Old Style';
            app.NetworkStructurePanel.FontWeight = 'bold';
            app.NetworkStructurePanel.FontSize = 14;
            app.NetworkStructurePanel.Position = [280 22 317 320];

            % Create UIAxes
            app.UIAxes = uiaxes(app.NetworkStructurePanel);
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [1 -2 317 299];
            axis(app.UIAxes, "off");

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = E1

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