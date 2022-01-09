# matlab-utils
Some utility matlab functions (you may need these for my other matlab projects)   

Utitilies:  
  > ImFmtConvert - Convert an image to another format ('uint8' or 'uint16')  
  > dat2int - Set the data to an apropriate integer type to reduce the memory use  
  > findOffset3D - Find the 3D offset of a small 2D/3D image f relative to a large 3D image B (based on cross-correlation)  
  > findPtsInTrPrism - Find points within the triangular prism that is obtained by extrusion of a triangle
  > rmVox3D - Remove grey levels of the voxels located on a mannually defined 3D surface (with thickness --> 3D volume)
  > kron_npts - Kronecker product between two vectors at many points (npts)

Image-related math operations:  
  > div - Compute the divergence of vectors whose components are defined in two 2D images or three 3D images, using 3-points numerical differentiation (see help gradient)  
  > div_5pts - Compute the divergence of vectors whose components are defined in two 2D images or three 3D images, using 5-points numerical differentiation  
  > imgrad_5pts - Compute the gradiant of a 2D/3D image using 5-point numerical differentiation  
  > imgrad_Npts - Compute the gradiant of a 2D/3D image using 3-point / 5-point numerical differentiation  
  > gaussianKernal - Compute the kernal matrix for window function  
  > RotMatrix - Express the three Euler's angles by three rotation matricees in the coordinates of initial tube axis  
  > rotV2XYZ - Rotate a 3D image along one of the coordinate axes X Y Z  
  > vecRot2vec - Rotate vector(s) with respect to given arbitrary vector(s)  
  > I_local - Compute the local inertia tensor for chosen points in a given gray-level image  

Mechancis-related:  
  > tensLst_XYZ2RTZ - Transform the stress/strain tensor from Cartesian to cylindrical  
  > XYZ2RTZtens - Transform 3x3 tensor(s) from XYZ coordinates to RTZ coodinates  

More specific functions:  
  > voidprops - Characterise the geometric properties of voids (or any 3D object) in a 3D image

To be moved to another repo (?):  
  > LocAxisCalc_v2 - Compute the local axes for each micro pore's CoG  
  > RTZ2XYZ - FROM R-THETA-Z COORDINATES (Tube-Local) TO X-Y-Z COORDINATES (Image-Global)  
  > XYZ2RTZ - FROM X-Y-Z COORDINATES (Image-Global) TO R-THETA-Z COORDINATES (Tube-Local)  
  > ind2indneighb - This function returns the voxel list of the input points neighbors (only for 3D application, 2D not yet availabel)  
  > ind2indneighb_p - Same functionality as "ind2indneighb" but extended to periodicity
 
