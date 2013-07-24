program sobol_index_test

  use mo_kind,        only: dp,i4, i8
  use mo_sobol,       only: sobol
  use mo_model,       only: getrange, model
  use mo_sobol_index, only: sobol_index

  implicit none

  integer(i4), parameter                 :: npara = 4                       ! number of parameter
  integer(i4), parameter                 :: nsets = 400                     ! number of parametersets 
  integer(i4), parameter                 :: nx = 10                         ! number of variable values
  integer(i8)                            :: skip = 30000_i8                 ! used for generating parameter sets via sobol sequences

  ! Samples and Model Output
  real(dp),    dimension(npara,2)        :: ParaRange                       ! array: Parameter ranges (Min, Max)
  real(dp),    dimension(nx)             :: x                               ! array: variable values

  ! Sobol index
  real(dp),    dimension(2*npara)        :: sample_sobol                    ! sobol sequence
  real(dp),    dimension(npara)          :: sample_a                        ! parameter sample A
  real(dp),    dimension(npara)          :: sample_b                        ! parameter sample B
  real(dp),    dimension(npara)          :: sample_ci                       ! parameter sample Ci
  real(dp),    dimension(nsets,nx)       :: ya, yb                          ! model output A and B, 
  !                                                                         !    i.e. time series with nx time points
  real(dp),    dimension(nsets,npara,nx) :: yc                              ! model output C(i), i=1,npara, 
  !                                                                         !    i.e. time series with nx time points
  real(dp),    dimension(npara,nx)       :: si                              ! Sobol index (main effect)  per time point and parameter
  !                                                                         !    based on ya, yb, and yc
  real(dp),    dimension(npara,nx)       :: sti                             ! Sobol index (total effect) per time point and parameter
  !                                                                         !    based on ya, yb, and yc

  ! Dummy variables
  integer(i4)                            :: set, para, i
  logical                                :: isgood = .true.

  ParaRange = GetRange()

  ! ------------------------------------------------------------------
  ! variable values, e.g. time points
  ! ------------------------------------------------------------------
  do i=1,nx
     x(i) = real(i,dp) * 0.1_dp
  end do

  ! ------------------------------------------------------------------
  ! Generating model outputs for parameter sets A, B, and C(i)
  ! ------------------------------------------------------------------
  do set = 1,nsets
     ! sobol sequence
     call sobol(int(2*npara,i8), skip, sample_sobol)
     sample_a = sample_sobol(1:npara)
     sample_b = sample_sobol(npara+1:2*npara)
     ! scaling
     sample_a = ParaRange(:,1) + sample_a * (ParaRange(:,2) - ParaRange(:,1)) 
     sample_b = ParaRange(:,1) + sample_b * (ParaRange(:,2) - ParaRange(:,1)) 

     ya(set,:) = model(sample_a,x)
     yb(set,:) = model(sample_b,x)
     
     do para=1,npara
        sample_ci       = sample_b
        sample_ci(para) = sample_a(para)
        yc(set,para,:)  = model(sample_ci,x)
     end do
  end do

  ! ------------------------------------------------------------------
  ! Calculate Sobol index: Main Effect (Si) and Total Effect (STi)
  ! ------------------------------------------------------------------
  call sobol_index(ya, yb, yc, si, sti)
  
  ! ------------------------------------------------------------------
  ! Printing and checking
  ! ------------------------------------------------------------------
  write(*,'(A40)')         '----------------------------------------'
  write(*,'(A27,F4.2,A5)') '        Sobol index   (x = ',x(4),')    '
  write(*,'(A40)')         '----------------------------------------'
  write(*,'(A40)')         'para  SI         STI                    '
  do para=1,npara
     write(*,'(I4,A2,F7.4,A4,F7.4)') para, '   ', si(para,4),'  ', sti(para,4)
  end do
  write(*,'(A40)') '----------------------------------------'
  write(*,*) ' '

  if (nint(si(1,4)*10000._dp)      .ne.   35_i4)  isgood = .false.
  if (nint(si(2,4)*10000._dp)      .ne.  218_i4)  isgood = .false.
  if (nint(si(3,4)*10000._dp)      .ne. 1377_i4)  isgood = .false.
  if (nint(si(4,4)*10000._dp)      .ne. 8185_i4)  isgood = .false.
  if (nint(sti(1,4)*10000._dp)     .ne.   54_i4)  isgood = .false.
  if (nint(sti(2,4)*10000._dp)     .ne.  261_i4)  isgood = .false.
  if (nint(sti(3,4)*10000._dp)     .ne. 1202_i4)  isgood = .false.
  if (nint(sti(4,4)*10000._dp)     .ne. 8410_i4)  isgood = .false.

  if (isgood) then
     write(*,*) 'mo_sobol_index o.k.'
  else
     write(*,*) 'mo_sobol_index failed'
  end if

end program sobol_index_test