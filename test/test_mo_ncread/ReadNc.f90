! ------------------------------------------------------------------------------
!
! Test Program for reading nc files using the netcdf4 library.
!
! author: Stephan Thober
!
! created: 04.11.2011
! last update: 06.10.2012
!
! ------------------------------------------------------------------------------
program ReadNc
!
use mo_kind,   only: i4, sp, dp
use mo_NcRead, only: Get_NcVar, get_ncdim, NcOpen, NcClose, Get_NcDimAtt, Get_NcVarAtt
!
real(sp)      , dimension(:,:,:), allocatable :: data
character(256), dimension(:)    , allocatable :: DimNames
integer(i4)   , dimension(:)    , allocatable :: DimLen
real(dp)      , dimension(:)    , allocatable :: DimData
character(256)                                :: Filename
character(256)                                :: Varname
character(256)                                :: Attname
character(256)                                :: AttValues
integer(i4)                                   :: ncid
integer(i4)                                   :: NoDims
integer(i4)                                   :: i
integer(i4)   , dimension(5)                  :: dl
LOGICAL                                       :: isgood
!
Filename = '../FORTRAN_chs_lib/test/test_mo_ncread/pr_1961-2000.nc'
!Filename = 'pr_1961-2000.nc'
!
! Variable name can be retrieved by a "ncdump -h <filename>"
Varname  = 'pr'
!
isgood = .true.
!
dl = get_ncdim(Filename, Varname, ndims=NoDims)
!
allocate(data(dl(1),dl(2),dl(3)))
!
! get Dimesnion information - name & lenght (size)
call Get_NcDimAtt(Filename, Varname, DimNames, DimLen)
!
isgood = isgood .and. (DimNames(1) == 'x')
isgood = isgood .and. (DimNames(2) == 'y')
isgood = isgood .and. (DimNames(3) == 'time')
!
isgood = isgood .and. (DimLen(1) == 28)
isgood = isgood .and. (DimLen(2) == 36)
isgood = isgood .and. (DimLen(3) == 2)
!
! read data corresponding to dimesnion 3 ('time')
allocate(DimData(DimLen(3)))
call Get_NcVar(Filename, DimNames(3) ,DimData)
isgood = isgood .and. (anint(sum(DimData)) == 8100_i4)
deallocate(DimData)
!
call Get_NcVar(Filename,Varname, data)
!
! The sum of the data should be 0.1174308 in single precision
!write(*,*) 'sum of data: ', sum(data)
isgood = isgood .and. (anint(1e7_sp*sum(data)) == 1174308_i4)
data = -9999._sp
!
! check dynamic read
ncid = NcOpen(trim(Filename)) ! open file and get file handle
!
do i = 1, size(data,3)
   call Get_NcVar(Filename, Varname, data(:,:,i), (/1,1,i/),(/dl(1),dl(2),1/), ncid)
end do
!
call NcClose(ncid)            ! close file
!
isgood = isgood .and. (anint(1e7_sp*sum(data)) == 1174308_i4)
!
! retrieving variables attributes
AttName='units'
call Get_NcVarAtt(FileName, trim(DimNames(3)), AttName, AttValues)
isgood = isgood .and. (AttValues == 'days since 1950-01-01 00:00:00')
!
call Get_NcVarAtt(FileName, 'pr', '_FillValue', AttValues)
isgood = isgood .and. (AttValues == '1.0000000E+30')
!
if (isgood) then
   write(*,*) 'mo_ncread o.k.'
else
   write(*,*) 'mo_ncread failed!'
endif
!
deallocate(data)
!
end program ReadNc
