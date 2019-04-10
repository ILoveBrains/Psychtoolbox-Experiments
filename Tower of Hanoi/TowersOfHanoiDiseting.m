classdef TowersOfHanoiDiseting < handle
%--------------------------------------------------------------------------
% Syntax:       TowersOfHanoi;
%               TowersOfHanoi(n);
%               
% Input:        n is the desired number of blocks. The default is
%               TowersOfHanoi.defaultNBlocks
%               
% Active Keys:  {1,2,3} number keys are used to move blocks between the
%               corresponding 3 pegs
%               
% Description:  The objective of Towers of Hanoi is to move all n blocks
%               from the far left peg to the far right peg. The only
%               restricitons are that you may only move the top block on a
%               peg, and you may not place a larger block on top of a
%               smaller block. To move the top block on a peg to a
%               different peg, use the 1-3 number keys to select the target
%               and destination pegs. If you want to change the number of
%               blocks in the game, you can use the NUMBER OF BLOCKS
%               pull-down menu. To restart the game, you can push the RESET
%               button. Alternatively, the RANDOM RESET button will
%               randomly generate an initial setup with the specified
%               number of blocks. If you're still stuck, you can use the
%               SOLUTION SPEED slider and the SOLVE button to ask the
%               computer to solve the puzzle. While the computer is
%               solving, you may stop it at any time by pushing the STOP
%               button. Then you can continue the solution yourself. To
%               change the curent color scheme, use the COLOR SCHEME
%               pull-down menu. Finally, to quit the game, push the EXIT
%               button.
%               
% Author:       Brian Moore
%               brimoor@umich.edu
%               
% Date:         March 2, 2014
%--------------------------------------------------------------------------
    
    %
    % Private constants
    %
    properties (GetAccess = private, Constant = true)
        % Constants
        defaultNBlocks = 5;         % Default number of blocks
        minNBlocks = 2;             % Minimum number of blocks (>= 2)
        maxNBlocks = 15;            % Maximum number of blocks
        kB = 0.25;                  % Curvature of blocks
        kP = 0.15;                  % Curvature of pegs
        colormaps = {@hsv;          % Supported colormaps
                     @jet;
                     @prism;
                     @hot;
                     @cool;
                     @spring;
                     @summer;
                     @autumn;
                     @winter;
                     @bone;
                     @copper;
                     @gray;
                     @pink;
                     @white;
                     @flag;
                     @lines};
    end
    
    %
    % Private properties
    %
    properties (Access = private)
        % Program properties
        solving = false;            % Solving flag
        randomBoard = false;        % Random board flag
        n;                          % Number of pegs
        state;                      % State container
        handles;                    % Block handles
        minWidth;                   % Min block width
        maxWidth;                   % Max block width
        widths;                     % Block widths
        height;                     % Block heights
        pegs;                       % Peg positions
        pegWidth;                   % Peg width
        pegDot;                     % Peg dot location
        pegDotD;                    % Peg dot diameter
        to;                         % To peg
        from;                       % From peg
        numListStr;                 % Block counts list
        colors;                     % Color scheme
        
        % GUI handles
        fig;                        % Figure handle
        ax;                         % Axis handle
        speedSlider;                % Speed slider handle
%        solveButton;                % Solve button handle
        numList;                    % Block count list handle
        colorList;                  % Color list handle
    end
    
    %
    % Public methods
    %
    methods (Access = public)
        %
        % Constructor
        %
        function this = TowersOfHanoi(n)
            % Check if size was specified
            if (nargin == 1)
                % User-specified number of blocks
                this.n = min(max(n,TowersOfHanoi.minNBlocks), ...
                             TowersOfHanoi.maxNBlocks);
            else
                % Default number of blocks
                this.n = TowersOfHanoi.defaultNBlocks;
            end
            
            % Default color scheme
            this.colors = TowersOfHanoi.colormaps{1}(this.n);
            
            % Generate block number list string
            this.numListStr = '';
            for i = TowersOfHanoi.minNBlocks:TowersOfHanoi.maxNBlocks
                this.numListStr = strcat(this.numListStr,num2str(i),'|');
            end
            this.numListStr = strcat(this.numListStr,'64 (Just Kidding!)');
            
            % Create GUI
            this.CreateGUI();
            
            % Initialize board
            this.InitializeBoard();
        end
        
        %
        % Override display function
        %
        function display(this) %#ok
            % Empty
        end
    end
    
    %
    % Private methods
    %
    methods (Access = private)
        %
        % Handle key press
        %
        function HandleKeyPress(this)
            % Check if the puzzle is currently being solved
            if (this.solving == false)
                % Process key press
                key = get(this.fig,'CurrentCharacter') - 48;
                if (any(key > 0) && any(key < 4))
                    % Valid key press
                    if isempty(this.from)
                        % Save "from key"
                        this.from = key;
                        
                        % Put dot above active peg
                        pos = [this.pegs(this.from) - this.pegDotD / 2, ...
                               1,this.pegDotD,this.pegDotD];
                        this.pegDot = rectangle('Position',pos, ...
                                                'Curvature',[1 1], ...
                                                'FaceColor','k');
                    elseif isempty(this.to)
                        % Save "to key"
                        this.to = key;
                        
                        % Remove dot
                        delete(this.pegDot);
                    end
                end
                
                % Check if we have a move to perform
                if (~isempty(this.from) && ~isempty(this.to))
                    % Perform move
                    this.MovePiece(this.from,this.to);
                    this.to = [];
                    this.from = [];
                    
                    % Check for solution
                    this.CheckForSolution();
                end                
            end
        end
        
        %
        % Move piece
        %
        function MovePiece(this,fromP,toP)
            % Get original rung
            fromR = find(~isnan(this.state(:,fromP)),1,'first');
            
            % Get target rung
            toR = find(isnan(this.state(:,toP)),1,'last');
            
            % Get block number
            num = this.state(fromR,fromP);
            
            % Perform the move (if valid)
            if ~(num >= this.state(min(this.n,toR + 1),toP))
                % Move block
                pos = [(this.pegs(toP) - this.widths(num) / 2), ...
                       ((this.n - toR) * this.height), ...
                       this.widths(num), ...
                       this.height];
                this.state(toR,toP) = num;
                this.handles{toR,toP} = this.handles{fromR,fromP};
                set(this.handles{toR,toP},'Position',pos);
                
                % Remove block from original location
                this.state(fromR,fromP) = nan;
                this.handles{fromR,fromP} = nan;
                
                % Flush graphics
                drawnow;
            end
        end
        
        %
        % Solve the puzzle
        %
        function SolvePuzzle(this)
            try
                % Check if the puzzle is already being solved
                if (this.solving == false)
                    % Set solve button
                    set(this.solveButton,'String','Stop');
                    set(this.solveButton,'BackgroundColor','r');
                    this.solving = true;
                    
                    % Begin solving the puzzle
                    this.ArbitrarySolver(this.n,3);
                    
                    % Check if puzzle is now solved
                    this.CheckForSolution();
                end
                
                % Reset solve button
                set(this.solveButton,'String','Solve');
                set(this.solveButton,'BackgroundColor',0.9294 * [1 1 1]);        
                this.solving = false;
            catch %#ok
                % GUI was probably closed during automated solving
            end
        end
        
        %
        % Solve the puzzle from an arbitrary position
        %
        function ArbitrarySolver(this,NBlocks,toP)
            % Check if the puzzle is already being solved
            if (this.solving == true)
                % Find largest discrepancy
                N = NBlocks;
                while (sum(N == this.state(:,toP)) == 1)
                    N = N - 1;
                end
                
                % Find where the guilty party resides
                fromP = ceil(find(this.state == N) / this.n);
                topFromP = find(~isnan(this.state(:,fromP)),1,'first');
                
                % See if we can fix largest discrepancy in one move
                if ((this.state(topFromP,fromP) ~= N) || ...
                    (sum(this.state(:,toP) < N) ~= 0))
                    % We can't, so align smaller blocks on auxillary peg
                    this.ArbitrarySolver(N - 1,6 - fromP - toP);
                end
                
                % Check if the puzzle is still being solved
                if (this.solving == true)
                    % Now we can make the move!
                    this.MovePiece(fromP,toP);
                    
                    % Wait a little bit
                    this.Pause();
                    
                    % Use ideal solver to complete the puzzle
                    this.IdealSolver(6 - fromP - toP,toP,N - 1);
                end
            end
        end
        
        %
        % Solve the puzzle from an ideal position
        %
        function IdealSolver(this,fromP,toP,NBlocks)
            % Check if the puzzle is already being solved
            if (this.solving == true)
                % Check if there is work to do
                if (NBlocks <= 0)
                    return;
                else
                    % Recursively call IdealSolver()
                    this.IdealSolver(fromP,6 - toP - fromP,NBlocks - 1);
                    
                    % Check if the puzzle is still being solved
                    if (this.solving == true)
                        % Perform the move
                        this.MovePiece(fromP,toP);
                        
                        % Wait a little bit
                        this.Pause();
                        
                        % Recursively call IdealSolver()
                        this.IdealSolver(6 - toP - fromP,toP,NBlocks - 1);
                    end                    
                end
            end
        end
        
        %
        % Pause game
        %
        function Pause(this)
            % Get pause time from slider
            time = (100 - get(this.speedSlider,'Value')) / 200;
            
            % Pause for desired time
            if (time > 0)
                pause(time);
            end
        end
        
        %
        % Check for solution
        %
        function CheckForSolution(this)
            % Check for puzzle solution
            solved = sum(this.state(:,3)) == (this.n * (this.n + 1) / 2);
            
            % Handle game state
            if (solved == true)
                % Puzzle has been solved
                s = 'Congratulations! You solved the puzzle. Play again?';
                select = questdlg(s,'Towers of Hanoi','Yes','No','Yes');
                
                % Process based on user selection
                switch select, 
                  case 'Yes'
                     % Reset the board
                     this.ResetBoard();
                  case 'No'
                     % Exit the game
                     this.ExitGame();
                end
            end
        end
        
        %
        % Reset board
        %
        function ResetBoard(this)
            % Get number of blocks
            this.GetNBlocks();
            
            % Deterministic board setup
            this.randomBoard = false;
            
            % Clean up the board
            this.CleanUpBoard();
            
            % Initialize the board
            this.InitializeBoard();
        end
        
        %
        % Random board reset
        %
        function RandomBoardReset(this)
            % Get number of blocks
            this.GetNBlocks();
            
            % Random board setup
            this.randomBoard = true;
            
            % Clean up the board
            this.CleanUpBoard();
            
            % Initialize the board
            this.InitializeBoard();
        end
        
        %
        % Get number of blocks from GUI
        %
        function GetNBlocks(this)
            % Get number of blocks
            num = get(this.numList,'Value') + this.minNBlocks - 1;
            
            % Handle "just kidding option"
            this.n = min(num,this.maxNBlocks);
            set(this.numList,'Value',this.n + 1 - this.minNBlocks);
        end
        
        %
        % Exit game
        %
        function ExitGame(this)
            % Set solving status to false for graceful(?) exit
            this.solving = false;
            
            % Delete the GUI
            close(this.fig);
        end
        
        %
        % Clean up board
        %
        function CleanUpBoard(this)
            % Clear axis
            cla(this.ax);
            
            % Clear peg clicks
            this.to = [];
            this.from = [];
            
            % Delete peg dot handle
            if ishandle(this.pegDot)
                delete(this.pegDot);
            end
        end
        
        %
        % Update color scheme
        %
        function UpdateColorScheme(this)
            % Get new color scheme
            listNum = get(this.colorList,'Value');
            if (listNum == (length(this.colormaps) + 1))
                this.colors = rand(this.n,3);
            else
                fnHandle = this.colormaps{listNum};
                this.colors = fnHandle(this.n);
                this.colors = this.colors(end:-1:1,:);
            end
            
            % Update block colors
            for j = 1:3
                for i = 1:this.n
                    if ~isnan(this.state(i,j))
                        set(this.handles{i,j}, ...
                               'FaceColor',this.colors(this.state(i,j),:));
                    end
                end
            end
        end
        
        %
        % Initialize the board
        %
        function InitializeBoard(this)
            % Update block dimensions
            this.widths = linspace(this.minWidth,this.maxWidth,this.n)';
            this.height = 1 / (this.n + 1);
            
            % Initialize game state storage
            this.handles = cell(this.n,3);
            this.state = nan(this.n,3);
            
            % See if we are randomly generating a board
            if (this.randomBoard == true)
                % Random setup
                inds = randi(3,this.n,1);
                if (sum(inds) == (3 * this.n))
                    inds(1) = inds(1) - 1;
                end
                for N = this.n:-1:1
                    bool = isnan(this.state(:,inds(N)));
                    this.state(find(bool,1,'last'),inds(N)) = N;
                end
            else
                % Standard setup
                this.state(:,1) = (1:this.n)';
            end
            
            % Create pegs
            for i = 1:3
                pos = [(this.pegs(i) - this.pegWidth / 2),0, ...
                       this.pegWidth,0.97];
                rectangle('Position',pos, ...
                          'Curvature',[this.kP this.kP], ...
                          'FaceColor',[0.5 0.5 0.5]);
            end
            
            % Create blocks
            for j = 1:3
                for i = 1:this.n
                    if ~isnan(this.state(i,j))
                        num = this.state(i,j);
                        pos = [(this.pegs(j) - this.widths(num) / 2), ...
                               ((this.n - i) * this.height), ...
                               this.widths(num), ...
                               this.height];
                        this.handles{i,j} = rectangle('Position',pos, ...
                                            'Curvature',[this.kB this.kB]);
                    end
                end
            end
            
            % Set initial color scheme
            this.UpdateColorScheme();
            
            % Initialize solving state
            set(this.solveButton,'String','Solve');
            set(this.solveButton,'BackgroundColor',0.9294 * [1 1 1]);
            this.solving = false;
        end
        
        %
        % Create the GUI
        %
        function CreateGUI(this)
            % Initialize GUI object dimensions
            axPos = [0.05 0.25 0.9 0.6];
            aspectratio = axPos(3) / axPos(4);
            this.maxWidth = aspectratio * (9 / 30);
            this.minWidth = this.maxWidth / 2;
            this.pegWidth = this.minWidth / 3;
            this.pegs = aspectratio * [1/6 3/6 5/6];
            this.pegDotD = this.pegWidth / 1.5;
            
            % Generate color test string
            colorstr = '';
            for i = 1:length(this.colormaps)
                str = func2str(this.colormaps{i});
                if strcmpi(str,'HSV')
                    % HSV in All-CAPS
                    str = 'HSV';
                else
                    % Capitalize first letter of everything else
                    str = strcat(upper(str(1)),str(2:end));
                end
                colorstr = strcat(colorstr,str,'|');
            end
            colorstr = strcat(colorstr,'Random'); % Add random color option
            
            % Create figure            
            this.fig = figure;
            set(this.fig,'WindowKeyPressFcn',@(s,e)HandleKeyPress(this));
            set(this.fig,'MenuBar','None');
            set(this.fig,'NumberTitle','off');
            set(this.fig,'Interruptible','on');
            pan(this.fig,'off');
            
            % Setup axis
            this.ax = gca;
            set(this.ax,'Position',axPos);            
            axis(this.ax,'equal');
            axis([0 aspectratio 0 (1 + this.pegDotD)]);
            title(this.ax,'Towers  of  Hanoi', ...
                          'FontUnits','normalized', ...
                          'FontSize',0.15, ...
                          'FontName','Lucida Handwriting');
            axis(this.ax,'off');
            
            % Add GUI buttons
            uicontrol(this.fig,'Style','text', ...
                               'FontUnits','normalized', ...
                               'BackgroundColor',[0.8,0.8,0.8], ...
                               'String','Solution Speed', ...
                               'Units','normalized', ...
                               'Position',[0.04 0.11 0.2 0.05]);
            uicontrol(this.fig,'Style','text', ...
                               'FontUnits','normalized', ...
                               'BackgroundColor',[0.8,0.8,0.8], ...
                               'String','Slow', ...
                               'Units','normalized', ...
                               'Position',[0.02 0.02 0.08 0.05]);
            uicontrol(this.fig,'Style','text', ...
                               'FontUnits','normalized', ...
                               'BackgroundColor',[0.8,0.8,0.8], ...
                               'String','Fast', ...
                               'Units','normalized', ...
                               'Position',[0.18 0.02 0.08 0.05]);                        
            this.speedSlider = uicontrol(this.fig,'Style','slider', ...
                               'Min',1, ...
                               'Max',100, ...
                               'Value',50, ...
                               'Units','normalized', ...
                               'Position',[0.04 0.065 0.2 0.05]);
            this.solveButton = uicontrol(this.fig,'Style','pushbutton', ...
                               'FontUnits','normalized', ...
                               'String','Solve', ...
                               'Callback',@(s,e)SolvePuzzle(this), ...
                               'Units','normalized', ...
                               'Position',[0.28 0.03 0.2 0.05]);
            uicontrol(this.fig,'Style','text', ...
                               'FontUnits','normalized', ...
                               'BackgroundColor',[0.8,0.8,0.8], ...
                               'String','Number of Blocks', ...
                               'Units','normalized', ...
                               'Position',[0.52 0.15 0.2 0.05]);
            this.numList = uicontrol(this.fig,'Style','popup', ...
                               'FontUnits','normalized', ...
                               'Callback',@(s,e)ResetBoard(this), ...
                               'String',this.numListStr, ...
                               'Units','normalized', ...
                               'Position',[0.52 0.1 0.2 0.05]);
            uicontrol(this.fig,'Style','pushbutton', ...
                               'FontUnits','normalized', ...
                               'String','Reset', ...
                               'Callback',@(s,e)ResetBoard(this), ...
                               'Units','normalized', ...
                               'Position',[0.76 0.03 0.2 0.05]);
            uicontrol(this.fig, ...
                               'Style','pushbutton', ...
                               'FontUnits','normalized', ...
                               'String','Random Reset', ...
                               'Callback',@(s,e)RandomBoardReset(this), ...
                               'Units','normalized', ...
                               'Position',[0.76 0.1 0.2 0.05]);
            uicontrol(this.fig,'Style','pushbutton', ...
                               'FontUnits','normalized', ...
                               'String','Exit', ...
                               'Callback',@(s,e)ExitGame(this), ...
                               'Units','normalized', ...
                               'Position',[0.52 0.03 0.2 0.05]);
            this.colorList = uicontrol(this.fig,'Style','popup', ...
                               'FontUnits','normalized', ...
                               'Callback',@(s,e)UpdateColorScheme(this),...
                               'String',colorstr, ...
                               'Units','normalized', ...
                               'Position',[0.28 0.1 0.2 0.05]);
            uicontrol(this.fig,'Style','text', ...
                               'FontUnits','normalized', ...
                               'BackgroundColor',[0.8,0.8,0.8], ...
                               'String','Color Scheme', ...
                               'Units','normalized', ...
                               'Position',[0.28 0.15 0.2 0.05]);
            
            % Set initial number of pegs
            val = this.n - this.minNBlocks + 1;
            set(this.numList,'Value',val);
            
            % Set inital color scheme
            set(this.colorList,'Value',1);
        end
    end
end
