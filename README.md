


You need nvcc installed to compile.

You need gcc 13 to compile: 

On fedora systems : 
```sh
sudo dnf install gcc13 gcc13-c++
```

## Fedora 

You need to install Nvidia drivers FROM RPM FUSION, do not install it from Nvidia website: 
https://rpmfusion.org/Howto/NVIDIA

You need to install CUDA FROM RPM FUSION: 
https://rpmfusion.org/Howto/CUDA


You may need to run this afterwards : 
```sh
sudo akmods --force
```

You may want to add the CUDAS binaries to your path to use NVCC: 
/usr/local/cuda/bin/


### DEBUG 
```sh
sudo dmesg | grep nvidia
```


