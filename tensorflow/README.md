## Quick Background: TensorFlow

TensorFlow is an open source software library released in 2015 by Google to
make it easier for developers to design, build, and train deep learning models.
TensorFlow originated as an internal library that Google developers used to
build models in-house.

Starting in 2011, Google Brain built DistBelief as their first-generation,
proprietary, machine learning system (specillaly designed for Deep Learning, a 
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

With machine learning we need computation power and massive data processing
(data driven), this is a kind of technology where massive CPU power and massive
data I/O converge together.

## Getting started with TensorFlow and CUDA

## CUDA setting up

This steps are based on Fedora 24 host machine:

- Pre-installation actions:

lspci | grep -i nvidia
07:00.0 VGA compatible controller: NVIDIA Corporation GT218 [GeForce 210] (rev a2)

sudo dnf install kernel-devel-$(uname -r) kernel-headers-$(uname -r) -y

    wget http://developer.download.nvidia.com/compute/cuda/repos/fedora23/x86_64/cuda-repo-fedora23-8.0.44-1.x86_64.rpm
    sudo rpm -i cuda-repo-fedora23-8.0.44-1.x86_64.rpm`
    wget https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-24.noarch.rpm
    sudo rpm -ih rpmfusion-free-release-24.noarch.rpm 

    sudo dnf clean all
    sudo dnf install cuda -y

    sudo systemctl start nvidia-persistenced.service
    sudo journalctl -xe


NVRM: The NVIDIA GeForce 210 GPU installed in this system is
NVRM: supported through the NVIDIA the NVIDIA 340.xx Legacy drivers.
NVRM: The 367.48 NVIDIA driver will ignore this GPU.  

Install the 340.xx Legacy drivers (last driver with GeForce 210 support):

wget http://us.download.nvidia.com/XFree86/Linux-x86_64/340.98/NVIDIA-Linux-x86_64-340.98.run
sudo sh NVIDIA-Linux-x86_64-340.98.run
sudo systemctl start nvidia-persistenced.service
sudo systemctl status nvidia-persistenced.service

lsmod | grep nvidia
nvidia              10559488  0
drm                   344064  5 ttm,drm_kms_helper,mgag200,nvidia

ls /dev/nvidia?

# nvidia-smi -L
GPU 0: GeForce 210 (UUID: GPU-3893b8f8-f89a-e24c-24af-3ae42c2b9f39)

# nvidia-smi 
Fri Oct  7 10:10:54 2016       
+------------------------------------------------------+                       
| NVIDIA-SMI 340.98     Driver Version: 340.98         |                       
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce 210         On   | 0000:07:00.0     N/A |                  N/A |
| 35%   41C   P12    N/A /  N/A |      2MiB /  1023MiB |     N/A      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Compute processes:                                               GPU Memory |
|  GPU       PID  Process name                                     Usage      |
|=============================================================================|
|    0            Not Supported                                               |
+-----------------------------------------------------------------------------+

#if __GNUC__ > 5

//#error -- unsupported GNU version! gcc versions later than 5 are not supported!

#endif /* __GNUC__ > 5 */


export CC=gcc34
export CXX=g++34 
make


https://developer.nvidia.com/cuda-legacy-gpus
Compute Capability -> 1.2
CUDA 7+ compute capabilities 1.x are no longer supported.

We have to install CUDA 6.5, where compute_1x are supported.

https://developer.nvidia.com/cuda-toolkit-65



NEW MACHINE


dnf install kernel-devel-$(uname -r) kernel-headers-$(uname -r) -y
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/340.98/NVIDIA-Linux-x86_64-340.98.run
rmmod nouveau
sh NVIDIA-Linux-x86_64-340.98.run -s
nvidia-modprobe -c 0 

nvidia-smi 
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

wget http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.14_linux_64.run
sh cuda_6.5.14_linux_64.run -silent -samples -toolkit --override

dnf install compat-gcc-34 compat-gcc-34-c++ -y
cd /usr/local/cuda-6.5/samples/1_Utilities/deviceQuery
GCC=g++34 make
./deviceQuery 



``````
``````
## TensorFlow in Containers (Docker)

## TensorFlow in OpenShift
