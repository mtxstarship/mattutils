" Extension to C syntax for systems code
" Language: C
" Maintainer: Matthew Fernandez <matthew.fernandez@gmail.com>

" GCC builtins
syn keyword cOperator __builtin_alloca __builtin_alloca_with_align __builtin_apply
    \ __builtin_apply_args __builtin_assume_aligned __builtin_bswap16 __builtin_bswap32
    \ __builtin_bswap64 __builtin_call_with_static_chain __builtin_choose_expr
    \ __builtin___clear_cache __builtin_clrsb __builtin_clrsbl __builtin_clrsbll __builtin_clz
    \ __builtin_clzl __builtin_clzll __builtin_complex __builtin_constant_p __builtin_ctz
    \ __builtin_ctzl __builtin_ctzll __builtin_expect __builtin_extract_return_addr __builtin_FILE
    \ __builtin_fpclassify __builtin_ffs __builtin_ffsl __builtin_ffsll __builtin_frame_address
    \ __builtin_frob_return_address __builtin_FUNCTION __builtin_huge_val __builtin_huge_valf
    \ __builtin_huge_vall __builtin_inf __builtin_infd32 __builtin_infd64 __builtin_infd128
    \ __builtin_inff __builtin_infl __builtin_isinf_sign __builtin_LINE __builtin_nan
    \ __builtin_nand32 __builtin_nand64 __builtin_nand128 __builtin_nanf __builtin_nanl
    \ __builtin_nans __builtin_nansf __builtin_nansl __builtin_object_size __builtin_offsetof
    \ __builtin_parity __builtin_parityl __builtin_parityll __builtin_popcount __builtin_popcountl
    \ __builtin_popcountll __builtin_powi __builtin_powif __builtin_powil __builtin_prefetch
    \ __builtin_return __builtin_return_address __builtin_trap __builtin_types_compatible_p
    \ __builtin_unreachable __builtin_va_arg_pack __builtin_va_arg_pack_len __clear_cache

" GCC x86 CPUID builtins
syn keyword cOperator __builtin_cpu_init __builtin_cpu_is __builtin_cpu_supports

" GCC extensions
syn keyword cType __label__ __auto_type __int128 __thread
syn keyword cOperator __alignof__ typeof
syn keyword cConstant __FUNCTION__ __PRETTY_FUNCTION__

" Clang builtins
syn keyword cOperator __builtin_assume __builtin_bitreverse __builtin_convertvector
    \ __builtin_readcyclecounter __builtin_shufflevector __builtin_unpredictable

" Clang ARM builtins
syn keyword cOperator __builtin_arm_clrex __builtin_arm_ldaex __builtin_arm_ldrex
    \ __builtin_arm_stlex __builtin_arm_strex __dmb __dsb __isb 

" Linux extras
syn keyword cType __force __iomem __kernel __kernel_size_t __nocast __percpu __pmem __private __rcu
    \ __safe __user notrace 
syn keyword cType __compat_gid_t __compat_gid16_t __compat_gid32_t __compat_uid_t __compat_uid16_t
    \ __compat_uid32_t compat_caddr_t compat_clock_t compat_daddr_t compat_dev_t compat_fsid_t
    \ compat_ino_t compat_int_t compat_ipc_pid_t compat_key_t compat_loff_t compat_long_t
    \ compat_mode_t compat_nlink_t compat_off_t compat_old_sigset_t compat_pid_t compat_s64
    \ compat_short_t compat_sigset_word compat_size_t compat_ssize_t compat_time_t compat_timer_t
    \ compat_u64 compat_uint_t compat_ulong_t compat_uptr_t compat_ushort_t dev_t gfp_t irqreturn_t
    \ loff_t s8 s16 s32 s64 u8 u16 u32 u64
syn keyword cConstant __ATTR_NULL __GFP_HIGHMEM __GFP_HIGH COMPAT_LOFF_T_MAX COMPAT_OFF_T_MAX
    \ EADDRINUSE EADDRNOTAVAIL EADV EAFNOSUPPORT EALREADY EBADE EBADFD EBADR EBADRQC EBADSLT EBFRONT
    \ ECHRNG ECOMM ECONNABORTED ECONNREFUSED ECONNRESET EDEADLOCK EDESTADDRREQ EDOTDOT EDQUOT
    \ EHOSTDOWN EHOSTUNREACH EHWPOISON EIDRM EISCONN EISNAM EKEYEXPIRED EKEYREJECTED EKEYREVOKED
    \ EL2HLT EL2NSYNC EL3HLT EL3RST ELNRNG ELOOP EMULTIHOP ENETDOWN ENETRESET ENETUNREACH ENOANO
    \ ENODATA ENOTCONN ELIBACC ELIBBAD ELIBEXEC ELIBMAX ELIBSCN EMEDIUMTYPE ENAVAIL ENOBUFS ENOKEY
    \ ENOLINK ENOMEDIUM ENOMSG ENONET ENOPKG ENOPROTOOPT ENOSCI ENOSR ENOSTR ENOTNAM ENOTRECOVERABLE
    \ ENOTSOCK ENOTUNIQ EOPNOTSUPP EOVERFLOW EOWNERDEAD EPFNOSUPPORT EPROTO EPROTONOSUPPORT
    \ EPROTOTYPE EREMCHG EREMOTE EREMOTEIO ERESTART ERFKILL ESHUTDOWN ESOCKTNOSUPPORT ESRMNT ESTALE
    \ ESTRPIPE ETIME ETOOMANYREFS EUCLEAN EUNATCH EUSERS EWOULDBLOCK EXFULL GFP_ATOMIC GFP_KERNEL
    \ IRQ_NONE IRQ_HANDLED IRQ_WAKE_THREAD PAGE_SIZE POLLERR POLLHUP POLLIN POLLNVAL POLLOUT POLLPRI
    \ THIS_MODULE UIO_FASTIOV UIO_MAXIOV
syn keyword cOperator EXPORT_SYMBOL EXPORT_SYMBOL_GPL MODULE_AUTHOR MODULE_DESCRIPTION
    \ MODULE_DEVICE_TABLE MODULE_LICENSE