
# This is the Fortran library of JAMS.

Created 11.11.2011 by Juliane Mai and Matthias Cuntz at the  
Department Computational Hydrosystems  
Helmholtz Centre for Environmental Research - UFZ  
Permoserstr. 15, 04318 Leipzig, Germany

Copyright 2011-2016 JAMS  
Contact Matthias Cuntz - mc (at) macu.de

---------------------------------------------------------------

The library is maintained with a git repository at:

    https://bitbucket.org/mcuntz/jams_fortran

For running on Windows under Cygwin:  
The link files on the SVN server are *nix style. One has to redo them on Windows.  
In cygwin, in the directory FORTRAN_chs_lib do:

    for i in $(find . -mindepth 2 -maxdepth 2 -name mo_\* -print) ; do if [[ $(head -1 $i | cut -f 1 -d ' ') == link ]] ; then cd $(dirname $i) ; ln -sf ../$(basename $i) ; cd .. ; fi ; done

    for i in $(find . -mindepth 3 -maxdepth 3 -name mo_\* -print) ; do if [[ $(head -1 $i | cut -f 1 -d ' ') == link ]] ; then cd $(dirname $i) ; ln -sf ../../$(basename $i) ; cd ../.. ; fi ; done

    cd test/test_mo_kernel ; ln -sf ../../nr_chs/golden.f90 ; cd ../..

Please do not commit these files because it will break the Library everywhere else except on Cygwin.


One can produce a browseable html of the library in the directory html by calling: make SRCPATH=. html

---------------------------------------------------------------

## License

This file is part of the JAMS Fortran library.

Not all files in the library are free software. The license is given in the 'License' section
of the docstring of each routine.

There are 3 possibilities:

1. The routine is not yet released under the GNU Lesser General Public License.  
    This is marked by a text such as  
        This file is part of the JAMS Fortran library.
        It is NOT released under the GNU Lesser General Public License, yet.
        If you use this routine, please contact Matthias Cuntz.
        Copyright 2012-2013 Matthias Cuntz
    If you want to use this routine for publication or similar, please contact the author for possible co-authorship.

2. The routine is already released under the GNU Lesser General Public License
   but if you use the routine in a publication or similar, you have to cite the respective
   publication, e.g.  
   If you use this routine in your work, you should cite the following reference  
       Goehler M, J Mai, and M Cuntz (2013)  
            Use of eigendecomposition in a parameter sensitivity analysis of the Community Land
            Model,  
            J Geophys Res 188, 904-921, doi:10.1002/jgrg.20072

3. The routine is released under the GNU Lesser General Public License. The following applies:  
   The JAMS Fortran library is free software: you can redistribute it and/or modify
   it under the terms of the GNU Lesser General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.  
   The JAMS Fortran library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU Lesser General Public License for more details.  
   You should have received a copy of the GNU Lesser General Public License
   along with the JAMS Fortran library (cf. gpl.txt and lgpl.txt).
   If not, see <http://www.gnu.org/licenses/>.

Copyright 2011-2016 Matthias Cuntz

---------------------------------------------------------------

## Note on Numerical Recipes License

Be aware that some code is under the Numerical Recipes License 3rd
edition <http://www.nr.com/aboutNR3license.html>

The Numerical Recipes Personal Single-User License lets you personally
use Numerical Recipes code ("the code") on any number of computers,
but only one computer at a time. You are not permitted to allow anyone
else to access or use the code. You may, under this license, transfer
precompiled, executable applications incorporating the code to other,
unlicensed, persons, providing that (i) the application is
noncommercial (i.e., does not involve the selling or licensing of the
application for a fee), and (ii) the application was first developed,
compiled, and successfully run by you, and (iii) the code is bound
into the application in such a manner that it cannot be accessed as
individual routines and cannot practicably be unbound and used in
other programs. That is, under this license, your application user
must not be able to use Numerical Recipes code as part of a program
library or "mix and match" workbench.

Businesses and organizations that purchase the disk or code download,
and that thus acquire one or more Numerical Recipes Personal
Single-User Licenses, may permanently assign those licenses, in the
number acquired, to individual employees. Such an assignment must be
made before the code is first used and, once made, it is irrevocable
and can not be transferred. 

If you do not hold a Numerical Recipes License, this code is only for
informational and educational purposes but cannot be used.