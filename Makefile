export CXX_FLAGS := $(CXXFLAGS) -std=c++17 -g3 -O0 -pthread -D_GLIBCXX_USE_CXX11_ABI=0 -Wall -Wextra -Wno-unused-function -D_LIBCPP_DEBUG # -D_GLIBCXX_DEBUG
# -ftrapv

export INCPATH := $(shell python -c "import torch.utils.cpp_extension as C; print('-isystem' + str.join(' -isystem', C.include_paths()))")

export LIBPATH := $(shell python -c "import torch.utils.cpp_extension as C; print(C.include_paths()[0] + '/../')")

export USE_CUDA := $(shell python -c "import torch; print(torch.cuda.is_available())")

ifeq ($(USE_CUDA),True)
export TORCH_LIBS=-ltorch -lcaffe2 -lcaffe2_gpu -lc10 -lc10_cuda -lcuda -lnvrtc -lnvToolsExt # -lnccl -lmkldnn -lmkl_rt
else
export TORCH_LIBS=-ltorch -lcaffe2 -lc10
endif

export THXX_LOCAL_INCPATH := -I$(PWD)/include -isystem$(PWD)/third_party


.PHONY: test clean install-conda install-latest third_party

test: third_party
	$(MAKE) --directory test

example-mnist: third_party
	$(MAKE) --directory example/mnist

example-copy: third_party
	$(MAKE) --directory example/copy

clean:
	find . -name "*.o" -exec rm -v {} \;
	find . -name "*.out" -exec rm -v {} \;

third_party:
	$(MAKE) --directory third_party
