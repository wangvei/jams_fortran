!> \file mo_random_field.f90

!> \brief This module contains generating random fields with certain 
!>        statistical properties, e.g. correlation length.

!> \details This module contains generating random fields with certain 
!>          statistical properties, e.g. correlation length.\n
!>          Right now there are the following implemented:
!>          * Irrotational flow fields with Gauss-shape correlation functions
!>            described by Attinger et al. (2008) 'Effective velocity for transport in 
!>            heterogeneous compressible flows with mean drift' (Eq. 31-32)
!>          * some more...

!> \authors Juliane Mai
!> \date Jul 2014

module mo_random_field
  ! Written  Juliane Mai, Jul 2014
  ! Modified 

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
  ! along with the UFZ makefile project (cf. gpl.txt and lgpl.txt).
  ! If not, see <http://www.gnu.org/licenses/>.

  ! Copyright 2014 Juliane Mai

  ! Always use the number precisions of mo_kind
  use mo_kind, only: i4, i8, dp

  ! Of course
  implicit none

  public :: random_velocity_field_gauss    ! Fields with gauss-shape correlation function

  ! ------------------------------------------------------------------

  !     NAME
  !         random_velocity_field_gauss

  !     PURPOSE
  !>        \brief Calculates random velocity fields by using a correlation function
  !>               which is a product of Gauss-shaped functions as described 
  !>               by Attinger et al. (2008).
  !
  !>        \details Calculates random velocity fields by using a correlation function
  !>               which is a product of Gauss-shaped functions as described 
  !>               by Attinger et al. (2008).\n
  !>               A transport equation in a reference domain is considered where the 
  !>               velocity field \f$ u \f$ splits into \f$ u = \bar{u} + \tilde{u}\f$. 
  !>               \f$ \bar{u}\f$ is a constant mean and \f$ \tilde{u} \f$ is a random 
  !>               compressible velocity field defined by a zero mean random Gaussian 
  !>               correlation function.\n
  !>               The potential can be generated by a superposition of randomly 
  !>               chosen cosine modes as follows:
  !>                    \f[ u_i^N = \sigma \sqrt{\frac{2}{N}} \sum\limits_{j=1}^{N} k_i^j \cos(k^jx + \omega_j) \f]
  !>               where each component of \f$ k^j=(k_1^j,k_2^j)\f$ obeys a Gaussian 
  !>               distribution with zero mean and variance given by \f$ 1/l_i^2 \f$.
  !>               \f$ l_i \f$ are the correlation lengths,  \f$ N \f$ is the number of cosine modes used for approximation.
  !
  !     INTENT(IN)
  !>        \param[in] "real(sp/dp)            :: coord(n,m)"       2D-array of n coordinates in m dimensional space
  !>                                                                where field has to be evaluated
  !>        \param[in] "real(sp/dp)            :: corr_length(m)"   correlation length for each of the m dimensions
  !
  !     INTENT(INOUT)
  !         None
  !
  !     INTENT(OUT)
  !         None
  !
  !     INTENT(IN), OPTIONAL
  !>        \param[in] "real(sp/dp)            :: sigma2"           variance of correlation function\n
  !>                                                                DEFAULT: 1.0_dp
  !>        \param[in] "integer(i4), optional  :: ncosinemode"      number of cosine modes summed up\n
  !>                                                                DEFAULT: 100
  !
  !     INTENT(INOUT), OPTIONAL
  !         None
  !
  !     INTENT(OUT), OPTIONAL
  !>        \param[out] "real(sp/dp), optional :: cosine_modes(ncosinemode,m)"
  !>                                                                returns <ncosinemode> random Gaussian modes 
  !>                                                                \f$ k^j=(k_1^j,...,k_m^j)\f$, i.e. all 
  !>                                                                information describing the field. 
  !>                                                                Therefore, additional positions 
  !>                                                                coord(:,:) can be evaluated afterwards.
  !>        \param[out] "real(sp/dp), optional :: potential(n)"     returns the potential of the field at all
  !>                                                                requested points
  !
  !     RETURN
  !>       \return     real(sp/dp) :: velocity(n,m) &mdash; velocity at given coordinates
  !
  !     RESTRICTIONS
  !>       \note None.
  !
  !     EXAMPLE
  !         -> see also example in test directory

  !     LITERATURE
  !         Attinger, S., & Abdulle, A. (2008). 
  !             Effective velocity for transport in heterogeneous compressible flows with mean drift. 
  !             Physics of Fluids

  !     HISTORY
  !>        \author Juliane Mai
  !>        \date Jul 2014
  !         Modified, 
  interface random_velocity_field_gauss
     module procedure random_velocity_field_gauss_dp !, random_velocity_field_gauss_sp
  end interface random_velocity_field_gauss

  ! ------------------------------------------------------------------

  private

contains

  function random_velocity_field_gauss_dp(coord, corr_length, ncosinemode, sigma2, seed, cosine_modes_in, &
       cosine_modes_out, potential) &
       result (velocity)

    use mo_constants,    only: pi_dp
    use mo_xor4096,      only: xor4096g, get_timeseed
    use mo_xor4096_apps, only: xor4096g_array

    implicit none

    real(dp), dimension(:,:),              intent(in)            :: coord            ! coordinates where field has to be evaluated
    !                                                                                !    dim1: number of requested points
    !                                                                                !    dim2: number of dimensions
    real(dp), dimension(:),                intent(in)            :: corr_length      ! correlation length for each dimension
    !                                                                                !    dim1: number of dimensions
    integer(i4),                           intent(in), optional  :: ncosinemode      ! number of cosine modes summed up
    !                                                                                !    DEFAULT: 100
    real(dp),                              intent(in), optional  :: sigma2           ! variance of correlation function
    !                                                                                !    DEFAULT: 1.0_dp
    integer(i8),                           intent(in), optional  :: seed             ! seed for random numbers
    !                                                                                !    DEFAULT: -9_i8 --> time_seed
    real(dp), dimension(:,:),              intent(in), optional  :: cosine_modes_in  ! cosine mode is already determined in prev. 
    !                                                                                ! run and is now fixed there, i.e. field 
    !                                                                                ! generation is skipped and only velocity 
    !                                                                                ! and potential are determined
    !                                                                                !    dim1: number of cosine modes
    !                                                                                !    dim2: number of dimensions
    real(dp), dimension(:,:), allocatable, intent(out), optional :: cosine_modes_out ! returns the random cosine modes which 
    !                                                                                ! define the field
    !                                                                                !    dim1: number of cosine modes
    !                                                                                !    dim2: number of dimensions
    real(dp), dimension(size(coord,1)),    intent(out), optional :: potential        ! potential of field at given point
    !                                                                                !    dim1: number of requested points
    real(dp), dimension(size(coord,1), size(coord,2))            :: velocity         ! velocity at given point
    !                                                                                !    dim1: number of requested points
    !                                                                                !    dim2: number of dimensions

    ! local variables
    integer(i4)                            :: idim, ipoint, imode  ! counter
    real(dp)                               :: h, h_pot             ! helper variables
    real(dp)                               :: isigma2              ! variance of correlation function
    integer(i4)                            :: incosinemode         ! number of cosine modes summed up
    integer(i4)                            :: npoints              ! number of points given
    integer(i4)                            :: dims                 ! number of dimensions
    real(dp), dimension(size(coord,1))     :: ipotential           ! potential of field at given point
    real(dp), dimension(:,:), allocatable  :: modes                ! random cosine modes which define the field
    integer(i8), dimension(:), allocatable :: iseed                ! seed for random numbers

    if (size(coord,2) .ne. size(corr_length,1)) then
       stop 'random_velocity_field_gauss: correlation length for each dimension has to be given'
    end if

    if ( any(corr_length .lt. 0.0_dp) ) then
       stop 'random_velocity_field_gauss: correlation length has to be positive'
    end if

    if (present(ncosinemode)) then
       if ( ncosinemode .le. 0 ) then
          stop 'random_velocity_field_gauss: ncosinemode is the number of cosine modes summed up and therefore has to be positive'
       else
          incosinemode = ncosinemode
       end if
    else
       incosinemode = 100
    end if

    if (present(cosine_modes_in)) then
       if ( size(cosine_modes_in,2) .ne. size(coord,2) ) then
          stop 'random_velocity_field_gauss: shape mismatch in second dimension'
       end if
       incosinemode = size(cosine_modes_in,1)
       ! later: values handed over to "modes"
    end if

    if (present(sigma2)) then
       if ( sigma2 .lt. 0.0_dp ) then
          stop 'random_velocity_field_gauss: sigma2 is variance of correlation function and therefore has to be positive'
       else
          isigma2 = sigma2
       end if
    else
       isigma2 = 1.0_dp
    end if

    npoints = size(coord,1)
    dims    = size(coord,2)

    allocate(modes(incosinemode, dims))
    modes = 0.0_dp
    set_modes: if (present(cosine_modes_in)) then
       modes = cosine_modes_in
    else
       allocate(iseed(dims))
       if (present(seed)) then
          if (seed .gt. 0_i8) then
             iseed(1) = seed
             do idim=2, dims
                iseed(idim) = iseed(idim-1) + 1000_i8
             end do
          else 
             call get_timeseed(iseed)
          end if
       else
          call get_timeseed(iseed)
       end if
       
       ! initialize Random numbers
       call xor4096g(iseed, modes(1,:))
       
       ! generate random modes
       call xor4096g_array(modes)
       
       ! scale with correlation length
       do idim=1, dims
          modes(:,idim) = modes(:,idim) * 1.0_dp/corr_length(idim)
       end do
    end if set_modes

    velocity(:,:) = 0.0_dp
    ipotential(:) = 0.0_dp
    do ipoint=1,npoints
       do imode=1,incosinemode
          h     = 0.0_dp ! velocity
          h_pot = 0.0_dp ! potential
          do idim=1,dims
             h  = h + modes(imode,idim) * coord(ipoint,idim)
          end do
          h_pot = h
          h     = cos( h     + real(imode,dp)*2.0_dp*pi_dp/real(incosinemode,dp) )
          h_pot = sin( h_pot + real(imode,dp)*2.0_dp*pi_dp/real(incosinemode,dp) )
          velocity(ipoint,:) = velocity(ipoint,:) + h * modes(imode,:)   
          ipotential(ipoint)  = ipotential(ipoint)  + h_pot
       end do
    end do

    do idim=1,dims
       velocity(:,idim) = velocity(:,idim) * (isigma2) * sqrt( 2.0_dp/real(incosinemode,dp) )    
    end do
    ipotential(:) = ipotential(:) * (isigma2) * sqrt( 2.0_dp/real(incosinemode,dp) ) 

    if (present(cosine_modes_out)) then
       allocate(cosine_modes_out(incosinemode, dims))
       cosine_modes_out = modes
    end if

    if (present(potential)) then
       potential = ipotential
    end if

  end function random_velocity_field_gauss_dp


end module mo_random_field
