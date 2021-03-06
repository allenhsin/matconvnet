function s = saveobj(obj, save_vars)
%SAVEOBJ  Save a DagNN to a vanilla MATLAB structure
%   S = OBJ.SAVEOBJ() saves the DagNN OBJ to a vanilla MATLAB
%   structure S. This is particularly convenient to preserve future
%   compatibility and to ship networks that are pure structures,
%   instead of embedding dependencies to code.
%
%   The object can be reconstructe by `obj = DagNN.loadobj(s)`.
%
%   As a side-effect the network is being reset (all variables are cleared)
%   and is transfered to CPU.
%
%   See Also: dagnn.DagNN.loadobj, dagnn.DagNN.reset

% Copyright (C) 2015-2016 Karel Lenc and Andrea Vedaldi.
% All rights reserved.
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).

if nargin < 2
    save_vars   =   0;
end

%device = obj.device ;
%obj.move('cpu') ;
s.device = obj.device;
if save_vars == 1
    s.vars = struct(...
        'name', {obj.vars.name}, ...
        'value', {obj.vars.value}, ...
        'precious', {obj.vars.precious}) ;
else
    s.vars = struct(...
        'name', {obj.vars.name}, ...
        'precious', {obj.vars.precious}) ;
end
s.params = struct(...
  'name', {obj.params.name}, ...
  'value', {obj.params.value}, ...
  'fi_value', {obj.params.fi_value}, ...
  'learningRate', {obj.params.learningRate}, ...
  'weightDecay', {obj.params.weightDecay}) ;
s.layers = struct(...
  'name', {obj.layers.name}, ...
  'type', {[]}, ...
  'inputs', {obj.layers.inputs}, ...
  'outputs', {obj.layers.outputs}, ...
  'params', {obj.layers.params}, ...
  'block', {[]}, ...
  'quantization', {obj.layers.quantization}) ;
s.meta = obj.meta ;

for l = 1:numel(obj.layers)
  block = obj.layers(l).block ;
  slayer = block.save() ;
  s.layers(l).type = class(block) ;
  s.layers(l).block = slayer ;
end
