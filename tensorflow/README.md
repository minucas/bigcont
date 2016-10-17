## Quick Background: TensorFlow

TensorFlow is an open source software library released in 2015 by Google to
make it easier for developers to design, build, and train deep learning models.
TensorFlow originated as an internal library that Google developers used to
build models in-house.

Starting in 2011, Google Brain built DistBelief as their first-generation,
proprietary, Machine Learning system (specillaly designed for Deep Learning, a 
branch of Machine Learning). TensorFlow was Google Brain's second generation 
machine learning system, which was released as open source on November 9, 2015. 
While the reference implementation runs on single devices, TensorFlow can run 
on multiple CPUs and GPUs (with optional CUDA extensions).

At a high level, TensorFlow is a Python library that allows users to express
arbitrary computation as a graph of data flows.

## Why is important TensorFlow in a Big Data ecosystem?

TensorFlow is basically a software library for numerical computation. We could
include this tool in the segment of Octave, Scilab, R or Pandas. Traditionally
this kind of tools are used in Hight Performance Computing (or Grid Computing)
environments, on top or resource managers such as SGE, HTCondor or SLURM.

Nevertheless Big Data and HPC are hand by hand related, the more data we
collect, the more computational capacity we need to analyze the data.
Machine learning is well suited to the complexity of dealing with disparate
data sources and the huge variety of variables and amounts of data involved. 
The general rule of thumb in ML is that more data produces better results.

With machine learning (aka Iductive Learning) we need computation power and 
massive data processing (data driven), this is a kind of technology where 
massive CPU power and massive data I/O converge together.

## Getting started CUDA

### CUDA setting up

The following steps are carry out based on Fedora 24 and an ancient NVIDIA GPU.

The GPU used is one of the first CUDA able generations from NVIDIA. The
hardware used for this test is a NVIDIA Geforce 210.

We have to install the 340.xx Legacy drivers (last driver with GeForce 210 
support), in order to run this tests with our NVIDIA avaiable for this proof.

https://developer.nvidia.com/cuda-legacy-gpus

Installing the CUDA driver:

``````
$ lspci | grep -i nvidia
07:00.0 VGA compatible controller: NVIDIA Corporation GT218 [GeForce 210] (rev a2)

# dnf install kernel-devel-$(uname -r) kernel-headers-$(uname -r) -y
# wget http://us.download.nvidia.com/XFree86/Linux-x86_64/340.98/NVIDIA-Linux-x86_64-340.98.run
# rmmod nouveau
# sh NVIDIA-Linux-x86_64-340.98.run -s
# nvidia-modprobe -c 0 

# lsmod | grep nvidia
nvidia              10559488  0
drm                   344064  5 ttm,drm_kms_helper,mgag200,nvidia
# ls /dev/nvidia?
/dev/nvidia0

# nvidia-smi -L
GPU 0: GeForce 210 (UUID: GPU-3893b8f8-f89a-e24c-24af-3ae42c2b9f39)

# nvidia-smi 
Fri Oct  7 13:33:19 2016       
+------------------------------------------------------+                       
| NVIDIA-SMI 340.98     Driver Version: 340.98         |                       
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce 210         Off  | 0000:07:00.0     N/A |                  N/A |
| 35%   47C    P0    N/A /  N/A |      2MiB /  1023MiB |     N/A      Default |
+-------------------------------+----------------------+----------------------+
+-----------------------------------------------------------------------------+
| Compute processes:                                               GPU Memory |
|  GPU       PID  Process name                                     Usage      |
|=============================================================================|
|    0            Not Supported                                               |
+-----------------------------------------------------------------------------+

``````

We have to install a CUDA tookit with support for Geforce 210, the last CUDA
tookit with support for this hardware is the version CUDA 6.5 series. after
thsi version the support of this device was deprecated.

https://developer.nvidia.com/cuda-toolkit-65

Installing the CUDA tookit for programming with  Cuda Driver API and cuda
Runtime API:

``````
wget http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.14_linux_64.run
sh cuda_6.5.14_linux_64.run -silent -samples -toolkit --override

dnf install compat-gcc-34 compat-gcc-34-c++ -y
cd /usr/local/cuda-6.5/samples/1_Utilities/deviceQuery
GCC=g++34 make
./deviceQuery 
./deviceQuery Starting...

 CUDA Device Query (Runtime API) version (CUDART static linking)

Detected 1 CUDA Capable device(s)

Device 0: "GeForce 210"
  CUDA Driver Version / Runtime Version          6.5 / 6.5
  CUDA Capability Major/Minor version number:    1.2
  Total amount of global memory:                 1024 MBytes (1073479680 bytes)
  ( 2 ) Multiprocessors, (  8 ) CUDA Cores/MP:     16 CUDA Cores
  GPU Clock rate:                                1230 MHz (1.23 GHz)
  Memory Clock rate:                             600 Mhz
  Memory Bus Width:                              64-bit
  Maximum Texture Dimension Size (x,y,z)         1D=(8192), 2D=(65536, 32768), 3D=(2048, 2048, 2048)
  Maximum Layered 1D Texture Size, (num) layers  1D=(8192), 512 layers
  Maximum Layered 2D Texture Size, (num) layers  2D=(8192, 8192), 512 layers
  Total amount of constant memory:               65536 bytes
  Total amount of shared memory per block:       16384 bytes
  Total number of registers available per block: 16384
  Warp size:                                     32
  Maximum number of threads per multiprocessor:  1024
  Maximum number of threads per block:           512
  Max dimension size of a thread block (x,y,z): (512, 512, 64)
  Max dimension size of a grid size    (x,y,z): (65535, 65535, 1)
  Maximum memory pitch:                          2147483647 bytes
  Texture alignment:                             256 bytes
  Concurrent copy and kernel execution:          Yes with 1 copy engine(s)
  Run time limit on kernels:                     No
  Integrated GPU sharing Host Memory:            No
  Support host page-locked memory mapping:       Yes
  Alignment requirement for Surfaces:            Yes
  Device has ECC support:                        Disabled
  Device supports Unified Addressing (UVA):      No
  Device PCI Bus ID / PCI location ID:           7 / 0
  Compute Mode:
     < Default (multiple host threads can use ::cudaSetDevice() with device simultaneously) >

deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 6.5, CUDA Runtime
Version = 6.5, NumDevs = 1, Device0 = GeForce 210
``````

## Important note

The GPU-enabled version of TensorFlow has the following requirements:

- NVIDIA CUDA® 7.5 (CUDA 8.0 required for Pascal GPUs)

- NVIDIA cuDNN v4.0 (minimum) or v5.1 (recommended)

We will also need an NVIDIA GPU supporting compute capability 3.0 or higher.

Unfortunatly in this project we only have a NVDIA GPU with compute capability
1.2 and we have to use NVIDIA CUDA 6.5. In CUDA 7+ compute capabilities 1.x are 
no longer supported.

We will have to focus on TensorFlow using scalar CPUs and study the CUDA
capabilities in other project within this project. (DistributedR with CUDA
support).

## TensorFlow in Containers (Docker)

## TensorFlow in OpenShift
