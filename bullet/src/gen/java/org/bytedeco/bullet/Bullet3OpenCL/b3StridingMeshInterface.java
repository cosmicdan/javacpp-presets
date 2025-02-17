// Targeted by JavaCPP version 1.5.8: DO NOT EDIT THIS FILE

package org.bytedeco.bullet.Bullet3OpenCL;

import java.nio.*;
import org.bytedeco.javacpp.*;
import org.bytedeco.javacpp.annotation.*;

import static org.bytedeco.javacpp.presets.javacpp.*;
import org.bytedeco.bullet.Bullet3Common.*;
import static org.bytedeco.bullet.global.Bullet3Common.*;
import org.bytedeco.bullet.Bullet3Collision.*;
import static org.bytedeco.bullet.global.Bullet3Collision.*;
import org.bytedeco.bullet.Bullet3Dynamics.*;
import static org.bytedeco.bullet.global.Bullet3Dynamics.*;
import org.bytedeco.bullet.LinearMath.*;
import static org.bytedeco.bullet.global.LinearMath.*;

import static org.bytedeco.bullet.global.Bullet3OpenCL.*;


/**	The b3StridingMeshInterface is the interface class for high performance generic access to triangle meshes, used in combination with b3BvhTriangleMeshShape and some other collision shapes.
 *  Using index striding of 3*sizeof(integer) it can use triangle arrays, using index striding of 1*sizeof(integer) it can handle triangle strips.
 *  It allows for sharing graphics and collision meshes. Also it provides locking/unlocking of graphics meshes that are in gpu memory. */
@NoOffset @Properties(inherit = org.bytedeco.bullet.presets.Bullet3OpenCL.class)
public class b3StridingMeshInterface extends Pointer {
    static { Loader.load(); }
    /** Pointer cast constructor. Invokes {@link Pointer#Pointer(Pointer)}. */
    public b3StridingMeshInterface(Pointer p) { super(p); }


	public native void InternalProcessAllTriangles(b3InternalTriangleIndexCallback callback, @Const @ByRef b3Vector3 aabbMin, @Const @ByRef b3Vector3 aabbMax);

	/**brute force method to calculate aabb */
	public native void calculateAabbBruteForce(@ByRef b3Vector3 aabbMin, @ByRef b3Vector3 aabbMax);

	/** get read and write access to a subpart of a triangle mesh
	 *  this subpart has a continuous array of vertices and indices
	 *  in this way the mesh can be handled as chunks of memory with striding
	 *  very similar to OpenGL vertexarray support
	 *  make a call to unLockVertexBase when the read and write access is finished */
	public native void getLockedVertexIndexBase(@Cast("unsigned char**") PointerPointer vertexbase, @ByRef IntPointer numverts, @Cast("PHY_ScalarType*") @ByRef IntPointer type, @ByRef IntPointer stride, @Cast("unsigned char**") PointerPointer indexbase, @ByRef IntPointer indexstride, @ByRef IntPointer numfaces, @Cast("PHY_ScalarType*") @ByRef IntPointer indicestype, int subpart/*=0*/);
	public native void getLockedVertexIndexBase(@Cast("unsigned char**") @ByPtrPtr BytePointer vertexbase, @ByRef IntPointer numverts, @Cast("PHY_ScalarType*") @ByRef IntPointer type, @ByRef IntPointer stride, @Cast("unsigned char**") @ByPtrPtr BytePointer indexbase, @ByRef IntPointer indexstride, @ByRef IntPointer numfaces, @Cast("PHY_ScalarType*") @ByRef IntPointer indicestype);
	public native void getLockedVertexIndexBase(@Cast("unsigned char**") @ByPtrPtr BytePointer vertexbase, @ByRef IntPointer numverts, @Cast("PHY_ScalarType*") @ByRef IntPointer type, @ByRef IntPointer stride, @Cast("unsigned char**") @ByPtrPtr BytePointer indexbase, @ByRef IntPointer indexstride, @ByRef IntPointer numfaces, @Cast("PHY_ScalarType*") @ByRef IntPointer indicestype, int subpart/*=0*/);
	public native void getLockedVertexIndexBase(@Cast("unsigned char**") @ByPtrPtr ByteBuffer vertexbase, @ByRef IntBuffer numverts, @Cast("PHY_ScalarType*") @ByRef IntBuffer type, @ByRef IntBuffer stride, @Cast("unsigned char**") @ByPtrPtr ByteBuffer indexbase, @ByRef IntBuffer indexstride, @ByRef IntBuffer numfaces, @Cast("PHY_ScalarType*") @ByRef IntBuffer indicestype, int subpart/*=0*/);
	public native void getLockedVertexIndexBase(@Cast("unsigned char**") @ByPtrPtr ByteBuffer vertexbase, @ByRef IntBuffer numverts, @Cast("PHY_ScalarType*") @ByRef IntBuffer type, @ByRef IntBuffer stride, @Cast("unsigned char**") @ByPtrPtr ByteBuffer indexbase, @ByRef IntBuffer indexstride, @ByRef IntBuffer numfaces, @Cast("PHY_ScalarType*") @ByRef IntBuffer indicestype);
	public native void getLockedVertexIndexBase(@Cast("unsigned char**") @ByPtrPtr byte[] vertexbase, @ByRef int[] numverts, @Cast("PHY_ScalarType*") @ByRef int[] type, @ByRef int[] stride, @Cast("unsigned char**") @ByPtrPtr byte[] indexbase, @ByRef int[] indexstride, @ByRef int[] numfaces, @Cast("PHY_ScalarType*") @ByRef int[] indicestype, int subpart/*=0*/);
	public native void getLockedVertexIndexBase(@Cast("unsigned char**") @ByPtrPtr byte[] vertexbase, @ByRef int[] numverts, @Cast("PHY_ScalarType*") @ByRef int[] type, @ByRef int[] stride, @Cast("unsigned char**") @ByPtrPtr byte[] indexbase, @ByRef int[] indexstride, @ByRef int[] numfaces, @Cast("PHY_ScalarType*") @ByRef int[] indicestype);

	public native void getLockedReadOnlyVertexIndexBase(@Cast("const unsigned char**") PointerPointer vertexbase, @ByRef IntPointer numverts, @Cast("PHY_ScalarType*") @ByRef IntPointer type, @ByRef IntPointer stride, @Cast("const unsigned char**") PointerPointer indexbase, @ByRef IntPointer indexstride, @ByRef IntPointer numfaces, @Cast("PHY_ScalarType*") @ByRef IntPointer indicestype, int subpart/*=0*/);
	public native void getLockedReadOnlyVertexIndexBase(@Cast("const unsigned char**") @ByPtrPtr BytePointer vertexbase, @ByRef IntPointer numverts, @Cast("PHY_ScalarType*") @ByRef IntPointer type, @ByRef IntPointer stride, @Cast("const unsigned char**") @ByPtrPtr BytePointer indexbase, @ByRef IntPointer indexstride, @ByRef IntPointer numfaces, @Cast("PHY_ScalarType*") @ByRef IntPointer indicestype);
	public native void getLockedReadOnlyVertexIndexBase(@Cast("const unsigned char**") @ByPtrPtr BytePointer vertexbase, @ByRef IntPointer numverts, @Cast("PHY_ScalarType*") @ByRef IntPointer type, @ByRef IntPointer stride, @Cast("const unsigned char**") @ByPtrPtr BytePointer indexbase, @ByRef IntPointer indexstride, @ByRef IntPointer numfaces, @Cast("PHY_ScalarType*") @ByRef IntPointer indicestype, int subpart/*=0*/);
	public native void getLockedReadOnlyVertexIndexBase(@Cast("const unsigned char**") @ByPtrPtr ByteBuffer vertexbase, @ByRef IntBuffer numverts, @Cast("PHY_ScalarType*") @ByRef IntBuffer type, @ByRef IntBuffer stride, @Cast("const unsigned char**") @ByPtrPtr ByteBuffer indexbase, @ByRef IntBuffer indexstride, @ByRef IntBuffer numfaces, @Cast("PHY_ScalarType*") @ByRef IntBuffer indicestype, int subpart/*=0*/);
	public native void getLockedReadOnlyVertexIndexBase(@Cast("const unsigned char**") @ByPtrPtr ByteBuffer vertexbase, @ByRef IntBuffer numverts, @Cast("PHY_ScalarType*") @ByRef IntBuffer type, @ByRef IntBuffer stride, @Cast("const unsigned char**") @ByPtrPtr ByteBuffer indexbase, @ByRef IntBuffer indexstride, @ByRef IntBuffer numfaces, @Cast("PHY_ScalarType*") @ByRef IntBuffer indicestype);
	public native void getLockedReadOnlyVertexIndexBase(@Cast("const unsigned char**") @ByPtrPtr byte[] vertexbase, @ByRef int[] numverts, @Cast("PHY_ScalarType*") @ByRef int[] type, @ByRef int[] stride, @Cast("const unsigned char**") @ByPtrPtr byte[] indexbase, @ByRef int[] indexstride, @ByRef int[] numfaces, @Cast("PHY_ScalarType*") @ByRef int[] indicestype, int subpart/*=0*/);
	public native void getLockedReadOnlyVertexIndexBase(@Cast("const unsigned char**") @ByPtrPtr byte[] vertexbase, @ByRef int[] numverts, @Cast("PHY_ScalarType*") @ByRef int[] type, @ByRef int[] stride, @Cast("const unsigned char**") @ByPtrPtr byte[] indexbase, @ByRef int[] indexstride, @ByRef int[] numfaces, @Cast("PHY_ScalarType*") @ByRef int[] indicestype);

	/** unLockVertexBase finishes the access to a subpart of the triangle mesh
	 *  make a call to unLockVertexBase when the read and write access (using getLockedVertexIndexBase) is finished */
	public native void unLockVertexBase(int subpart);

	public native void unLockReadOnlyVertexBase(int subpart);

	/** getNumSubParts returns the number of separate subparts
	 *  each subpart has a continuous array of vertices and indices */
	public native int getNumSubParts();

	public native void preallocateVertices(int numverts);
	public native void preallocateIndices(int numindices);

	public native @Cast("bool") boolean hasPremadeAabb();
	public native void setPremadeAabb(@Const @ByRef b3Vector3 aabbMin, @Const @ByRef b3Vector3 aabbMax);
	public native void getPremadeAabb(b3Vector3 aabbMin, b3Vector3 aabbMax);

	public native @Const @ByRef b3Vector3 getScaling();
	public native void setScaling(@Const @ByRef b3Vector3 scaling);

	public native int calculateSerializeBufferSize();

	/**fills the dataBuffer and returns the struct name (and 0 on failure) */
	//virtual	const char*	serialize(void* dataBuffer, b3Serializer* serializer) const;
}
