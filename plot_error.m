function axhdl = plot_error(type,D,err,xtick,col,errcol,xlab,ind,slab)
%
% USAGE plot_error(type,D,err,xtick,col,errcol,xlab,ind,slab)
%
% ARGS
% type    plot type: 'bar','dot','dotline'
% D       data matrix (variable in columns!) OR vector of means
% err     error specification: 'none','sd','sem','ci' OR
%         vector of errors
% xtick	  vector xtick positions [dim: 1 x size(D,2)]
% col     cell array of color definitions, e.g., {'r'}, OR {[0.5 0.5 0.5]} [dim: 1 x size(D,2)]
% errcol  string of color of error bars, 's'ame or blac'k' (default = red,
%         if empty), OR vector of RGB values, e.g., [0.3 0.3 0.3]
% xlab    cell array of xticklabels [dim: 1 x size(D,2)]
% ind     flag for overlaying individual data (default = 0)
% slab    flag for including subject number in the individual overlay
%__________________________________________________________________________
% (c) by Jan Gläscher (glaescher@gmail.com) last updated 04/24/2013

if nargin < 9
  slab = 0;
end
if nargin < 8
  ind = 0;
end
if nargin < 7
  xlab = [];
end
if nargin < 6
  errcol = 'r';
end
if nargin < 5
  col = {[0.9 0.9 0.9]}; % light gray
end
if nargin < 4
  xtick = [];
end
if nargin < 3
  err = 'sem';
end
if nargin < 2
  error('Not enough input arguments')
end;

% some default definitions
dlw = 2; % line width for data (type: 'dotline')
ewl = 2; % line width for error bars
dms = 10; % marker size for data (type: 'dot','dotline')
ims = 8; % marker size for individual overlayed data

sz = size(D);

if all(sz~=1) % it's a data matrix
  M = nanmean(D);
else
  M = D(:)'; % make a row vector
end

% what kind of error spec do we have?
if all(sz~=1) % data is a matrix
  if isnumeric(err)
    disp('Select error spec from: ''none'',''sem'',''sd'',''ci''. Bailing out.')
    return;
  else
    switch err
      case 'none'
        S = zeros(1,size(D,2));
      case 'sd'
        S = nanstd(D);
      case 'sem'
        S = nansem(D);
      case 'ci'
        S = nansem(D) * 1.6449; % spm_invNcdf(0.95)
      otherwise
        disp('Unknown error spec. Bailing out.')
        return;
    end
  end
else
  if ischar(err)
    disp('Please specify a vector of errors. Bailing out.')
    return;
  elseif length(err) ~= length(M)
    disp('Error vector must be same size das data vector.  Bailing out.')
  elseif isempty(err)
    err = zeros(size(M));
  else
    S = err(:)'; % make row vector
  end
end

% Do we have xticks yet?
if isempty(xtick)
  xtick = 1:size(M,2);
end

% Do we have colors?
if length(col) == 1
  col = repmat(col,size(M,2));
elseif length(col) ~= length(M)
  disp('Mismatch between data and color specs. Baililng out.')
  return;
end

% Individual data only for data matrix
if ind && any(sz==1)
  disp('Overlay of individual data only for data matrix. Bailing out.');
  return;
end

if ~isempty(xlab) && length(xlab) ~= length(1:size(D,2))
  disp('Mismatch between data and xticklabels. Bailing out.');
  return;
end

hold on;

switch type
  case 'bar'
    for f = 1:length(M)
      h = bar(xtick(f),M(f));
      set(h,'FaceColor',col{f})
      l = line([xtick(f) xtick(f)],[S(f) 0-S(f)]+M(f));
      if strcmp(errcol,'s')
        set(l,'LineWidth',ewl,'Color',col{f});
      elseif strcmp(errcol,'k')
        set(l,'LineWidth',ewl,'Color','k');
      else
        set(l,'LineWidth',ewl,'Color',errcol);
      end
    end
  case {'dot','dotline'}
    for f = 1:length(M)
      l = line([xtick(f) xtick(f)],[S(f) 0-S(f)]+M(f));
      if strcmp(errcol,'s')
        set(l,'LineWidth',ewl,'Color',col{f});
      elseif strcmp(errcol,'k')
        set(l,'LineWidth',ewl,'Color','k');
      else
        set(l,'LineWidth',ewl,'Color',errcol);
      end
      if strcmp(type,'dot')
        h = plot(xtick(f),M(f));
        set(h,'LineStyle','none','Marker','.',...
          'Markersize',dms,'Color',col{f});
      elseif strcmp(type,'dotline')
        if all(diff(xtick) >= 1)
          h = plot(xtick(f),M(f));
          set(h,'LineStyle','none','LineWidth',dlw,'Marker','.',...
            'Markersize',dms+5,'Color',col{f});
        else
          i = find(diff(xtick)<0);
          while ~isempty(i)
            h = plot(xtick(1:i),M(1:i));
            set(h,'LineStyle','-','LineWidth',dlw,'Marker','.',...
              'Markersize',dms+5,'Color',col{1});
            xtick(1:i) = []; M(1:i) = []; col(1:i) = [];i(1) = [];
          end
          h = plot(xtick(f),M(f));
          set(h,'LineStyle','-','LineWidth',dlw,'Marker','.',...
            'Markersize',dms+5,'Color',col{1});
        end
      end
    end
    if strcmp(type,'dotline') && all(diff(xtick) > 0)
      h = plot(xtick,M);
      set(h,'LineStyle','-','LineWidth',dlw,'Marker','none','Color',col{f});
    end
end

if ind
  for f = 1:size(D,2)
    for s = 1:size(D,1)
      if slab
        if mod(s,2) % uneven + left
          plot(xtick(f)-0.07,D(s,f),'Marker','.',...
            'Color','k','Markersize',ims);
          text(xtick(f)-0.10,D(s,f),num2str(s),...
            'FontSize',8,'HorizontalAlignment','r');
        else
          plot(xtick(f)+0.07,D(s,f),'Marker','.',...
            'Color','k','Markersize',ims);
          text(xtick(f)+0.10,D(s,f),num2str(s),...
            'FontSize',8,'HorizontalAlignment','l');
        end
      else
        plot(xtick(f)+0.07,D(s,f),'Marker','.',...
          'Color','k','Markersize',ims);
      end
    end
  end
end

set(gca,'xlim',[min(xtick)-1 max(xtick)+1],'xtick',xtick);
if ~isempty(xlab)
  set(gca,'xticklabel',xlab)
end

%hold off
axhdl = gca;
return;
