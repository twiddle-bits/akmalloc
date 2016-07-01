/**
 * \file tSlab.cpp
 * \date Jul 01, 2016
 */

#include "unittest.hpp"

#include "akmalloc/malloc.h"

CPP_TEST( slab )
{
    ak_slab_root root;
    ak_slab_init_root(&root, 8);

    {// test root
        TEST_TRUE(root.bk == (ak_slab*)&root);
        TEST_TRUE(root.fd == (ak_slab*)&root);
        TEST_TRUE(root.sz == 8);
        TEST_TRUE(ak_num_slabs_per_page(8) == 16);
    }

    {// single alloc and free
        void* p = ak_slab_alloc(&root);
        TEST_TRUE(root.fd != (ak_slab*)&root);
        ak_slab_free(p);
        TEST_TRUE(root.fd == (ak_slab*)&root);
    }

    static const ak_sz nptrs = 100000;
    
    void* parr[nptrs] = { 0 };
    
    for (ak_sz i = 0; i != nptrs; ++i)
    {
        parr[i] = ak_slab_alloc(&root);
        // parr[i] = malloc(8);
    }

    for (ak_sz i = 0; i != nptrs; ++i)
    {
        ak_slab_free(parr[i]);
        // free(parr[i]);
    }
}
