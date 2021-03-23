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

#ifndef IMG_GRALLOC1_PUBLIC_H
#define IMG_GRALLOC1_PUBLIC_H

/* Authors of third party hardware composer (HWC) modules will need to include
 * this header to access functionality in the gralloc HAL (version >=1.0).
 */

#include "img_gralloc_common_public.h"
#include <hardware/gralloc1.h>

/* In HAL v1 we have to access functions by descriptor, and the last descriptor
 * used by the platform will change with the platform version. To try to keep
 * some amount of binary compatibility, use a large fixed offset, and check
 * we don't overlap with the platform's last function descriptor.
 */

#define GRALLOC1_FUNCTION_IMG_EXT_OFF 1000

//static_assert(GRALLOC1_LAST_FUNCTION <= GRALLOC1_FUNCTION_IMG_EXT_OFF,
//               "gralloc1 function descriptors overlap with extension range");

enum
{
	GRALLOC1_FUNCTION_GET_BUFFER_FORMAT_IMG =
		(GRALLOC1_FUNCTION_IMG_EXT_OFF + GRALLOC_GET_BUFFER_FORMAT_IMG),
	GRALLOC1_FUNCTION_GET_BUFFER_FORMATS_IMG =
		(GRALLOC1_FUNCTION_IMG_EXT_OFF + GRALLOC_GET_BUFFER_FORMATS_IMG),
	GRALLOC1_FUNCTION_BLIT_HANDLE_TO_HANDLE_IMG =
		(GRALLOC1_FUNCTION_IMG_EXT_OFF + GRALLOC_BLIT_HANDLE_TO_HANDLE_IMG),
	GRALLOC1_FUNCTION_BLIT_STAMP_TO_HANDLE_IMG =
		(GRALLOC1_FUNCTION_IMG_EXT_OFF + GRALLOC_BLIT_STAMP_TO_HANDLE_IMG),
	GRALLOC1_FUNCTION_SET_DATA_SPACE_IMG =
		(GRALLOC1_FUNCTION_IMG_EXT_OFF + GRALLOC_SET_DATA_SPACE_IMG),
	GRALLOC1_FUNCTION_GET_ION_CLIENT_IMG =
		(GRALLOC1_FUNCTION_IMG_EXT_OFF + GRALLOC_GET_ION_CLIENT_IMG),
	GRALLOC1_FUNCTION_GET_BUFFER_HANDLE_IMG =
		(GRALLOC1_FUNCTION_IMG_EXT_OFF + GRALLOC_GET_BUFFER_HANDLE_IMG),
	GRALLOC1_FUNCTION_GET_COLORSPACE_BUFFER_FORMAT_IMG =
		(GRALLOC1_FUNCTION_IMG_EXT_OFF + GRALLOC_GET_COLORSPACE_BUFFER_FORMAT_IMG),
};

/* Public HAL extension API */

typedef gralloc1_device_t gralloc_t;

typedef int (*GRALLOC1_PFN_GET_BUFFER_FORMAT_IMG)
	(gralloc_t *g, int format, const IMG_buffer_format_public_t **v);

static inline int gralloc_get_buffer_format_img
	(gralloc_t *g, int format, const IMG_buffer_format_public_t **v)
{
	GRALLOC1_PFN_GET_BUFFER_FORMAT_IMG f =
		(GRALLOC1_PFN_GET_BUFFER_FORMAT_IMG)
			g->getFunction(g, GRALLOC1_FUNCTION_GET_BUFFER_FORMAT_IMG);

	return f(g, format, v);
}

typedef int (*GRALLOC1_PFN_GET_BUFFER_FORMATS_IMG)
	(gralloc_t *g, const IMG_buffer_format_public_t **v);

static inline int gralloc_get_buffer_formats_img
	(gralloc_t *g, const IMG_buffer_format_public_t **v)
{
	GRALLOC1_PFN_GET_BUFFER_FORMATS_IMG f =
		(GRALLOC1_PFN_GET_BUFFER_FORMATS_IMG)
			g->getFunction(g, GRALLOC1_FUNCTION_GET_BUFFER_FORMATS_IMG);

	return f(g, v);
}

typedef int (*GRALLOC1_PFN_BLIT_HANDLE_TO_HANDLE_IMG)
	(gralloc_t *g, buffer_handle_t src, buffer_handle_t dest, int w, int h,
	 int x, int y, int transform, int input_fence, int *output_fence);

static inline int gralloc_blit_handle_to_handle_img
	(gralloc_t *g, buffer_handle_t src, buffer_handle_t dest, int w, int h,
	 int x, int y, int transform, int input_fence, int *output_fence)
{
	GRALLOC1_PFN_BLIT_HANDLE_TO_HANDLE_IMG f =
		(GRALLOC1_PFN_BLIT_HANDLE_TO_HANDLE_IMG)
			g->getFunction(g, GRALLOC1_FUNCTION_BLIT_HANDLE_TO_HANDLE_IMG);

	return f(g, src, dest, w, h, x, y, transform, input_fence, output_fence);
}

typedef int (*GRALLOC1_PFN_BLIT_STAMP_TO_HANDLE_IMG)
	(gralloc_t *g, unsigned long long src_stamp, int src_width, int src_height,
	 int src_format, int src_stride_in_pixels, int src_rotation,
	 buffer_handle_t dest, int dest_rotation, int input_fence,
	 int *output_fence);

static inline int gralloc_blit_stamp_to_handle
	(gralloc_t *g, unsigned long long src_stamp, int src_width, int src_height,
	 int src_format, int src_stride_in_pixels, int src_rotation,
	 buffer_handle_t dest, int dest_rotation, int input_fence,
	 int *output_fence)
{
	GRALLOC1_PFN_BLIT_STAMP_TO_HANDLE_IMG f =
		(GRALLOC1_PFN_BLIT_STAMP_TO_HANDLE_IMG)
			g->getFunction(g, GRALLOC1_FUNCTION_BLIT_STAMP_TO_HANDLE_IMG);

	return f(g, src_stamp, src_width, src_height, src_format,
			 src_stride_in_pixels, src_rotation, dest, dest_rotation,
			 input_fence, output_fence);
}

typedef int (*GRALLOC1_PFN_SET_DATA_SPACE_IMG)
	(gralloc_t *g, buffer_handle_t handle,
	 android_dataspace_ext_t source_dataspace,
	 android_dataspace_ext_t dest_dataspace);

static inline int gralloc_set_data_space_img
	(gralloc_t *g, buffer_handle_t handle,
	 android_dataspace_ext_t source_dataspace,
	 android_dataspace_ext_t dest_dataspace)
{
	GRALLOC1_PFN_SET_DATA_SPACE_IMG f =
		(GRALLOC1_PFN_SET_DATA_SPACE_IMG)
			g->getFunction(g, GRALLOC1_FUNCTION_SET_DATA_SPACE_IMG);

	return f(g, handle, source_dataspace, dest_dataspace);
}

typedef int (*GRALLOC1_PFN_GET_ION_CLIENT_IMG)
	(gralloc_t *g, int *client);

static inline int gralloc_get_ion_client_img
	(gralloc_t *g, int *client)
{
	GRALLOC1_PFN_GET_ION_CLIENT_IMG f =
		(GRALLOC1_PFN_GET_ION_CLIENT_IMG)
			g->getFunction(g, GRALLOC1_FUNCTION_GET_ION_CLIENT_IMG);

	return f(g, client);
}

/* NOTE: The buffer handle returned is a raw memory copy, so if the handle
 *       type contains file descriptors, the caller does not own them and
 *       must not close them. Also, the handles can go away at any time,
 *       so users of this code should work with the implicit gralloc
 *       contract, and not hold onto the handles returned here.
 */

typedef int (*GRALLOC1_PFN_GET_BUFFER_HANDLE_IMG)
	(gralloc_t *g, buffer_handle_t handle, IMG_buffer_handle_t *buffer_handle);

static inline int gralloc_get_buffer_handle_img
	(gralloc_t *g, buffer_handle_t handle, IMG_buffer_handle_t *buffer_handle)
{
	GRALLOC1_PFN_GET_BUFFER_HANDLE_IMG f =
		(GRALLOC1_PFN_GET_BUFFER_HANDLE_IMG)
			g->getFunction(g, GRALLOC1_FUNCTION_GET_BUFFER_HANDLE_IMG);

	return f(g, handle, buffer_handle);
}

typedef int (*GRALLOC1_PFN_GET_COLORSPACE_BUFFER_FORMAT_IMG)
	(gralloc_t *g, int format, android_dataspace_ext_t eColorspace,
     const IMG_buffer_format_public_t **v);

static inline int gralloc_get_colorspace_buffer_format_img
	(gralloc_t *g, int format, android_dataspace_ext_t eColorspace,
     const IMG_buffer_format_public_t **v)
{
	GRALLOC1_PFN_GET_COLORSPACE_BUFFER_FORMAT_IMG f =
		(GRALLOC1_PFN_GET_COLORSPACE_BUFFER_FORMAT_IMG)
			g->getFunction(g, GRALLOC1_FUNCTION_GET_COLORSPACE_BUFFER_FORMAT_IMG);

	return f(g, format, eColorspace, v);
}

#endif /* IMG_GRALLOC_PUBLIC_H */
