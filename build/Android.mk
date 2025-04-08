
define intermediates_path_for_lib
$(addprefix $(PRODUCT_OUT)/$1/$2/$(basename $3)_intermediates/,$3)
endef

define intermediates_path_for_java_lib
$(addprefix $(PRODUCT_OUT)/../../common/$1/$2/$3_intermediates/,$4)
endef

IMG_DEPS_LIBRARIES := \
    libaidlcommonsupport.a \
    libarect.a \
    libbase_ndk.a \
    libcrypto_static.a \
    libcutils.a \
    libdmabufinfo.a \
    libneuralnetworks_common.a \
    libneuralnetworks_common_cl.a \
    libneuralnetworks_cl.a \
    libneuralnetworks_shim_static.a \
    libRScpp_static.a \
    libBlobCache.a \
    lib_nnCache.a \
    neuralnetworks_supportlibrary_loader.a \
    neuralnetworks_types_cl.a \
    neuralnetworks_utils_hal_aidl.a \
    neuralnetworks_utils_hal_common.a \
    libprotobuf-cpp-lite.a \
    perfetto_trace_protos.a \
    libperfetto_client_experimental.a

IMG_JAVA_CLASSES_HEADER_DEPS := \
    android_system_stubs_current \

IMG_DEPS_LIBRARIES_TARGETS := $(foreach lib,$(IMG_DEPS_LIBRARIES), \
            $(call intermediates_path_for_lib,obj,STATIC_LIBRARIES,$(lib)))
IMG_DEPS_LIBRARIES_TARGETS += $(foreach lib,$(IMG_DEPS_LIBRARIES), \
                $(call intermediates_path_for_lib,obj_arm,STATIC_LIBRARIES,$(lib)))
IMG_DEPS_LIBRARIES_TARGETS += $(foreach lib,$(IMG_JAVA_CLASSES_HEADER_DEPS), \
                $(call intermediates_path_for_java_lib,obj,JAVA_LIBRARIES,$(lib),classes-header.jar))

include $(CLEAR_VARS)

LOCAL_PATH := $(PRODUCT_OUT)

$(PRODUCT_OUT)/img-deps:
	@echo 'added' > $(PRODUCT_OUT)/img-deps

LOCAL_MODULE := img-deps
LOCAL_SRC_FILES := img-deps
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_ADDITIONAL_DEPENDENCIES += $(IMG_DEPS_LIBRARIES_TARGETS)

include $(BUILD_PREBUILT)
