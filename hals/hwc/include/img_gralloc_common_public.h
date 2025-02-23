/* Copyright (c) Imagination Technologies Ltd.
 *
 * The contents of this file are subject to the MIT license as set out below.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#ifndef IMG_GRALLOC_COMMON_PUBLIC_H
#define IMG_GRALLOC_COMMON_PUBLIC_H

#include <cutils/native_handle.h>
#include <system/graphics.h>
#include <linux/ion.h>

#ifndef ALIGN
#define ALIGN(x,a)	((((x) + (a) - 1L) / (a)) * (a))
#endif
#define HW_ALIGN	32

/* Use bits [0-3] of "vendor format" bits as real format. Customers should
 * use *only* the unassigned bits below for custom pixel formats, YUV or RGB.
 *
 * If there are no bits set in this part of the field, or other bits are set
 * in the format outside of the "vendor format" mask, the non-extension format
 * is used instead. Reserve 0 for this purpose.
 */

#define HAL_PIXEL_FORMAT_VENDOR_EXT(fmt) (0x100 | (fmt & 0xFF))

/*      Reserved ** DO NOT USE **    HAL_PIXEL_FORMAT_VENDOR_EXT(0) */
/*      HAL_PIXEL_FORMAT_RGBA_8888   HAL_PIXEL_FORMAT_VENDOR_EXT(1) */
/*      HAL_PIXEL_FORMAT_RGBX_8888   HAL_PIXEL_FORMAT_VENDOR_EXT(2) */
/*      HAL_PIXEL_FORMAT_RGB_888     HAL_PIXEL_FORMAT_VENDOR_EXT(3) */
/*      HAL_PIXEL_FORMAT_RGB_565     HAL_PIXEL_FORMAT_VENDOR_EXT(4) */
/*      HAL_PIXEL_FORMAT_BGRA_8888   HAL_PIXEL_FORMAT_VENDOR_EXT(5) */
#define HAL_PIXEL_FORMAT_NV12        HAL_PIXEL_FORMAT_VENDOR_EXT(6)
#define HAL_PIXEL_FORMAT_BGRX_8888   HAL_PIXEL_FORMAT_VENDOR_EXT(7)
#define HAL_PIXEL_FORMAT_sRGB_A_8888 HAL_PIXEL_FORMAT_VENDOR_EXT(8)
#define HAL_PIXEL_FORMAT_sRGB_X_8888 HAL_PIXEL_FORMAT_VENDOR_EXT(9)
#define HAL_PIXEL_FORMAT_sBGR_A_8888 HAL_PIXEL_FORMAT_VENDOR_EXT(10)
#define HAL_PIXEL_FORMAT_sBGR_X_8888 HAL_PIXEL_FORMAT_VENDOR_EXT(11)
/*      Free for customer use        HAL_PIXEL_FORMAT_VENDOR_EXT(12) */
/*      Free for customer use        HAL_PIXEL_FORMAT_VENDOR_EXT(13) */
/*      Free for customer use        HAL_PIXEL_FORMAT_VENDOR_EXT(14) */
/*      Free for customer use        HAL_PIXEL_FORMAT_VENDOR_EXT(15) */

/* One of the below compression modes is out of "vendor format" field and
 * OR'ed into bits [12-15] format. If no bits are set in this "compression
 * mask", the normal memory format for the pixel format is used. Otherwise
 * the pixel data will be compressed in memory with the Rogue framebuffer
 * compressor.
 */
#define HAL_FB_COMPRESSION_NONE                0
#define HAL_FB_COMPRESSION_DIRECT_8x8          1
#define HAL_FB_COMPRESSION_DIRECT_16x4         2
#define HAL_FB_COMPRESSION_DIRECT_32x2         3
#define HAL_FB_COMPRESSION_DIRECT_LOSSY25_8x8  4
#define HAL_FB_COMPRESSION_DIRECT_LOSSY25_16x4 5
#define HAL_FB_COMPRESSION_DIRECT_LOSSY25_32x2 6
#define HAL_FB_COMPRESSION_DIRECT_LOSSY75_8x8  7
#define HAL_FB_COMPRESSION_DIRECT_LOSSY50_8x8  8
#define HAL_FB_COMPRESSION_DIRECT_LOSSY50_16x4 9
#define HAL_FB_COMPRESSION_DIRECT_LOSSY50_32x2 10
#define HAL_FB_COMPRESSION_DIRECT_PACKED_8x8   11
#define HAL_FB_COMPRESSION_DIRECT_LOSSY75_16x4 12
#define HAL_FB_COMPRESSION_DIRECT_LOSSY75_32x2 13
#define HAL_FB_COMPRESSION_DIRECT_LOSSY37_8x8  14
#define HAL_FB_COMPRESSION_DIRECT_LOSSY37_16x4 15
#define HAL_FB_COMPRESSION_DIRECT_LOSSY37_32x2 16

/* The memory layout is OR'ed into bit 7 (top bit) of the 8 bit "vendor
 * format" field. Only STRIDED and TWIDDLED are supported; there is no space
 * for PAGETILED.
 */
#define HAL_FB_MEMLAYOUT_STRIDED               0
#define HAL_FB_MEMLAYOUT_TWIDDLED              1

/* This can be tuned down as appropriate for the SOC.
 *
 * IMG formats are usually a single sub-alloc.
 * Some OEM video formats are two sub-allocs (Y, UV planes).
 * Future OEM video formats might be three sub-allocs (Y, U, V planes).
 */
#define MAX_SUB_ALLOCS (3)

typedef struct
{
	native_handle_t base;

	/* These fields can be sent cross process. They are also valid
	 * to duplicate within the same process.
	 *
	 * A table is stored within the gralloc implementation's private data
	 * structure (which is per-process) which maps stamps to a mapped
	 * PVRSRV_MEMDESC in that process. Each map entry has a lock count
	 * associated with it, satisfying the requirements of the gralloc API.
	 * This also prevents us from leaking maps/allocations.
	 */

#define IMG_NATIVE_HANDLE_NUMFDS (MAX_SUB_ALLOCS)

	/* The 'fd' field is used to "export" a meminfo to another process. */
	int fd[MAX_SUB_ALLOCS];

	/* This define should represent the number of packed 'int's required to
	 * represent the fields following it. If you add a data type that is
	 * 64-bit, for example using 'uint64_t', you should write that
	 * as "sizeof(uint64)t) / sizeof(int)". Please keep the order
	 * of the additions the same as the defined field order.
	 */

#if defined(PVR_ANDROID_HAS_GRAPHICSHAL_HIDL)
#define IMG_NATIVE_HANDLE_NUMINTS \
	(sizeof(uint64_t) / sizeof(int) + \
	 sizeof(uint64_t) / sizeof(int) + \
	 5 + MAX_SUB_ALLOCS + MAX_SUB_ALLOCS + \
	 sizeof(uint64_t) / sizeof(int) * MAX_SUB_ALLOCS + \
	 MAX_SUB_ALLOCS + MAX_SUB_ALLOCS + MAX_SUB_ALLOCS + 2)
#else
#define IMG_NATIVE_HANDLE_NUMINTS \
	(sizeof(uint64_t) / sizeof(int) + \
	 6 + MAX_SUB_ALLOCS + MAX_SUB_ALLOCS + \
	 sizeof(uint64_t) / sizeof(int) * MAX_SUB_ALLOCS + \
	 MAX_SUB_ALLOCS + MAX_SUB_ALLOCS + MAX_SUB_ALLOCS + 3)
#endif

	/* A KERNEL unique identifier for any exported kernel memdesc. Each
	 * exported kernel memdesc will have a unique stamp, but note that in
	 * userspace, several memdescs across multiple processes could have
	 * the same stamp. As the native_handle can be dup(2)'d, there could be
	 * multiple handles with the same stamp but different file descriptors.
	 */
	uint64_t ui64Stamp;

	/* This is used for buffer usage validation */
#if defined(PVR_ANDROID_HAS_GRAPHICSHAL_HIDL)
	uint64_t usage;
#else
	int usage;
#endif

	/* In order to do efficient cache flushes we need the buffer dimensions,
	 * format and bits per pixel. There are ANativeWindow queries for the
	 * width, height and format, but the graphics HAL might have remapped the
	 * request to different values at allocation time. These are the 'true'
	 * values of the buffer allocation.
	 */
	int iWidth;
	int iHeight;
	int iFormat;
	unsigned int uiBpp;

	/* Planes are not the same as the 'fd' suballocs. A multi-planar YUV
	 * allocation has different planes (interleaved = 1, semi-planar = 2,
	 * fully-planar = 3) but might be spread across 1, 2 or 3 independent
	 * memory allocations (or not).
	 */
	int iPlanes;

	/* For multi-planar allocations, there will be multiple hstrides */
	int aiStride[MAX_SUB_ALLOCS];

	/* For multi-planar allocations, there will be multiple vstrides */
	int aiVStride[MAX_SUB_ALLOCS];

	/* These byte offsets are reconciled with the number of sub-allocs used
	 * for a multi-planar allocation. If there is a 1:1 mapping between the
	 * number of planes and the number of sub-allocs, these will all be zero.
	 *
	 * Otherwise, normally the zeroth entry will be zero, and the latter
	 * entries will be non-zero.
	 */
	uint64_t aulPlaneOffset[MAX_SUB_ALLOCS];

	/* Indicates what are stored in memdesc  */
	unsigned int auiMemdescUsage[MAX_SUB_ALLOCS];

	/* Indicates the number of virtual chunks that covers the virtual size of
	 * the handles
	 */
	unsigned int auiNumVirtualChunks[MAX_SUB_ALLOCS];

	/* Indicates the number of chunks that are physically backed */
	unsigned int auiNumPhysicalChunks[MAX_SUB_ALLOCS];

	/* This records the number of MAX_SUB_ALLOCS fds actually used by the
	 * buffer allocation. File descriptors up to fd[iNumSubAllocs - 1] are
	 * guaranteed to be valid. (This does not have any bearing on the aiStride,
	 * aiVStride or aulPlaneOffset fields, as 'iPlanes' of those arrays should
	 * be initialized, not 'iNumSubAllocs'.)
	 */
	int iNumSubAllocs;

	/* How many layers a buffer contains. Layers are used to allocate for
	 * texture arrays shared between processes. The multiple layers are
	 * contained in one memory allocation. */
	int iLayers;

	/* This records reserved bits for implementation-specific usage flags */
#ifndef PVR_ANDROID_HAS_GRAPHICSHAL_HIDL
	int iPrivUsage;
#endif
}
__attribute__((aligned(sizeof(int)),packed)) IMG_native_handle_t;

/* Channel encoding of buffer data.
 *
 * If the buffer has only one plane, the ENCODING bits should be interpreted
 * as a definition of the interleaving pattern. Only two of the possible four
 * permutations are defined; this is because the YVYU and VYUY patterns are
 * not seen in the wild.
 *
 * If the buffer has more than one plane, the ENCODING bits should be
 * interpreted as a definition of the plane order in memory. Assuming a YUV
 * format, Y is always first, but U and V may be defined in 'V then U' or
 * 'U then V' orders.
 *
 * Some bits are not used, to maximize compatibility with older DDKs which
 * used them in semantically different ways.
 */
#define IMG_BFF_ENCODING_MASK                (3 << 0)
/* For uiPlanes == 1 **********************************/
/*   Reserved for VYUY (check IsYUV if used) (0 << 0) */
#define IMG_BFF_ENCODING_INTERLEAVED_YUYV    (1 << 0)
/*   Reserved for YVYU                       (2 << 0) */
#define IMG_BFF_ENCODING_INTERLEAVED_UYVY    (3 << 0)
/* For uiPlanes > 1 ***********************************/
/*   Unused (check IsYUV if used)            (0 << 0) */
#define IMG_BFF_ENCODING_VUCrCb              (1 << 0)
/*   Unused                                  (2 << 0) */
#define IMG_BFF_ENCODING_UVCbCr              (3 << 0)

/* Whether the buffer should be cleared to zero from userspace, or via the
 * PowerVR services at import time. This is deprecated functionality as most
 * platforms use dma-buf or ion now, and for security reasons these allocators
 * should never return uncleared memory.
 */
#define IMG_BFF_CPU_CLEAR                    (1 << 2)

/* Deprecated, do not use */
#define IMG_BFF_DONT_GPU_CLEAR               (1 << 3)

/* Deprecated, do not use */
#define IMG_BFF_PARTIAL_ALLOC                (1 << 4)

/* Guarantee that GPU framebuffer compression is never used for buffers in
 * this format, even if the format is supported by the compressor. This might
 * be useful if the buffer is being fed to hardware blocks that cannot handle
 * the framebuffer compression encoding, and the existing HAL overrides are
 * not sufficiently expressive.
 */
#define IMG_BFF_NEVER_COMPRESS               (1 << 5)

/* Deprecated, do not use */
#define IMG_BFF_BIFTILED                     (1 << 6)

/* YUV subsampling encoding of buffer data.
 * Many YUV formats have less chroma information than luma information. If
 * this is not the case, use SUBSAMPLING_4_4_4. If each of the U and V channel
 * data are 1/4 the size of the Y channel data, use SUBSAMPLING_4_2_0.
 * Otherwise, use SUBSAMPLING_4_2_2.
 */
#define IMG_BFF_YUV_SUBSAMPLING_MASK         (3 << 7)
#define IMG_BFF_YUV_SUBSAMPLING_4_2_0        (0 << 7)
/* Unused: 4:1:1, 4:2:1, 4:1:0, 3:1:1?       (1 << 7) */
#define IMG_BFF_YUV_SUBSAMPLING_4_2_2        (2 << 7)
#define IMG_BFF_YUV_SUBSAMPLING_4_4_4        (3 << 7)

/* Move the format to the end of the list when returning configs to EGL. */
#define IMG_BFF_EGL_LOW_PRIORITY             (1 << 9)

/* When computing the first bit in the metadata plane layout for each
 * components, it's equivalent to the offset in pixels for channels.
 * According to this bit to assign corresponding offets for R component and
 * B component.
 */
#define IMG_BFF_B_G_R_ORDER                  (1 << 10)

/* To determine how many components in the plane. */
#define IMG_BFF_WITHOUT_ALPHA                (1 << 11)

/* Buffers are expected to be locked for reading and writing in multiple
 * threads and/or processes simultaneously but clients must take care of
 * data consistent.
 */
#define IMG_BFF_CPU_WRITE_CONCURRENT         (1 << 12)

/* Backwards compatibility */
#define IMG_BFF_YUV             IMG_BFF_ENCODING_VUCrCb
#define IMG_BFF_UVCbCrORDERING  IMG_BFF_ENCODING_UVCbCr

/* Keep this in sync with SGX */
typedef struct IMG_buffer_format_public_t
{
	/* Buffer formats are returned as a linked list */
	struct IMG_buffer_format_public_t *psNext;

	/* HAL_PIXEL_FORMAT_... enumerant */
	int iHalPixelFormat;

	/* IMG_PIXFMT_... enumerant */
	int iIMGPixelFormat;

	/* Friendly name for format */
	const char *const szName;

	/* Bits (not bytes) per pixel */
	unsigned int uiBpp;

	/* Supported HW usage bits. If this is GRALLOC_USAGE_HW_MASK, all usages
	 * are supported. Used for HAL_PIXEL_FORMAT_IMPLEMENTATION_DEFINED.
	 */
#if defined(PVR_ANDROID_HAS_GRAPHICSHAL_HIDL)
	uint64_t iSupportedUsage;
#else
	int iSupportedUsage;
#endif
	/* Allocation description flags */
	unsigned int uiFlags;
}
IMG_buffer_format_public_t;

typedef struct
{
	enum
	{
		IMG_BUFFER_HANDLE_TYPE_ION    = 0,
		IMG_BUFFER_HANDLE_TYPE_DMABUF = 1,
	}
	eType;

	union
	{
		int aiIonUserHandleFd[MAX_SUB_ALLOCS];
		int aiDmaBufShareFd[MAX_SUB_ALLOCS];
	};
}
IMG_buffer_handle_t;

/* Public extensions, common to v0 and v1 HALs */

#define GRALLOC_GET_BUFFER_FORMAT_IMG                1
#define GRALLOC_GET_BUFFER_FORMATS_IMG               2
#define GRALLOC_BLIT_HANDLE_TO_HANDLE_IMG            3
#define GRALLOC_BLIT_STAMP_TO_HANDLE_IMG             4
#define GRALLOC_SET_DATA_SPACE_IMG                   5
#define GRALLOC_GET_ION_CLIENT_IMG                   6
#define GRALLOC_GET_BUFFER_HANDLE_IMG                7
#define GRALLOC_GET_COLORSPACE_BUFFER_FORMAT_IMG     8


#endif /* IMG_GRALLOC_COMMON_PUBLIC_H */
