MODULE mo_append

  ! This module is appending and pasting scalars, vectors, and matrixes into one.
  ! and is part of the UFZ CHS Fortran library.

  ! 
  ! Written  Juliane Mai, Aug 2012
  ! Modified Juliane Mai, Aug 2012 : character append & paste

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

  ! Copyright 2012 Juliane Mai

  USE mo_kind, only: i4, i8, sp, dp

  IMPLICIT NONE

  PRIVATE

  PUBLIC :: append    ! Returns input1 appended with input2. (like bash cat)
  PUBLIC :: paste     ! Returns input1 pasted with input2.   (like bash paste)

  ! Interfaces for single and double precision routines; sort alphabetically
  INTERFACE append
     MODULE PROCEDURE append_i4_v_s, append_i4_v_v, append_i4_m_m, &
                      append_i8_v_s, append_i8_v_v, append_i8_m_m, &
                      append_sp_v_s, append_sp_v_v, append_sp_m_m, &
                      append_dp_v_s, append_dp_v_v, append_dp_m_m, &
                      append_char_v_s, append_char_v_v, append_char_m_m
                     
  END INTERFACE append

  INTERFACE paste
     MODULE PROCEDURE paste_i4_m_s, paste_i4_m_v, paste_i4_m_m, &
                      paste_i8_m_s, paste_i8_m_v, paste_i8_m_m, &
                      paste_sp_m_s, paste_sp_m_v, paste_sp_m_m, &
                      paste_dp_m_s, paste_dp_m_v, paste_dp_m_m, &
                      paste_char_m_s, paste_char_m_v, paste_char_m_m
                     
  END INTERFACE paste


  ! ------------------------------------------------------------------

CONTAINS

  ! ------------------------------------------------------------------

  !     NAME
  !         append

  !     PURPOSE
  !         appends one input to another input
  !         The input might be a scalar, a vector or a matrix.
  !         Possibilities: 
  !         (1)     append scalar to vector
  !         (2)     append vector to vector
  !         (3)     append matrix to matrix    

  !     CALLING SEQUENCE
  !         input1 = (/ 1.0_dp , 2.0_dp /)
  !         input2 = 3.0_dp
  !
  !         call append (input1, input2)
  !         --> input1 = (/ 1.0_dp , 2.0_dp, 3.0_dp /)
  !
  !         see also test folder for a detailed example


  !     INDENT(IN)
  !         INTEGER(I4/I8)/REAL(SP/DP)/CHARACTER(len=*), -/DIMENSION(:)/DIMENSION(:,:), -/ALLOCATABLE  
  !                                       :: input2 ... flexible kind, but same as input1
  !                                                     scalar, vector, or matrix

  !     INDENT(INOUT)
  !         INTEGER(I4/I8)/REAL(SP/DP)/CHARACTER(len=*), DIMENSION(:)/DIMENSION(:,:), ALLOCATABLE  
  !                                       :: input1 ... flexible kind, but same as input2
  !                                                     vector, or matrix
  !                                                     has to be allocatable

  !     INDENT(OUT)
  !         None

  !     INDENT(IN), OPTIONAL
  !         None

  !     INDENT(INOUT), OPTIONAL
  !         None

  !     INDENT(OUT), OPTIONAL
  !         None

  !     RESTRICTIONS
  !         Size of input1 and input2 have to fit together,
  !         i.e. number of columns input1 = number of columns input2
  !
  !         Strings have to be less or equal 256 characters in length.

  !     EXAMPLE
  !         see test/test_mo_append/

  !     LITERATURE

  !     HISTORY
  !        Written  Juliane Mai, Aug   2012

SUBROUTINE append_i4_v_s(vec1, sca2)

    implicit none

    integer(i4), dimension(:), allocatable, intent(inout)   :: vec1
    integer(i4),                            intent(in)      :: sca2

    ! local variables
    integer(i4)                             :: n1, n2
    integer(i4), dimension(:), allocatable  :: tmp

    n2 = 1_i4

    if (allocated(vec1)) then
       n1 = size(vec1)
       ! save vec1
       allocate(tmp(n1))
       tmp=vec1
       deallocate(vec1)

       allocate(vec1(n1+n2))
       vec1(1:n1)          = tmp(1:n1)
       vec1(n1+1_i4)       = sca2
    else
       n1 = 0_i4

       allocate(vec1(n2))
       vec1(1_i4) = sca2
    end if

  END SUBROUTINE append_i4_v_s

  SUBROUTINE append_i4_v_v(vec1, vec2)

    implicit none

    integer(i4), dimension(:), allocatable, intent(inout)   :: vec1
    integer(i4), dimension(:), intent(in)                   :: vec2

    ! local variables
    integer(i4)                             :: n1, n2    ! length of vectors
    integer(i4), dimension(:), allocatable  :: tmp

    n2 = size(vec2)

    if (allocated(vec1)) then
       n1 = size(vec1)
       ! save vec1
       allocate(tmp(n1))
       tmp=vec1
       deallocate(vec1)

       allocate(vec1(n1+n2))
       vec1(1:n1)          = tmp(1:n1)
       vec1(n1+1_i4:n1+n2) = vec2(1:n2)
    else
       n1 = 0_i4

       allocate(vec1(n2))
       vec1(n1+1_i4:n1+n2) = vec2(1:n2)
    end if

  END SUBROUTINE append_i4_v_v

  SUBROUTINE append_i4_m_m(mat1, mat2)

    implicit none

    integer(i4), dimension(:,:), allocatable, intent(inout)   :: mat1
    integer(i4), dimension(:,:), intent(in)                   :: mat2

    ! local variables
    integer(i4)                               :: m1, m2    ! dim1 of matrixes: rows
    integer(i4)                               :: n1, n2    ! dim2 of matrixes: columns
    integer(i4), dimension(:,:), allocatable  :: tmp

    m2 = size(mat2,1)   ! rows
    n2 = size(mat2,2)    ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns

       if (n1 .ne. n2) then
          print*, 'append: columns of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if

       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1+m2,n1))
       mat1(1:m1,:)          = tmp(1:m1,:)
       mat1(m1+1_i4:m1+m2,:) = mat2(1:m2,:)
    else
       n1 = 0_i4

       allocate(mat1(m2,n2))
       mat1 = mat2
    end if

  END SUBROUTINE append_i4_m_m

  SUBROUTINE append_i8_v_s(vec1, sca2)

    implicit none

    integer(i8), dimension(:), allocatable, intent(inout)   :: vec1
    integer(i8),                            intent(in)      :: sca2

    ! local variables
    integer(i4)                             :: n1, n2
    integer(i8), dimension(:), allocatable  :: tmp

    n2 = 1_i4

    if (allocated(vec1)) then
       n1 = size(vec1)
       ! save vec1
       allocate(tmp(n1))
       tmp=vec1
       deallocate(vec1)

       allocate(vec1(n1+n2))
       vec1(1:n1)          = tmp(1:n1)
       vec1(n1+1_i4)       = sca2
    else
       n1 = 0_i4

       allocate(vec1(n2))
       vec1(1_i4) = sca2
    end if

  END SUBROUTINE append_i8_v_s

  SUBROUTINE append_i8_v_v(vec1, vec2)

    implicit none

    integer(i8), dimension(:), allocatable, intent(inout)   :: vec1
    integer(i8), dimension(:), intent(in)                   :: vec2

    ! local variables
    integer(i4)                             :: n1, n2    ! length of vectors
    integer(i8), dimension(:), allocatable  :: tmp

    n2 = size(vec2)

    if (allocated(vec1)) then
       n1 = size(vec1)
       ! save vec1
       allocate(tmp(n1))
       tmp=vec1
       deallocate(vec1)

       allocate(vec1(n1+n2))
       vec1(1:n1)          = tmp(1:n1)
       vec1(n1+1_i4:n1+n2) = vec2(1:n2)
    else
       n1 = 0_i4

       allocate(vec1(n2))
       vec1(n1+1_i4:n1+n2) = vec2(1:n2)
    end if

  END SUBROUTINE append_i8_v_v

  SUBROUTINE append_i8_m_m(mat1, mat2)

    implicit none

    integer(i8), dimension(:,:), allocatable, intent(inout)   :: mat1
    integer(i8), dimension(:,:), intent(in)                   :: mat2

    ! local variables
    integer(i4)                               :: m1, m2    ! dim1 of matrixes: rows
    integer(i4)                               :: n1, n2    ! dim2 of matrixes: columns
    integer(i8), dimension(:,:), allocatable  :: tmp

    m2 = size(mat2,1)   ! rows
    n2 = size(mat2,2)    ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns

       if (n1 .ne. n2) then
          print*, 'append: columns of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if

       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1+m2,n1))
       mat1(1:m1,:)          = tmp(1:m1,:)
       mat1(m1+1_i4:m1+m2,:) = mat2(1:m2,:)
    else
       n1 = 0_i4

       allocate(mat1(m2,n2))
       mat1 = mat2
    end if

  END SUBROUTINE append_i8_m_m

  SUBROUTINE append_sp_v_s(vec1, sca2)

    implicit none

    real(sp), dimension(:), allocatable, intent(inout)   :: vec1
    real(sp),                            intent(in)      :: sca2

    ! local variables
    integer(i4)                             :: n1, n2
    real(sp), dimension(:), allocatable     :: tmp

    n2 = 1_i4

    if (allocated(vec1)) then
       n1 = size(vec1)
       ! save vec1
       allocate(tmp(n1))
       tmp=vec1
       deallocate(vec1)

       allocate(vec1(n1+n2))
       vec1(1:n1)          = tmp(1:n1)
       vec1(n1+1_i4)       = sca2
    else
       n1 = 0_i4

       allocate(vec1(n2))
       vec1(1_i4) = sca2
    end if

  END SUBROUTINE append_sp_v_s

  SUBROUTINE append_sp_v_v(vec1, vec2)

    implicit none

    real(sp), dimension(:), allocatable, intent(inout)   :: vec1
    real(sp), dimension(:),              intent(in)      :: vec2

    ! local variables
    integer(i4)                             :: n1, n2    ! length of vectors
    real(sp), dimension(:), allocatable     :: tmp

    n2 = size(vec2)

    if (allocated(vec1)) then
       n1 = size(vec1)
       ! save vec1
       allocate(tmp(n1))
       tmp=vec1
       deallocate(vec1)

       allocate(vec1(n1+n2))
       vec1(1:n1)          = tmp(1:n1)
       vec1(n1+1_i4:n1+n2) = vec2(1:n2)
    else
       n1 = 0_i4

       allocate(vec1(n2))
       vec1(n1+1_i4:n1+n2) = vec2(1:n2)
    end if

  END SUBROUTINE append_sp_v_v

  SUBROUTINE append_sp_m_m(mat1, mat2)

    implicit none

    real(sp), dimension(:,:), allocatable, intent(inout)   :: mat1
    real(sp), dimension(:,:), intent(in)                   :: mat2

    ! local variables
    integer(i4)                               :: m1, m2    ! dim1 of matrixes: rows
    integer(i4)                               :: n1, n2    ! dim2 of matrixes: columns
    real(sp), dimension(:,:), allocatable     :: tmp

    m2 = size(mat2,1)   ! rows
    n2 = size(mat2,2)    ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns

       if (n1 .ne. n2) then
          print*, 'append: columns of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if

       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1+m2,n1))
       mat1(1:m1,:)          = tmp(1:m1,:)
       mat1(m1+1_i4:m1+m2,:) = mat2(1:m2,:)
    else
       n1 = 0_i4

       allocate(mat1(m2,n2))
       mat1 = mat2
    end if

  END SUBROUTINE append_sp_m_m

  SUBROUTINE append_dp_v_s(vec1, sca2)

    implicit none

    real(dp), dimension(:), allocatable, intent(inout)   :: vec1
    real(dp),                            intent(in)      :: sca2

    ! local variables
    integer(i4)                             :: n1, n2
    real(dp), dimension(:), allocatable     :: tmp

    n2 = 1_i4

    if (allocated(vec1)) then
       n1 = size(vec1)
       ! save vec1
       allocate(tmp(n1))
       tmp=vec1
       deallocate(vec1)

       allocate(vec1(n1+n2))
       vec1(1:n1)          = tmp(1:n1)
       vec1(n1+1_i4)       = sca2
    else
       n1 = 0_i4

       allocate(vec1(n2))
       vec1(1_i4) = sca2
    end if

  END SUBROUTINE append_dp_v_s

  SUBROUTINE append_dp_v_v(vec1, vec2)

    implicit none

    real(dp), dimension(:), allocatable, intent(inout)   :: vec1
    real(dp), dimension(:), intent(in)                   :: vec2

    ! local variables
    integer(i4)                             :: n1, n2    ! length of vectors
    real(dp), dimension(:), allocatable     :: tmp

    n2 = size(vec2)

    if (allocated(vec1)) then
       n1 = size(vec1)
       ! save vec1
       allocate(tmp(n1))
       tmp=vec1
       deallocate(vec1)

       allocate(vec1(n1+n2))
       vec1(1:n1)          = tmp(1:n1)
       vec1(n1+1_i4:n1+n2) = vec2(1:n2)
    else
       n1 = 0_i4

       allocate(vec1(n2))
       vec1(n1+1_i4:n1+n2) = vec2(1:n2)
    end if

  END SUBROUTINE append_dp_v_v

  SUBROUTINE append_dp_m_m(mat1, mat2)

    implicit none

    real(dp), dimension(:,:), allocatable, intent(inout)   :: mat1
    real(dp), dimension(:,:), intent(in)                   :: mat2

    ! local variables
    integer(i4)                               :: m1, m2    ! dim1 of matrixes: rows
    integer(i4)                               :: n1, n2    ! dim2 of matrixes: columns
    real(dp), dimension(:,:), allocatable     :: tmp

    m2 = size(mat2,1)   ! rows
    n2 = size(mat2,2)    ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns

       if (n1 .ne. n2) then
          print*, 'append: columns of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if

       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1+m2,n1))
       mat1(1:m1,:)          = tmp(1:m1,:)
       mat1(m1+1_i4:m1+m2,:) = mat2(1:m2,:)
    else
       n1 = 0_i4

       allocate(mat1(m2,n2))
       mat1 = mat2
    end if

  END SUBROUTINE append_dp_m_m

  SUBROUTINE append_char_v_s(vec1, sca2)

    implicit none

    character(len=*), dimension(:), allocatable, intent(inout)   :: vec1
    character(len=*),                            intent(in)      :: sca2

    ! local variables
    integer(i4)                               :: n1, n2
    character(256), dimension(:), allocatable :: tmp

    n2 = 1_i4

    if (allocated(vec1)) then
       n1 = size(vec1)
       ! save vec1
       allocate(tmp(n1))
       tmp=vec1
       deallocate(vec1)

       allocate(vec1(n1+n2))
       vec1(1:n1)          = tmp(1:n1)
       vec1(n1+1_i4)       = sca2
    else
       n1 = 0_i4

       allocate(vec1(n2))
       vec1(1_i4) = sca2
    end if

  END SUBROUTINE append_char_v_s

  SUBROUTINE append_char_v_v(vec1, vec2)

    character(len=*), dimension(:), allocatable, intent(inout)   :: vec1
    character(len=*), dimension(:),              intent(in)      :: vec2

    ! local variables
    integer(i4)                               :: n1, n2
    character(256), dimension(:), allocatable :: tmp

    n2 = size(vec2)

    if (allocated(vec1)) then
       n1 = size(vec1)
       ! save vec1
       allocate(tmp(n1))
       tmp=vec1
       deallocate(vec1)

       allocate(vec1(n1+n2))
       vec1(1:n1)          = tmp(1:n1)
       vec1(n1+1_i4:n1+n2) = vec2(1:n2)
    else
       n1 = 0_i4

       allocate(vec1(n2))
       vec1(n1+1_i4:n1+n2) = vec2(1:n2)
    end if

  END SUBROUTINE append_char_v_v

  SUBROUTINE append_char_m_m(mat1, mat2)

    implicit none

    character(len=*), dimension(:,:), allocatable, intent(inout)   :: mat1
    character(len=*), dimension(:,:),              intent(in)      :: mat2

    ! local variables
    integer(i4)                                 :: m1, m2    ! dim1 of matrixes: rows
    integer(i4)                                 :: n1, n2    ! dim2 of matrixes: columns
    character(256), dimension(:,:), allocatable :: tmp

    m2 = size(mat2,1)   ! rows
    n2 = size(mat2,2)    ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns

       if (n1 .ne. n2) then
          print*, 'append: columns of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if

       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1+m2,n1))
       mat1(1:m1,:)          = tmp(1:m1,:)
       mat1(m1+1_i4:m1+m2,:) = mat2(1:m2,:)
    else
       n1 = 0_i4

       allocate(mat1(m2,n2))
       mat1 = mat2
    end if

  END SUBROUTINE append_char_m_m

  ! ------------------------------------------------------------------

  !     NAME
  !         paste

  !     PURPOSE
  !         Pastes one input to another input
  !         The input might be a scalar, a vector or a matrix.
  !         Possibilities: 
  !         (1)     paste scalar to one-line matrix
  !         (3)     paste vector to a matrix
  !         (5)     paste matrix to matrix    

  !     CALLING SEQUENCE
  !         input1 = (/ 1.0_dp , 2.0_dp /)
  !         input2 = (/ 3.0_dp , 4.0_dp /)
  !
  !         call paste (input1, input2)
  !         --> input1(1,:) = (/ 1.0_dp , 3.0_dp /)
  !             input1(2,:) = (/ 2.0_dp , 4.0_dp /)
  !
  !         see also test folder for a detailed example


  !     INDENT(IN)
  !         INTEGER(I4/I8)/REAL(SP/DP)/CHARACTER(len=*), -/DIMENSION(:)/DIMENSION(:,:), -/ALLOCATABLE  
  !                                       :: input2 ... flexible kind, but same as input1
  !                                                     scalar, vector, or matrix

  !     INDENT(INOUT)
  !         INTEGER(I4/I8)/REAL(SP/DP)/CHARACTER(len=*), DIMENSION(:)/DIMENSION(:,:), ALLOCATABLE  
  !                                       :: input1 ... flexible kind, but same as input2
  !                                                     vector, or matrix
  !                                                     has to be allocatable

  !     INDENT(OUT)
  !         None

  !     INDENT(IN), OPTIONAL
  !         None

  !     INDENT(INOUT), OPTIONAL
  !         None

  !     INDENT(OUT), OPTIONAL
  !         None

  !     RESTRICTIONS
  !         Size of input1 and input2 have to fit together,
  !         i.e. number of rows input1 = number of rows input2
  !
  !         Strings have to be less or equal 256 characters in length.

  !     EXAMPLE
  !         see test/test_mo_append/

  !     LITERATURE

  !     HISTORY
  !        Written  Juliane Mai, Aug   2012

  SUBROUTINE paste_i4_m_s(mat1, sca2)

    implicit none

    integer(i4), dimension(:,:), allocatable, intent(inout)   :: mat1
    integer(i4),                              intent(in)      :: sca2

    ! local variables
    integer(i4)                               :: m1    ! dim1 of matrix
    integer(i4)                               :: n1    ! dim2 of matrix
    integer(i4), dimension(:,:), allocatable  :: tmp

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. 1_i4) then
          print*, 'paste: scalar paste to matrix only works with one-line matrix'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(1_i4,n1+1_i4))
       mat1(1,1:n1)          = tmp(1,1:n1)
       mat1(1,n1+1_i4)       = sca2
    else
       allocate(mat1(1_i4,1_i4))
       mat1(1,1) = sca2
    end if

  END SUBROUTINE paste_i4_m_s
  
  SUBROUTINE paste_i4_m_v(mat1, vec2)

    implicit none

    integer(i4), dimension(:,:), allocatable, intent(inout)   :: mat1
    integer(i4), dimension(:),                intent(in)      :: vec2

    ! local variables
    integer(i4)                             :: m1, m2    ! dim1 of matrixes
    integer(i4)                             :: n1, n2    ! dim2 of matrixes
    integer(i4), dimension(:,:), allocatable  :: tmp

    m2 = size(vec2,1)   ! rows
    n2 = 1_i4           ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. m2) then
          print*, 'paste: rows of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1,n1+n2))
       mat1(:,1:n1)          = tmp(:,1:n1)
       mat1(1:m2,n1+n2)      = vec2(1:m2)
    else
       n1 = 0_i4
       m1 = m2

       allocate(mat1(m2,n2))
       mat1(1:m2,n1+n2)      = vec2(1:m2)
    end if

  END SUBROUTINE paste_i4_m_v

  SUBROUTINE paste_i4_m_m(mat1, mat2)

    implicit none

    integer(i4), dimension(:,:), allocatable, intent(inout)   :: mat1
    integer(i4), dimension(:,:),              intent(in)      :: mat2

    ! local variables
    integer(i4)                             :: m1, m2    ! dim1 of matrixes
    integer(i4)                             :: n1, n2    ! dim2 of matrixes
    integer(i4), dimension(:,:), allocatable  :: tmp

    m2 = size(mat2,1)   ! rows
    n2 = size(mat2,2)   ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. m2) then
          print*, 'paste: rows of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1,n1+n2))
       mat1(:,1:n1)          = tmp(:,1:n1)
       mat1(:,n1+1_i4:n1+n2) = mat2(:,1:n2)
    else
       n1 = 0_i4
       m1 = m2

       allocate(mat1(m2,n2))
       mat1(:,n1+1_i4:n1+n2) = mat2(:,1:n2)
    end if

  END SUBROUTINE paste_i4_m_m

  SUBROUTINE paste_i8_m_s(mat1, sca2)

    implicit none

    integer(i8), dimension(:,:), allocatable, intent(inout)   :: mat1
    integer(i8),                              intent(in)      :: sca2

    ! local variables
    integer(i4)                               :: m1    ! dim1 of matrix
    integer(i4)                               :: n1    ! dim2 of matrix
    integer(i8), dimension(:,:), allocatable  :: tmp

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. 1_i4) then
          print*, 'paste: scalar paste to matrix only works with one-line matrix'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(1_i4,n1+1_i4))
       mat1(1,1:n1)          = tmp(1,1:n1)
       mat1(1,n1+1_i4)       = sca2
    else
       allocate(mat1(1_i4,1_i4))
       mat1(1,1) = sca2
    end if

  END SUBROUTINE paste_i8_m_s
  
  SUBROUTINE paste_i8_m_v(mat1, vec2)

    implicit none

    integer(i8), dimension(:,:), allocatable, intent(inout)   :: mat1
    integer(i8), dimension(:),                intent(in)      :: vec2

    ! local variables
    integer(i4)                             :: m1, m2    ! dim1 of matrixes
    integer(i4)                             :: n1, n2    ! dim2 of matrixes
    integer(i8), dimension(:,:), allocatable  :: tmp

    m2 = size(vec2,1)   ! rows
    n2 = 1_i4           ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. m2) then
          print*, 'paste: rows of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1,n1+n2))
       mat1(:,1:n1)          = tmp(:,1:n1)
       mat1(1:m2,n1+n2)      = vec2(1:m2)
    else
       n1 = 0_i4
       m1 = m2

       allocate(mat1(m2,n2))
       mat1(1:m2,n1+n2)      = vec2(1:m2)
    end if

  END SUBROUTINE paste_i8_m_v

  SUBROUTINE paste_i8_m_m(mat1, mat2)

    implicit none

    integer(i8), dimension(:,:), allocatable, intent(inout)   :: mat1
    integer(i8), dimension(:,:),              intent(in)      :: mat2

    ! local variables
    integer(i4)                             :: m1, m2    ! dim1 of matrixes
    integer(i4)                             :: n1, n2    ! dim2 of matrixes
    integer(i8), dimension(:,:), allocatable  :: tmp

    m2 = size(mat2,1)   ! rows
    n2 = size(mat2,2)   ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. m2) then
          print*, 'paste: rows of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1,n1+n2))
       mat1(:,1:n1)          = tmp(:,1:n1)
       mat1(:,n1+1_i4:n1+n2) = mat2(:,1:n2)
    else
       n1 = 0_i4
       m1 = m2

       allocate(mat1(m2,n2))
       mat1(:,n1+1_i4:n1+n2) = mat2(:,1:n2)
    end if

  END SUBROUTINE paste_i8_m_m

  SUBROUTINE paste_sp_m_s(mat1, sca2)

    implicit none

    real(sp), dimension(:,:), allocatable, intent(inout)   :: mat1
    real(sp),                              intent(in)      :: sca2

    ! local variables
    integer(i4)                               :: m1    ! dim1 of matrix
    integer(i4)                               :: n1    ! dim2 of matrix
    real(sp), dimension(:,:), allocatable  :: tmp

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. 1_i4) then
          print*, 'paste: scalar paste to matrix only works with one-line matrix'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(1_i4,n1+1_i4))
       mat1(1,1:n1)          = tmp(1,1:n1)
       mat1(1,n1+1_i4)       = sca2
    else
       allocate(mat1(1_i4,1_i4))
       mat1(1,1) = sca2
    end if

  END SUBROUTINE paste_sp_m_s
  
  SUBROUTINE paste_sp_m_v(mat1, vec2)

    implicit none

    real(sp), dimension(:,:), allocatable, intent(inout)   :: mat1
    real(sp), dimension(:),                intent(in)      :: vec2

    ! local variables
    integer(i4)                             :: m1, m2    ! dim1 of matrixes
    integer(i4)                             :: n1, n2    ! dim2 of matrixes
    real(sp), dimension(:,:), allocatable  :: tmp

    m2 = size(vec2,1)   ! rows
    n2 = 1_i4           ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. m2) then
          print*, 'paste: rows of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1,n1+n2))
       mat1(:,1:n1)          = tmp(:,1:n1)
       mat1(1:m2,n1+n2)      = vec2(1:m2)
    else
       n1 = 0_i4
       m1 = m2

       allocate(mat1(m2,n2))
       mat1(1:m2,n1+n2)      = vec2(1:m2)
    end if

  END SUBROUTINE paste_sp_m_v

  SUBROUTINE paste_sp_m_m(mat1, mat2)

    implicit none

    real(sp), dimension(:,:), allocatable, intent(inout)   :: mat1
    real(sp), dimension(:,:),              intent(in)      :: mat2

    ! local variables
    integer(i4)                             :: m1, m2    ! dim1 of matrixes
    integer(i4)                             :: n1, n2    ! dim2 of matrixes
    real(sp), dimension(:,:), allocatable  :: tmp

    m2 = size(mat2,1)   ! rows
    n2 = size(mat2,2)   ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. m2) then
          print*, 'paste: rows of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1,n1+n2))
       mat1(:,1:n1)          = tmp(:,1:n1)
       mat1(:,n1+1_i4:n1+n2) = mat2(:,1:n2)
    else
       n1 = 0_i4
       m1 = m2

       allocate(mat1(m2,n2))
       mat1(:,n1+1_i4:n1+n2) = mat2(:,1:n2)
    end if

  END SUBROUTINE paste_sp_m_m

  SUBROUTINE paste_dp_m_s(mat1, sca2)

    implicit none

    real(dp), dimension(:,:), allocatable, intent(inout)   :: mat1
    real(dp),                              intent(in)      :: sca2

    ! local variables
    integer(i4)                               :: m1    ! dim1 of matrix
    integer(i4)                               :: n1    ! dim2 of matrix
    real(dp), dimension(:,:), allocatable  :: tmp

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. 1_i4) then
          print*, 'paste: scalar paste to matrix only works with one-line matrix'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(1_i4,n1+1_i4))
       mat1(1,1:n1)          = tmp(1,1:n1)
       mat1(1,n1+1_i4)       = sca2
    else
       allocate(mat1(1_i4,1_i4))
       mat1(1,1) = sca2
    end if

  END SUBROUTINE paste_dp_m_s
  
  SUBROUTINE paste_dp_m_v(mat1, vec2)

    implicit none

    real(dp), dimension(:,:), allocatable, intent(inout)   :: mat1
    real(dp), dimension(:),                intent(in)      :: vec2

    ! local variables
    integer(i4)                             :: m1, m2    ! dim1 of matrixes
    integer(i4)                             :: n1, n2    ! dim2 of matrixes
    real(dp), dimension(:,:), allocatable  :: tmp

    m2 = size(vec2,1)   ! rows
    n2 = 1_i4           ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. m2) then
          print*, 'paste: rows of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1,n1+n2))
       mat1(:,1:n1)          = tmp(:,1:n1)
       mat1(1:m2,n1+n2)      = vec2(1:m2)
    else
       n1 = 0_i4
       m1 = m2

       allocate(mat1(m2,n2))
       mat1(1:m2,n1+n2)      = vec2(1:m2)
    end if

  END SUBROUTINE paste_dp_m_v

  SUBROUTINE paste_dp_m_m(mat1, mat2)

    implicit none

    real(dp), dimension(:,:), allocatable, intent(inout)   :: mat1
    real(dp), dimension(:,:),              intent(in)      :: mat2

    ! local variables
    integer(i4)                             :: m1, m2    ! dim1 of matrixes
    integer(i4)                             :: n1, n2    ! dim2 of matrixes
    real(dp), dimension(:,:), allocatable  :: tmp

    m2 = size(mat2,1)   ! rows
    n2 = size(mat2,2)   ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. m2) then
          print*, 'paste: rows of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1,n1+n2))
       mat1(:,1:n1)          = tmp(:,1:n1)
       mat1(:,n1+1_i4:n1+n2) = mat2(:,1:n2)
    else
       n1 = 0_i4
       m1 = m2

       allocate(mat1(m2,n2))
       mat1(:,n1+1_i4:n1+n2) = mat2(:,1:n2)
    end if

  END SUBROUTINE paste_dp_m_m

  SUBROUTINE paste_char_m_s(mat1, sca2)

    implicit none

    character(len=*), dimension(:,:), allocatable, intent(inout)   :: mat1
    character(len=*),                              intent(in)      :: sca2

    ! local variables
    integer(i4)                                  :: m1    ! dim1 of matrix
    integer(i4)                                  :: n1    ! dim2 of matrix
    character(256), dimension(:,:), allocatable  :: tmp

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. 1_i4) then
          print*, 'paste: scalar paste to matrix only works with one-line matrix'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(1_i4,n1+1_i4))
       mat1(1,1:n1)          = tmp(1,1:n1)
       mat1(1,n1+1_i4)       = sca2
    else
       allocate(mat1(1_i4,1_i4))
       mat1(1,1) = sca2
    end if

  END SUBROUTINE paste_char_m_s
  
  SUBROUTINE paste_char_m_v(mat1, vec2)

    implicit none

    character(len=*), dimension(:,:), allocatable, intent(inout)   :: mat1
    character(len=*), dimension(:),                intent(in)      :: vec2

    ! local variables
    integer(i4)                                  :: m1, m2    ! dim1 of matrixes
    integer(i4)                                  :: n1, n2    ! dim2 of matrixes
    character(256), dimension(:,:), allocatable  :: tmp

    m2 = size(vec2,1)   ! rows
    n2 = 1_i4           ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. m2) then
          print*, 'paste: rows of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1,n1+n2))
       mat1(:,1:n1)          = tmp(:,1:n1)
       mat1(1:m2,n1+n2)      = vec2(1:m2)
    else
       n1 = 0_i4
       m1 = m2

       allocate(mat1(m2,n2))
       mat1(1:m2,n1+n2)      = vec2(1:m2)
    end if

  END SUBROUTINE paste_char_m_v

  SUBROUTINE paste_char_m_m(mat1, mat2)

    implicit none

    character(len=*), dimension(:,:), allocatable, intent(inout)   :: mat1
    character(len=*), dimension(:,:),              intent(in)      :: mat2

    ! local variables
    integer(i4)                                  :: m1, m2    ! dim1 of matrixes
    integer(i4)                                  :: n1, n2    ! dim2 of matrixes
    character(256), dimension(:,:), allocatable  :: tmp

    m2 = size(mat2,1)   ! rows
    n2 = size(mat2,2)   ! columns

    if (allocated(mat1)) then
       m1 = size(mat1,1)   ! rows
       n1 = size(mat1,2)   ! columns
       if (m1 .ne. m2) then
          print*, 'paste: rows of matrix1 and matrix2 are unequal : (',m1,',',n1,')  and  (',m2,',',n2,')'
          STOP 
       end if
       ! save mat1
       allocate(tmp(m1,n1))
       tmp=mat1
       deallocate(mat1)

       allocate(mat1(m1,n1+n2))
       mat1(:,1:n1)          = tmp(:,1:n1)
       mat1(:,n1+1_i4:n1+n2) = mat2(:,1:n2)
    else
       n1 = 0_i4
       m1 = m2

       allocate(mat1(m2,n2))
       mat1(:,n1+1_i4:n1+n2) = mat2(:,1:n2)
    end if

  END SUBROUTINE paste_char_m_m


END MODULE mo_append
