MODULE mo_string_utils

  ! This module holds string conversion utilities

  ! License
  ! -------
  ! This file is part of the UFZ Fortran library.

  ! The UFZ Fortran library is free software: you can redistribute it and/or modify
  ! it under the terms of the GNU Lesser General Public License as published by
  ! the Free Software Foundation, either version 3 of the License, or
  ! (at your option) any later version.

  ! The UFZ Fortran library is distributed in the hope that it will be useful,
  ! but WITHOUT ANY WARRANTY; without even the implied warranty of
  ! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  ! GNU Lesser General Public License for more details.

  ! You should have received a copy of the GNU Lesser General Public License
  ! along with the UFZ Fortran library. If not, see <http://www.gnu.org/licenses/>.

  ! Copyright 2012 Matthias Cuntz

  USE mo_kind, ONLY: i4, i8, sp, dp

  IMPLICIT NONE

  PRIVATE

  PUBLIC :: DIVIDE_STRING ! split string in substring with the help of delimiter
  PUBLIC :: nonull        ! Check if string is still NULL
  PUBLIC :: num2str       ! Convert a number to a string
  PUBLIC :: separator     ! Format string: '-----...-----'
  PUBLIC :: tolower       ! Conversion   : 'ABCXYZ' -> 'abcxyz'   
  PUBLIC :: toupper       ! Conversion   : 'abcxyz' -> 'ABCXYZ'

  INTERFACE num2str
     MODULE PROCEDURE i42str, i82str, sp2str, dp2str, log2str
  END INTERFACE

  CHARACTER(len=*), PARAMETER :: separator = repeat('-',70)

  ! ------------------------------------------------------------------

CONTAINS

  ! ------------------------------------------------------------------

  !     NAME
  !         nonull

  !     PURPOSE
  !         Checks if string was already used, i.e. does not contain NULL character anymore.

  !     CALLING SEQUENCE
  !         used = nonull(str)
  
  !     INDENT(IN)
  !         character(len=*) :: str    String

  !     INDENT(INOUT)
  !         None

  !     INDENT(OUT)
  !         logical :: used    .true.: string was already set; .false.: string still in initialised state

  !     INDENT(IN), OPTIONAL
  !         None

  !     INDENT(INOUT), OPTIONAL
  !         None

  !     INDENT(OUT), OPTIONAL
  !         None

  !     RESTRICTIONS
  !         None

  !     EXAMPLE
  !         if (nonull(str)) write(*,*) trim(str)
  !         -> see also example in test directory

  !     LITERATURE
  !         None

  !     HISTORY
  !         Written,  Matthias Cuntz, Jan 2012

  FUNCTION nonull(str)

    IMPLICIT NONE

    CHARACTER(LEN=*), INTENT(in) :: str
    LOGICAL                      :: nonull

    if (scan(str, achar(0)) == 0) then
       nonull = .true.
    else
       nonull = .false.
    endif

  END FUNCTION nonull

  ! ------------------------------------------------------------------

  !     NAME
  !         num2str

  !     PURPOSE
  !         Convert a number or logical to a string with an optional format.

  !     CALLING SEQUENCE
  !         str = num2str(num,form=form)
  
  !     INDENT(IN)
  !         integer(i4/i8)/real(sp/dp)/logical :: num    Number or logical

  !     INDENT(INOUT)
  !         None

  !     INDENT(OUT)
  !         character(len=X) :: str              String of formatted input number or logical
  !                                              Ouput length X is:
  !                                              i4    - 10
  !                                              i8    - 20
  !                                              sp/dp - 32
  !                                              log   - 10

  !     INDENT(IN), OPTIONAL
  !         character(len=*) :: form             Format string
  !                                              Defaults are:
  !                                              i4    - '(I10)'
  !                                              i8    - '(I20)'
  !                                              sp/dp - '(G32.5)'
  !                                              log   - '(L10)'

  !     INDENT(INOUT), OPTIONAL
  !         None

  !     INDENT(OUT), OPTIONAL
  !         None

  !     RESTRICTIONS
  !         Uses WRITE to write into string. Recursive write is not permitted before Fortran 2003
  !         so that one cannot use
  !             write(*,*) 'A='//num2str(a)
  !         Use 'call message' from mo_messages.f90
  !             use mo_messages, only message
  !             call message('A=', trim(num2str(a)))
  !         or write into another string first:
  !             str = 'A='//num2str(a)
  !             write(*,*) trim(str)

  !     EXAMPLE
  !         str = num2str(3.1415217_i4,'(F3.1)')
  !         -> see also example in test directory

  !     LITERATURE
  !         None

  !     HISTORY
  !         Written,  Matthias Cuntz, Dec 2011 - modified from Echam5, (C) MPI-MET, Hamburg, Germany

  PURE FUNCTION i42str(nn,form)
    ! returns integer nn as a string (often needed in printing messages)
    IMPLICIT NONE
    INTEGER(i4),      INTENT(IN)           :: nn
    CHARACTER(len=*), INTENT(IN), OPTIONAL :: form
    CHARACTER(len=10) :: i42str

    if (present(form)) then
       write(i42str,form) nn
    else
       write(i42str,'(I10)') nn
    end if
    !i42str = adjustl(i42str)

  END FUNCTION i42str


  PURE FUNCTION i82str(nn,form)
    ! returns integer nn as a string (often needed in printing messages)
    IMPLICIT NONE
    INTEGER(i8),      INTENT(IN)           :: nn
    CHARACTER(len=*), INTENT(IN), OPTIONAL :: form
    CHARACTER(len=20) :: i82str

    if (present(form)) then
       write(i82str,form) nn
    else
       write(i82str,'(I20)') nn
    end if
    !i82str = adjustl(i82str)

  END FUNCTION i82str


  PURE FUNCTION sp2str(rr,form)
    ! returns real rr as a string (often needed in printing messages)
    IMPLICIT NONE
    REAL(sp),         INTENT(IN)           :: rr
    CHARACTER(len=*), INTENT(IN), OPTIONAL :: form
    CHARACTER(len=32) :: sp2str

    if (present(form)) then
       write(sp2str,form) rr
    else
       write(sp2str,'(G32.5)') rr
    end if
    !sp2str = adjustl(sp2str)

  END FUNCTION sp2str


  PURE FUNCTION dp2str(rr,form)
    ! returns real rr as a string (often needed in printing messages)
    IMPLICIT NONE
    REAL(dp),         INTENT(IN)           :: rr
    CHARACTER(len=*), INTENT(IN), OPTIONAL :: form
    CHARACTER(len=32) :: dp2str

    if (present(form)) then
       write(dp2str,form) rr
    else
       write(dp2str,'(G32.5)') rr
    end if
    !dp2str = adjustl(dp2str)

  END FUNCTION dp2str


  PURE FUNCTION log2str(ll,form)
    ! returns logical ll as a string (often needed in printing messages)
    IMPLICIT NONE
    LOGICAL,          INTENT(in)           :: ll
    CHARACTER(len=*), INTENT(IN), OPTIONAL :: form
    CHARACTER(len=10) :: log2str

    if (present(form)) then
       write(log2str,form) ll
    else
       write(log2str,'(L10)') ll
    end if
    !log2str = adjustl(log2str)

  END FUNCTION log2str

  ! ------------------------------------------------------------------

  !     NAME
  !         tolower

  !     PURPOSE
  !         Convert all upper case letters in string to lower case letters.

  !     CALLING SEQUENCE
  !         low = tolower(upper)
  
  !     INDENT(IN)
  !         character(len=*) :: upper    String

  !     INDENT(INOUT)
  !         None

  !     INDENT(OUT)
  !         character(len=len_trim(upper)) :: low    String where all uppercase in input is converted to lowercase

  !     INDENT(IN), OPTIONAL
  !         None

  !     INDENT(INOUT), OPTIONAL
  !         None

  !     INDENT(OUT), OPTIONAL
  !         None

  !     RESTRICTIONS
  !         None

  !     EXAMPLE
  !         ! Returns 'hallo'
  !         low = tolower('Hallo')
  !         -> see also example in test directory

  !     LITERATURE
  !         None

  !     HISTORY
  !         Written,  Matthias Cuntz, Dec 2011 - modified from Echam5, (C) MPI-MET, Hamburg, Germany

  FUNCTION tolower(upper)

    IMPLICIT NONE

    CHARACTER(LEN=*)              ,INTENT(in) :: upper
    CHARACTER(LEN=LEN_TRIM(upper))            :: tolower

    INTEGER            :: i
    INTEGER ,PARAMETER :: idel = ICHAR('a')-ICHAR('A')

    DO i=1,LEN_TRIM(upper)
      IF (ICHAR(upper(i:i)) >= ICHAR('A') .AND. &
          ICHAR(upper(i:i)) <= ICHAR('Z')) THEN
        tolower(i:i) = CHAR( ICHAR(upper(i:i)) + idel )
      ELSE
        tolower(i:i) = upper(i:i)
      END IF
    END DO

  END FUNCTION tolower

  ! ------------------------------------------------------------------

  !     NAME
  !         toupper

  !     PURPOSE
  !         Convert all lower case letters in string to upper case letters.

  !     CALLING SEQUENCE
  !         up = toupper(lower)
  
  !     INDENT(IN)
  !         character(len=*) :: lower    String

  !     INDENT(INOUT)
  !         None

  !     INDENT(OUT)
  !         character(len=len_trim(lower)) :: up    String where all lowercase in input is converted to uppercase

  !     INDENT(IN), OPTIONAL
  !         None

  !     INDENT(INOUT), OPTIONAL
  !         None

  !     INDENT(OUT), OPTIONAL
  !         None

  !     RESTRICTIONS
  !         None

  !     EXAMPLE
  !         ! Returns 'HALLO'
  !         up = toupper('Hallo')
  !         -> see also example in test directory

  !     LITERATURE
  !         None

  !     HISTORY
  !         Written,  Matthias Cuntz, Dec 2011 - modified from Echam5, (C) MPI-MET, Hamburg, Germany

  FUNCTION toupper (lower)

    IMPLICIT NONE

    CHARACTER(LEN=*)              ,INTENT(in) :: lower
    CHARACTER(LEN=LEN_TRIM(lower))            :: toupper

    INTEGER            :: i
    INTEGER, PARAMETER :: idel = ICHAR('A')-ICHAR('a')

    DO i=1,LEN_TRIM(lower)
      IF (ICHAR(lower(i:i)) >= ICHAR('a') .AND. &
          ICHAR(lower(i:i)) <= ICHAR('z')) THEN
        toupper(i:i) = CHAR( ICHAR(lower(i:i)) + idel )
      ELSE
        toupper(i:i) = lower(i:i)
      END IF
    END DO

  END FUNCTION toupper

  ! ------------------------------------------------------------------

  !     NAME
  !         DIVIDE_STRING

  !     PURPOSE
  !         Divides a string in several substrings (array of strings) with the help of a user specified delimiter.

  !     CALLING SEQUENCE
  !         DIVIDE_STRING(string, delim, strArr(:))
  
  !     INDENT(IN)
  !         CHARACTER(len=*), INTENT(IN)        :: string     - string to be divided
  !         CHARACTER(len=*), INTENT(IN)        :: delim      - delimiter specifying places for division

  !     INDENT(INOUT)
  !         None

  !     INDENT(OUT)
  !         CHARACTER(len=*), DIMENSION(:) ,   &
  !                  ALLOCATABLE,  INTENT(OUT)  :: strArr     -  Array of substrings, has to be allocateable and is
  !                                                              handed to the routine unallocated

  !     INDENT(IN), OPTIONAL
  !         None

  !     INDENT(INOUT), OPTIONAL
  !         None

  !     INDENT(OUT), OPTIONAL
  !         None

  !     RESTRICTIONS
  !         only character types allowed
  !         output array should be allocateable array, which is unallocated handed to the subroutine
  !             allocation is done in in devide_string 

  !     EXAMPLE
  !        DIVIDE_STRING('I want to test this routine!', ' ', strArr(:))
  !         -> see also example in test directory

  !     LITERATURE
  !         None

  !     HISTORY
  !         Written,  Matthias Zink, Oct 2012

  SUBROUTINE DIVIDE_STRING(string, delim, strArr)
    !
    IMPLICIT NONE
    !
    CHARACTER(len=*)             , INTENT(IN)        :: string
    CHARACTER(len=*)             , INTENT(IN)        :: delim
    CHARACTER(len=*), DIMENSION(:) , ALLOCATABLE, &
                                   INTENT(OUT)      :: strArr
    !
    CHARACTER(256)                                   :: stringDummy   ! string in fisrt place but cutted in pieces
    CHARACTER(256), DIMENSION(:) , ALLOCATABLE       :: strDummyArr   ! Dummy arr until number of substrings is known 
    INTEGER(i4)                                      :: pos           ! position of dilimiter
    INTEGER(i4)                                      :: nosubstr      ! number of substrings in string
    !
    stringDummy = string
    !
    allocate(strDummyArr(len_trim(stringDummy)))
    pos=999_i4; nosubstr=0_i4
    ! search for substrings and theirs count
    do
       pos = index(trim(adjustl(stringDummy)), delim)
       ! exit if no more delimiter is find and save the last part of the string
       if (pos .EQ. 0_i4) then
          nosubstr = nosubstr + 1_i4
          StrDummyArr(nosubstr) = trim(stringDummy)
          exit
       end if
       !
       nosubstr = nosubstr + 1_i4
       strDummyArr(nosubstr) = stringDummy(1:pos-1)
       stringDummy = stringDummy(pos+1:len_trim(stringDummy))
    end do
    ! hand over results to strArr
    if (nosubstr .EQ. 0_i4) then
       print*, '***WARNING: string does not contain delimiter. There are no substrings. (subroutine DIVIDE_STRING)'
       return
    else
       allocate(strArr(nosubstr))
       strArr = StrDummyArr(1:nosubstr)
    end if
    !
    deallocate(strDummyArr)
    !
  END SUBROUTINE DIVIDE_STRING

END MODULE mo_string_utils
