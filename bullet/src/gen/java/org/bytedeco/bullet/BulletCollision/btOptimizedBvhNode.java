// Targeted by JavaCPP version 1.5.8: DO NOT EDIT THIS FILE

package org.bytedeco.bullet.BulletCollision;

import java.nio.*;
import org.bytedeco.javacpp.*;
import org.bytedeco.javacpp.annotation.*;

import static org.bytedeco.javacpp.presets.javacpp.*;
import org.bytedeco.bullet.LinearMath.*;
import static org.bytedeco.bullet.global.LinearMath.*;

import static org.bytedeco.bullet.global.BulletCollision.*;


/** btOptimizedBvhNode contains both internal and leaf node information.
 *  Total node size is 44 bytes / node. You can use the compressed version of 16 bytes. */
@Properties(inherit = org.bytedeco.bullet.presets.BulletCollision.class)
public class btOptimizedBvhNode extends Pointer {
    static { Loader.load(); }
    /** Default native constructor. */
    public btOptimizedBvhNode() { super((Pointer)null); allocate(); }
    /** Native array allocator. Access with {@link Pointer#position(long)}. */
    public btOptimizedBvhNode(long size) { super((Pointer)null); allocateArray(size); }
    /** Pointer cast constructor. Invokes {@link Pointer#Pointer(Pointer)}. */
    public btOptimizedBvhNode(Pointer p) { super(p); }
    private native void allocate();
    private native void allocateArray(long size);
    @Override public btOptimizedBvhNode position(long position) {
        return (btOptimizedBvhNode)super.position(position);
    }
    @Override public btOptimizedBvhNode getPointer(long i) {
        return new btOptimizedBvhNode((Pointer)this).offsetAddress(i);
    }


	//32 bytes
	public native @ByRef btVector3 m_aabbMinOrg(); public native btOptimizedBvhNode m_aabbMinOrg(btVector3 setter);
	public native @ByRef btVector3 m_aabbMaxOrg(); public native btOptimizedBvhNode m_aabbMaxOrg(btVector3 setter);

	//4
	public native int m_escapeIndex(); public native btOptimizedBvhNode m_escapeIndex(int setter);

	//8
	//for child nodes
	public native int m_subPart(); public native btOptimizedBvhNode m_subPart(int setter);
	public native int m_triangleIndex(); public native btOptimizedBvhNode m_triangleIndex(int setter);

	//pad the size to 64 bytes
	public native @Cast("char") byte m_padding(int i); public native btOptimizedBvhNode m_padding(int i, byte setter);
	@MemberGetter public native @Cast("char*") BytePointer m_padding();
}
