# header only library : akmalloc
# -- Headers

# update the rc.h.template file when the version is bumped
set(akmalloc_major 0)
set(akmalloc_minor 0)
set(akmalloc_patch 1)

set(xprt include/akmalloc)

configure_file(${xprt}/rc.h.template
               ${CMAKE_CURRENT_SOURCE_DIR}/${xprt}/rc.h
               @ONLY
               )

set(akmalloc_impl
    ${xprt}/malloc.c
    )

# export
set(akmalloc_exp_hdr
    ${xprt}/assert.h;
    ${xprt}/atomic.h;
    ${xprt}/config.h;
    ${xprt}/constants.h;
    ${xprt}/malloc.h;
    ${xprt}/memmap.h;
    ${xprt}/threadlocal.h;
    ${xprt}/types.h;
    ${xprt}/utils.h;
    ${xprt}/rc.h;
    )

if (AKMALLOC_LIBRARY)
  set(akmalloc_all_src ${akmalloc_exp_hdr};${akmalloc_impl})
  add_lib(akmalloc SHARED ${akmalloc_all_src})
  add_lib_build_def(akmalloc include/akmalloc/exportsym.h AKMALLOC)
  link_libs(akmalloc )
  if (NOT is_msvc)
    add_comp_flag(akmalloc "-Wno-unused-function")
  endif()
  set_tgt_ver(akmalloc "${akmalloc_major}.${akmalloc_minor}.${akmalloc_patch}" "${akmalloc_major}.${akmalloc_minor}")
else()
  list(APPEND akmalloc_exp_hdr ${akmalloc_impl})
  set(akmalloc_all_src ${akmalloc_exp_hdr})
  add_custom_target(akmalloc SOURCES ${akmalloc_exp_hdr})
endif()

# -- Install!
install_hdr(${akmalloc_exp_hdr})
