function [frames, descrs, im] = getSIFTFeatures(im, varargin)

opts.method = 'dog' ;
opts.affineAdaptation = true ;
opts.orientation = true ;
opts.peakThreshold = 0.04; 
opts.maxHeight = +inf ;
opts = vl_argparse(opts, varargin) ;

if size(im,3) > 1, im = rgb2gray(im) ; end
im = im2single(im) ;

if size(im,1) > opts.maxHeight
  im = imresize(im, [opts.maxHeight, NaN]) ;
end

[frames, descrs] = vl_covdet(im, 'EstimateAffineShape', opts.affineAdaptation, 'EstimateOrientation', opts.orientation, 'DoubleImage', false, 'Method', opts.method, 'PeakThreshold', opts.peakThreshold, 'Verbose') ;
frames = single(frames) ;