function vw = ff_recomputeVertex(vw)
% recompute vertex when projecting stuff to the mesh else they might come
% out all scattered

MSH = viewGet(vw, 'Mesh'); 
vertexGrayMap = mrmMapVerticesToGray( meshGet(MSH, 'initialvertices'), viewGet(vw, 'nodes'), viewGet(vw, 'mmPerVox'), viewGet(vw, 'edges') ); 
MSH = meshSet(MSH, 'vertexgraymap', vertexGrayMap); 
vw = viewSet(vw, 'Mesh', MSH); 
clear MSH vertexGrayMap

end