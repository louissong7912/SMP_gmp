dnl  IA-64 mpn_invert_limb -- Invert a normalized limb.

dnl  Copyright (C) 2000 Free Software Foundation, Inc.

dnl  This file is part of the GNU MP Library.

dnl  The GNU MP Library is free software; you can redistribute it and/or modify
dnl  it under the terms of the GNU Lesser General Public License as published
dnl  by the Free Software Foundation; either version 2.1 of the License, or (at
dnl  your option) any later version.

dnl  The GNU MP Library is distributed in the hope that it will be useful, but
dnl  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
dnl  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
dnl  License for more details.

dnl  You should have received a copy of the GNU Lesser General Public License
dnl  along with the GNU MP Library; see the file COPYING.LIB.  If not, write to
dnl  the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
dnl  MA 02111-1307, USA.

include(`../config.m4')

C INPUT PARAMETERS
C rp = r32
C s1p = r33
C s2p = r34
C n = r35

ASM_START()
	.section	.rodata
	.align 16
.LC0:	data4 0x00000000, 0x80000000, 0x0000403f, 0x00000000	// 2^64
	data4 0x00000000, 0x80000000, 0x0000407f, 0x00000000	// 2^128

PROLOGUE(mpn_invert_limb)
	addl		r14 = @ltoff(.LC0),gp
	add		r8 = r32,r32;;			// check for d = 2^63
	ld8		r14 = [r14]
	cmp.eq		p6,p7 = 0,r8;;			// check for d = 2^63
	ldfe		f10 = [r14],16			// 2^64
        setf.sig	f12 = r32
   (p6)	br.cond.spnt.few .L1;;				// branch if d = 2^63
        ldfe		f8 = [r14]			// 2^128
	fmpy.s1		f11 = f12,f10;;			// scale by 2^64
	fsub.s1		f8 = f8,f11;;
        fma.s1		f6 = f8,f1,f0
        fma.s1		f7 = f12,f1,f0;;
        frcpa.s1	f8,p6 = f6,f7;;
   (p6) fnma.s1		f9 = f7,f8,f1
   (p6) fma.s1		f10 = f6,f8,f0;;
   (p6) fma.s1		f11 = f9,f9,f0
   (p6) fma.s1		f10 = f9,f10,f10;;
   (p6) fma.s1		f8 = f9,f8,f8
   (p6) fma.s1		f9 = f11,f10,f10;;
   (p6) fma.s1		f8 = f11,f8,f8
   (p6) fnma.s1		f10 = f7,f9,f6;;
   (p6) fma.s1		f8 = f10,f8,f9;;
        fcvt.fxu.trunc.s1 f8 = f8;;
	xmpy.hu		f10 = f8,f7;;
        getf.sig	r8 = f8
	getf.sig	r14 = f10;;
	add		r32 = r32,r14;;
	cmp.ltu		p6,p7 = r32,r14;;
   (p6) add		r8 = -1,r8
.L1:
        br.ret.sptk	b0
EPILOGUE(mpn_invert_limb)
ASM_END()
