/*
 * This software is copyright (c) 2008, 2009 by Leon Timmermans <leont@cpan.org>.
 *
 * This is free software; you can redistribute it and/or modify it under
 * the same terms as perl itself.
 *
 */

#if defined linux || defined solaris
#include <sys/sendfile.h>
#elif defined freebsd
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/uio.h>
#endif
#include <unistd.h>

#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

MODULE = Sys::Sendfile				PACKAGE = Sys::Sendfile

#if defined linux || defined solaris || defined freebsd

SV*
sendfile(out, in, count = 0, offset = &PL_sv_undef)
	int out = PerlIO_fileno(IoOFP(sv_2io(ST(0))));
	int in  = PerlIO_fileno(IoIFP(sv_2io(ST(1))));
	size_t count;
	SV* offset;
	PROTOTYPE: **@
	CODE:
	off_t real_offset = SvOK(offset) ? SvUV(offset) : lseek(in, 0, SEEK_CUR);
#if defined linux || defined solaris
	if (count == 0) {
		struct stat info;
		if (fstat(in, &info) == -1) 
			XSRETURN_EMPTY;
		count = info.st_size - real_offset;
	}
	{
		ssize_t success = sendfile(out, in, &real_offset, count);
		if (success == -1)
			XSRETURN_EMPTY;
		else
			XSRETURN_IV(success);
#elif defined freebsd
	{
		off_t bytes;
		int ret = sendfile(out, in, real_offset, count, NULL, &bytes, 0);
		if (ret == -1)
			XSRETURN_EMPTY;
		else
			XSRETURN_IV(bytes);
#endif
	}

#else

#error Your operating system appears to be unsupported

#endif
