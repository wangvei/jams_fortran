SUBROUTINE linbcg_sp(b,x,itol,tol,itmax,iter,err)
  USE mo_kind, only: sp, i4
  USE mo_nrutil, ONLY : assert_eq, nrerror
  use mo_nr, ONLY : atimes, asolve, snrm
  IMPLICIT NONE
  REAL(SP), DIMENSION(:), INTENT(IN) :: b
  REAL(SP), DIMENSION(:), INTENT(INOUT) :: x
  INTEGER(I4), INTENT(IN) :: itol,itmax
  REAL(SP), INTENT(IN) :: tol
  INTEGER(I4), INTENT(OUT) :: iter
  REAL(SP), INTENT(OUT) :: err
  REAL(SP), PARAMETER :: EPS=1.0e-9_sp
  INTEGER(I4) :: n
  REAL(SP) :: ak,akden,bk,bkden,bknum,bnrm,dxnrm,xnrm,zm1nrm,znrm
  REAL(SP), DIMENSION(size(b)) :: p,pp,r,rr,z,zz
  n=assert_eq(size(b),size(x),'linbcg_sp')
  iter=0
  call atimes(x,r,0)
  r=b-r
  rr=r
  !	call atimes(r,rr,0)
  select case(itol)
  case(1)
     bnrm=snrm(b,itol)
     call asolve(r,z,0)
  case(2)
     call asolve(b,z,0)
     bnrm=snrm(z,itol)
     call asolve(r,z,0)
  case(3:4)
     call asolve(b,z,0)
     bnrm=snrm(z,itol)
     call asolve(r,z,0)
     znrm=snrm(z,itol)
  case default
     call nrerror('illegal itol in linbcg_sp')
  end select
  do
     if (iter > itmax) exit
     iter=iter+1
     call asolve(rr,zz,1)
     bknum=dot_product(z,rr)
     if (iter == 1) then
        p=z
        pp=zz
     else
        bk=bknum/bkden
        p=bk*p+z
        pp=bk*pp+zz
     end if
     bkden=bknum
     call atimes(p,z,0)
     akden=dot_product(z,pp)
     ak=bknum/akden
     call atimes(pp,zz,1)
     x=x+ak*p
     r=r-ak*z
     rr=rr-ak*zz
     call asolve(r,z,0)
     select case(itol)
     case(1)
        err=snrm(r,itol)/bnrm
     case(2)
        err=snrm(z,itol)/bnrm
     case(3:4)
        zm1nrm=znrm
        znrm=snrm(z,itol)
        if (abs(zm1nrm-znrm) > EPS*znrm) then
           dxnrm=abs(ak)*snrm(p,itol)
           err=znrm/abs(zm1nrm-znrm)*dxnrm
        else
           err=znrm/bnrm
           cycle
        end if
        xnrm=snrm(x,itol)
        if (err <= 0.5_sp*xnrm) then
           err=err/xnrm
        else
           err=znrm/bnrm
           cycle
        end if
     end select
     !write (*,*) ' iter=',iter,' err=',err
     if (err <= tol) exit
  end do
END SUBROUTINE linbcg_sp


SUBROUTINE linbcg_dp(b,x,itol,tol,itmax,iter,err)
  USE mo_kind, only: dp, i4
  USE mo_nrutil, ONLY : assert_eq, nrerror
  use mo_nr, ONLY : atimes, asolve, snrm
  IMPLICIT NONE
  REAL(DP), DIMENSION(:), INTENT(IN) :: b
  REAL(DP), DIMENSION(:), INTENT(INOUT) :: x
  INTEGER(I4), INTENT(IN) :: itol,itmax
  REAL(DP), INTENT(IN) :: tol
  INTEGER(I4), INTENT(OUT) :: iter
  REAL(DP), INTENT(OUT) :: err
  REAL(DP), PARAMETER :: EPS=1.0e-14_dp
  INTEGER(I4) :: n
  REAL(DP) :: ak,akden,bk,bkden,bknum,bnrm,dxnrm,xnrm,zm1nrm,znrm
  REAL(DP), DIMENSION(size(b)) :: p,pp,r,rr,z,zz
  n=assert_eq(size(b),size(x),'linbcg_dp')
  iter=0
  call atimes(x,r,0)
  r=b-r
  rr=r
  !	call atimes(r,rr,0)
  select case(itol)
  case(1)
     bnrm=snrm(b,itol)
     call asolve(r,z,0)
  case(2)
     call asolve(b,z,0)
     bnrm=snrm(z,itol)
     call asolve(r,z,0)
  case(3:4)
     call asolve(b,z,0)
     bnrm=snrm(z,itol)
     call asolve(r,z,0)
     znrm=snrm(z,itol)
  case default
     call nrerror('illegal itol in linbcg_dp')
  end select
  do
     if (iter > itmax) exit
     iter=iter+1
     call asolve(rr,zz,1)
     bknum=dot_product(z,rr)
     if (iter == 1) then
        p=z
        pp=zz
     else
        bk=bknum/bkden
        p=bk*p+z
        pp=bk*pp+zz
     end if
     bkden=bknum
     call atimes(p,z,0)
     akden=dot_product(z,pp)
     ak=bknum/akden
     call atimes(pp,zz,1)
     x=x+ak*p
     r=r-ak*z
     rr=rr-ak*zz
     call asolve(r,z,0)
     select case(itol)
     case(1)
        err=snrm(r,itol)/bnrm
     case(2)
        err=snrm(z,itol)/bnrm
     case(3:4)
        zm1nrm=znrm
        znrm=snrm(z,itol)
        if (abs(zm1nrm-znrm) > EPS*znrm) then
           dxnrm=abs(ak)*snrm(p,itol)
           err=znrm/abs(zm1nrm-znrm)*dxnrm
        else
           err=znrm/bnrm
           cycle
        end if
        xnrm=snrm(x,itol)
        if (err <= 0.5_dp*xnrm) then
           err=err/xnrm
        else
           err=znrm/bnrm
           cycle
        end if
     end select
     !write (*,*) ' iter=',iter,' err=',err
     if (err <= tol) exit
  end do
END SUBROUTINE linbcg_dp
