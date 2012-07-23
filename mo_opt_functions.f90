MODULE mo_opt_functions

  ! This modules provides test functions for minimisation routines

  ! Written, Jul 2012 Matthias Cuntz

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

  use mo_kind, only: i4, dp

  IMPLICIT NONE

  PRIVATE

  ! ------------------------------------------------------------------
  ! test_min package of John Burkardt
  PUBLIC :: quadratic                         ! Simple quadratic, (x-2)^2+1.
  PUBLIC :: quadratic_exponential             ! Quadratic plus exponential, x^2 + e^(-x).
  PUBLIC :: quartic                           ! Quartic, x^4 + 2x^2 + x + 3.
  PUBLIC :: steep_valley                      ! Steep valley, e^x + 1/(100x).
  PUBLIC :: steep_valley2                     ! Steep valley, e^x - 2x + 1/(100x) - 1/(1000000x^2)
  PUBLIC :: dying_snake                       ! The dying snake, ( x + sin(x) ) * e^(-x^2).
  PUBLIC :: thin_pole                         ! The "Thin Pole", x^2+1+log((pi-x)^2)/pi^4
  PUBLIC :: oscillatory_parabola              ! The oscillatory parabola
  PUBLIC :: cosine_combo                      ! The cosine combo
  PUBLIC :: abs1                              ! 1 + |3x-1|
  ! ------------------------------------------------------------------
  ! test_opt package of John Burkardt
  PUBLIC :: fletcher_powell_helical_valley    ! The Fletcher-Powell helical valley function, N = 3.
  PUBLIC :: biggs_exp6                        ! The Biggs EXP6 function, N = 6.
  PUBLIC :: gaussian                          ! The Gaussian function, N = 3.
  PUBLIC :: powell_badly_scaled               ! The Powell badly scaled function, N = 2.
  PUBLIC :: box_3dimensional                  ! The Box 3-dimensional function, N = 3.
  PUBLIC :: variably_dimensioned              ! The variably dimensioned function, 1 <= N.
  PUBLIC :: watson                            ! The Watson function, 2 <= N.
  PUBLIC :: penalty1                          ! The penalty function #1, 1 <= N.
  PUBLIC :: penalty2                          ! The penalty function #2, 1 <= N.
  PUBLIC :: brown_badly_scaled                ! The Brown badly scaled function, N = 2.
  PUBLIC :: brown_dennis                      ! The Brown and Dennis function, N = 4.
  PUBLIC :: gulf_rd                           ! The Gulf R&D function, N = 3.
  PUBLIC :: trigonometric                     ! The trigonometric function, 1 <= N.
  PUBLIC :: ext_rosenbrock_parabolic_valley   ! The extended Rosenbrock parabolic valley function, 1 <= N.
  PUBLIC :: ext_powell_singular_quartic       ! The extended Powell singular quartic function, 4 <= N.
  PUBLIC :: beale                             ! The Beale function, N = 2.
  PUBLIC :: wood                              ! The Wood function, N = 4.
  PUBLIC :: chebyquad                         ! The Chebyquad function, 1 <= N.
  PUBLIC :: leon_cubic_valley                 ! Leon''s cubic valley function, N = 2.
  PUBLIC :: gregory_karney_tridiagonal_matrix ! Gregory and Karney''s Tridiagonal Matrix Function, 1 <= N.
  PUBLIC :: hilbert                           ! The Hilbert function, 1 <= N.
  PUBLIC :: de_jong_f1                        ! The De Jong Function F1, N = 3.
  PUBLIC :: de_jong_f2                        ! The De Jong Function F2, N = 2.
  PUBLIC :: de_jong_f3                        ! The De Jong Function F3 (discontinuous), N = 5.
  PUBLIC :: de_jong_f4                        ! The De Jong Function F4 (Gaussian noise), N = 30. 
  PUBLIC :: de_jong_f5                        ! The De Jong Function F5, N = 2.
  PUBLIC :: schaffer_f6                       ! The Schaffer Function F6, N = 2.
  PUBLIC :: schaffer_f7                       ! The Schaffer Function F7, N = 2. 
  PUBLIC :: goldstein_price_polynomial        ! The Goldstein Price Polynomial, N = 2. 
  PUBLIC :: branin_rcos                       ! The Branin RCOS Function, N = 2.
  PUBLIC :: shekel_sqrn5                      ! The Shekel SQRN5 Function, N = 4.  
  PUBLIC :: shekel_sqrn7                      ! The Shekel SQRN7 Function, N = 4. 
  PUBLIC :: shekel_sqrn10                     ! The Shekel SQRN10 Function, N = 4.
  PUBLIC :: six_nump_camel_back_polynomial    ! The Six-Hump Camel-Back Polynomial, N = 2.
  PUBLIC :: schubert                          ! The Shubert Function, N = 2.
  PUBLIC :: stuckman                          ! The Stuckman Function, N = 2.
  PUBLIC :: easom                             ! The Easom Function, N = 2.
  PUBLIC :: bohachevsky1                      ! The Bohachevsky Function #1, N = 2.
  PUBLIC :: bohachevsky2                      ! The Bohachevsky Function #2, N = 2.
  PUBLIC :: bohachevsky3                      ! The Bohachevsky Function #3, N = 2.
  PUBLIC :: colville_polynomial               ! The Colville Polynomial, N = 4.
  PUBLIC :: powell3d                          ! The Powell 3D function, N = 3.
  PUBLIC :: himmelblau                        ! The Himmelblau function, N = 2.
  ! ------------------------------------------------------------------
  ! Standard test of DDS of Bryan Tolson
  PUBLIC :: griewank                          ! Griewank function
  ! ------------------------------------------------------------------
  ! Miscellaneous functions
  PUBLIC :: rosenbrock                        ! Rosenbrock parabolic valley

CONTAINS

  ! ------------------------------------------------------------------
  !
  !  Simple quadratic, (x-2)^2+1
  !  Solution: x = 2.0
  !  With Brent method:
  !   A,  X*,  B:   1.9999996       2.0000000       2.0000004
  !  FA, FX*, FB:   1.0000000       1.0000000       1.0000000
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    25 February 2002
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Input, real(dp) X, the argument of the objective function.
  !
  function quadratic( x )

    implicit none

    real(dp), intent(in) :: x
    real(dp) :: quadratic

    quadratic = ( x - 2.0_dp ) * ( x - 2.0_dp ) + 1.0_dp

  end function quadratic

  ! ------------------------------------------------------------------
  !
  !  Quadratic plus exponential, x^2 + e^(-x)
  !  Solution: x = 0.35173370
  !  With Brent method:
  !   A,  X*,  B:  0.35173337      0.35173370      0.35173404
  !  FA, FX*, FB:  0.82718403      0.82718403      0.82718403
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    26 February 2002
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    LE Scales,
  !    Introduction to Non-Linear Optimization,
  !    Springer, 1985.
  !
  !  Parameters:
  !
  !    Input, real(dp) X, the argument of the objective function.
  !

  function quadratic_exponential( x )

    implicit none

    real(dp), intent(in) :: x
    real(dp) :: quadratic_exponential

    quadratic_exponential = x * x + exp ( - x )

  end function quadratic_exponential

  ! ------------------------------------------------------------------
  !
  !  Quartic, x^4 + 2x^2 + x + 3
  !  Solution: x = -0.23673291
  !  With Brent method:
  !   A,  X*,  B: -0.23673324     -0.23673291     -0.23673257
  !  FA, FX*, FB:   2.8784928       2.8784928       2.8784928
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    26 February 2002
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    LE Scales,
  !    Introduction to Non-Linear Optimization,
  !    Springer, 1985.
  !
  !  Parameters:
  !
  !    Input, real(dp) X, the argument of the objective function.
  !

  function quartic( x )

    implicit none

    real(dp), intent(in) :: x
    real(dp) :: quartic

    quartic = ( ( x * x + 2.0_dp ) * x + 1.0_dp ) * x + 3.0_dp

  end function quartic

  ! ------------------------------------------------------------------
  !
  !  Steep valley, e^x + 1/(100x)
  !  Solution: x = 0.95344636E-01
  !  With Brent method:
  !   A,  X*,  B:  0.95344301E-01  0.95344636E-01  0.95344971E-01
  !  FA, FX*, FB:   1.2049206       1.2049206       1.2049206
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    26 February 2002
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    LE Scales,
  !    Introduction to Non-Linear Optimization,
  !    Springer, 1985.
  !
  !  Parameters:
  !
  !    Input, real(dp) X, the argument of the objective function.
  !

  function steep_valley( x )

    implicit none

    real(dp), intent(in) :: x
    real(dp) :: steep_valley

    steep_valley = exp ( x ) + 0.01_dp / x

  end function steep_valley

  ! ------------------------------------------------------------------
  !
  !  Steep valley2, e^x - 2x + 1/(100x) - 1/(1000000x^2)
  !  Solution: x = 0.70320487
  !  With Brent method:
  !   A,  X*,  B:  0.70320453      0.70320487      0.70320521
  !  FA, FX*, FB:  0.62802572      0.62802572      0.62802572
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    26 February 2002
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    LE Scales,
  !    Introduction to Non-Linear Optimization,
  !    Springer, 1985.
  !
  !  Parameters:
  !
  !    Input, real(dp) X, the argument of the objective function.
  !

  function steep_valley2( x )

    implicit none

    real(dp), intent(in) :: x
    real(dp) :: steep_valley2

    steep_valley2 = exp( x ) - 2.0_dp * x + 0.01_dp / x - 0.000001_dp / x / x

  end function steep_valley2

  ! ------------------------------------------------------------------
  !
  !  The dying snake, ( x + sin(x) ) * e^(-x^2)
  !  Solution: x = -0.67957876
  !  With Brent method:
  !   A,  X*,  B: -0.67957911     -0.67957876     -0.67957842
  !  FA, FX*, FB: -0.82423940     -0.82423940     -0.82423940
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    26 February 2002
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Richard Brent,
  !    Algorithms for Minimization Without Derivatives,
  !    Prentice Hall 1973,
  !    Reprinted Dover, 2002
  !
  !  Parameters:
  !
  !    Input, real(dp) X, the argument of the objective function.
  !

  function dying_snake(x)

    implicit none

    real(dp), intent(in) :: x
    real(dp) :: dying_snake

    dying_snake = ( x + sin ( x ) ) * exp ( - x * x )

  end function dying_snake

  ! ------------------------------------------------------------------
  !
  !  The "Thin Pole", x^2+1+log((pi-x)^2)/pi^4
  !  Solution: x = 2.0
  !  With Brent method:
  !   A,  X*,  B:   2.0000000       2.0000007       2.0000011
  !  FA, FX*, FB:   13.002719       13.002727       13.002732
  !
  !  Discussion:
  !
  !    This function looks positive, but has a pole at x = pi,
  !    near which f -> negative infinity, and has two zeroes nearby.
  !    None of this will show up computationally.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    19 February 2003
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Arnold Krommer, Christoph Ueberhuber,
  !    Numerical Integration on Advanced Systems,
  !    Springer, 1994, pages 185-186.
  !
  !  Parameters:
  !
  !    Input, real(dp) X, the argument of the objective function.
  !

  function thin_pole(x)

    use mo_constants, only: pi_dp

    implicit none

    real(dp), intent(in) :: x
    real(dp) :: thin_pole

    if ( x == pi_dp ) then
       thin_pole = - 10000.0_dp
    else
       thin_pole = 3.0_dp * x * x + 1.0_dp + ( log ( ( x - pi_dp ) * ( x - pi_dp ) ) ) / pi_dp**4
    end if

  end function thin_pole

  ! ------------------------------------------------------------------
  !
  !  The oscillatory parabola x^2 - 10*sin(x^2-3x+2)
  !  Solution: x = -1.3384521
  !  With Brent method:
  !   A,  X*,  B:  -1.3384524      -1.3384521      -1.3384517
  !  FA, FX*, FB:  -8.1974224      -8.1974224      -8.1974224
  !
  !  Discussion:
  !
  !    This function is oscillatory, with many local minima.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    25 January 2008
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Input, real(dp) X, the argument of the objective function.
  !

  function oscillatory_parabola(x)

    implicit none

    real(dp), intent(in) :: x
    real(dp) :: oscillatory_parabola

    oscillatory_parabola = x * x - 10.0_dp * sin ( x * x - 3.0_dp * x + 2.0_dp )

  end function oscillatory_parabola

  ! ------------------------------------------------------------------
  !
  !  The cosine combo cos(x)+5cos(1.6x)-2cos(2x)+5cos(4.5x)+7cos(9x)
  !  Solution: x = 1.0167821
  !  With Brent method:
  !   A,  X*,  B:   1.0167817       1.0167821       1.0167824
  !  FA, FX*, FB:  -6.2827509      -6.2827509      -6.2827509
  !
  !  Discussion:
  !
  !    This function is oscillatory.
  !
  !    The function has a local minimum at 1.7922 whose function value is
  !    very close to the minimum value.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    09 February 2009
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Isabel Beichl, Dianne O'Leary, Francis Sullivan,
  !    Monte Carlo Minimization and Counting: One, Two, Too Many,
  !    Computing in Science and Engineering,
  !    Volume 9, Number 1, January/February 2007.
  !
  !    Dianne O'Leary,
  !    Scientific Computing with Case Studies,
  !    SIAM, 2008,
  !    ISBN13: 978-0-898716-66-5,
  !    LC: QA401.O44.
  !
  !  Parameters:
  !
  !    Input, real(dp) X, the argument of the objective function.
  !

  function cosine_combo(x)

    implicit none

    real(dp), intent(in) :: x
    real(dp) :: cosine_combo

    cosine_combo =   cos (           x ) &
         + 5.0_dp * cos ( 1.6_dp * x ) &
         - 2.0_dp * cos ( 2.0_dp * x ) &
         + 5.0_dp * cos ( 4.5_dp * x ) &
         + 7.0_dp * cos ( 9.0_dp * x )

  end function cosine_combo

  ! ------------------------------------------------------------------
  !
  !  1 + |3x-1|
  !  Solution: x = 1./3.
  !  With Brent method:
  !   A,  X*,  B:  0.33333299      0.33333351      0.33333385
  !  FA, FX*, FB:   1.0000010       1.0000005       1.0000015
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    03 February 2012
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Input, real(dp) X, the argument of the objective function.
  !

  function abs1(x)

    implicit none

    real(dp), intent(in) :: x
    real(dp) :: abs1

    abs1 = 1.0_dp + abs ( 3.0_dp * x - 1.0_dp )

  end function abs1

  ! ------------------------------------------------------------------
  !
  !  R8_AINT truncates an R8 argument to an integer.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    18 October 2011
  !
  !  Author:
  !
  !    John Burkardt.
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Input, real(dp) X, the argument.
  !
  !    Output, real(dp) VALUE, the truncated version of X.
  !

  function r8_aint( x )

    implicit none

    real(dp) :: r8_aint
    real(dp) :: val
    real(dp) :: x

    if ( x < 0.0_dp ) then
       val = -int( abs ( x ) )
    else
       val =  int( abs ( x ) )
    end if

    r8_aint = val

  end function r8_aint

  !*****************************************************************************80
  !
  !! NORMAL_01_SAMPLE samples the standard Normal PDF.
  !
  !  Discussion:
  !
  !    The standard normal distribution has mean 0 and standard
  !    deviation 1.
  !
  !  Method:
  !
  !    The Box-Muller method is used.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    01 December 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Output, real(dp) X, a sample of the PDF.
  !

  subroutine normal_01_sample ( x )

    use mo_constants, only: pi_dp

    implicit none

    integer(i4), save :: iset = -1
    real(dp) v1
    real(dp) v2
    real(dp) x
    real(dp), save :: xsave = 0.0_dp

    if ( iset == -1 ) then
       call random_seed ( )
       iset = 0
    end if

    if ( iset == 0 ) then

       call random_number ( harvest = v1 )

       if ( v1 <= 0.0_dp ) then
          write ( *, '(a)' ) ' '
          write ( *, '(a)' ) 'NORMAL_01_SAMPLE - Fatal error!'
          write ( *, '(a)' ) '  V1 <= 0.'
          write ( *, '(a,g14.6)' ) '  V1 = ', v1
          stop
       end if

       call random_number ( harvest = v2 )

       if ( v2 <= 0.0_dp ) then
          write ( *, '(a)' ) ' '
          write ( *, '(a)' ) 'NORMAL_01_SAMPLE - Fatal error!'
          write ( *, '(a)' ) '  V2 <= 0.'
          write ( *, '(a,g14.6)' ) '  V2 = ', v2
          stop
       end if

       x = sqrt ( - 2.0_dp * log ( v1 ) ) * cos ( 2.0_dp * pi_dp * v2 )

       xsave = sqrt ( - 2.0_dp * log ( v1 ) ) * sin ( 2.0_dp * PI_dp * v2 )

       iset = 1

    else

       x = xsave
       iset = 0

    end if

    return
  end subroutine normal_01_sample

  ! ------------------------------------------------------------------
  !
  ! The Fletcher-Powell helical valley function, N = 3.
  ! Solution: x(1:3) = (/ 1.0_dp, 0.0_dp, 0.0_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    15 March 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Richard Brent,
  !    Algorithms for Minimization with Derivatives,
  !    Dover, 2002,
  !    ISBN: 0-486-41998-3,
  !    LC: QA402.5.B74.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function fletcher_powell_helical_valley(x)

    use mo_constants, only: pi_dp

    implicit none

    !    integer(i4) :: n

    real(dp) :: fletcher_powell_helical_valley
    real(dp) :: th
    real(dp), dimension(:), intent(in) :: x

    if ( 0.0_dp < x(1) ) then
       th = 0.5_dp * atan ( x(2) / x(1) ) / pi_dp
    else if ( x(1) < 0.0_dp ) then
       th = 0.5_dp * atan ( x(2) / x(1) ) / pi_dp + 0.5_dp
    else if ( 0.0_dp < x(2) ) then
       th = 0.25_dp
    else if ( x(2) < 0.0_dp ) then
       th = - 0.25_dp
    else
       th = 0.0_dp
    end if
    !call p01_th ( x, th )

    fletcher_powell_helical_valley = 100.0_dp * ( x(3) - 10.0_dp * th )**2 &
         + 100.0_dp * ( sqrt ( x(1) * x(1) + x(2) * x(2) ) - 1.0_dp )**2 &
         + x(3) * x(3)

  end function fletcher_powell_helical_valley

  ! ------------------------------------------------------------------
  !
  ! The Biggs EXP6 function, N = 6.
  ! Solution: x(1:6) = (/ 1.0_dp, 10.0_dp, 1.0_dp, 5.0_dp, 4.0_dp, 3.0_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    04 May 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function biggs_exp6(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: c
    real(dp) :: biggs_exp6
    real(dp) :: fi
    integer(i4) ::i
    real(dp), dimension(:), intent(in) :: x

    biggs_exp6 = 0.0_dp

    do i = 1, 13

       c = - real ( i, dp ) / 10.0_dp

       fi = x(3)     * exp ( c * x(1) )         - x(4) * exp ( c * x(2) ) &
            + x(6)     * exp ( c * x(5) )         -        exp ( c ) &
            + 5.0_dp  * exp ( 10.0_dp * c ) - 3.0_dp  * exp ( 4.0_dp * c )

       biggs_exp6 = biggs_exp6 + fi * fi

    end do

  end function biggs_exp6

  ! ------------------------------------------------------------------
  !
  ! The Gaussian function, N = 3.
  ! Solution: x(1:n) = 0.0_dp
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    24 March 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function gaussian(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: gaussian
    integer(i4) ::i
    real(dp) :: t
    real(dp), dimension(:), intent(in) :: x
    real(dp) :: y(15)

    y(1:15) = (/ 0.0009_dp, 0.0044_dp, 0.0175_dp, 0.0540_dp, 0.1295_dp, &
         0.2420_dp, 0.3521_dp, 0.3989_dp, 0.3521_dp, 0.2420_dp, &
         0.1295_dp, 0.0540_dp, 0.0175_dp, 0.0044_dp, 0.0009_dp /)

    gaussian = 0.0_dp

    do i = 1, 15

       t = x(1) * exp ( - 0.5_dp * x(2) * &
            ( 3.5_dp - 0.5_dp * real ( i - 1, dp ) - x(3) )**2 ) - y(i)

       gaussian = gaussian + t * t

    end do

  end function gaussian

  ! ------------------------------------------------------------------
  !
  ! The Powell badly scaled function, N = 2.
  ! Solution: x(1:2) = (/ 1.098159D-05, 9.106146_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    04 May 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Richard Brent,
  !    Algorithms for Minimization with Derivatives,
  !    Dover, 2002,
  !    ISBN: 0-486-41998-3,
  !    LC: QA402.5.B74.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function powell_badly_scaled(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: powell_badly_scaled
    real(dp) :: f1
    real(dp) :: f2
    real(dp), dimension(:), intent(in) :: x

    f1 = 10000.0_dp * x(1) * x(2) - 1.0_dp
    f2 = exp ( - x(1) ) + exp ( - x(2) ) - 1.0001_dp

    powell_badly_scaled = f1 * f1 + f2 * f2

  end function powell_badly_scaled

  ! ------------------------------------------------------------------
  !
  ! The Box 3-dimensional function, N = 3.
  ! Solution: x(1:3) = (/ 1.0_dp, 10.0_dp, 1.0_dp /)
  !
  !  Discussion:
  !
  !    The function is formed by the sum of squares of 10 separate terms.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    04 May 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function box_3dimensional(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: c
    real(dp) :: box_3dimensional
    real(dp) :: fi
    integer(i4) ::i
    real(dp), dimension(:), intent(in) :: x

    box_3dimensional = 0.0_dp

    do i = 1, 10

       c = - real ( i, dp ) / 10.0_dp

       fi = exp ( c * x(1) ) - exp ( c * x(2) ) - x(3) * &
            ( exp ( c ) - exp ( 10.0_dp * c ) )

       box_3dimensional = box_3dimensional + fi * fi

    end do

  end function box_3dimensional

  ! ------------------------------------------------------------------
  !
  ! The variably dimensioned function, 1 <= N.
  ! Solution: x(1:n) = 1.0_dp
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    05 May 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Richard Brent,
  !    Algorithms for Minimization with Derivatives,
  !    Dover, 2002,
  !    ISBN: 0-486-41998-3,
  !    LC: QA402.5.B74.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function variably_dimensioned(x)

    implicit none

    integer(i4) :: n

    real(dp) :: variably_dimensioned
    real(dp) :: f1
    real(dp) :: f2
    integer(i4) ::i
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    f1 = 0.0_dp
    do i = 1, n
       f1 = f1 + real ( i, dp ) * ( x(i) - 1.0_dp )
    end do

    f2 = 0.0_dp
    do i = 1, n
       f2 = f2 + ( x(i) - 1.0_dp )**2
    end do

    variably_dimensioned = f1 * f1 * ( 1.0_dp + f1 * f1 ) + f2

  end function variably_dimensioned

  ! ------------------------------------------------------------------
  !
  ! The Watson function, 2 <= N.
  ! Solution: n==6: x(1:n) = (/ -0.015725_dp, 1.012435_dp, -0.232992_dp,
  !                             1.260430_dp, -1.513729_dp, 0.992996_dp /)
  !           n==9  x(1:n) = (/ -0.000015_dp, 0.999790_dp, 0.014764_dp,
  !                              0.146342_dp, 1.000821_dp, -2.617731_dp,
  !                              4.104403_dp, -3.143612_dp, 1.052627_dp /)
  !           else unknown
  !
  !  Discussion:
  !
  !    For N = 9, the problem of minimizing the Watson function is
  !    very ill conditioned.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    15 March 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Richard Brent,
  !    Algorithms for Minimization with Derivatives,
  !    Dover, 2002,
  !    ISBN: 0-486-41998-3,
  !    LC: QA402.5.B74.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function watson(x)

    implicit none

    integer(i4) :: n

    real(dp) :: d
    real(dp) :: watson
    integer(i4) ::i
    integer(i4) ::j
    real(dp) :: s1
    real(dp) :: s2
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    watson = 0.0_dp
    do i = 1, 29

       s1 = 0.0_dp
       d = 1.0_dp
       do j = 2, n
          s1 = s1 + real ( j - 1, dp ) * d * x(j)
          d = d * real ( i, dp ) / 29.0_dp
       end do

       s2 = 0.0_dp
       d = 1.0_dp
       do j = 1, n
          s2 = s2 + d * x(j)
          d = d * real ( i, dp ) / 29.0_dp
       end do

       watson = watson + ( s1 - s2 * s2 - 1.0_dp )**2

    end do

    watson = watson + x(1) * x(1) + ( x(2) - x(1) * x(1) - 1.0_dp )**2

  end function watson

  ! ------------------------------------------------------------------
  !
  ! The penalty function #1, 1 <= N.
  ! Solution: x(1:n) = 0.0_dp
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    15 March 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function penalty1(x)

    implicit none

    integer(i4) :: n

    real(dp), parameter :: ap = 0.00001_dp
    real(dp) :: penalty1
    real(dp) :: t1
    real(dp) :: t2
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    t1 = - 0.25_dp + sum ( x(1:n)**2 )

    t2 = sum ( ( x(1:n) - 1.0_dp )**2 )

    penalty1 = ap * t2 + t1 * t1

  end function penalty1

  ! ------------------------------------------------------------------
  !
  ! The penalty function #2, 1 <= N.
  ! Solution: x(1:n) = 0.0_dp
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    15 March 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function penalty2(x)

    implicit none

    integer(i4) :: n

    real(dp), parameter :: ap = 0.00001_dp
    real(dp) :: d2
    real(dp) :: penalty2
    integer(i4) ::j
    real(dp) :: s1
    real(dp) :: s2
    real(dp) :: s3
    real(dp) :: t1
    real(dp) :: t2
    real(dp) :: t3
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    t1 = -1.0_dp
    t2 = 0.0_dp
    t3 = 0.0_dp
    d2 = 1.0_dp
    s2 = 0.0_dp
    do j = 1, n
       t1 = t1 + real ( n - j + 1, dp ) * x(j)**2
       s1 = exp ( x(j) / 10.0_dp )
       if ( 1 < j ) then
          s3 = s1 + s2 - d2 * ( exp ( 0.1_dp ) + 1.0_dp )
          t2 = t2 + s3 * s3
          t3 = t3 + ( s1 - 1.0_dp / exp ( 0.1_dp ) )**2
       end if
       s2 = s1
       d2 = d2 * exp ( 0.1_dp )
    end do

    penalty2 = ap * ( t2 + t3 ) + t1 * t1 + ( x(1) - 0.2_dp )**2

  end function penalty2

  ! ------------------------------------------------------------------
  !
  ! The Brown badly scaled function, N = 2.
  ! Solution: x(1:2) = (/ 1.0D+06, 2.0D-06 /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    15 March 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function brown_badly_scaled(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: brown_badly_scaled
    real(dp), dimension(:), intent(in) :: x

    brown_badly_scaled = ( x(1) - 1000000.0_dp )**2 &
         + ( x(2) - 0.000002_dp )**2 &
         + ( x(1) * x(2) - 2.0_dp )**2

  end function brown_badly_scaled

  ! ------------------------------------------------------------------
  !
  ! The Brown and Dennis function, N = 4.
  ! Solution: x(1:n) = (/ -11.5844_dp, 13.1999_dp, -0.406200_dp, 0.240998_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    05 May 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function brown_dennis(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: c
    real(dp) :: brown_dennis
    real(dp) :: f1
    real(dp) :: f2
    integer(i4) ::i
    real(dp), dimension(:), intent(in) :: x

    brown_dennis = 0.0_dp

    do i = 1, 20

       c = real ( i, dp ) / 5.0_dp
       f1 = x(1) + c * x(2) - exp ( c )
       f2 = x(3) + sin ( c ) * x(4) - cos ( c )

       brown_dennis = brown_dennis + f1**4 + 2.0_dp * f1 * f1 * f2 * f2 + f2**4

    end do

  end function brown_dennis

  ! ------------------------------------------------------------------
  !
  ! The Gulf R&D function, N = 3.
  ! Solution: x(1:3) = (/ 50.0_dp, 25.0_dp, 1.5_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    15 March 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function gulf_rd(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: arg
    real(dp) :: gulf_rd
    integer(i4) ::i
    real(dp) :: r
    real(dp) :: t
    real(dp), dimension(:), intent(in) :: x

    gulf_rd = 0.0_dp
    do i = 1, 99
       arg = real ( i, dp ) / 100.0_dp
       r = abs ( ( - 50.0_dp * log ( arg ) )**( 2.0_dp / 3.0_dp ) &
            + 25.0_dp - x(2) )

       t = exp ( - r**x(3) / x(1) ) - arg

       gulf_rd = gulf_rd + t * t

    end do

  end function gulf_rd

  ! ------------------------------------------------------------------
  !
  ! The trigonometric function, 1 <= N.
  ! Solution: x(1:n) = 0.0_dp
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    15 March 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function trigonometric(x)

    implicit none

    integer(i4) :: n

    real(dp) :: trigonometric
    integer(i4) ::j
    real(dp) :: s1
    real(dp) :: t
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    s1 = sum ( cos ( x(1:n) ) )

    trigonometric = 0.0_dp
    do j = 1, n
       t = real ( n + j, dp ) - sin ( x(j) ) &
            - s1 - real ( j, dp ) * cos ( x(j) )
       trigonometric = trigonometric + t * t
    end do

  end function trigonometric

  ! ------------------------------------------------------------------
  !
  ! The extended Rosenbrock parabolic valley function, 1 <= N.
  ! Solution: x(1:n) = 1.0_dp
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    15 March 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Richard Brent,
  !    Algorithms for Minimization with Derivatives,
  !    Dover, 2002,
  !    ISBN: 0-486-41998-3,
  !    LC: QA402.5.B74.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function ext_rosenbrock_parabolic_valley(x)

    implicit none

    integer(i4) :: n

    real(dp) :: ext_rosenbrock_parabolic_valley
    integer(i4) ::j
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    ext_rosenbrock_parabolic_valley = 0.0_dp
    do j = 1, n
       if ( mod ( j, 2 ) == 1 ) then
          ext_rosenbrock_parabolic_valley = ext_rosenbrock_parabolic_valley + ( 1.0_dp - x(j) )**2
       else
          ext_rosenbrock_parabolic_valley = ext_rosenbrock_parabolic_valley + 100.0_dp * ( x(j) - x(j-1) * x(j-1) )**2
       end if
    end do

  end function ext_rosenbrock_parabolic_valley

  ! ------------------------------------------------------------------
  !
  ! The extended Powell singular quartic function, 4 <= N.
  ! Solution: x(1:n) = 0.0_dp
  !
  !  Discussion:
  !
  !    The Hessian matrix is doubly singular at the minimizer,
  !    suggesting that most optimization routines will experience
  !    a severe slowdown in convergence.
  !
  !    The problem is usually only defined for N being a multiple of 4.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    05 May 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Richard Brent,
  !    Algorithms for Minimization with Derivatives,
  !    Dover, 2002,
  !    ISBN: 0-486-41998-3,
  !    LC: QA402.5.B74.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function ext_powell_singular_quartic(x)

    implicit none

    integer(i4) :: n

    real(dp) :: ext_powell_singular_quartic
    real(dp) :: f1
    real(dp) :: f2
    real(dp) :: f3
    real(dp) :: f4
    integer(i4) ::j
    real(dp), dimension(:), intent(in) :: x
    real(dp) :: xjp1
    real(dp) :: xjp2
    real(dp) :: xjp3

    n = size(x)
    ext_powell_singular_quartic = 0.0_dp

    do j = 1, n, 4

       if ( j + 1 <= n ) then
          xjp1 = x(j+1)
       else
          xjp1 = 0.0_dp
       end if

       if ( j + 2 <= n ) then
          xjp2 = x(j+2)
       else
          xjp2 = 0.0_dp
       end if

       if ( j + 3 <= n ) then
          xjp3 = x(j+3)
       else
          xjp3 = 0.0_dp
       end if

       f1 = x(j) + 10.0_dp * xjp1

       if ( j + 1 <= n ) then
          f2 = xjp2 - xjp3
       else
          f2 = 0.0_dp
       end if

       if ( j + 2 <= n ) then
          f3 = xjp1 - 2.0_dp * xjp2
       else
          f3 = 0.0_dp
       end if

       if ( j + 3 <= n ) then
          f4 = x(j) - xjp3
       else
          f4 = 0.0_dp
       end if

       ext_powell_singular_quartic = ext_powell_singular_quartic +            f1 * f1 &
            +  5.0_dp * f2 * f2 &
            +            f3 * f3 * f3 * f3 &
            + 10.0_dp * f4 * f4 * f4 * f4

    end do

  end function ext_powell_singular_quartic

  ! ------------------------------------------------------------------
  !
  ! The Beale function, N = 2.
  ! Solution: x(1:2) = (/ 3.0_dp, 0.5_dp /)
  !
  !  Discussion:
  !
  !    This function has a valley approaching the line X(2) = 1.
  !
  !    The function has a global minimizer:
  !
  !      X(*) = ( 3.0, 0.5 ), F(X*) = 0.0.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    28 January 2008
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Evelyn Beale,
  !    On an Iterative Method for Finding a Local Minimum of a Function
  !    of More than One Variable,
  !    Technical Report 25,
  !    Statistical Techniques Research Group,
  !    Princeton University, 1958.
  !
  !    Richard Brent,
  !    Algorithms for Minimization with Derivatives,
  !    Dover, 2002,
  !    ISBN: 0-486-41998-3,
  !    LC: QA402.5.B74.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function beale(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: beale
    real(dp) :: f1
    real(dp) :: f2
    real(dp) :: f3
    real(dp), dimension(:), intent(in) :: x

    f1 = 1.5_dp   - x(1) * ( 1.0_dp - x(2)    )
    f2 = 2.25_dp  - x(1) * ( 1.0_dp - x(2) * x(2) )
    f3 = 2.625_dp - x(1) * ( 1.0_dp - x(2) * x(2) * x(2) )

    beale = f1 * f1 + f2 * f2 + f3 * f3

  end function beale

  ! ------------------------------------------------------------------
  !
  ! The Wood function, N = 4.
  ! Solution: x(1:4) = (/ 1.0_dp, 1.0_dp, 1.0_dp, 1.0_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    06 January 2008
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Richard Brent,
  !    Algorithms for Minimization with Derivatives,
  !    Dover, 2002,
  !    ISBN: 0-486-41998-3,
  !    LC: QA402.5.B74.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function wood(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: wood
    real(dp) :: f1
    real(dp) :: f2
    real(dp) :: f3
    real(dp) :: f4
    real(dp) :: f5
    real(dp) :: f6
    real(dp), dimension(:), intent(in) :: x

    f1 = x(2) - x(1) * x(1)
    f2 = 1.0_dp - x(1)
    f3 = x(4) - x(3) * x(3)
    f4 = 1.0_dp - x(3)
    f5 = x(2) + x(4) - 2.0_dp
    f6 = x(2) - x(4)

    wood = 100.0_dp * f1 * f1 &
         +             f2 * f2 &
         +  90.0_dp * f3 * f3 &
         +             f4 * f4 &
         +  10.0_dp * f5 * f5 &
         +   0.1_dp * f6 * f6

  end function wood

  ! ------------------------------------------------------------------
  !
  ! The Chebyquad function, 1 <= N.
  ! Solution: n==2: x(1:2) = (/ 0.2113249_dp, 0.7886751_dp /)
  !           n==4: x(1:4) = (/ 0.1026728_dp, 0.4062037_dp, 0.5937963_dp, 0.8973272_dp /)
  !           n==6: x(1:6) = (/ 0.066877_dp, 0.288741_dp, 0.366682_dp,
  !                             0.633318_dp, 0.711259_dp, 0.933123_dp /)
  !           n==8: x(1:8) = (/ 0.043153_dp, 0.193091_dp, 0.266329_dp, 0.500000_dp, &
  !                             0.500000_dp, 0.733671_dp, 0.806910_dp, 0.956847_dp /)
  !           else unknown
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    23 March 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Richard Brent,
  !    Algorithms for Minimization with Derivatives,
  !    Dover, 2002,
  !    ISBN: 0-486-41998-3,
  !    LC: QA402.5.B74.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function chebyquad(x)

    implicit none

    integer(i4) :: n

    real(dp) :: chebyquad
    real(dp), dimension(:), intent(in) :: x

    real(dp), dimension(size(x)) :: fvec
    integer(i4) :: i
    integer(i4) :: j
    real(dp) :: t
    real(dp) :: t1
    real(dp) :: t2
    real(dp) :: th

    !
    !  Compute FVEC.
    !
    n = size(x)
    fvec(1:n) = 0.0_dp
    do j = 1, n
       t1 = 1.0_dp
       t2 = 2.0_dp * x(j) - 1.0_dp
       t = 2.0_dp * t2
       do i = 1, n
          fvec(i) = fvec(i) + t2
          th = t * t2 - t1
          t1 = t2
          t2 = th
       end do
    end do

    do i = 1, n
       fvec(i) = fvec(i) / real ( n, dp )
       if ( mod ( i, 2 ) == 0 ) then
          fvec(i) = fvec(i) + 1.0_dp / ( real ( i, dp )**2 - 1.0_dp )
       end if
    end do
    !call p18_fvec ( n, x, fvec )
    !
    !  Compute F.
    !
    chebyquad = sum ( fvec(1:n)**2 )

  end function chebyquad

  ! ------------------------------------------------------------------
  !
  ! The Leon''s cubic valley function, N = 2.
  ! Solution: x(1:2) = (/ 1.0_dp, 1.0_dp /)
  !
  !  Discussion:
  !
  !    The function is similar to Rosenbrock's.  The "valley" follows
  !    the curve X(2) = X(1)**3.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    17 March 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Richard Brent,
  !    Algorithms for Minimization with Derivatives,
  !    Dover, 2002,
  !    ISBN: 0-486-41998-3,
  !    LC: QA402.5.B74.
  !
  !    A Leon,
  !    A Comparison of Eight Known Optimizing Procedures,
  !    in Recent Advances in Optimization Techniques,
  !    edited by Abraham Lavi, Thomas Vogl,
  !    Wiley, 1966.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function leon_cubic_valley(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: leon_cubic_valley
    real(dp) :: f1
    real(dp) :: f2
    real(dp), dimension(:), intent(in) :: x

    f1 = x(2) - x(1) * x(1) * x(1)
    f2 = 1.0_dp - x(1)

    leon_cubic_valley = 100.0_dp * f1 * f1 &
         +             f2 * f2

  end function leon_cubic_valley

  ! ------------------------------------------------------------------
  !
  ! The Gregory and Karney''s Tridiagonal Matrix Function, 1 <= N.
  ! Solution: forall(i=1:n) x(i) = real(n+1-i, dp)
  !
  !  Discussion:
  !
  !    The function has the form
  !      f = x'*A*x - 2*x(1)
  !    where A is the (-1,2,-1) tridiagonal matrix, except that A(1,1) is 1.
  !    The minimum value of F(X) is -N, which occurs for
  !      x = ( n, n-1, ..., 2, 1 ).
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    20 March 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Richard Brent,
  !    Algorithms for Minimization with Derivatives,
  !    Prentice Hall, 1973,
  !    Reprinted by Dover, 2002.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function gregory_karney_tridiagonal_matrix(x)

    implicit none

    integer(i4) :: n

    real(dp) :: gregory_karney_tridiagonal_matrix
    integer(i4) ::i
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    gregory_karney_tridiagonal_matrix = x(1) * x(1) + 2.0_dp * sum ( x(2:n)**2 )

    do i = 1, n-1
       gregory_karney_tridiagonal_matrix = gregory_karney_tridiagonal_matrix - 2.0_dp * x(i) * x(i+1)
    end do

    gregory_karney_tridiagonal_matrix = gregory_karney_tridiagonal_matrix - 2.0_dp * x(1)

  end function gregory_karney_tridiagonal_matrix

  ! ------------------------------------------------------------------
  !
  ! The Hilbert function, 1 <= N.
  ! Solution: x(1:n) = 0.0_dp
  !
  !  Discussion:
  !
  !    The function has the form
  !      f = x'*A*x
  !    where A is the Hilbert matrix.  The minimum value
  !    of F(X) is 0, which occurs for
  !      x = ( 0, 0, ..., 0 ).
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    20 March 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Richard Brent,
  !    Algorithms for Minimization with Derivatives,
  !    Dover, 2002,
  !    ISBN: 0-486-41998-3,
  !    LC: QA402.5.B74.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function hilbert(x)

    implicit none

    integer(i4) :: n

    real(dp) :: hilbert
    integer(i4) ::i
    integer(i4) ::j
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    hilbert = 0.0_dp

    do i = 1, n
       do j = 1, n
          hilbert = hilbert + x(i) * x(j) / real ( i + j - 1, dp )
       end do
    end do

  end function hilbert

  ! ------------------------------------------------------------------
  !
  ! The De Jong Function F1, N = 3.
  ! Solution: x(1:n) = 0.0_dp
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    30 December 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function de_jong_f1(x)

    implicit none

    integer(i4) :: n

    real(dp) :: de_jong_f1
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    de_jong_f1 = sum ( x(1:n)**2 )

  end function de_jong_f1

  ! ------------------------------------------------------------------
  !
  ! The De Jong Function F2, N = 2.
  ! Solution: x(1:n) = 0.0_dp
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    31 December 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function de_jong_f2(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: de_jong_f2
    real(dp), dimension(:), intent(in) :: x

    de_jong_f2 = 100.0_dp * ( x(1) * x(1) - x(2) )**2 + ( 1.0_dp - x(1) )**2

  end function de_jong_f2

  ! ------------------------------------------------------------------
  !
  ! The De Jong Function F3 (discontinuous), N = 5.
  ! Solution: x(1:n) = 1.0_dp
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    31 December 2000
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function de_jong_f3(x)

    implicit none

    integer(i4) :: n

    real(dp) :: de_jong_f3
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    de_jong_f3 = real ( sum ( int ( x(1:n) ) ), dp )

  end function de_jong_f3

  ! ------------------------------------------------------------------
  !
  ! The De Jong Function F4 (Gaussian noise), N = 30.
  ! Solution: x(1:n) = -5.0_dp
  !
  !  Discussion:
  !
  !    The function includes Gaussian noise, multiplied by a parameter P.
  !
  !    If P is zero, then the function is a proper function, and evaluating
  !    it twice with the same argument will yield the same results.
  !    Moreover, P25_G and P25_H are the correct gradient and hessian routines.
  !
  !    If P is nonzero, then evaluating the function at the same argument
  !    twice will generally yield two distinct values; this means the function
  !    is not even a well defined mathematical function, let alone continuous;
  !    the gradient and hessian are not correct.  And yet, at least for small
  !    values of P, it may be possible to approximate the minimizer of the
  !    (underlying well-defined ) function.
  !
  !    The value of the parameter P is by default 1.  The user can manipulate
  !    this value by calling P25_P_GET or P25_P_SET.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    22 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function de_jong_f4(x)

    implicit none

    integer(i4) :: n

    real(dp) :: de_jong_f4
    real(dp) :: gauss
    integer(i4) ::i
    real(dp) :: p
    real(dp), dimension(:), intent(in) :: x

    real(dp), save :: p_save = 1.0_dp

    n = size(x)
    p = p_save
    !call p25_p_get ( p )

    call normal_01_sample ( gauss )

    de_jong_f4 = p * gauss
    do i = 1, n
       de_jong_f4 = de_jong_f4 + real ( i, dp ) * x(i)**4
    end do

  end function de_jong_f4

  ! ------------------------------------------------------------------
  !
  ! The De Jong Function F5, N = 2.
  ! Solution: x(1:n) = 0.0_dp
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    01 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function de_jong_f5(x)

    implicit none

    !    integer(i4) :: n

    integer(i4) ::a1
    integer(i4) ::a2
    real(dp) :: de_jong_f5
    real(dp) :: fi
    real(dp) :: fj
    integer(i4) ::j
    integer(i4) ::j1
    integer(i4) ::j2
    integer(i4), parameter :: jroot = 5
    integer(i4), parameter :: k = 500
    real(dp), dimension(:), intent(in) :: x

    fi = real ( k, dp )

    do j = 1, jroot * jroot

       j1 = mod ( j - 1, jroot ) + 1
       a1 = - 32 + j1 * 16

       j2 = ( j - 1 ) / jroot
       a2 = - 32 + j2 * 16

       fj = real ( j, dp ) + ( x(1) - real ( a1, dp ) )**6 &
            + ( x(2) - real ( a2, dp ) )**6

       fi = fi + 1.0_dp / fj

    end do

    de_jong_f5 = 1.0_dp / fi

  end function de_jong_f5

  ! ------------------------------------------------------------------
  !
  ! The Schaffer Function F6, N = 2.
  ! Solution: x(1:n) = (/ -32.0_dp, -32.0_dp /)
  !
  !  Discussion:
  !
  !    F can be regarded as a function of R = SQRT ( X(1)^2 + X(2)^2 ).
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    18 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function schaffer_f6(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: a
    real(dp) :: b
    real(dp) :: schaffer_f6
    real(dp) :: r
    real(dp), dimension(:), intent(in) :: x

    r = sqrt ( x(1)**2 + x(2)**2 )

    a = ( 1.0_dp + 0.001_dp * r**2 )**( -2 )

    b = ( sin ( r ) )**2 - 0.5_dp

    schaffer_f6 = 0.5_dp + a * b

  end function schaffer_f6

  ! ------------------------------------------------------------------
  !
  ! The Schaffer Function F7, N = 2.
  ! Solution: x(1:n) = (/ 0.0_dp, 0.0_dp /)
  !
  !  Discussion:
  !
  !    Note that F is a function of R^2 = X(1)^2 + X(2)^2
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    08 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function schaffer_f7(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: schaffer_f7
    real(dp) :: r
    real(dp), dimension(:), intent(in) :: x

    r = sqrt ( x(1)**2 + x(2)**2 )

    schaffer_f7 = sqrt ( r ) * ( 1.0_dp + ( sin ( 50.0_dp * r**0.2_dp ) )**2 )

  end function schaffer_f7

  ! ------------------------------------------------------------------
  !
  ! The Goldstein Price Polynomial, N = 2.
  ! Solution: x(1:n) = (/ 0.0_dp, 0.0_dp /)
  !
  !  Discussion:
  !
  !    Note that F is a polynomial in X.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    08 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function goldstein_price_polynomial(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: a
    real(dp) :: b
    real(dp) :: c
    real(dp) :: d
    real(dp) :: goldstein_price_polynomial
    real(dp), dimension(:), intent(in) :: x

    a = x(1) + x(2) + 1.0_dp

    b = 19.0_dp - 14.0_dp * x(1) + 3.0_dp * x(1) * x(1) - 14.0_dp * x(2) &
         + 6.0_dp * x(1) * x(2) + 3.0_dp * x(2) * x(2)

    c = 2.0_dp * x(1) - 3.0_dp * x(2)

    d = 18.0_dp - 32.0_dp * x(1) + 12.0_dp * x(1) * x(1) + 48.0_dp * x(2) &
         - 36.0_dp * x(1) * x(2) + 27.0_dp * x(2) * x(2)

    goldstein_price_polynomial = ( 1.0_dp + a * a * b ) * ( 30.0_dp + c * c * d )

  end function goldstein_price_polynomial

  ! ------------------------------------------------------------------
  !
  ! The Branin RCOS Function, N = 2.
  ! Solution: 1st solution: x(1:n) = (/ -pi, 12.275_dp /)
  !           2nd solution: x(1:n) = (/  pi,  2.275_dp /)
  !           3rd solution: x(1:n) = (/ 9.42478_dp, 2.475_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    10 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function branin_rcos(x)

    use mo_constants, only: pi_dp

    implicit none

    !    integer(i4) :: n

    real(dp), parameter :: a = 1.0_dp
    real(dp) :: b
    real(dp) :: c
    real(dp), parameter :: d = 6.0_dp
    real(dp), parameter :: e = 10.0_dp
    real(dp) :: branin_rcos
    real(dp) :: ff
    real(dp), dimension(:), intent(in) :: x

    b = 5.1_dp / ( 4.0_dp * pi_dp**2 )
    c = 5.0_dp / pi_dp
    ff = 1.0_dp / ( 8.0_dp * pi_dp )

    branin_rcos = a * ( x(2) - b * x(1)**2 + c * x(1) - d )**2 &
         + e * ( 1.0_dp - ff ) * cos ( x(1) ) + e

  end function branin_rcos

  ! ------------------------------------------------------------------
  !
  ! The Shekel SQRN5 Function, N = 4.
  ! Solution: x(1:n) = (/ 4.0_dp, 4.0_dp, 4.0_dp, 4.0_dp /)
  !
  !  Discussion:
  !
  !    The minimal function value is -10.15320.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    10 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function shekel_sqrn5(x)

    implicit none

    integer(i4), parameter :: m = 5
    integer(i4) :: n

    real(dp), parameter, dimension ( 4, m ) :: a = reshape ( &
         (/ 4.0_dp, 4.0_dp, 4.0_dp, 4.0_dp, &
         1.0_dp, 1.0_dp, 1.0_dp, 1.0_dp, &
         8.0_dp, 8.0_dp, 8.0_dp, 8.0_dp, &
         6.0_dp, 6.0_dp, 6.0_dp, 6.0_dp, &
         3.0_dp, 7.0_dp, 3.0_dp, 7.0_dp /), (/ 4, m /) )
    real(dp), save, dimension ( m ) :: c = &
         (/ 0.1_dp, 0.2_dp, 0.2_dp, 0.4_dp, 0.6_dp /)
    real(dp) :: shekel_sqrn5
    integer(i4) ::j
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    shekel_sqrn5 = 0.0_dp
    do j = 1, m
       shekel_sqrn5 = shekel_sqrn5 - 1.0_dp / ( c(j) + sum ( ( x(1:n) - a(1:n,j) )**2 ) )
    end do

  end function shekel_sqrn5

  ! ------------------------------------------------------------------
  !
  ! The Shekel SQRN7 Function, N = 4.
  ! Solution: x(1:n) = (/ 4.0_dp, 4.0_dp, 4.0_dp, 4.0_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    12 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function shekel_sqrn7(x)

    implicit none

    integer(i4), parameter :: m = 7
    integer(i4) :: n

    real(dp), parameter, dimension ( 4, m ) :: a = reshape ( &
         (/ 4.0_dp, 4.0_dp, 4.0_dp, 4.0_dp, &
         1.0_dp, 1.0_dp, 1.0_dp, 1.0_dp, &
         8.0_dp, 8.0_dp, 8.0_dp, 8.0_dp, &
         6.0_dp, 6.0_dp, 6.0_dp, 6.0_dp, &
         3.0_dp, 7.0_dp, 3.0_dp, 7.0_dp, &
         2.0_dp, 9.0_dp, 2.0_dp, 9.0_dp, &
         5.0_dp, 5.0_dp, 3.0_dp, 3.0_dp /), (/ 4, m /) )
    real(dp), save, dimension ( m ) :: c = &
         (/ 0.1_dp, 0.2_dp, 0.2_dp, 0.4_dp, 0.6_dp, 0.6_dp, 0.3_dp /)
    real(dp) :: shekel_sqrn7
    integer(i4) ::j
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    shekel_sqrn7 = 0.0_dp
    do j = 1, m
       shekel_sqrn7 = shekel_sqrn7 - 1.0_dp / ( c(j) + sum ( ( x(1:n) - a(1:n,j) )**2 ) )
    end do

  end function shekel_sqrn7

  ! ------------------------------------------------------------------
  !
  ! The Shekel SQRN10 Function, N = 4.
  ! Solution: x(1:n) = (/ 4.0_dp, 4.0_dp, 4.0_dp, 4.0_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    12 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function shekel_sqrn10(x)

    implicit none

    integer(i4), parameter :: m = 10
    integer(i4) :: n

    real(dp), parameter, dimension ( 4, m ) :: a = reshape ( &
         (/ 4.0, 4.0, 4.0, 4.0, &
         1.0, 1.0, 1.0, 1.0, &
         8.0, 8.0, 8.0, 8.0, &
         6.0, 6.0, 6.0, 6.0, &
         3.0, 7.0, 3.0, 7.0, &
         2.0, 9.0, 2.0, 9.0, &
         5.0, 5.0, 3.0, 3.0, &
         8.0, 1.0, 8.0, 1.0, &
         6.0, 2.0, 6.0, 2.0, &
         7.0, 3.6, 7.0, 3.6 /), (/ 4, m /) )

    real(dp), save, dimension ( m ) :: c = &
         (/ 0.1_dp, 0.2_dp, 0.2_dp, 0.4_dp, 0.6_dp, &
         0.6_dp, 0.3_dp, 0.7_dp, 0.5_dp, 0.5_dp /)
    real(dp) :: shekel_sqrn10
    integer(i4) ::j
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    shekel_sqrn10 = 0.0_dp
    do j = 1, m
       shekel_sqrn10 = shekel_sqrn10 - 1.0_dp / ( c(j) + sum ( ( x(1:n) - a(1:n,j) )**2 ) )
    end do

  end function shekel_sqrn10

  ! ------------------------------------------------------------------
  !
  ! The Six-Hump Camel-Back Polynomial, N = 2.
  ! Solution: 1st solution: x(1:n) = (/ -0.0898_dp,  0.7126_dp /)
  !           2nd solution: x(1:n) = (/  0.0898_dp, -0.7126_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    12 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function six_nump_camel_back_polynomial(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: six_nump_camel_back_polynomial
    real(dp), dimension(:), intent(in) :: x

    six_nump_camel_back_polynomial = ( 4.0_dp - 2.1_dp * x(1)**2 + x(1)**4 / 3.0_dp ) * x(1)**2 &
         + x(1) * x(2) + 4.0_dp * ( x(2)**2 - 1.0_dp ) * x(2)**2

  end function six_nump_camel_back_polynomial

  ! ------------------------------------------------------------------
  !
  ! The Shubert Function, N = 2.
  ! Solution: x(1:n) = (/ 0.0_dp, 0.0_dp /)
  !
  !  Discussion:
  !
  !    For -10 <= X(I) <= 10, the function has 760 local minima, 18 of which
  !    are global minima, with minimum value -186.73.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    12 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !    Bruno Shubert,
  !    A sequential method seeking the global maximum of a function,
  !    SIAM Journal on Numerical Analysis,
  !    Volume 9, pages 379-388, 1972.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function schubert(x)

    implicit none

    integer(i4) :: n

    real(dp) :: schubert
    real(dp) :: factor
    integer(i4) ::i
    integer(i4) ::k
    real(dp) :: k_r8
    real(dp), dimension(:), intent(in) :: x

    n = size(x)
    schubert = 1.0_dp

    do i = 1, n
       factor = 0.0_dp
       do k = 1, 5
          k_r8 = real ( k, dp )
          factor = factor + k_r8 * cos ( ( k_r8 + 1.0_dp ) * x(1) + k_r8 )
       end do
       schubert = schubert * factor
    end do

  end function schubert

  ! ------------------------------------------------------------------
  !
  ! The Stuckman Function, N = 2.
  ! Solution: Only iterative solution; Check reference.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    16 October 2004
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function stuckman(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: a1
    real(dp) :: a2
    real(dp) :: b
    real(dp) :: stuckman
    real(dp) :: m1
    real(dp) :: m2
    real(dp) :: r11
    real(dp) :: r12
    real(dp) :: r21
    real(dp) :: r22
    real(dp), dimension(:), intent(in) :: x

    real(dp), save :: b_save = 0.0_dp
    real(dp), save :: m1_save = 0.0_dp
    real(dp), save :: m2_save = 0.0_dp
    real(dp), save :: r11_save = 0.0_dp
    real(dp), save :: r12_save = 0.0_dp
    real(dp), save :: r21_save = 0.0_dp
    real(dp), save :: r22_save = 0.0_dp

    !call p36_p_get ( b, m1, m2, r11, r12, r21, r22, seed )
    b = b_save
    m1 = m1_save
    m2 = m2_save
    r11 = r11_save
    r12 = r12_save
    r21 = r21_save
    r22 = r22_save

    a1 = r8_aint ( abs ( x(1) - r11 ) ) + r8_aint ( abs ( x(2) - r21 ) )
    a2 = r8_aint ( abs ( x(1) - r12 ) ) + r8_aint ( abs ( x(2) - r22 ) )

    if ( x(1) <= b ) then
       if ( a1 == 0.0_dp ) then
          stuckman = r8_aint ( m1 )
       else
          stuckman = r8_aint ( m1 * sin ( a1 ) / a1 )
       end if
    else
       if ( a2 == 0.0_dp ) then
          stuckman = r8_aint ( m2 )
       else
          stuckman = r8_aint ( m2 * sin ( a2 ) / a2 )
       end if
    end if

  end function stuckman

  ! ------------------------------------------------------------------
  !
  ! The Easom Function, N = 2.
  ! Solution: x(1:n) = (/ pi, pi /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    11 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function easom(x)

    use mo_constants, only: pi_dp

    implicit none

    !    integer(i4) :: n

    real(dp) :: arg
    real(dp) :: easom
    real(dp), dimension(:), intent(in) :: x

    arg = - ( x(1) - pi_dp )**2 - ( x(2) - pi_dp )**2
    easom = - cos ( x(1) ) * cos ( x(2) ) * exp ( arg )

  end function easom

  ! ------------------------------------------------------------------
  !
  ! The Bohachevsky Function #1, N = 2.
  ! Solution: x(1:n) = (/ 0.0_dp, 0.0_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    11 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function bohachevsky1(x)

    use mo_constants, only: pi_dp

    implicit none

    !    integer(i4) :: n

    real(dp) :: bohachevsky1
    real(dp), dimension(:), intent(in) :: x

    bohachevsky1 =           x(1) * x(1) - 0.3_dp * cos ( 3.0_dp * pi_dp * x(1) ) &
         + 2.0_dp * x(2) * x(2) - 0.4_dp * cos ( 4.0_dp * pi_dp * x(2) ) &
         + 0.7_dp

  end function bohachevsky1

  ! ------------------------------------------------------------------
  !
  ! The Bohachevsky Function #2, N = 2.
  ! Solution: x(1:n) = (/ 0.0_dp, 0.0_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    11 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function bohachevsky2(x)

    use mo_constants, only: pi_dp

    implicit none

    !    integer(i4) :: n

    real(dp) :: bohachevsky2
    real(dp), dimension(:), intent(in) :: x

    bohachevsky2 = x(1) * x(1) + 2.0_dp * x(2) * x(2) &
         - 0.3_dp * cos ( 3.0_dp * pi_dp * x(1) ) &
         * cos ( 4.0_dp * pi_dp * x(2) ) + 0.3_dp

  end function bohachevsky2

  ! ------------------------------------------------------------------
  !
  ! The Bohachevsky Function #3, N = 2.
  ! Solution: x(1:n) = (/ 0.0_dp, 0.0_dp /)
  !
  !  Discussion:
  !
  !    There is a typo in the reference.  I'm just guessing at the correction.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    12 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function bohachevsky3(x)

    use mo_constants, only: pi_dp

    implicit none

    !    integer(i4) :: n

    real(dp) :: bohachevsky3
    real(dp), dimension(:), intent(in) :: x

    bohachevsky3 = x(1)**2 + 2.0_dp * x(2)**2 &
         - 0.3_dp * cos ( 3.0_dp * pi_dp * x(1) ) &
         + cos ( 4.0_dp * pi_dp * x(2) ) + 0.3_dp

  end function bohachevsky3

  ! ------------------------------------------------------------------
  !
  ! The Colville Polynomial, N = 4.
  ! Solution: x(1:n) = (/ 1.0_dp, 1.0_dp, 1.0_dp, 1.0_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    12 January 2001
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    Zbigniew Michalewicz,
  !    Genetic Algorithms + Data Structures = Evolution Programs,
  !    Third Edition,
  !    Springer Verlag, 1996,
  !    ISBN: 3-540-60676-9,
  !    LC: QA76.618.M53.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function colville_polynomial(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: colville_polynomial
    real(dp), dimension(:), intent(in) :: x

    colville_polynomial = 100.0_dp * ( x(2) - x(1)**2 )**2 &
         + ( 1.0_dp - x(1) )**2 &
         + 90.0_dp * ( x(4) - x(3)**2 )**2 &
         + ( 1.0_dp - x(3) )**2 &
         + 10.1_dp * ( ( x(2) - 1.0_dp )**2 + ( x(4) - 1.0_dp )**2 ) &
         + 19.8_dp * ( x(2) - 1.0_dp ) * ( x(4) - 1.0_dp )

  end function colville_polynomial

  ! ------------------------------------------------------------------
  !
  ! The Powell 3D function, N = 3.
  ! Solution: x(1:n) = (/ 1.0_dp, 1.0_dp, 1.0_dp /)
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    03 March 2002
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    MJD Powell,
  !    An Efficient Method for Finding the Minimum of a Function of
  !    Several Variables Without Calculating Derivatives,
  !    Computer Journal,
  !    Volume 7, Number 2, pages 155-162, 1964.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function powell3d(x)

    use mo_constants, only: pi_dp

    implicit none

    !    integer(i4) :: n

    real(dp) :: arg
    real(dp) :: powell3d
    real(dp) :: term
    real(dp), dimension(:), intent(in) :: x

    if ( x(2) == 0.0_dp ) then
       term = 0.0_dp
    else
       arg = ( x(1) + 2.0_dp * x(2) + x(3) ) / x(2)
       term = exp ( - arg**2 )
    end if

    powell3d = 3.0_dp &
         - 1.0_dp / ( 1.0_dp + ( x(1) - x(2) )**2 ) &
         - sin ( 0.5_dp * pi_dp * x(2) * x(3) ) &
         - term

  end function powell3d

  ! ------------------------------------------------------------------
  !
  ! The Himmelblau function, N = 2.
  ! Solution: x(1:2) = (/ 3.0_dp, 2.0_dp /)
  !
  !  Discussion:
  !
  !    This function has 4 global minima:
  !
  !      X* = (  3,        2       ), F(X*) = 0.
  !      X* = (  3.58439, -1.84813 ), F(X*) = 0.
  !      X* = ( -3.77934, -3.28317 ), F(X*) = 0.
  !      X* = ( -2.80512,  3.13134 ), F(X*) = 0.
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    28 January 2008
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    David Himmelblau,
  !    Applied Nonlinear Programming,
  !    McGraw Hill, 1972,
  !    ISBN13: 978-0070289215,
  !   LC: T57.8.H55.
  !
  !  Parameters:
  !
  !    Input, real(dp) :: X(N), the argument of the objective function.
  !

  function himmelblau(x)

    implicit none

    !    integer(i4) :: n

    real(dp) :: himmelblau
    real(dp), dimension(:), intent(in) :: x

    himmelblau = ( x(1)**2 + x(2) - 11.0_dp )**2 &
         + ( x(1) + x(2)**2 - 7.0_dp )**2

  end function himmelblau

  ! ------------------------------------------------------------------
  !
  ! This is the Griewank Function (2-D or 10-D)
  ! Bound: X(i)=[-600,600], for i=1,2,...,10
  ! Global minimum: 0, at origin
  !
  ! Coded originally by Q Duan.  Edited for incorporation into Fortran DDS algorithm by
  ! Bryan Tolson, Nov 2005.
  ! DDS users should make their objective functions follow this framework
  ! user function arguments must be the same as above for the Griewank function
  !
  ! Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  ! I/O Variable definitions:
  !     nopt     -  the number of decision variables
  !     x_values -      an array of decision variable values (size nopt)
  !     fvalue   -      the value of the objective function with x_values as input

  function griewank(x_values)

    use mo_kind, only: i4, dp

    implicit none

    real(dp), dimension(:), intent(in)  :: x_values
    real(dp) :: griewank

    integer(i4) :: nopt
    integer(i4) :: j
    real(dp)    :: d, u1, u2

    nopt = size(x_values)
    if (nopt .eq. 2) then
       d = 200.0_dp
    else
       d = 4000.0_dp
    end if
    u1 = 0.0_dp
    u2 = 1.0_dp
    do j = 1, nopt
       u1 = u1 + x_values(j)**2 / d
       u2 = u2 * cos(x_values(j)/sqrt(real(j,dp)))
    end do
    griewank = u1 - u2 + 1
    !
  end function griewank

  ! ------------------------------------------------------------------
  !
  !  Rosenbrock parabolic value function, N = 2.
  !  Solution: x(1:n) = 1.0_dp
  !
  !  Licensing:
  !
  !    This code is distributed under the GNU LGPL license.
  !
  !  Modified:
  !
  !    19 February 2008
  !
  !  Author:
  !
  !    John Burkardt
  !    Modified Jul 2012 Matthias Cuntz - function, dp, etc.
  !
  !  Reference:
  !
  !    R ONeill,
  !    Algorithm AS 47:
  !    Function Minimization Using a Simplex Procedure,
  !    Applied Statistics,
  !    Volume 20, Number 3, 1971, pages 338-345.
  !
  !  Parameters:
  !
  !    Input, real(dp) X(2), the argument.
  !

  function rosenbrock(x)

    implicit none

    real(dp), dimension(:), intent(in) :: x
    real(dp) :: rosenbrock

    real(dp) :: fx
    real(dp) :: fx1
    real(dp) :: fx2

    fx1 = x(2) - x(1) * x(1)
    fx2 = 1.0_dp - x(1)

    fx = 100.0_dp * fx1 * fx1 + fx2 * fx2

    rosenbrock = fx

  end function rosenbrock

END MODULE mo_opt_functions