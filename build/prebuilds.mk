# DDK UM Prebuilds for H3 ES 3.0

LOCAL_PATH := $(DDK_UM_PREBUILDS)

PRODUCT_COPY_FILES += \
		$(LOCAL_PATH)/vendor/bin/hwperfbin2jsont:vendor/bin/hwperfbin2jsont \
		$(LOCAL_PATH)/vendor/bin/pvrhwperf:vendor/bin/pvrhwperf \
		$(LOCAL_PATH)/vendor/bin/pvrlogdump:vendor/bin/pvrlogdump \
		$(LOCAL_PATH)/vendor/bin/pvrlogsplit:vendor/bin/pvrlogsplit \
		$(LOCAL_PATH)/vendor/bin/pvrsrvctl:vendor/bin/pvrsrvctl \
		$(LOCAL_PATH)/vendor/etc/firmware/rgx.fw.signed.4.46.6.62:vendor/etc/firmware/rgx.fw.signed.4.46.6.62 \
		$(LOCAL_PATH)/vendor/etc/firmware/rgx.fw.signed.4.46.6.62.vz:vendor/etc/firmware/rgx.fw.signed.4.46.6.62.vz \
		$(LOCAL_PATH)/vendor/lib/libglslcompiler.so:vendor/lib/libglslcompiler.so \
		$(LOCAL_PATH)/vendor/lib/libIMGegl.so:vendor/lib/libIMGegl.so \
		$(LOCAL_PATH)/vendor/lib/libPVRScopeServices.so:vendor/lib/libPVRScopeServices.so \
		$(LOCAL_PATH)/vendor/lib/libsrv_um.so:vendor/lib/libsrv_um.so \
		$(LOCAL_PATH)/vendor/lib/libtqvalidate.so:vendor/lib/libtqvalidate.so \
		$(LOCAL_PATH)/vendor/lib/libusc.so:vendor/lib/libusc.so \
		$(LOCAL_PATH)/vendor/lib/egl/libEGL_POWERVR_ROGUE.so:vendor/lib/egl/libEGL_POWERVR_ROGUE.so \
		$(LOCAL_PATH)/vendor/lib/egl/libGLESv1_CM_POWERVR_ROGUE.so:vendor/lib/egl/libGLESv1_CM_POWERVR_ROGUE.so \
		$(LOCAL_PATH)/vendor/lib/egl/libGLESv2_POWERVR_ROGUE.so:vendor/lib/egl/libGLESv2_POWERVR_ROGUE.so \
		$(LOCAL_PATH)/vendor/lib/hw/gralloc.r8a7795.so:vendor/lib/hw/gralloc.r8a7795.so \
		$(LOCAL_PATH)/vendor/lib/hw/memtrack.r8a7795.so:vendor/lib/hw/memtrack.r8a7795.so \
        $(LOCAL_PATH)/vendor/lib64/libglslcompiler.so:vendor/lib64/libglslcompiler.so \
        $(LOCAL_PATH)/vendor/lib64/libIMGegl.so:vendor/lib64/libIMGegl.so \
        $(LOCAL_PATH)/vendor/lib64/libPVRScopeServices.so:vendor/lib64/libPVRScopeServices.so \
        $(LOCAL_PATH)/vendor/lib64/libsrv_um.so:vendor/lib64/libsrv_um.so \
		$(LOCAL_PATH)/vendor/lib64/libtqvalidate.so:vendor/lib64/libtqvalidate.so \
        $(LOCAL_PATH)/vendor/lib64/libusc.so:vendor/lib64/libusc.so \
        $(LOCAL_PATH)/vendor/lib64/egl/libEGL_POWERVR_ROGUE.so:vendor/lib64/egl/libEGL_POWERVR_ROGUE.so \
        $(LOCAL_PATH)/vendor/lib64/egl/libGLESv1_CM_POWERVR_ROGUE.so:vendor/lib64/egl/libGLESv1_CM_POWERVR_ROGUE.so \
        $(LOCAL_PATH)/vendor/lib64/egl/libGLESv2_POWERVR_ROGUE.so:vendor/lib64/egl/libGLESv2_POWERVR_ROGUE.so \
        $(LOCAL_PATH)/vendor/lib64/hw/gralloc.r8a7795.so:vendor/lib64/hw/gralloc.r8a7795.so \
        $(LOCAL_PATH)/vendor/lib64/hw/memtrack.r8a7795.so:vendor/lib64/hw/memtrack.r8a7795.so \
