% Dark-field particle simulation: ideal image with CSV
clear; clc;

% parameters
N = 20;       % number of particles
dMin = 20;       % um
dMax = 100;      % um
roi = 8000;     % ROI side length [um]
nPx = 2048;     % pixels across ROI - assumesmROI fills the 2048-px sensor

% derived/generated particle parameters
um_px = roi/nPx;                       % 3.91 um/px
d_um  = dMin + (dMax-dMin)*rand(N,1);   % diameters [um]
d_px  = d_um/um_px;                     % diameters [px]
r_px  = d_px/2;
cx_px = r_px + (nPx-2*r_px).*rand(N,1);   % centers [px], image coords (x right, y down)
cy_px = r_px + (nPx-2*r_px).*rand(N,1);

% render (white dots on black background)
[X,Y] = meshgrid(1:nPx);
img = zeros(nPx);
for k = 1:N
    img = max(img, min(max(r_px(k) - hypot(X-cx_px(k), Y-cy_px(k)) + 0.5, 0), 1));
end
imwrite(uint8(255*img), 'particles.png'); % writes clean png for input into processing algorithm

% generates CSV of particle size/location for comparison
% um measured from the ROI top-left corner, same axes as the image
x_um = (cx_px-0.5)*um_px;
y_um = (cy_px-0.5)*um_px;
T = table((1:N)', x_um, y_um, d_um, cx_px, cy_px, d_px, ...
    'VariableNames', {'id','x_um','y_um','diam_um','x_px','y_px','diam_px'});
writetable(T, 'particles.csv');

% generates local display of image with axes matching CSV
% labels each 
imshow(img);
axis on;
title('simulated darkfield image (binary)')
