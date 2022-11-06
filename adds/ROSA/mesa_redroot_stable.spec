# (cg) Cheater...
%define Werror_cflags %{nil}
# use separate, newer LLVM, to avoid updating system one
%define llvm_ver 15
%global optflags %{optflags} -L/opt/llvm%{llvm_ver}/lib -I/opt/llvm%{llvm_ver}/include

# (aco) Needed for the dri drivers
%define _disable_ld_no_undefined 1

# Example: symlink libXvMCr600.so -> libXvMCr600.so.1.0.0 and the file
# libXvMCr600.so.1.0.0 are in the same package lib(64)dri-drivers-radeon,
# plus files in /usr/lib64/{dri,gallium-pipe,<...>}/ must not be processed,
# avoid pulling devel() dependencies
%global __develgen_exclude_path ^%{_libdir}/((libXvMCr600|libXvMCnouveau|libvulkan_radeon|libvulkan_intel|libvulkan_lvp|libintel_noop_drm_shim).so$|.*/.*)

# (tpg) starting version 11.1.1 this may fully support OGL 4.1
%define opengl_ver 4.5
# change me if you want release-candidate
%define relc %{nil}

%bcond_with gcc
# undefined reference to getPollyPluginInfo()'
# bug of llvm or mesa
%bcond_with opencl

%{?build_selinux}%{?!build_selinux:%bcond_with selinux}
%bcond_with bootstrap
%bcond_without vdpau
%bcond_without va
%bcond_without glvnd
%bcond_without egl
%ifarch %{ix86} %{x86_64}
%bcond_without intel
%else
%bcond_with intel
%endif
# Sometimes it's necessary to disable r600 while bootstrapping
# an LLVM change (such as the r600 -> AMDGPU rename)
%bcond_without r600

%if "%{relc}" != ""
%define vsuffix -rc%{relc}
%else
%define vsuffix %{nil}
%endif

%define osmesamajor 8
%define libosmesa %mklibname osmesa %{osmesamajor}
%define devosmesa %mklibname osmesa -d

%define eglmajor 0
%define eglname EGL_mesa
%define libegl %mklibname %{eglname} %{eglmajor}
%define devegl %mklibname %{eglname} -d

%define glmajor 0
%define glname GLX_mesa
%define libgl %mklibname %{glname} %{glmajor}
%define devgl %mklibname GL -d

%define devvulkan %mklibname vulkan-intel -d

%define glesv1major 1
%define glesv1name GLESv1_CM
%define libglesv1 %mklibname %{glesv1name} %{glesv1major}
%define devglesv1 %mklibname %{glesv1name} -d

%define glesv2major 2
%define glesv2name GLESv2
%define libglesv2 %mklibname %{glesv2name}_ %{glesv2major}
%define devglesv2 %mklibname %{glesv2name} -d

%define devglesv3 %mklibname glesv3 -d

%define d3dmajor 1
%define d3dname d3dadapter9
%define libd3d %mklibname %{d3dname} %{d3dmajor}
%define devd3d %mklibname %{d3dname} -d

%define glapimajor 0
%define glapiname glapi
%define libglapi %mklibname %{glapiname} %{glapimajor}
%define devglapi %mklibname %{glapiname} -d

%define dridrivers %mklibname dri-drivers
%define vdpaudrivers %mklibname vdpau-drivers

%define gbmmajor 1
%define gbmname gbm
%define libgbm %mklibname %{gbmname} %{gbmmajor}
%define devgbm %mklibname %{gbmname} -d

%define xatrackermajor 2
%define xatrackername xatracker
%define libxatracker %mklibname %xatrackername %{xatrackermajor}
%define devxatracker %mklibname %xatrackername -d

%define swravxmajor 0
%define swravxname swravx
%define libswravx %mklibname %swravxname %{swravxmajor}

%define swravx2major 0
%define swravx2name swravx2
%define libswravx2 %mklibname %swravx2name %{swravx2major}

%define clmajor 1
%define clname mesaopencl
%define libcl %mklibname %clname %clmajor
%define devcl %mklibname %clname -d

%define mesasrcdir %{_prefix}/src/Mesa/
%define driver_dir %{_libdir}/dri

%define short_ver %(if [ `echo %{version} |cut -d. -f3` = "0" ]; then echo %{version} |cut -d. -f1-2; else echo %{version}; fi)

Summary:	OpenGL %{opengl_ver} compatible 3D graphics library
Name:		mesa
Version:	22.2.2
Release:	1
Group:		System/Libraries
License:	MIT
Url:		http://www.mesa3d.org
Source0:	https://mesa.freedesktop.org/archive/mesa-%{version}%{vsuffix}.tar.xz
Source3:	make-git-snapshot.sh
Source5:	mesa-driver-install
Source100:	%{name}.rpmlintrc

%define dricoremajor 1
%define dricorename dricore
%define devdricore %mklibname %{dricorename} -d
%define libdricore %mklibname %{dricorename} 9

Obsoletes:	%{libdricore} < %{EVRD}
Obsoletes:	%{devdricore} < %{EVRD}
Obsoletes:	%{name}-xorg-drivers < %{EVRD}
Obsoletes:	%{name}-xorg-drivers-radeon < %{EVRD}
Obsoletes:	%{name}-xorg-drivers-nouveau < %{EVRD}

Patch1:		mesa-19.2.3-arm32-buildfix.patch
Patch2:		baikal-vdu.patch
BuildRequires:	flex
BuildRequires:	bison
BuildRequires:	gccmakedep
BuildRequires:	python3-libxml2
BuildRequires:	makedepend
BuildRequires:	meson
BuildRequires:	lm_sensors-devel
BuildRequires:	llvm%{llvm_ver}
BuildRequires:	pkgconfig(expat)
BuildRequires:	elfutils-devel
%if %{with selinux}
BuildRequires:	pkgconfig(libselinux)
%endif
%ifarch %{ix86}
BuildRequires:	libatomic-devel
%endif
BuildRequires:	python3-mako
BuildRequires:	pkgconfig(libdrm) >= 2.4.56
BuildRequires:	pkgconfig(libudev) >= 186
%if %{with glvnd}
BuildRequires:	pkgconfig(libglvnd)
%endif
%ifnarch %{armx} %{riscv} %{e2k}
# needed only for intel binaries
BuildRequires:	pkgconfig(epoxy)
BuildRequires:	pkgconfig(gtk+-3.0)
%endif
BuildRequires:	pkgconfig(libzstd)
BuildRequires:	pkgconfig(vulkan)
BuildRequires:	pkgconfig(x11) >= 1.3.3
BuildRequires:	pkgconfig(xdamage) >= 1.1.1
BuildRequires:	pkgconfig(xext) >= 1.1.1
BuildRequires:	pkgconfig(xfixes) >= 4.0.3
BuildRequires:	pkgconfig(xi) >= 1.3
BuildRequires:	pkgconfig(xmu) >= 1.0.3
BuildRequires:	pkgconfig(xproto)
BuildRequires:	pkgconfig(xt) >= 1.0.5
BuildRequires:	pkgconfig(xxf86vm) >= 1.1.0
BuildRequires:	pkgconfig(xshmfence) >= 1.1
BuildRequires:	pkgconfig(xrandr)
BuildRequires:	pkgconfig(xcb-dri3)
BuildRequires:	pkgconfig(xcb-present)
BuildRequires:	pkgconfig(xv)
BuildRequires:	pkgconfig(xvmc)
#BuildRequires:	pkgconfig(valgrind)
# for libsupc++.a
BuildRequires:	stdc++-static-devel
# (tpg) with openssl a steam crashes
# Program received signal SIGSEGV, Segmentation fault.
# 0xf63db8d5 in OPENSSL_ia32_cpuid () from /lib/libcrypto.so.1.0.0
# crypto is needed for shader cache which uses the SHA-1
# (tpg) strting from 2019-04-15 and openssl-1.1.1b-5 this is fixed
BuildRequires:	pkgconfig(libssl)
%if %{with opencl}
BuildRequires:	pkgconfig(libclc)
%endif
BuildRequires:	pkgconfig(xvmc)

%if %{with vdpau}
BuildRequires:	pkgconfig(vdpau)
%endif

%if %{with va}
BuildRequires:	pkgconfig(libva) >= 0.31.0
%endif
BuildRequires:	pkgconfig(wayland-egl)
BuildRequires:	pkgconfig(wayland-client)
BuildRequires:	pkgconfig(wayland-server)
BuildRequires:	pkgconfig(wayland-protocols)
BuildRequires:	pkgconfig(wayland-scanner)
BuildRequires:	glslang
BuildRequires:	patchelf

# package mesa
Requires:	libGL.so.1%{_arch_tag_suffix}
# be a meta-package too, but with arch-independent name (without lib64 prefix)
Recommends:	%{dridrivers}%{_isa} = %{EVRD}

%description
Mesa is an OpenGL %{opengl_ver} compatible 3D graphics library.

%files
%doc docs/README.*
%{_datadir}/drirc.d

%package -n %{dridrivers}
Summary:	Mesa DRI drivers
Group:		System/Libraries
Requires:	%{dridrivers}-swrast = %{EVRD}
Requires:	%{dridrivers}-vmwgfx = %{EVRD}
%ifnarch %{riscv}
Requires:	%{dridrivers}-virtio = %{EVRD}
%endif
%if %{with r600}
Requires:	%{dridrivers}-radeon = %{EVRD}
%endif
%ifarch %{ix86} %{x86_64}
Requires:	%{dridrivers}-intel = %{EVRD}
%endif
Requires:	%{dridrivers}-nouveau = %{EVRD}
%ifarch %{armx}
Requires:	%{dridrivers}-vc4 = %{EVRD}
Requires:	%{dridrivers}-v3d = %{EVRD}
Requires:	%{dridrivers}-etnaviv = %{EVRD}
Requires:	%{dridrivers}-freedreno = %{EVRD}
Requires:	%{dridrivers}-baikal = %{EVRD}
Requires:	%{dridrivers}-tegra = %{EVRD}
Requires:	%{dridrivers}-lima = %{EVRD}
Requires:	%{dridrivers}-panfrost = %{EVRD}
Requires:	%{dridrivers}-kmsro = %{EVRD}
%endif
Provides:	dri-drivers = %{EVRD}
Provides:	mesa-dri-drivers = %{EVRD}
Obsoletes:	%{_lib}XvMCgallium1 < %{EVRD}

%description -n %{dridrivers}
DRI and XvMC drivers.

%files -n %{dridrivers}

#----------------------------------------------------------------------------

%package -n %{dridrivers}-radeon
Summary:	DRI Drivers for AMD/ATI Radeon graphics chipsets
Group:		System/Libraries

%description -n %{dridrivers}-radeon
DRI and XvMC drivers for AMD/ATI Radeon graphics chipsets

%files -n %{dridrivers}-radeon
%{_bindir}/mesa-overlay-control.py
%{_libdir}/libXvMCgallium.so.1
%{_libdir}/libVkLayer_MESA_device_select.so
%{_libdir}/libVkLayer_MESA_overlay.so
%{_datadir}/vulkan/implicit_layer.d/*.json
%{_datadir}/vulkan/explicit_layer.d/*.json
%ifarch %{x86_64} %{ix86}
%{_libdir}/libvulkan_virtio.so
%{_datadir}/vulkan/icd.d/virtio_icd.*.json
%endif
%ifarch %{ix86} %{x86_64}
%{_libdir}/dri/r?00_dri.so
%{_libdir}/libXvMCr?00.so
%{_libdir}/libXvMCr?00.so.1*
%{_libdir}/dri/radeonsi_dri.so
%{_libdir}/libvulkan_radeon.so
%{_datadir}/vulkan/icd.d/radeon_icd.*.json
%if %{with opencl}
%{_libdir}/gallium-pipe/pipe_r?00.so
%endif
%if %{with r600}
%if %{with va}
%{_libdir}/dri/r600_drv_video.so
%endif
%if %{with va}
%{_libdir}/dri/radeonsi_drv_video.so
%endif
%if %{with opencl}
%{_libdir}/gallium-pipe/pipe_radeonsi.so
%endif
%endif
%endif

#----------------------------------------------------------------------------

%package -n %{dridrivers}-vmwgfx
Summary:	DRI Drivers for VMWare guest OS
Group:		System/Libraries

%description -n %{dridrivers}-vmwgfx
DRI and XvMC drivers for VMWare guest Operating Systems.

%files -n %{dridrivers}-vmwgfx
%ifarch %{ix86} %{x86_64} aarch64
%{_libdir}/dri/vmwgfx_dri.so
%if %{with opencl}
%{_libdir}/gallium-pipe/pipe_vmwgfx.so
%endif
%endif
#----------------------------------------------------------------------------

%ifarch %{ix86} %{x86_64}
%package -n %{dridrivers}-intel
Summary:	DRI Drivers for Intel graphics chipsets
Group:		System/Libraries
Suggests:	libvdpau-va-gl

%description -n %{dridrivers}-intel
DRI and XvMC drivers for Intel graphics chipsets

%files -n %{dridrivers}-intel
%{_libdir}/dri/i9?5_dri.so
%{_libdir}/dri/iris_dri.so
%{_libdir}/libvulkan_intel.so
%{_datadir}/vulkan/icd.d/intel_icd.*.json
# Crocus is for gen4-gen7
%{_libdir}/dri/crocus_dri.so
%{_libdir}/gallium-pipe/pipe_crocus.so
%{_libdir}/gallium-pipe/pipe_i915.so
%endif
#----------------------------------------------------------------------------

%ifnarch aarch64
%package -n %{dridrivers}-iris
Summary:	More modern DRI Drivers for Intel graphics chips
Group:		System/Libraries

%description -n %{dridrivers}-iris
A modern driver for Intel Gen 8+ graphics chipsets.

This driver supports GPUs also supported by %{dridrivers}-intel.
The -intel driver is (for now) more stable.

%files -n %{dridrivers}-iris
%{_libdir}/dri/iris_dri.so
%{_libdir}/gallium-pipe/pipe_iris.so
%endif

#----------------------------------------------------------------------------

%package -n %{dridrivers}-nouveau
Summary:	DRI Drivers for NVIDIA graphics chipsets using the Nouveau driver
Group:		System/Libraries

%description -n %{dridrivers}-nouveau
DRI and XvMC drivers for Nvidia graphics chipsets

%files -n %{dridrivers}-nouveau
%{_libdir}/dri/nouveau*_dri.so
%{_libdir}/libXvMCnouveau.so
%{_libdir}/libXvMCnouveau.so.1*
%if %{with va}
%{_libdir}/dri/nouveau_drv_video.so
%endif
%if %{with opencl}
%{_libdir}/gallium-pipe/pipe_nouveau.so
%endif
#----------------------------------------------------------------------------

%package -n %{dridrivers}-swrast
Summary:	DRI Drivers for software rendering
Group:		System/Libraries
Obsoletes:	%{libswravx} < %{EVRD}
Obsoletes:	%{libswravx2} < %{EVRD}

%description -n %{dridrivers}-swrast
Generic DRI driver using CPU rendering

%files -n %{dridrivers}-swrast
%{_libdir}/dri/swrast_dri.so
%{_libdir}/dri/kms_swrast_dri.so
%{_libdir}/libvulkan_lvp.so
%if %{with opencl}
%{_libdir}/gallium-pipe/pipe_swrast.so
%endif
#----------------------------------------------------------------------------

%package -n %{dridrivers}-swrast-json
Summary:	DRI Drivers for software rendering
Group:		System/Libraries

%description -n %{dridrivers}-swrast-json
Generic DRI driver using CPU rendering

%files -n %{dridrivers}-swrast-json
%{_datadir}/vulkan/icd.d/lvp_icd.*.json
#----------------------------------------------------------------------------

%package -n %{dridrivers}-virtio
Summary:	DRI Drivers for virtual environments
Group:		System/Libraries

%description -n %{dridrivers}-virtio
Generic DRI driver for virtual environments.

%ifnarch %{riscv}
%files -n %{dridrivers}-virtio
%{_libdir}/dri/virtio_gpu_dri.so
%endif
#----------------------------------------------------------------------------

%package -n %{dridrivers}-freedreno
Summary:	DRI Drivers for Adreno graphics chipsets
Group:		System/Libraries

%description -n %{dridrivers}-freedreno
DRI and XvMC drivers for Adreno graphics chipsets

%files -n %{dridrivers}-freedreno
%ifarch aarch64
%{_libdir}/dri/kgsl_dri.so
%{_libdir}/dri/msm_dri.so
%if %{with opencl}
%{_libdir}/gallium-pipe/pipe_msm.so
%endif
%endif

#----------------------------------------------------------------------------
%ifarch aarch64
%package -n %{dridrivers}-vc4
Summary:	DRI Drivers for Broadcom VC4 graphics chipsets
Group:		System/Libraries

%description -n %{dridrivers}-vc4
DRI and XvMC drivers for Broadcom VC4 graphics chips

%files -n %{dridrivers}-vc4
%{_libdir}/dri/vc4_dri.so

#----------------------------------------------------------------------------

%package -n %{dridrivers}-v3d
Summary:	DRI Drivers for Broadcom VC5 graphics chipsets
Group:		System/Libraries

%description -n %{dridrivers}-v3d
DRI and XvMC drivers for Broadcom VC5 graphics chips

%files -n %{dridrivers}-v3d
%{_libdir}/dri/v3d_dri.so
%ifarch %{ix86} %{x86_64}
%{_libdir}/libv3d_noop_drm_shim.so
%endif
#----------------------------------------------------------------------------

%package -n %{dridrivers}-etnaviv
Summary:	DRI Drivers for Vivante graphics chipsets
Group:		System/Libraries

%description -n %{dridrivers}-etnaviv
DRI and XvMC drivers for Vivante graphics chips

%files -n %{dridrivers}-etnaviv
%{_libdir}/dri/etnaviv_dri.so
%ifarch %{ix86} %{x86_64}
%{_libdir}/libetnaviv_noop_drm_shim.so
%endif

#----------------------------------------------------------------------------

%package -n %{dridrivers}-baikal
Summary:	DRI Drivers for Baikal-M graphics chipsets
Group:		System/Libraries

%description -n %{dridrivers}-baikal
DRI and XvMC drivers for Baikal graphics chips

%files -n %{dridrivers}-baikal
%{_libdir}/dri/baikal-vdu_dri.so

#----------------------------------------------------------------------------

%package -n %{dridrivers}-tegra
Summary:	DRI Drivers for Tegra graphics chipsets
Group:		System/Libraries

%description -n %{dridrivers}-tegra
DRI and XvMC drivers for Tegra graphics chips

%files -n %{dridrivers}-tegra
%{_libdir}/dri/tegra_dri.so
#----------------------------------------------------------------------------

%package -n %{dridrivers}-lima
Summary:	DRI Drivers for Mali Utgard devices
Group:		System/Libraries

%description -n %{dridrivers}-lima
DRI drivers for Mali Utgard devices

%files -n %{dridrivers}-lima
%ifarch %{ix86} %{x86_64}
%{_bindir}/lima_compiler
%{_bindir}/lima_disasm
%{_libdir}/liblima_noop_drm_shim.so
%endif
%{_libdir}/dri/lima_dri.so
#----------------------------------------------------------------------------

%package -n %{dridrivers}-panfrost
Summary:	DRI Drivers for Mali Midgard and Bifrost devices
Group:		System/Libraries

%description -n %{dridrivers}-panfrost
DRI drivers for Mali Midgard and Bifrost devices

%files -n %{dridrivers}-panfrost
%ifarch %{ix86} %{x86_64}
%{_libdir}/libpanfrost_noop_drm_shim.so
%endif
%{_libdir}/dri/panfrost_dri.so

#----------------------------------------------------------------------------


%package -n %{dridrivers}-kmsro
Summary:	DRI Drivers for KMS-only devices
Group:		System/Libraries
%rename %{dridrivers}-pl111
%rename %{dridrivers}-imx

%description -n %{dridrivers}-kmsro
DRI and XvMC drivers for KMS renderonly layer devices

%files -n %{dridrivers}-kmsro
%{_libdir}/dri/armada-drm_dri.so
%{_libdir}/dri/exynos_dri.so
%{_libdir}/dri/hx8357d_dri.so
%{_libdir}/dri/ili9???_dri.so
%{_libdir}/dri/imx-drm_dri.so
%{_libdir}/dri/imx-dcss_dri.so
%{_libdir}/dri/ingenic-drm_dri.so
%{_libdir}/dri/mali-dp_dri.so
%{_libdir}/dri/mcde_dri.so
%ifarch aarch64
%{_libdir}/dri/imx-lcdif_dri.so
%{_libdir}/dri/kirin_dri.so
%{_libdir}/dri/mediatek_dri.so
%{_libdir}/dri/komeda_dri.so
%{_libdir}/dri/rcar-du_dri.so
%endif
%{_libdir}/dri/meson_dri.so
%{_libdir}/dri/mi0283qt_dri.so
%{_libdir}/dri/mxsfb-drm_dri.so
%{_libdir}/dri/pl111_dri.so
%{_libdir}/dri/repaper_dri.so
%{_libdir}/dri/rockchip_dri.so
%{_libdir}/dri/st7586_dri.so
%{_libdir}/dri/st7735r_dri.so
%{_libdir}/dri/stm_dri.so
%{_libdir}/dri/sun4i-drm_dri.so
%if %{with opencl}
%{_libdir}/gallium-pipe/pipe_kmsro.so
%endif
%endif
# end of armx
#----------------------------------------------------------------------------

%package -n %{libosmesa}
Summary:	Mesa offscreen rendering library
Group:		System/Libraries

%description -n %{libosmesa}
Mesa offscreen rendering libraries for rendering OpenGL into
application-allocated blocks of memory.

%files -n %{libosmesa}
%{_libdir}/libOSMesa.so.%{osmesamajor}*
#----------------------------------------------------------------------------

%package -n %{devosmesa}
Summary:	Development files for libosmesa
Group:		Development/C
Requires:	%{libosmesa} = %{EVRD}

%description -n %{devosmesa}
This package contains the headers needed to compile programs against
the Mesa offscreen rendering library.

%files -n %{devosmesa}
%{_includedir}/GL/osmesa.h
%{_libdir}/libOSMesa.so
%{_libdir}/pkgconfig/osmesa.pc
#----------------------------------------------------------------------------

%package -n %{libgl}
Summary:	Files for Mesa (GL and GLX libs)
Group:		System/Libraries
Suggests:	%{dridrivers} >= %{EVRD}
Obsoletes:	%{_lib}mesagl1 < %{EVRD}
Requires:	%{_lib}udev1
Requires:	%{_lib}GL1%{?_isa}
Provides:	mesa-libGL%{?_isa} = %{EVRD}
Requires:	%mklibname GL 1
%if %{with glvnd}
Requires:	libglvnd-GL
%endif
%define oldglname %mklibname gl 1
%rename %oldglname

%description -n %{libgl}
Mesa is an OpenGL %{opengl_ver} compatible 3D graphics library.
GL and GLX parts.

%files -n %{libgl}
%if %{with glvnd}
%{_datadir}/glvnd/egl_vendor.d/50_mesa.json
%{_libdir}/libGLX_mesa.so.0*
%endif
%dir %{_libdir}/dri
%if %{with opencl}
%dir %{_libdir}/gallium-pipe
%endif
#----------------------------------------------------------------------------

%package -n %{devgl}
Summary:	Development files for Mesa (OpenGL compatible 3D lib)
Group:		Development/C
%ifarch armv7hl
# This will allow to install proprietary libGL library for ie. imx
Requires:	libGL.so.1%{_arch_tag_suffix}
# This is to prevent older version of being installed to satisfy dependency
Conflicts:	%{libgl} < %{EVRD}
%else
Requires:	%{libgl} = %{EVRD}
%endif
%if %{with glvnd}
Requires:	pkgconfig(libglvnd)
%endif
# GL/glext.h uses KHR/khrplatform.h
Requires:	%{devegl}  = %{EVRD}
%define oldlibgl %mklibname gl -d
%rename %oldlibgl

%description -n %{devgl}
This package contains the headers needed to compile Mesa programs.

%files -n %{devgl}
%if ! %{with glvnd}
%dir %{_includedir}/GL
%{_includedir}/GL/gl.h
%{_includedir}/GL/glcorearb.h
%{_includedir}/GL/glext.h
%{_includedir}/GL/glx.h
%{_includedir}/GL/glxext.h
%{_libdir}/pkgconfig/gl.pc
%endif
%if %{with glvnd}
%{_libdir}/libGLX_mesa.so
%endif
%{_libdir}/pkgconfig/dri.pc

#FIXME: check those headers
%dir %{_includedir}/GL/internal
%{_includedir}/GL/internal/dri_interface.h
#----------------------------------------------------------------------------

%package -n %{devvulkan}
Summary:	Development files for the Intel Vulkan driver
Group:		Development/C
Requires:	pkgconfig(vulkan)
Provides:	vulkan-intel-devel = %{EVRD}

%description -n %{devvulkan}
This package contains the headers needed to compile applications
that use Intel Vulkan driver extras

%ifarch %{ix86} %{x86_64}
%files -n %{devvulkan}
%endif
#----------------------------------------------------------------------------

%if %{with egl}
%package -n %{libegl}
Summary:	Files for Mesa (EGL libs)
Group:		System/Libraries
Provides:	mesa-libEGL%{?_isa} = %{EVRD}
%if %{with glvnd}
Requires:	libglvnd-egl
%endif
%define oldegl %mklibname egl 1
%rename %oldegl

%description -n %{libegl}
Mesa is an OpenGL %{opengl_ver} compatible 3D graphics library.
EGL parts.

%files -n %{libegl}
%{_libdir}/libEGL_mesa.so.%{eglmajor}*
#----------------------------------------------------------------------------

%package -n %{devegl}
Summary:	Development files for Mesa (EGL libs)
Group:		Development/C
Provides:	egl-devel = %{EVRD}
Requires:	%{libegl} = %{EVRD}
Obsoletes:	%{_lib}egl1-devel < %{EVRD}
%define olddevegl %mklibname egl -d
%rename %olddevegl

%description -n %{devegl}
Mesa is an OpenGL %{opengl_ver} compatible 3D graphics library.
EGL development parts.

%files -n %{devegl}
%if ! %{with glvnd}
%{_includedir}/EGL
%{_includedir}/KHR
%{_libdir}/pkgconfig/egl.pc
%else
%{_includedir}/EGL/eglextchromium.h
%{_includedir}/EGL/eglmesaext.h
%endif
%{_libdir}/libEGL_mesa.so
%endif
#----------------------------------------------------------------------------

%package -n %{libglapi}
Summary:	Files for mesa (glapi libs)
Group:		System/Libraries

%description -n %{libglapi}
This package provides the glapi shared library used by gallium.

%files -n %{libglapi}
%{_libdir}/libglapi.so.%{glapimajor}*
#----------------------------------------------------------------------------

%package -n %{devglapi}
Summary:	Development files for glapi libs
Group:		Development/C
Requires:	%{libglapi} = %{EVRD}
Obsoletes:	%{_lib}glapi0-devel < %{EVRD}

%description -n %{devglapi}
This package contains the headers needed to compile programs against
the glapi shared library.

%files -n %{devglapi}
%{_libdir}/libglapi.so
#----------------------------------------------------------------------------

%if ! %{with bootstrap}
%package -n %{libxatracker}
Summary:	Files for mesa (xatracker libs)
Group:		System/Libraries

%description -n %{libxatracker}
This package provides the xatracker shared library used by gallium.

%files -n %{libxatracker}
%{_libdir}/libxatracker.so.%{xatrackermajor}*
#----------------------------------------------------------------------------

%package -n %{devxatracker}
Summary:	Development files for xatracker libs
Group:		Development/C
Requires:	%{libxatracker} = %{EVRD}

%description -n %{devxatracker}
This package contains the headers needed to compile programs against
the xatracker shared library.

%files -n %{devxatracker}
%{_libdir}/libxatracker.so
%{_includedir}/xa_*.h
%{_libdir}/pkgconfig/xatracker.pc
%endif
#----------------------------------------------------------------------------

%package -n %{libswravx}
Summary:	AVX Software rendering library for Mesa
Group:		System/Libraries

%description -n %{libswravx}
AVX Software rendering library for Mesa
#----------------------------------------------------------------------------

%package -n %{libswravx2}
Summary:	AVX2 Software rendering library for Mesa
Group:		System/Libraries

%description -n %{libswravx2}
AVX2 Software rendering library for Mesa
#----------------------------------------------------------------------------

%package -n %{libglesv1}
Summary:	Files for Mesa (glesv1 libs)
Group:		System/Libraries

%description -n %{libglesv1}
OpenGL ES is a low-level, lightweight API for advanced embedded graphics using
well-defined subset profiles of OpenGL.

This package provides the OpenGL ES library version 1.

%if ! %{with glvnd}
%files -n %{libglesv1}
%optional %{_libdir}/libGLESv1_CM.so.%{glesv1major}*
%endif
#----------------------------------------------------------------------------

%package -n %{devglesv1}
Summary:	Development files for glesv1 libs
Group:		Development/C
Requires:	%{libglesv1}
%if %{with glvnd}
Requires:	libglvnd-GLESv1_CM
# For libGLESv1_CM.so symlink
Requires:	pkgconfig(libglvnd)
%endif
Obsoletes:	%{_lib}glesv1_1-devel < %{EVRD}

%description -n %{devglesv1}
This package contains the headers needed to compile OpenGL ES 1 programs.

%if ! %{with glvnd}
%files -n %{devglesv1}
%{_includedir}/GLES
%{_libdir}/pkgconfig/glesv1_cm.pc
%endif
#----------------------------------------------------------------------------

%package -n %{libglesv2}
Summary:	Files for Mesa (glesv2 libs)
Group:		System/Libraries
%if %{with glvnd}
# For libGLESv2.so symlink
Requires:	pkgconfig(libglvnd)
%endif

%description -n %{libglesv2}
OpenGL ES is a low-level, lightweight API for advanced embedded graphics using
well-defined subset profiles of OpenGL.
This package provides the OpenGL ES library version 2.

%if ! %{with glvnd}
%files -n %{libglesv2}
%optional %{_libdir}/libGLESv2.so.%{glesv2major}*
%endif
#----------------------------------------------------------------------------

%package -n %{devglesv2}
Summary:	Development files for glesv2 libs
Group:		Development/C
Requires:	%{libglesv2}
%if %{with glvnd}
Requires:	libglvnd-GLESv2
%endif
Obsoletes:	%{_lib}glesv2_2-devel < %{EVRD}

%description -n %{devglesv2}
This package contains the headers needed to compile OpenGL ES 2 programs.

%if ! %{with glvnd}
%files -n %{devglesv2}
%{_includedir}/GLES2
%{_libdir}/pkgconfig/glesv2.pc
%endif
#----------------------------------------------------------------------------

%package -n %{devglesv3}
Summary:	Development files for glesv3 libs
Group:		Development/C
# there is no pkgconfig
Provides:	glesv3-devel = %{EVRD}

%description -n %{devglesv3}
This package contains the headers needed to compile OpenGL ES 3 programs.

%if ! %{with glvnd}
%files -n %{devglesv3}
%{_includedir}/GLES3
%endif
#----------------------------------------------------------------------------

%package -n %{libd3d}
Summary:	Mesa Gallium Direct3D 9 state tracker
Group:		System/Libraries

%description -n %{libd3d}
OpenGL ES is a low-level, lightweight API for advanced embedded graphics using
well-defined subset profiles of OpenGL.

This package provides Direct3D 9 support.

%files -n %{libd3d}
%dir %{_libdir}/d3d
%{_libdir}/d3d/d3dadapter9.so.%{d3dmajor}*
#----------------------------------------------------------------------------

%package -n %{devd3d}
Summary:	Development files for Direct3D 9 libs
Group:		Development/C
Requires:	%{libd3d} = %{EVRD}
Provides:	d3d-devel = %{EVRD}

%description -n %{devd3d}
This package contains the headers needed to compile Direct3D 9 programs.

%files -n %{devd3d}
%{_includedir}/d3dadapter
%{_libdir}/d3d/d3dadapter9.so
%{_libdir}/pkgconfig/d3d.pc
#----------------------------------------------------------------------------

%if %{with opencl}
%package -n %{libcl}
Summary:	Mesa OpenCL libs
Group:		System/Libraries
Provides:	mesa-libOpenCL = %{EVRD}
Provides:	mesa-opencl = %{EVRD}

%description -n %{libcl}
Open Computing Language (OpenCL) is a framework for writing programs that
execute across heterogeneous platforms consisting of central processing units
(CPUs), graphics processing units (GPUs), DSPs and other processors.

OpenCL includes a language (based on C99) for writing kernels (functions that
execute on OpenCL devices), plus application programming interfaces (APIs) that
are used to define and then control the platforms. OpenCL provides parallel
computing using task-based and data-based parallelism. OpenCL is an open
standard maintained by the non-profit technology consortium Khronos Group.
It has been adopted by Intel, Advanced Micro Devices, Nvidia, and ARM Holdings.

%files -n %{libcl}
%{_sysconfdir}/OpenCL
%{_libdir}/libMesaOpenCL.so.%{clmajor}*
#----------------------------------------------------------------------------

%package -n %{devcl}
Summary:	Development files for OpenCL libs
Group:		Development/Other
Requires:	%{libcl} = %{EVRD}
Provides:	%{clname}-devel = %{EVRD}
Provides:	mesa-libOpenCL-devel = %{EVRD}
Provides:	mesa-opencl-devel = %{EVRD}

%description -n %{devcl}
Development files for the OpenCL library

%files -n %{devcl}
%{_includedir}/CL
%{_libdir}/libMesaOpenCL.so
%endif
#----------------------------------------------------------------------------

%if %{with vdpau}
%package -n %{vdpaudrivers}
Summary:	Mesa VDPAU drivers
Group:		System/Libraries
Requires:	%{dridrivers} = %{EVRD}
%ifnarch %{armx} %{riscv}
Requires:	%{_lib}vdpau-driver-nouveau
Requires:	%{_lib}vdpau-driver-r300
Requires:	%{_lib}vdpau-driver-radeonsi
%if %{with r600}
Requires:	%{_lib}vdpau-driver-r600
%endif
%endif
Requires:	%{_lib}vdpau-driver-softpipe
Provides:	vdpau-drivers = %{EVRD}

%description -n %{vdpaudrivers}
VDPAU drivers.

%files -n %{vdpaudrivers}
#----------------------------------------------------------------------------

%package -n %{_lib}vdpau-driver-nouveau
Summary:	VDPAU plugin for nouveau driver
Group:		System/Libraries
Requires:	%{_lib}vdpau1

%description -n %{_lib}vdpau-driver-nouveau
This packages provides a VPDAU plugin to enable video acceleration
with the nouveau driver.

%files -n %{_lib}vdpau-driver-nouveau
%{_libdir}/vdpau/libvdpau_nouveau.so.*
#----------------------------------------------------------------------------

%package -n %{_lib}vdpau-driver-softpipe
Summary:	VDPAU plugin for softpipe driver
Group:		System/Libraries
Requires:	%{_lib}vdpau1

%description -n %{_lib}vdpau-driver-softpipe
This packages provides a VPDAU plugin to enable video acceleration
with the softpipe driver.

%files -n %{_lib}vdpau-driver-softpipe
#----------------------------------------------------------------------------

%ifarch %{ix86} %{x86_64}
%package -n %{_lib}vdpau-driver-r300
Summary:	VDPAU plugin for r300 driver
Group:		System/Libraries
Requires:	%{_lib}vdpau1

%description -n %{_lib}vdpau-driver-r300
This packages provides a VPDAU plugin to enable video acceleration
with the r300 driver.

%files -n %{_lib}vdpau-driver-r300
%{_libdir}/vdpau/libvdpau_r300.so.*
#----------------------------------------------------------------------------


%if %{with r600}
%package -n %{_lib}vdpau-driver-r600
Summary:	VDPAU plugin for r600 driver
Group:		System/Libraries
Requires:	%{_lib}vdpau1

%description -n %{_lib}vdpau-driver-r600
This packages provides a VPDAU plugin to enable video acceleration
with the r600 driver.

%files -n %{_lib}vdpau-driver-r600
%{_libdir}/vdpau/libvdpau_r600.so.*
#----------------------------------------------------------------------------

%package -n %{_lib}vdpau-driver-radeonsi
Summary:	VDPAU plugin for radeonsi driver
Group:		System/Libraries
Requires:	%{_lib}vdpau1

%description -n %{_lib}vdpau-driver-radeonsi
This packages provides a VPDAU plugin to enable video acceleration
with the radeonsi driver.

%files -n %{_lib}vdpau-driver-radeonsi
%{_libdir}/vdpau/libvdpau_radeonsi.so.*
%endif
%endif
%endif
#----------------------------------------------------------------------------


%if %{with egl}
%package -n %{libgbm}
Summary:	Files for Mesa (gbm libs)
Group:		System/Libraries

%description -n %{libgbm}
Mesa is an OpenGL %{opengl_ver} compatible 3D graphics library.
GBM (Graphics Buffer Manager) parts.

%files -n %{libgbm}
%{_libdir}/libgbm.so.%{gbmmajor}*
#----------------------------------------------------------------------------

%package -n %{devgbm}
Summary:	Development files for Mesa (gbm libs)
Group:		Development/C
Requires:	%{libgbm} = %{EVRD}

%description -n %{devgbm}
Mesa is an OpenGL %{opengl_ver} compatible 3D graphics library.
GBM (Graphics Buffer Manager) development parts.

%files -n %{devgbm}
%{_includedir}/gbm.h
%{_libdir}/libgbm.so
%{_libdir}/pkgconfig/gbm.pc
%endif
#----------------------------------------------------------------------------

%package common-devel
Summary:	Meta package for mesa devel
Group:		Development/C
Requires:	pkgconfig(glu)
Requires:	pkgconfig(glut)
Requires:	%{devgl} = %{EVRD}
Requires:	%{devegl} = %{EVRD}
Requires:	%{devglapi} = %{EVRD}
%if !%{with glvnd}
Requires:	%{devglesv1} = %{EVRD}
Requires:	%{devglesv2} = %{EVRD}
%endif
Suggests:	%{devd3d} = %{EVRD}
%if %{with glvnd}
Requires:	pkgconfig(libglvnd)
Requires:	pkgconfig(glesv1_cm)
Requires:	pkgconfig(glesv2)
%endif

%description common-devel
Mesa common metapackage devel.

%files common-devel
# meta devel pkg
#----------------------------------------------------------------------------

%ifarch %{ix86} %{x86_64}
%package tools
Summary:	Tools for debugging Mesa drivers
Group:		Development/Tools

%description tools
Tools for debugging Mesa drivers.

%files tools
%{_bindir}/aubinator
%{_bindir}/aubinator_error_decode
%{_bindir}/aubinator_viewer
%{_bindir}/i965_asm
%{_bindir}/i965_disasm
%{_bindir}/intel_dump_gpu
%{_bindir}/intel_error2aub
%{_bindir}/intel_sanitize_gpu
%{_bindir}/intel_dev_info
%{_libexecdir}/libintel_dump_gpu.so
%{_libexecdir}/libintel_sanitize_gpu.so
%endif

#----------------------------------------------------------------------------

%prep
%autosetup -p1 -n mesa-%{version}%{vsuffix}
chmod +x %{SOURCE5}

# this is a hack for S3TC support. r200_screen.c is symlinked to
# radeon_screen.c in git, but is its own file in the tarball.
cp -f src/mesa/drivers/dri/{radeon,r200}/radeon_screen.c || :

%build
%if %{with gcc}
export CC=gcc
export CXX=g++
%else
export CC=/opt/llvm%{llvm_ver}/bin/clang
export CXX=/opt/llvm%{llvm_ver}/bin/clang++
# find llvm-config
export PATH="/opt/llvm%{llvm_ver}/bin:$PATH"
%endif

%meson \
	-Dmicrosoft-clc=disabled \
	-Dshared-llvm=enabled \
	-Db_ndebug=true \
	-Dc_std=c11 \
	-Dcpp_std=c++17 \
	-Dgallium-drivers=auto,r300,r600,radeonsi,nouveau,virgl,svga,swrast,iris,crocus,zink \
%if %{with opencl}
	-Dgallium-opencl=icd \
%else
	-Dgallium-opencl=disabled \
%endif
	-Dgallium-va=enabled \
	-Dgallium-vdpau=enabled \
	-Dgallium-xa=enabled \
	-Dgallium-nine=true \
	-Dglx=dri \
	-Dplatforms=wayland,x11 \
	-Degl-native-platform=wayland \
	-Dvulkan-layers=device-select,overlay \
	-Dvulkan-drivers=amd,intel,swrast,virtio-experimental \
	-Dxlib-lease=auto \
	-Dosmesa=true \
	-Dglvnd=true \
	-Ddri3=enabled \
	-Degl=enabled \
	-Dgbm=enabled \
	-Dgles1=disabled \
	-Dgles2=enabled \
	-Dglx-direct=true \
	-Dllvm=enabled \
	-Dlmsensors=enabled \
	-Dopengl=true \
	-Dshader-cache=enabled \
	-Dshared-glapi=enabled \
	-Dshared-llvm=enabled \
    -Dvideo-codecs=vc1dec,h264dec,h264enc,h265dec,h265enc \
%if %{with glvnd}
	-Dglvnd=true \
%endif
%if %{with selinux}
	-Dselinux=true \
%endif
%ifnarch %{armx} %{riscv} %{e2k}
	-Dbuild-tests=false \
	-Dtools=intel,intel-ui
%endif

%meson_build

%install
%meson_install

# remove bundled stuff
# we use libglvnd now
%if %{with glvnd}
rm -rf	%{buildroot}%{_includedir}/GL/gl.h \
	%{buildroot}%{_includedir}/GL/glcorearb.h \
	%{buildroot}%{_includedir}/GL/glext.h \
	%{buildroot}%{_includedir}/GL/glx.h \
	%{buildroot}%{_includedir}/GL/glxext.h \
	%{buildroot}%{_includedir}/EGL/eglext.h \
	%{buildroot}%{_includedir}/EGL/egl.h \
	%{buildroot}%{_includedir}/EGL/eglplatform.h \
	%{buildroot}%{_includedir}/KHR \
	%{buildroot}%{_includedir}/GLES \
	%{buildroot}%{_includedir}/GLES2 \
	%{buildroot}%{_includedir}/GLES3 \
	%{buildroot}%{_libdir}/pkgconfig/egl.pc \
	%{buildroot}%{_libdir}/pkgconfig/gl.pc
%endif

%ifarch %{x86_64}
mkdir -p %{buildroot}%{_prefix}/lib/dri
%endif

%if %{with opencl}
# FIXME workaround for OpenCL headers not being installed
if [ -e %{buildroot}%{_includedir}/CL/opencl.h ]; then
    echo OpenCL headers are being installed correctly now. Please remove the workaround.
    exit 1
else
    cp -af include/CL %{buildroot}%{_includedir}/
fi
%endif

# .so files are not needed by vdpau
rm -f %{buildroot}%{_libdir}/vdpau/libvdpau_*.so

%if %{with glvnd}
# We get those from libglvnd
rm -f %{buildroot}%{_libdir}/libGLESv1_CM.so* %{buildroot}%{_libdir}/libGLESv2.so*
%endif

# .la files are not needed by mesa
find %{buildroot} -name '*.la' |xargs rm -f

%if ! %{with glvnd}
# Used to be present in 19.0.x, and some packages rely on it
cat >%{buildroot}%{_libdir}/pkgconfig/glesv1_cm.pc <<'EOF'
Name: glesv1_cm
Description: Mesa OpenGL ES 1.1 CM library
Version:	%{version}
Libs: -lGLESv1_CM
Libs.private: -lpthread -pthread -lm -ldl
EOF
cat >%{buildroot}%{_libdir}/pkgconfig/glesv2.pc <<'EOF'
Name: glesv2
Description: Mesa OpenGL ES 2.0 library
Version:	%{version}
Libs: -lGLESv2
Libs.private: -lpthread -pthread -lm -ldl
EOF

# Used to be present in 19.1.x, and some packages rely on it
cat >%{buildroot}%{_libdir}/pkgconfig/egl.pc <<'EOF'
prefix=%{_prefix}
libdir=${prefix}/%{_libdir}
includedir=${prefix}/include
Name: egl
Description: Mesa EGL Library
Version:	%{version}
Requires.private: x11, xext, xdamage >=  1.1, xfixes, x11-xcb, xcb, xcb-glx >=  1.8.1, xcb-dri2 >=  1.8, xxf86vm, libdrm >=  2.4.75
Libs: -L${libdir} -lEGL
Libs.private: -lpthread -pthread -lm -ldl
Cflags: -I${includedir}
EOF
%endif

# use swrastg if built (Anssi 12/2011)
[ -e %{buildroot}%{_libdir}/dri/swrastg_dri.so ] && mv %{buildroot}%{_libdir}/dri/swrast{g,}_dri.so

# (tpg) remove wayland files as they are now part of wayland package
rm -rf %{buildroot}%{_libdir}/libwayland-egl.so*
rm -rf %{buildroot}%{_libdir}/pkgconfig/wayland-egl.pc

%check
# ensure custom LLVM is used
readelf -a %{buildroot}%{_libdir}/libOSMesa.so | grep -q LLVM_%{llvm_ver}
