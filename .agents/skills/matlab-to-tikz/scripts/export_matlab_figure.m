function manifestPath = export_matlab_figure(inputFigure, outputDirectory)
%EXPORT_MATLAB_FIGURE Export common MATLAB graphics data for PGFPlots.

arguments
    inputFigure (1, 1) string
    outputDirectory (1, 1) string
end
if ~isfile(inputFigure), error('matlab-to-tikz:MissingInput', 'Input figure does not exist: %s', inputFigure); end
if ~isfolder(outputDirectory), mkdir(outputDirectory); end
fig = openfig(inputFigure, 'invisible');
cleanupFigure = onCleanup(@() close(fig)); %#ok<NASGU>
axesObjects = flipud(findall(fig, 'Type', 'axes'));
if isempty(axesObjects), error('matlab-to-tikz:NoAxes', 'No Cartesian axes were found.'); end
axesRecords = repmat(struct('title', '', 'xlabel', '', 'ylabel', '', 'xscale', 'linear', 'yscale', 'linear', 'xlim', [], 'ylim', [], 'series', []), 0, 1);

for axisIndex = 1:numel(axesObjects)
    ax = axesObjects(axisIndex);
    children = flipud(ax.Children(:));
    seriesRecords = repmat(struct('type', '', 'name', '', 'dataFile', '', 'color', [], 'lineStyle', '-', 'marker', 'none'), 0, 1);
    for childIndex = 1:numel(children)
        child = children(childIndex);
        objectType = lower(string(child.Type));
        if ~ismember(objectType, ["line", "stair", "scatter", "bar", "errorbar"]), continue; end
        if ~isprop(child, 'XData') || ~isprop(child, 'YData'), continue; end
        x = double(child.XData(:)); y = double(child.YData(:));
        if numel(x) ~= numel(y), warning('Skipping object with mismatched XData and YData.'); continue; end
        data = table(x, y, 'VariableNames', {'x', 'y'});
        if objectType == "errorbar"
            data.yminus = getDelta(child, 'YNegativeDelta', numel(y));
            data.yplus = getDelta(child, 'YPositiveDelta', numel(y));
        end
        seriesIndex = numel(seriesRecords) + 1;
        dataName = sprintf('axis-%02d-series-%02d.csv', axisIndex, seriesIndex);
        writetable(data, fullfile(outputDirectory, dataName));
        record.type = char(objectType);
        record.name = getTextProperty(child, 'DisplayName');
        if isempty(record.name), record.name = sprintf('Series %d', seriesIndex); end
        record.dataFile = dataName; record.color = getColor(child);
        record.lineStyle = getTextProperty(child, 'LineStyle');
        if isempty(record.lineStyle), record.lineStyle = '-'; end
        record.marker = getTextProperty(child, 'Marker');
        if isempty(record.marker), record.marker = 'none'; end
        seriesRecords(end + 1, 1) = record; %#ok<AGROW>
    end
    axisRecord.title = normalizeText(ax.Title.String); axisRecord.xlabel = normalizeText(ax.XLabel.String); axisRecord.ylabel = normalizeText(ax.YLabel.String);
    axisRecord.xscale = char(string(ax.XScale)); axisRecord.yscale = char(string(ax.YScale)); axisRecord.xlim = double(ax.XLim); axisRecord.ylim = double(ax.YLim); axisRecord.series = seriesRecords;
    axesRecords(end + 1, 1) = axisRecord; %#ok<AGROW>
end

manifest.schemaVersion = 1; manifest.sourceFigure = char(inputFigure); manifest.matlabRelease = version('-release'); manifest.generatedAt = char(datetime('now', 'TimeZone', 'UTC', 'Format', 'yyyy-MM-dd''T''HH:mm:ssXXX')); manifest.axes = axesRecords;
manifestPath = fullfile(outputDirectory, 'manifest.json');
fileId = fopen(manifestPath, 'w', 'n', 'UTF-8');
if fileId < 0, error('matlab-to-tikz:ManifestWrite', 'Cannot write %s.', manifestPath); end
cleanupFile = onCleanup(@() fclose(fileId)); %#ok<NASGU>
fwrite(fileId, jsonencode(manifest, 'PrettyPrint', true), 'char');
fprintf('Exported %d axes to %s\n', numel(axesRecords), manifestPath);
end

function value = getDelta(object, propertyName, expectedLength)
if isprop(object, propertyName), value = double(object.(propertyName)(:)); else, value = zeros(expectedLength, 1); end
if isscalar(value), value = repmat(value, expectedLength, 1); end
if numel(value) ~= expectedLength, error('matlab-to-tikz:ErrorBarLength', '%s has an unexpected length.', propertyName); end
end

function value = getTextProperty(object, propertyName)
if isprop(object, propertyName), value = normalizeText(object.(propertyName)); else, value = ''; end
end

function value = getColor(object)
value = [];
if isprop(object, 'Color') && isnumeric(object.Color) && numel(object.Color) == 3, value = double(object.Color(:))';
elseif isprop(object, 'CData') && isnumeric(object.CData) && numel(object.CData) == 3, value = double(object.CData(:))'; end
end

function value = normalizeText(input)
if isempty(input), value = '';
elseif iscell(input), value = char(strjoin(string(input), ' '));
else, value = char(strjoin(string(input), ' ')); end
end
