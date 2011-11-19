	SUBROUTINE powell(p,xi,ftol,iter,fret)
	use mo_nrtype
          use mo_nrutil, ONLY : assert_eq,nrerror
	use mo_nr, ONLY : linmin
	IMPLICIT NONE
	REAL(SP), DIMENSION(:), INTENT(INOUT) :: p
	REAL(SP), DIMENSION(:,:), INTENT(INOUT) :: xi
	INTEGER(I4B), INTENT(OUT) :: iter
	REAL(SP), INTENT(IN) :: ftol
	REAL(SP), INTENT(OUT) :: fret
	INTERFACE
		FUNCTION func(p)
		use mo_nrtype
		IMPLICIT NONE
		REAL(SP), DIMENSION(:), INTENT(IN) :: p
		REAL(SP) :: func
		END FUNCTION func
	END INTERFACE
	INTEGER(I4B), PARAMETER :: ITMAX=200
	INTEGER(I4B) :: i,ibig,n
	REAL(SP) :: del,fp,fptt,t
	REAL(SP), DIMENSION(size(p)) :: pt,ptt,xit
	n=assert_eq(size(p),size(xi,1),size(xi,2),'powell')
	fret=func(p)
	pt(:)=p(:)
	iter=0
	do
		iter=iter+1
		fp=fret
		ibig=0
		del=0.0
		do i=1,n
			xit(:)=xi(:,i)
			fptt=fret
			call linmin(p,xit,fret)
			if (abs(fptt-fret) > del) then
				del=abs(fptt-fret)
				ibig=i
			end if
		end do
		if (2.0_sp*abs(fp-fret) <= ftol*(abs(fp)+abs(fret))) RETURN
		if (iter == ITMAX) call &
			nrerror('powell exceeding maximum iterations')
		ptt(:)=2.0_sp*p(:)-pt(:)
		xit(:)=p(:)-pt(:)
		pt(:)=p(:)
		fptt=func(ptt)
		if (fptt >= fp) cycle
		t=2.0_sp*(fp-2.0_sp*fret+fptt)*(fp-fret-del)**2-del*(fp-fptt)**2
		if (t >= 0.0) cycle
		call linmin(p,xit,fret)
		xi(:,ibig)=xi(:,n)
		xi(:,n)=xit(:)
	end do
	END SUBROUTINE powell
