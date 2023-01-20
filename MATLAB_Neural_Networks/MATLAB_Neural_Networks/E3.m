classdef E3 < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        SimilarcoauthorsPanel       matlab.ui.container.Panel
        FindSimilarButton           matlab.ui.control.Button
        ChooseAuthorEditField       matlab.ui.control.EditField
        ChooseAuthorEditFieldLabel  matlab.ui.control.Label
        Top10ListBox                matlab.ui.control.ListBox
        Top10ListBoxLabel           matlab.ui.control.Label
        MostImportantAuthorsPanel   matlab.ui.container.Panel
        ListAuthorsButton           matlab.ui.control.Button
        Top20ListBox                matlab.ui.control.ListBox
        Top20ListBoxLabel           matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        % Avoid getting errors
        function startupFcn(~)
          
        end

        % Button pushed function: ListAuthorsButton
        function ListAuthorsButtonPushed(app, ~)
            struct = load("dblp.mat"); %must be on the same folder
            dg=digraph(struct.Problem.A); % use adjaceny matrix for directional graph
            c=0.6; %mentioned in the exercise
            n=numnodes(dg);
            A=full(adjacency(dg));
            o=outdegree(dg);
            z=o==0;
            o(z)=1;
            W=A./o';% normalized A
            p=ones(n,1)*(1/n); % initialisation step
            % TOP 20 VALUES FOR STATIONARY DISTRIBUTION OF p:
            % 0.0014
            % 0.0010
            % 0.0009
            % 0.0009
            % 0.0009
            % 0.0009
            % 0.0009
            % 0.0009
            % 0.0008
            % 0.0008
            % 0.0008
            % 0.0008
            % 0.0008
            % 0.0008
            % 0.0008
            % 0.0008
            % 0.0007
            % 0.0007
            % 0.0007
            % 0.0007
            for k=1:100 % 62 iterations to reach stationary distribution
                [previous_values, ~] = maxk(p, 20); % store previous p-values
                p=c*W*p+(1-c)/n;
                [values, ~]=maxk(p, 20); % store new p-values
                common = intersect(previous_values, values); 
                if (length(common) == 20) % check if top 20 p-values of iteration t is equal to top 20 p-values of iteration t-1
                    %disp(previous_values);
                    %disp(values);
                    %disp(k);
                    break;
                end
            end
            [~,index]=maxk(p,20); % find the index of the top 20 authors
            authors = struct.Problem.authors; % the authors
            top_20_authors = authors(index);
            app.Top20ListBox.Items = top_20_authors;
        end

        % Button pushed function: FindSimilarButton
        function FindSimilarButtonPushed(app, ~)
            author_of_interest = app.ChooseAuthorEditField.Value; 
            struct = load("dblp.mat"); %must be on the same folder
            authors = struct.Problem.authors;
            if not(ismember(authors, author_of_interest)) % if author entered not in the list
                msgbox("Author not found!");
            else
                index_of_author = authors==author_of_interest;
                dg=digraph(struct.Problem.A);
                c=0.6;
                A=adjacency(dg);
                o=outdegree(dg);
                z=o==0;
                o(z)=1;
                A=A./o';
                n=numnodes(dg);
                I=eye(n);
                sr=I;
                %sims=sr(:,index_of_author);
                for k=1:100 % simrank does not converge over 100 iterations, nevertheless this is a tradeoff between speed and accuracy
                  %[previous_values,~]=maxk(sims,11);
                  sr=max(c*A'*sr*A,I);
                  %sims=sr(:,index_of_author);
                  %[values, ~]=maxk(sims, 11);
                  %common = intersect(previous_values, values);
                  disp(k); % algorithm takes a lot of time - indication of when it ends (ends when 100th iteration reached)
                  %if (length(common)==11)
                      %disp(previous_values);
                      %disp(values);
                      %disp(k);
                      %break;
                  %end
                end
                % Example SimRank for author 'Gerhard Weikum':
                % 1.0000 (SimRank of the author himself is removed from final result)
                % 0.0689
                % 0.0605
                % 0.0602
                % 0.0574
                % 0.0548
                % 0.0548
                % 0.0546
                % 0.0546
                % 0.0515
                % 0.0507
                sims=sr(:,index_of_author);
                % take the top 11 authors instead of 10
                [vals,index] = maxk(sims,11); % author of interest and most similar author have the same name
                disp(vals);
                top_10_similarites = authors(index);
                top_10_similarites(1) = []; % remove first record as this is the name of the author
                app.Top10ListBox.Items = top_10_similarites;
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

            % Create MostImportantAuthorsPanel
            app.MostImportantAuthorsPanel = uipanel(app.UIFigure);
            app.MostImportantAuthorsPanel.Title = 'Most Important Authors';
            app.MostImportantAuthorsPanel.FontName = 'Bell MT';
            app.MostImportantAuthorsPanel.FontWeight = 'bold';
            app.MostImportantAuthorsPanel.FontSize = 18;
            app.MostImportantAuthorsPanel.Position = [33 268 576 192];

            % Create Top20ListBoxLabel
            app.Top20ListBoxLabel = uilabel(app.MostImportantAuthorsPanel);
            app.Top20ListBoxLabel.HorizontalAlignment = 'right';
            app.Top20ListBoxLabel.FontName = 'Arial';
            app.Top20ListBoxLabel.Position = [32 132 41 22];
            app.Top20ListBoxLabel.Text = 'Top 20';

            % Create Top20ListBox
            app.Top20ListBox = uilistbox(app.MostImportantAuthorsPanel);
            app.Top20ListBox.Items = {''};
            app.Top20ListBox.FontName = 'Arial';
            app.Top20ListBox.Position = [79 29 213 125];
            app.Top20ListBox.Value = '';

            % Create ListAuthorsButton
            app.ListAuthorsButton = uibutton(app.MostImportantAuthorsPanel, 'push');
            app.ListAuthorsButton.ButtonPushedFcn = createCallbackFcn(app, @ListAuthorsButtonPushed, true);
            app.ListAuthorsButton.VerticalAlignment = 'top';
            app.ListAuthorsButton.FontName = 'Segoe UI Emoji';
            app.ListAuthorsButton.FontSize = 14;
            app.ListAuthorsButton.Position = [306 126 100 26];
            app.ListAuthorsButton.Text = 'List Authors';

            % Create SimilarcoauthorsPanel
            app.SimilarcoauthorsPanel = uipanel(app.UIFigure);
            app.SimilarcoauthorsPanel.Title = 'Similar co-authors';
            app.SimilarcoauthorsPanel.FontName = 'Bell MT';
            app.SimilarcoauthorsPanel.FontWeight = 'bold';
            app.SimilarcoauthorsPanel.FontSize = 18;
            app.SimilarcoauthorsPanel.Position = [33 24 576 221];

            % Create Top10ListBoxLabel
            app.Top10ListBoxLabel = uilabel(app.SimilarcoauthorsPanel);
            app.Top10ListBoxLabel.HorizontalAlignment = 'right';
            app.Top10ListBoxLabel.FontName = 'Arial';
            app.Top10ListBoxLabel.Position = [314 156 41 22];
            app.Top10ListBoxLabel.Text = 'Top 10';

            % Create Top10ListBox
            app.Top10ListBox = uilistbox(app.SimilarcoauthorsPanel);
            app.Top10ListBox.Items = {};
            app.Top10ListBox.FontName = 'Arial';
            app.Top10ListBox.Position = [362 13 198 165];
            app.Top10ListBox.Value = {};

            % Create ChooseAuthorEditFieldLabel
            app.ChooseAuthorEditFieldLabel = uilabel(app.SimilarcoauthorsPanel);
            app.ChooseAuthorEditFieldLabel.HorizontalAlignment = 'right';
            app.ChooseAuthorEditFieldLabel.FontSize = 14;
            app.ChooseAuthorEditFieldLabel.Position = [22 156 98 22];
            app.ChooseAuthorEditFieldLabel.Text = 'Choose Author';

            % Create ChooseAuthorEditField
            app.ChooseAuthorEditField = uieditfield(app.SimilarcoauthorsPanel, 'text');
            app.ChooseAuthorEditField.FontSize = 14;
            app.ChooseAuthorEditField.Position = [128 156 179 22];

            % Create FindSimilarButton
            app.FindSimilarButton = uibutton(app.SimilarcoauthorsPanel, 'push');
            app.FindSimilarButton.ButtonPushedFcn = createCallbackFcn(app, @FindSimilarButtonPushed, true);
            app.FindSimilarButton.FontName = 'Segoe UI Emoji';
            app.FindSimilarButton.FontSize = 14;
            app.FindSimilarButton.Position = [192 122 100 26];
            app.FindSimilarButton.Text = 'Find Similar';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = E3

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

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