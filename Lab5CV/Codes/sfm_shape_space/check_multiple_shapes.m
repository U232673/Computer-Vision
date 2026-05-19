%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%              LABORATORY #5 
%%%              COMPUTER VISION 2025-2026
%%%              NON-RIGID STRUCTURE FROM MOTION - OPTIMIZATION 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [val,our3D,gt3D] = check_multiple_shapes(recovered,gt,rot,rot_gt,procrust_all)
% Input:
%
% recovered: 3D sequence to be evaluated, points are stacked in columns, each triplet of row
% containing X,Y,Z coordinates
% gt: Reference 3D sequence
% rot: Camera matrices for the recovered sequence, if omitted identity is used.
% rot_gt: Reference camera matrices, if omitted identity is used.
% procrust_all: Flag to use or not procrust analysis to align each frame 0 - no, 1- yes, default: yes
%
% Output:
% 
% val: Vector of the normalised 3D errors for all frames, use mean(val)*100 to have a mean percentage
% our3D: Sequence with estimated rotation and scaling applied
% gt3D: Same as input gt, but mean-centered

if ~exist('rot','var')
    rot = repmat(eye(2,3),size(gt,1)/3,1);
end
if ~exist('rot_gt','var')
    rot_gt = repmat(eye(3),size(gt,1)/3,1);
end
if ~exist('procrust_all','var')
    procrust_all=1;
end

[nF,numPoints] = size(recovered);
numFrames=nF/3;
recovered=recovered - repmat(mean(recovered,2),1,numPoints);
gt=gt - repmat(mean(gt,2),1,numPoints);

if nF ~= size(gt,1)
    error('check_shapes: wrong number of frames');
end
[Q1,scale1] = align_shapes(recovered(1:3,:),gt(1:3,:));

if procrust_all==0
  for n=1:numFrames
    recovered(3*n-2:3*n,:)=Q1*recovered(3*n-2:3*n,:);
  end
end
our3D=[];
val=zeros(1,numFrames);
numflips=0;
for n=1:numFrames
  [Q,scale] = align_shapes(recovered(3*n-2:3*n,:),gt(3*n-2:3*n,:));
  a=recovered(3*n-2:3*n,:)/scale;
  if procrust_all==1
      a=procrust(gt(3*n-2:3*n,:)',a')';
      aflip=[a(1:2,:) ; -a(3,:)];
  else
      r3=[rot(2*n-1:2*n,:); cross(rot(2*n-1,:),rot(2*n,:))];
      a=r3*a;
      aflip=[a(1:2,:) ; -a(3,:)];
      aflip=rot_gt(3*n-2:3*n,:)'*aflip;
      gt(3*n-2:3*n,:) = rot_gt(3*n-2:3*n,:)*gt(3*n-2:3*n,:);
  end
  val(n)=norm(a - gt(3*n-2:3*n,:),'fro')/norm(gt(3*n-2:3*n,:),'fro');
  valflip=norm(aflip - gt(3*n-2:3*n,:),'fro')/norm(gt(3*n-2:3*n,:),'fro');
  if valflip<val(n) 
      val(n)=valflip; 
      a=aflip;
      numflips=numflips+1;
  end
  our3D=[our3D; a];
  % val is the norm between the two shapes after scale and rot.
end
gt3D=gt;
    
