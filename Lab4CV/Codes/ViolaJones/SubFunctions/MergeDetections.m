function MergedObjects = MergeDetections(Objects, overlapThresh)
% MergeDetections Merge overlapping detections into single boxes
%  Objects: N x 4  [x y w h]
%  overlapThresh: minimum IoU to consider two detections the same face

if nargin < 2 || isempty(overlapThresh)
    overlapThresh = 0.3;
end
if isempty(Objects)
    MergedObjects = [];
    return;
end

N = size(Objects,1);
assigned = false(N,1);
MergedObjects = [];

for i = 1:N
    if assigned(i), continue; end
    % Grow cluster of overlapping boxes (transitive closure)
    cluster = i;
    k = 1;
    while k <= numel(cluster)
        idx = cluster(k);
        for j = 1:N
            if ~assigned(j) && j ~= idx && ~ismember(j, cluster)
                if bbox_iou(Objects(idx,:), Objects(j,:)) > overlapThresh
                    cluster(end+1) = j; %#ok<AGROW>
                end
            end
        end
        k = k + 1;
    end
    assigned(cluster) = true;
    MergedObjects(end+1, :) = mean(Objects(cluster, :), 1); %#ok<AGROW>
end

% Round to integer pixel coordinates
MergedObjects = round(MergedObjects);
end

function o = bbox_iou(a,b)
% a and b are [x y w h]
ax = a(1); ay = a(2); aw = a(3); ah = a(4);
bx = b(1); by = b(2); bw = b(3); bh = b(4);

ix1 = max(ax, bx);
iy1 = max(ay, by);
ix2 = min(ax+aw, bx+bw);
iy2 = min(ay+ah, by+bh);
iw = ix2 - ix1;
ih = iy2 - iy1;
if iw <= 0 || ih <= 0
    o = 0;
    return;
end
inter = iw * ih;
areaA = aw * ah;
areaB = bw * bh;
o = inter / (areaA + areaB - inter);
end
