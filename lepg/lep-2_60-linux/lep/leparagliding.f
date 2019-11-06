c***************************************************************
c      LE PARAGLIDING v 2.60 "Les Escaules"
c      Pere Casellas 2010-2016
c      Laboratori d'envol
c      http://www.laboratoridenvol.com
c      pere AT laboratoridenvol DOT com
c      Version experimental 0.1: 2005-02-13
c      Version 0.8: 2010-01-02 "gnuLAB2"
c      Version 0.9: 2010-02-14
c      Version 1.0: 2010-03-07
c      Version 1.02: 2010-04-17 "Annency"
c      Version 1.1: 2010-04-25 "South Africa"
c      Version 1.11: 2010-12-26 "Montseny"
c      Version 1.2: 2011-01-14 "Adrenaline"
c      Version 1.25: 2011-03-20 "Romano"
c      Version 1.4: 2011-04-25 "V-Ribs"
c      Verssion 1.5: 2011-12-08 "HyperLite"
c      Version 2.0: 2012-01-08 "BHL"
c      Version 2.1: 2012-05-27 "BatLite"
c      Version 2.2: 2013-05-05 "Altair"
c      Version 2.21: 2013-07-17 "Fluid Wings"
c      Version 2.23: 2013-08-13 "BHL-2"
c      Version 2.31: 2013-12-31 "BASE"
c      Version 2.35: 2014-04-21 "BASE"
c      Version 2.37: 2015-04-25 "Omsk"
c      Versiom 2.41: 2015-09-20 "Omsk"
c      Version 2.45: 2016-03-12 "Utah"
c      Version 2.50: 2016-05-09 "Utah"
c      Version 2.51: 2016-06-05
c      Version 2.52: 2016-08-18
c      Version 2.5q2++: 2016-08-27
c      Version 2.60: 2016-12-12 "Les Escaules"
c      FORTRAN fort77/gfortran (GNU/Linux)
c      GNU General Public License 3.0 (http://www.gnu.org)
c
c**************************************************************
c
c       program leparagliding
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      1. VARIABLE NAMES
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      ncells: number of cells
c      nribst: total ribs
c      nribss: in semi-wing
c      rib(i,j): rib i parameter j
c            j=1 rib number
c            j=2 x_rib
c            j=3 y_LE
c            j=4 y_TE
c            j=5 chord
c            j=6 x'
c            j=7 z_rib
c            j=8 alpha washin
c            j=9 beta
c            j=10 rotation point
c            j=11 vent in
c            j=12 vent out
c            j=14 open=1 closed=0
c            j=15 anchors number
c            j=16 A %
c            j=17 B %
c            j=18 C %
c            J=19 D %
c            j=20 E %
c            j=21 F % brake
c            j=22 cell wide (i to i+1)
c            j=23 extrados length
c            j=24 intrados wide
c            j=25 intrados length
c            j=26 inlet length
c            j=30 panel length to the left of rib i - extrados
c            j=31 rib i length - extrados
c            j=32 panel length to the right of rib i - extrados
c            j=33 panel length to the left of rib i - intrados
c            j=33 rib i length - intrados
c            j=35 panel length to the right of rib i - intrados
c            j=36,37,38,39 mark amplification coeficients
c      alpha: airfoil washin angle
c      alpham: max washin
c      beta: airfoil vertical angle
c      calag: calage
c      cple: center of pressure
c      hcp: height pilote - center of pressure
c      assiette:angle between horizontal line and chord
c      finesse: glide ratio
c      aoa: angle of attack AoA
c      nomair(i): airfoil archive
c      np(i,1): airfoil points number
c      u(i,j,20) v(i,j,20): airfoils coordinates
c        K = 1 = original coordinates
c            2 = 100*coordinates
c            3 = scaled coordinates
c            4 = washin coordinates
c            5 = espace coordinates
c            6 = singular points
c                j=1 A anchor point 3D
c                j=2 B anchor point 3D
c                j=3 C anchor point 3D
c                j=4 D anchor point 3D
c                j=5 E anchor point 3D
c                j=6 F anchor point - brake 3D
c                j=7 B intake in point 3D
c                j=8 B intake out point 3D
c            7 = overwide local left
c            8 = overwide local right
c            9 = coordinates overwide left
c            10 = coordinates overwide right
c            11 = coordinates left sewing border
c            12 = coordinates right sewing border
c            14 = panel extreme points left
c            15 = panel extreme points right
c            16 = airfoil borders
c            18 = anchor space coordinates
c            19 = anchor absolute coordinates
c      x(i,j) y(i,j) z(i,j): absolute airfoil coordinates
c      xx(1,j) yy(1,j) zz(1,j): central airfoil (or i=0)
c      hol(100,20,20) airfoil holes properties
c      xl(i,j) xr(i,j) panels length
c      skin(k,j) skin tension
c      xupp, xupple, xuppte, xlow, xlowle, xlowte, xrib sewing allowances
c      mc(ii,j,k) suspension matrix
c           ii = line plan
c           j = path number
c           k = matrix column
c               1 ramifications number of the path
c               2 1 (ramification level 1)
c               3 order in the level 1
c               4 2 (ramification level 2)
c               5 order in the level 2
c               6 3 (ramification level 3)
c               7 order in the level 3
c               8 4 (ramification level 4)
c               9 order in the level 4
c               10 anchor line (1=A,2=B,3=C,4=c,5=D,6=freno)
c               11 anchor rib number
c      cam(ii) paths in plan ii
c      slp suspension line plans
c      corda(i,k) ramification properties of line i
c           k = 1 line plan
c           k = 2 line level (1=riser)
c           k = 3 liner order (in the same level, and left to right)
c           k = 4 action points associated
c           k = 5 path ramifications
c           k = 6 final anchor row 1=A 2=B ...
c           k = 7 anchor rib number
c      x1line(corda(i,1),corda(i,2),corda(i,3)) line i initial x-coordinate
c      y1line(corda(i,1),corda(i,2),corda(i,3)) line i initial y-coordinate
c      z1line(corda(i,1),corda(i,2),corda(i,3)) line i initial z-coordinate
c      x2line(corda(i,1),corda(i,2),corda(i,3)) line i final x-coordinate
c      y2line(corda(i,1),corda(i,2),corda(i,3)) line i final y-coordinate
c      z2line(corda(i,1),corda(i,2),corda(i,3)) line i final z-coordinate
c      x3line(corda(i,1),corda(i,2),corda(i,3)) line i action point x-coordinate
c      y3line(corda(i,1),corda(i,2),corda(i,3)) line i action point y-coordinate
c      z3line(corda(i,1),corda(i,2),corda(i,3)) line i action point z-coordinate
c      xline(i) line i length
c      raml(i,j) ramfication lengths
c
c      hvr(i,j) H and V ribs definiton
c      j=1 H-strap
c      j=2 V-rib partial
c      j=3 V-rib full
c      j=4 VH rib (3 cells)
c
c      V-ribs absolute coordinates
c      rx1(),ry1(),rz1()
c      rx2(),ry2(),rz2()
c      rx3(),ry3(),rz3()
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      2. VARIABLES TYPE DECLARATION
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c       double precision

       real*8 xkf,xwf
       real*8 ribdif, htens, xndif
       real*8 x1,y1,x2,y2,x3,y3
       real*8 p1x,p1y,p1z,p2x,p2y,p2z

       real*8 alpha,tetha,alpham,alphac,alphat,alpha1,alpha2,alpr,alpl
       real*8 alple,alpte,alp
       real*8 amte,amter,amtel,amle,amler,amlel
       real*8 tetha1,tetha2,tetha3,tetha4,angle,angle1,angle2

       real*8 xmk,xmark,xcir,xdes,xdesx,xdesy,xprev,xpost

       real*8 x0,y0,xx0,yy0,x00,xxa,yyb

       real*8 o1x,o1y,o2x,o2y,o3x,o3y

       real*8 xn,xm,xb,xn1,xm1,xn2,xm2,xn3,xm3

       real*8 xu,xv,xlu1,xlv1,xlu2,xlv2

       real*8 a,b,aa,bb,a1,b1,c1

       real*8 xrsep,yrsep,psep,psey
       real*8 asep,bsep,sepx,sepy,sepxx,sepyy

       real*8 xcos

       real*8 alptri,atri,btri,rtri,satri,h1tri,h2tri,h3tri

       real*8 agor,bgor,cgor,cggor,step1

       real*8 rib(0:100,200)

       character*50 wname, bname, nomair(100)
       character*50 xtext, lepv
       character*2 atp

       character*50 xstring, string1, string2, string3

       character*1 ln1,ln2
       character*2 ln3
       character*4 ln4(500)

       real*8 u(0:100,300,50),v(0:100,300,50),w(0:100,300,50)
       real*8 ru(0:100,300,50),rv(0:100,300,50),rw(0:100,300,50)

       real*8 x(0:100,300),y(0:100,300),z(0:100,300)

       real*8 rx(0:100,300),ry(0:100,300),rz(0:100,300)

       real*8 hx2(0:100,50,10), hy2(0:100,50,10), hz2(0:100,50,10)
       real*8 hx3(0:100,50,10), hy3(0:100,50,10), hz3(0:100,50,10)

       real*8 rx1(0:100,50,10), ry1(0:100,50,10), rz1(0:100,50,10)
       real*8 rx2(0:100,50,10), ry2(0:100,50,10), rz2(0:100,50,10)
       real*8 rx3(0:100,50,10), ry3(0:100,50,10), rz3(0:100,50,10)

       real*8 sx1(0:100,50,10), sy1(0:100,50,10), sz1(0:100,50,10)
       real*8 sx2(0:100,50,10), sy2(0:100,50,10), sz2(0:100,50,10)
       real*8 sx3(0:100,50,10), sy3(0:100,50,10), sz3(0:100,50,10)
       real*8 sx4(0:100,50,10), sy4(0:100,50,10), sz4(0:100,50,10)

       integer np(0:100,5)
       real*8 xx(1,300),yy(1,300),zz(1,300)

       real*8 px0,py0,ptheta
       real*8 pa,pb,pc,pd,pe,pf
       real*8 pa1l,pa2l,phl,pa1r,pa2r,phr
       real*8 pb1t,pb2t,pht,phu,pw1

       real*8 pl1x(0:100,300),pl1y(0:100,300),pl2x(0:100,300),
     + pl2y(0:100,300)
       real*8 pr1x(0:100,300),pr1y(0:100,300),pr2x(0:100,300),
     + pr2y(0:100,300)

       real*8 hol(0:100,20,20),skin(10,10)

       real*8 xsob(10),ysob(10)

       real*8 xupp, xupple, xuppte, xlow, xlowle, xlowte, xrib, xvrib

       real*8 brake(0:100,10)

       integer mc(10,100,20), cam(10), corda(500,10)

       integer cordam, cordat

       real*8 xcorda(500,5), ycorda(500,5), zcorda(500,5), raml(10,5)

       real*8 x1line(10,5,100),y1line(10,5,100),z1line(10,5,100)
       
       real*8 x2line(10,5,100),y2line(10,5,100),z2line(10,5,100)

       real*8 phi1(10,5,100),phi2(10,5,100),phi0(10,5,100)

       real*8 calag,cple,hcp,assiette,afinesse,aoa,finesse
       real*8 calage,cpress,clengr,clengl,clengk,clengb

       real*8 zcontrol, csusl, control

       real*8 acit,xci,yci,aci,cdgx,cdgy,cdg,xpoi,xdis

       real*8 dist,dist1

       real*8 xkar,ykar,zkar

       real*8 farea,parea,fspan,pspan,faratio,paratio

       real*8 comp1(10),comp2(10), xline(500),  xline2(500)

       real*8 hvr(0:200,15)

       real*8 ucnt(0:300,10,20), vcnt(0:300,10,20)

       real*8 ucnt1(0:100,10,300), vcnt1(0:100,10,300)
       real*8 ucnt2(0:100,10,300), vcnt2(0:100,10,300)
       real*8 ucnt3(0:100,10,300), vcnt3(0:100,10,300)
       real*8 ucnt4(0:100,10,300), vcnt4(0:100,10,300)

       integer jcon(0:200,10,300)
       integer jcon2(0:200,10,300),jcon4(0:200,10,300)
       integer jcon9(0:200,10,300),jcon11(0:200,10,300)

       integer npce, npc1e(100), npc2e(100), npc3e(100,100)
       integer npci, npc1i(100), npc2i(100), npc3i(100,100)
       real*8 xpc1e(100,100), xpc2e(100,100) 
       real*8 xpc1i(100,100), xpc2i(100,100)

       real*8 xle(100,100), xleinc(100,100)
       real*8 xpc3e(100,100), ypc3e(100,100)
       real*8 xli(100,100), xliinc(100,100)
       real*8 xpc3i(100,100), ypc3i(100,100)

       real*8 xarp(10), yarp(10)

       real*8 hdist(100), hangle(100)

       real*8 xtri(50),ytri(50)

       real*8 csus(10,10), cdis(10,10)

       real*8 aload(100,10), xload(500), xlide(500), xlifi(500)
       real*8 lvcx(300,300), lvcy(300,300),rvcx(300,300),rvcy(300,300)

       real*8 anccont(100,10)

       real*8 bd(10,10)

       real*8 xpt1,ypt1,zpt1,xpt2,ypt2,zpt2,xpt3,ypt3,zpt3
       real*8 xpt4,ypt4,zpt4,xpt6,ypt6,zpt6

       integer slpi(10), slp

       real*8 xlin1(5000),ylin1(5000)
       real*8 xlin3(5000),ylin3(5000)

       real*8 xru(2),xrv(2),xsu(2),xsv(2)

       real*8 xtu2(100),xtv2(100),xtu4(100),xtv4(100)
       real*8 xtu9(100),xtv9(100),xtu11(100),xtv11(100)

       real*8 xlte11(100),xl911(100),xlle9(100)
       real*8 xrte11(100),xr911(100),xrle9(100)
       real*8 xc24(100)

c       real*8 px9i(300),py9i(300)
       real*8 px9o(300),py9o(300)

       real*8 xanchor(100,6),yanchor(100,6)
       real*8 xanchoril(100,6),yanchoril(100,6)
       real*8 xanchorir(100,6),yanchorir(100,6)


       real*8 xprb(0:100,6,0:10),yprb(0:100,6,0:10)

       real*8 jconi(6),jconf(6),xkprb(6)

       real*8 jcve(100),jcvi(100)

       real*8 xirl(0:300),xirr(0:300),jirl(0:300),jirr(0:300)

       real*8 distee(0:300),anglee(0:300),siu(0:300),siv(0:300)


       real*8 alprom,xdu,xdv,xpo1,xpo2,ypo1,ypo2

       real*8 xlll,xrrr,yrrr,ylll,xgir

       real*8 xpos,ypos,xpx2,xpy2,xr,xs,xrm,xsm

       real*8 xequis,yequis, xth1, xth2

       real*8 xlabel, zlabel, clli, varrow

c      real*8 pi
       pi=4.*datan(1.0d0)

c      integer color

       lepv="LEparagliding 2.60"


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      3. INIT
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       
       write (*,*)
       write (*,*) "LABORATORI D'ENVOL PARAGLIDING"
       write (*,*) "Paragliders and parachutes design program"
       write (*,*)
       write (*,*) "LEparagliding 2.60 version ""Les Escaules"" "
       write (*,*) "(2016-12-12)"
       write (*,*)
       write (*,*) "Pere Casellas"
       write (*,*) "pere@laboratoridenvol.com"
       write (*,*) "GNU General Public License 3.0 http://www.gnu.org"
       write (*,*)

       open(unit=20,file='leparagliding.dxf')
       open(unit=22,file='leparagliding.txt')
       open(unit=23,file='lep-out.txt')
       open(unit=30,file='lines.txt')
       open(unit=25,file='lep-3d.dxf') 
       
       call dxfinit(20)

       call dxfinit(25)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4. DATA READING
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Lectura de dades del fitxer

       rewind (22)
       rewind (23)
       rewind (30)

c      4.1 Basic data
       do i=1,9
       read (22,*)
       end do

       read (22,*) bname
       read (22,*)
       read (22,*) wname
       read (22,*)
       read (22,*) xkf
       read (22,*)
       read (22,*) xwf
       read (22,*)
       read (22,*) ncells
       read (22,*)
       read (22,*) nribst
       read (22,*)
       read (22,*) alpham, kbbb         ! case 0,1

c      Read case "2"
       if (kbbb.eq.2) then
       backspace(22)
       read (22,*) alpham, kbbb, alphac ! case 2
       alphat=alpham-alphac
       end if

       read (22,*)
       read (22,*) atp, kaaa
       read (22,*)
       read (22,*)

c      4.2  Ribs geometry
       nribss=int(ncells/2.)+1

c      Ribs geometry rib,x,LE,TE,chord,x',z,beta,RP 
       do i=1,nribss
       read (22,*) rib(i,1), rib(i,2), rib(i,3), rib(i,4), rib(i,6), 
     + rib(i,7), rib(i,9), rib(i,10), rib(i,51)

c      Anticipates tan(0.0) if beta=0.
       if (rib(i,10).eq.0.) then
       rib(i,10)=0.01
       end if

c      Anticipates xp=0 in central airfoil
       if (rib(1,6).eq.0.) then
       rib(i,6)=0.01
       end if

c      central cell width control
       cencell=rib(1,2)

c      Scale
       rib(i,2)=rib(i,2)*xwf
       rib(i,3)=rib(i,3)*xwf
       rib(i,4)=rib(i,4)*xwf
       rib(i,6)=rib(i,6)*xwf
       rib(i,7)=rib(i,7)*xwf

c      Chord
       rib(i,5)=rib(i,4)-rib(i,3)

c      Washin calculus

c      Case 0
       
       if (kbbb.eq.0) then
       rib(i,8)=rib(i,51)
       end if

c      Case 1
       if (kbbb.eq.1) then
       ribdif=rib(1,5)-rib(i,5)
       ribdim=rib(1,5)-rib(nribss,5)
       rib(i,8)=alpham*ribdif/ribdim
       end if

c      Case 2
       if (kbbb.eq.2) then
       ribdif=rib(1,5)-rib(i,5)
       ribdim=rib(1,5)-rib(nribss,5)
       rib(i,8)=(alphat*ribdif/ribdim)+alphac
       end if

       end do

       write (*,*) "Planform read"

c      4.3 Airfoil data: name, intakes location, open cells, disp
       read (22,*)
       read (22,*)
       read (22,*)
       read (22,*)
       do i=1,nribss
       read (22,*) rib(i,1),nomair(i),rib(i,11),rib(i,12),rib(i,14)
     + ,rib(i,50),rib(i,55),rib(i,56)
       end do

c      4.4 Airfoil data: anchor points A,B,C,D,E,F location

       read (22,*)
       read (22,*)
       read (22,*)
       read (22,*)
       do i=1,nribss
       read (22,*) rib(i,1),rib(i,15),rib(i,16),rib(i,17),rib(i,18),
     + rib(i,19),rib(i,20),rib(i,21)
       end do

c      4.5 Load rib 0 data

       do k=1,50
       rib(0,k)=rib(1,k)
       end do
       rib(0,6)=-rib(1,6)

       write (*,*) "Ribs read"

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.6 Read holes
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       read (22,*)
       read (22,*)
       read (22,*)
       read (22,*) ndis

       do m=1,ndis
       
       read (22,*) nrib1
       read (22,*) nrib2
       read (22,*) nhols

       ir=nrib1

       do l=1,nhols

       hol(ir,l,1)=float(nhols)

       read(22,*) hol(ir,l,9),hol(ir,l,2),hol(ir,l,3),hol(ir,l,4),
     + hol(ir,l,5),hol(ir,l,6),hol(ir,l,7),hol(ir,l,8)

       end do
       
       do ii=nrib1,nrib2

       do l=1,nhols

       hol(ii,l,1)=hol(ir,l,1)
       hol(ii,l,2)=hol(ir,l,2)
       hol(ii,l,3)=hol(ir,l,3)
       hol(ii,l,4)=hol(ir,l,4)
       hol(ii,l,5)=hol(ir,l,5)
       hol(ii,l,6)=hol(ir,l,6)
       hol(ii,l,7)=hol(ir,l,7)
       hol(ii,l,8)=hol(ir,l,8)
       hol(ii,l,9)=hol(ir,l,9)

       if (hol(ii,l,9).eq.11) then ! parameters for unloaded
       ii11=ii
       nhols11=nhols
       end if

       end do

       end do

       end do

       write (*,*) "Airfoil holes read"

       ir=1
       
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.7 Read skin tension data
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc  

       read (22,*)
       read (22,*)
       read (22,*)
       read (22,*)

       do k=1,6
       read (22,*) skin(k,1),skin(k,2),skin(k,3),skin(k,4)
       end do
       read (22,*) htens
       htensi=htens
       read (22,*) ndif, xndif

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.8 Read sewing allowances
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       read (22,*)
       read (22,*)
       read (22,*)
       read (22,*) xupp, xupple, xuppte
       read (22,*) xlow, xlowle, xlowte
       read (22,*) xrib
       read (22,*) xvrib

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.9 Read marks
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       read (22,*)
       read (22,*)
       read (22,*)
       read (22,*) xmark, xcir, xdes

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.10 Read calage estimation parameters
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       read (22,*)
       read (22,*)
       read (22,*)
       read (22,*)
       read (22,*) finesse
       read (22,*)
       read (22,*) cpress
       read (22,*)
       read (22,*) calage
       read (22,*)
       read (22,*) clengr
       read (22,*)
       read (22,*) clengl
       clengl=clengl*xwf
       read (22,*)
       read (22,*) clengk

       write (*,*) "Calage read"

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.11 Read suspension lines description
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       read (22,*)
       read (22,*)
       read (22,*)

c      Read pondered media type zcontrol
       read (22,*) zcontrol

c      Read plans number
       read (22,*) slp

       do ii=1,int(slp) ! Brakes included

c      Read paths in plane ii
       read (22,*) cam(ii)

c      Read path i in plane ii
       do i=1,cam(ii)

       read (22,*) mc(ii,i,1), mc(ii,i,2), mc(ii,i,3), mc(ii,i,4), 
     + mc(ii,i,5),mc(ii,i,6), mc(ii,i,7), mc(ii,i,8), mc(ii,i,9),
     + mc(ii,i,14), mc(ii,i,15)

       end do

c      Reread data file
       do i=1,cam(ii)       
       backspace (22)
       end do

       do i=1,cam(ii)

c      Read normally levels 1 to 4
       if (mc(ii,i,1).le.4) then
       read (22,*) mc(ii,i,1), mc(ii,i,2), mc(ii,i,3), mc(ii,i,4), 
     + mc(ii,i,5),mc(ii,i,6), mc(ii,i,7), mc(ii,i,8), mc(ii,i,9),
     + mc(ii,i,14), mc(ii,i,15)
       mc(ii,i,10)=0.
       mc(ii,i,11)=0.
       end if
c      Read additional level number 5
       if (mc(ii,i,1).eq.5) then
       read (22,*) mc(ii,i,1), mc(ii,i,2), mc(ii,i,3), mc(ii,i,4), 
     + mc(ii,i,5),mc(ii,i,6), mc(ii,i,7), mc(ii,i,8), mc(ii,i,9),
     + mc(ii,i,10), mc(ii,i,11), mc(ii,i,14), mc(ii,i,15)
       end if

       end do


       end do

       write (*,*) "Lines read"

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.12 Read brakes
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       ii=slp+1

       read (22,*)
       read (22,*)
       read (22,*)

c      Rean main brake length

       read (22,*) clengb

       clengb=clengb*xwf

c      Read paths
       read (22,*) cam(ii)

c      Read path i
       do i=1,cam(ii)

       read (22,*) mc(ii,i,1), mc(ii,i,2), mc(ii,i,3), mc(ii,i,4), 
     + mc(ii,i,5),mc(ii,i,6), mc(ii,i,7), mc(ii,i,8), mc(ii,i,9),
     + mc(ii,i,14), brake(i,3)

c      Fractional anchors option
       brake(i,1)=float(int(brake(i,3)))
       brake(i,2)=brake(i,3)-brake(i,1)
       mc(ii,i,15)=int(brake(i,3))

c       write(*,*) i, brake(i,1), brake(i,2), mc(ii,i,15)

       end do

c      Read Brake distribution

       read (22,*)
       read (22,*) bd(1,1), bd(2,1), bd(3,1), bd(4,1), bd(5,1)
       read (22,*) bd(1,2), bd(2,2), bd(3,2), bd(4,2), bd(5,2)
       bd(1,2)=bd(1,2)*xwf
       bd(2,2)=bd(2,2)*xwf 
       bd(3,2)=bd(3,2)*xwf 
       bd(4,2)=bd(4,2)*xwf 
       bd(5,2)=bd(5,2)*xwf

       write (*,*) "Brakes read"

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.13 Read ramification lengths
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       read (22,*)
       read (22,*)
       read (22,*)

       read (22,*) raml(3,1), raml(3,3)
       read (22,*) raml(4,1), raml(4,3), raml(4,4)
       read (22,*) raml(5,1), raml(5,3)
       read (22,*) raml(6,1), raml(6,3), raml(6,4)

       raml(3,1)=raml(3,1)*xwf 
       raml(3,3)=raml(3,3)*xwf
       raml(4,1)=raml(4,1)*xwf
       raml(4,3)=raml(4,3)*xwf  
       raml(4,4)=raml(4,4)*xwf
       raml(5,1)=raml(5,1)*xwf
       raml(5,3)=raml(5,3)*xwf
       raml(6,1)=raml(6,1)*xwf
       raml(6,3)=raml(6,3)*xwf
       raml(6,4)=raml(6,4)*xwf

       write (*,*) "Ramifications read"

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.14 Read H V and HV ribs
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       read (22,*)
       read (22,*)
       read (22,*)

       read (22,*) nhvr
       read (22,*) xrsep, yrsep

       xrsep=xrsep*xkf
       yrsep=yrsep*xkf

       if (nhvr.ne.0) then
       
       do i=1,nhvr
       read (22,*) hvr(i,1),hvr(i,2),hvr(i,3),hvr(i,4),hvr(i,5),hvr(i,6)
     + ,hvr(i,7),hvr(i,8),hvr(i,9),hvr(i,10)

c      Case 3 special, use f- and r+ in % of chord, instead of absolute cm
c      Yuri request 2016-08-25
c      Set column 7 and 8 in %, and column number 9 to "1"
       if (hvr(i,2).eq.3.and.hvr(i,9).eq.1) then
       hvr(i,7)=(hvr(i,7)/100)*(rib(hvr(i,3),5))

       if (hvr(i,5).eq.1.and.hvr(i,6).eq.0) then
       hvr(i,8)=(hvr(i,8)/100)*(rib(hvr(i,3)-1,5))
       end if
       if (hvr(i,5).eq.0.and.hvr(i,6).eq.1) then
       hvr(i,8)=(hvr(i,8)/100)*(rib(hvr(i,3)+1,5))
       end if
       if (hvr(i,5).eq.1.and.hvr(i,6).eq.1) then
       hvr(i,8)=(hvr(i,8)/100)*(rib(hvr(i,3),5))
       end if

       end if

       end do

c      Re-read file
       do i=1,nhvr
       backspace(22)
       end do

c      Allow read type 6 in lep >= 2.49
c      Feature will be deleted when updated data file format
       do i=1,nhvr
       if (hvr(i,2).eq.6) then
       read (22,*) hvr(i,1),hvr(i,2),hvr(i,3),hvr(i,4),hvr(i,5),hvr(i,6)
     + ,hvr(i,7),hvr(i,8),hvr(i,9),hvr(i,10),hvr(i,11),hvr(i,12)
       else
       read (22,*) hvr(i,1),hvr(i,2),hvr(i,3),hvr(i,4),hvr(i,5),hvr(i,6)
     + ,hvr(i,7),hvr(i,8),hvr(i,9),hvr(i,10)
       end if
       end do

       end if


       write (*,*) "H V VH ribs read"

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.15 Read extrados colors
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       read (22,*)
       read (22,*)
       read (22,*)

       read (22,*) npce

c      k=total ribs with colors marks
       do k=1,npce

       read (22,*) npc1e(k), npc2e(k)

c      l=mark number in k rib
       do l=1,npc2e(k)

       read (22,*) npc3e(k,l), xpc1e(k,l), xpc2e(k,l)

       end do

       end do  

       write (*,*) "Extrados colors read"

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.16 Read intrados colors
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       read (22,*)
       read (22,*)
       read (22,*)

       read (22,*) npci

c      k=total ribs with colors marks
       do k=1,npci

       read (22,*) npc1i(k), npc2i(k)

c      l=mark number in k rib
       do l=1,npc2i(k)

       read (22,*) npc3i(k,l), xpc1i(k,l), xpc2i(k,l)

       end do

       end do

        write (*,*) "Intrados colors read"

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.17 Read aditional rib points
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       read (22,*)
       read (22,*)
       read (22,*)

       read (22,*) narp

       do i=1,narp

       read (22,*) xarp(i), yarp(i)

       end do

       write (*,*) "Aditional rib points read"

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.18 Read elastic lines corrections
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       read (22,*)
       read (22,*)
       read (22,*)

       read (22,*) csusl

       read (22,*) cdis(2,1), cdis(2,2)
       read (22,*) cdis(3,1), cdis(3,2), cdis(3,3)
       read (22,*) cdis(4,1), cdis(4,2), cdis(4,3), cdis(4,4)
       read (22,*) cdis(5,1), cdis(5,2), cdis(5,3),cdis(5,4),cdis(5,5)

       do i=1,5

       read (22,*) csus(i,1), csus(i,2), csus(i,3), csus(i,4)

       end do

       write (*,*) "Elastic lines corrections read"

       write (*,*) 

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.19 Center of gravity calculus (2D)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Planform

       acit=rib(1,2)*rib(1,5)
       cdgx=0.5*rib(1,2)*acit
       cdgy=0.5*(rib(1,3)+rib(1,4))*acit

       do i=1,nribss-1

       aci=0.5*(rib(i,5)+rib(i+1,5))*(rib(i+1,2)-rib(i,2))
       xci=0.5*(rib(i,2)+rib(i+1,2))
       yci=0.25*(rib(i,3)+rib(i,4)+rib(i+1,3)+rib(i+1,4))

       cdgx=cdgx+xci*aci
       cdgy=cdgy+yci*aci

       acit=acit+aci

       end do

       cdgx=cdgx/acit
       cdgy=cdgy/acit

       cdg=100.*((cdgy-rib(1,3))/rib(1,5))

       if (atp.eq."ds".or.atp.eq."ss") then
       write (*,'(A,F5.2,A)') " Area = ", acit*2./10000., " m2"
       else
       write (*,'(A,F5.2,A,F7.1,A)') " Area = ", acit*2./10000., " m2 ",
     + 10.7639*acit*2./10000.," ft2"
       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      4.20 Adjust some parameters
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Escala descensos de ribs no suspentats
       do i=1,nribss

       rib(i,50)=rib(i,50)*xwf

       end do

c      Rib and panel separation parameters
       seprix=350.*xwf
       sepriy=90.*xwf
       seppix=60.*xwf

c      If wing type eq "pc" increase by 1.2 sep ribs
       if (atp.eq."pc") then
       seprix=seprix*1.2
       sepriy=sepriy*1.2
       seppix=seppix*1.2
       end if

c     Compute some ribs additional parameters
c     Lengths from LE to anchor points A,B,...E

      do i=0,nribss

      rib(i,66)=(rib(i,16)*rib(i,5)/100.)
      rib(i,67)=(rib(i,17)*rib(i,5)/100.)
      rib(i,68)=(rib(i,18)*rib(i,5)/100.)
      rib(i,69)=(rib(i,19)*rib(i,5)/100.)
      rib(i,70)=(rib(i,20)*rib(i,5)/100.)

      end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     4.21 DXF layers  (project)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


     
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      5. GRAPHIC DESIGN
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      5.1 Planform
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box (1,1)

c      Ribs
       do i=1,nribss
       call line(rib(i,2),rib(i,3),rib(i,2),rib(i,4),5)
       call line(-rib(i,2),rib(i,3),-rib(i,2),rib(i,4),5)

c       call itxt(rib(i,2)-50.,rib(i,4)+10.,10.0d0,0.0d0,i,7)
c       call itxt(-rib(i,2)-50.,rib(i,4)+10.,10.0d0,0.0d0,i,7)

       end do

c      Leading edge        
       call line(-rib(1,2),rib(1,3),rib(1,2),rib(1,3),1)
       do i=1,nribss-1
       call line(rib(i,2),rib(i,3),rib(i+1,2),rib(i+1,3),1)
       call line(-rib(i,2),rib(i,3),-rib(i+1,2),rib(i+1,3),1)
       end do
 
c      Trailing edge  
       call line(-rib(1,2),rib(1,4),rib(1,2),rib(1,4),3)
       do i=1,nribss-1
       call line(rib(i,2),rib(i,4),rib(i+1,2),rib(i+1,4),3)
       call line(-rib(i,2),rib(i,4),-rib(i+1,2),rib(i+1,4),3)
       end do

c      Intake in

       if (cencell.ge.0.01.and.rib(1,14).eq.1)  then  
       call line(-rib(1,2),rib(1,3)+rib(1,5)*rib(1,11)/100.,rib(1,2),
     + rib(1,3)+rib(1,5)*rib(1,11)/100.,6)
       end if

       do i=2,nribss
       if(rib(i,14).eq.1) then
       call line(rib(i-1,2),rib(i-1,3)+rib(i-1,5)*rib(1,11)/100.,
     + rib(i,2),rib(i,3)+rib(i,5)*rib(1,11)/100.,6)
       call line(-rib(i-1,2),rib(i-1,3)+rib(i-1,5)*rib(1,11)/100.,
     + -rib(i,2),rib(i,3)+rib(i,5)*rib(1,11)/100.,6)
       end if

       if(rib(i,14).eq.0) then
       call line(rib(i-1,2),rib(i-1,3)+rib(i-1,5)*rib(1,11)/100.,
     + rib(i,2),rib(i,3)+rib(i,5)*rib(1,11)/100.,9)
       call line(-rib(i-1,2),rib(i-1,3)+rib(i-1,5)*rib(1,11)/100.,
     + -rib(i,2),rib(i,3)+rib(i,5)*rib(1,11)/100.,9)
       end if          

       end do

c      Central cell
       i=1
       if(rib(i,14).eq.0) then
       call line(-rib(i,2),rib(i,3)+rib(i,5)*rib(1,11)/100.,
     + rib(i,2),rib(i,3)+rib(i,5)*rib(1,11)/100.,9)
       end if      
        
c      Intake out

       if (cencell.ge.0.01.and.rib(1,14).eq.1)  then  
       call line(-rib(1,2),rib(1,3)+rib(1,5)*rib(1,12)/100.,rib(1,2),
     + rib(1,3)+rib(1,5)*rib(1,12)/100.,6)
       end if

       do i=2,nribss
       if(rib(i,14).eq.1) then
       call line(rib(i-1,2),rib(i-1,3)+rib(i-1,5)*rib(1,12)/100.,
     + rib(i,2),rib(i,3)+rib(i,5)*rib(1,12)/100.,6)
       call line(-rib(i-1,2),rib(i-1,3)+rib(i-1,5)*rib(1,12)/100.,
     + -rib(i,2),rib(i,3)+rib(i,5)*rib(1,12)/100.,6)
       end if
       end do

c      Anchor points

       xpoi=3. ! segment

       do i=1,nribss
       do k=1,int(rib(i,15))

       call line(rib(i,2)-xpoi,rib(i,3)+rib(i,5)*rib(i,15+k)/100.,
     + rib(i,2)+xpoi,rib(i,3)+rib(i,5)*rib(i,15+k)/100.,1)

       call line(xpoi-rib(i,2),rib(i,3)+rib(i,5)*rib(i,15+k)/100.,
     + -rib(i,2)-xpoi,rib(i,3)+rib(i,5)*rib(i,15+k)/100.,1)
       
       end do
       end do

c      Brakes in 2D included fractionary points

       do k=1,cam(ii)     ! cam in brake lines

       i=int(brake(k,3))  ! rib

       if (rib(i,21).ne.0.) then

       xr=rib(i,2)
       xs=rib(i,3)+rib(i,5)*rib(i,21)/100.

       brake(k,1)=float(int(brake(k,3)))
       brake(k,2)=brake(k,3)-brake(k,1)

       if (i.lt.nribss.and.brake(k,2).ne.0.) then
       xrm=rib(i+1,2)
       xsm=rib(i+1,3)+rib(i+1,5)*rib(i+0,21)/100.0d0 ! i+0 ok
       xr=xr+brake(k,2)*(xrm-xr)
       xs=xs+brake(k,2)*(xsm-xs)
       end if

       call ellipse(xr,xs,1.5*xcir,1.5d0*xcir,0.0d0,1)
       call ellipse(-xr,xs,1.5*xcir,1.5d0*xcir,0.0d0,1)

       end if

       end do

c      Restitute virtual anchor for 3D if rib i+1 not defined
c      Not strictly necessary
       do k=1,cam(ii)
       i=int(brake(k,3)) 
       if (i.lt.nribss.and.rib(i+1,21).eq.0.and.brake(k,2).ne.0) then
       rib(i+1,21)=100.  ! only 100% case, or specify value
       end if   
       end do


c      Extrados colors

       xpoi=2. ! segment

       do k=1,npce
      
       i=npc1e(k)

       do l=1,npc2e(k)

       ydist=100.-xpc1e(k,l)

       call line(rib(i,2)-xpoi,rib(i,3)+rib(i,5)*ydist/100.,
     + rib(i,2)+xpoi,rib(i,3)+rib(i,5)*ydist/100.,4)
       
       end do
       end do

c      Intrados colors

       if (atp.ne."ss") then

       xpoi=2. ! segment

       do k=1,npci
      
       i=npc1i(k)

       do l=1,npc2i(k)

       ydist=100.-xpc1i(k,l)

       call line(-rib(i,2)-xpoi,rib(i,3)+rib(i,5)*ydist/100.,
     + -rib(i,2)+xpoi,rib(i,3)+rib(i,5)*ydist/100.,7)
       
       end do
       end do

       end if

c      Miniribs and unloaded middle ribs

       rib(0,2)=-rib(1,2)
       rib(0,3)=rib(1,3)
       rib(0,4)=rib(1,4)

       do i=1,nribss

c      Draw only if minirib present
       if (rib(i,56).gt.1) then

       xru(1)=0.5*(rib(i,2)+rib(i-1,2))
       xrv(1)=0.5*(rib(i,3)+rib(i-1,3))
       xru(2)=0.5*(rib(i,2)+rib(i-1,2))
       xrv(2)=0.5*(rib(i,4)+rib(i-1,4))
       xrv(1)=xrv(2)-0.5*(rib(i,5)+rib(i-1,5))*rib(i,56)/100.

       call line(xru(1),xrv(1),xru(2),xrv(2),8)
       call line(-xru(1),xrv(1),-xru(2),xrv(2),8)
       
       end if

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      5.2 Canopy design - vault
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box (1,1)

       x0=0.
       y0=380.*xkf

       call line(-rib(1,6),y0+rib(1,7),rib(1,6),y0+rib(1,7),5)
       do i=1,nribss-1
       call line(rib(i,6),y0+rib(i,7),rib(i+1,6),y0+rib(i+1,7),5)
       call line(-rib(i,6),y0+rib(i,7),-rib(i+1,6),y0+rib(i+1,7),5)
       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      5.3 Boxes
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6x4

       do asep=0.,5.,1.
       do bsep=0.,3.,1.

       x1=-630.*xkf+asep*1260.*xkf
       x2=630.*xkf+asep*1260.*xkf
       y1=-50.*xkf+bsep*890.95*xkf
       y2=840.95*xkf+bsep*890.95*xkf

       call line(x1,y1,x2,y1,9)
       call line(x1,y1,x1,y2,9)
       call line(x2,y1,x2,y2,9)
       call line(x1,y2,x2,y2,9)
       
       end do
       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6. AIRFOILS coordinates calculus
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=1,nribss

c      rewind 23
       open (24, file=nomair(i))
       rewind (24)

       tetha=rib(i,8)*pi/180.

c      6.1 Read global points
       read (24,*) 
       read (24,*) np(i,1) ! total points
       read (24,*) np(i,2) ! extrados points
       read (24,*) np(i,3) ! intake points
       read (24,*) np(i,4) ! intrados points

       np(i,5)=np(i,2)+np(i,3)-1
       
c      Rib 0 points
       np(0,1)=np(1,1)
       np(0,2)=np(1,2)
       np(0,3)=np(1,3)
       np(0,4)=np(1,4)

       do j=1,np(i,1)

c      6.2 Read airfoil coordinates
       read (24,*) u(i,j,1),v(i,j,1)

c      6.3 Airfoil coordinates *100
       u(i,j,2)=100.*u(i,j,1)
       v(i,j,2)=100.*v(i,j,1)

c      6.4 Airfoil escaled and displaced coordinates
       u(i,j,3)=rib(i,5)*u(i,j,1)
       v(i,j,3)=rib(i,5)*v(i,j,1)-rib(i,50)

c      6.5 Airfoil washin coordinates
       u(i,j,4)=(u(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (v(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       v(i,j,4)=(-u(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (v(i,j,3))*dcos(tetha)

c      6.6 Airfoil (u,v,w) espace coordinates
       u(i,j,5)=u(i,j,4)
       v(i,j,5)=v(i,j,4)*dcos(rib(i,9)*pi/180.)
       w(i,j,5)=-v(i,j,4)*dsin(rib(i,9)*pi/180.)

c      6.7 Airfoil (x,y,z) absolute coordinates
       x(i,j)=rib(i,6)-w(i,j,5)
       y(i,j)=rib(i,3)+u(i,j,5)
       z(i,j)=rib(i,7)-v(i,j,5)

c      6.8 Tornar a posar la costella al seu lloc
       v(i,j,3)=v(i,j,3)+rib(i,50)

       end do

       end do

c      6.9 Airfoil 0 = 1' (symetrical to airfoil 1) BUT NON DISPLACED COORD

       do j=1,np(1,1)

       u(0,j,1)=u(1,j,1)
c      v(0,j,1)=u(1,j,1) ERROR
       v(0,j,1)=v(1,j,1)

c      Airfoil coordinates *100
       u(0,j,2)=u(1,j,2)
       v(0,j,2)=v(1,j,2)

c      Airfoil escaled coordinates
       u(0,j,3)=u(1,j,3)
       v(0,j,3)=v(1,j,3)

c      Airfoil washin coordinates
       u(0,j,4)=u(1,j,4)
       v(0,j,4)=v(1,j,4)

c      Airfoil (u,v,w) espace coordinates
       u(0,j,5)=-u(1,j,5)
       v(0,j,5)=v(1,j,5)
       w(0,j,5)=w(1,j,5)

c      Airfoil (x,y,z) absolute coordinates
       x(0,j)=-x(1,j)
       y(0,j)=y(1,j)
       z(0,j)=z(1,j)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Tornar a posar la costella al seu lloc
c      WARNING WARNIG
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c       v(0,j,3)=u(1,j,3)+rib(1,50)  ERROR
       v(0,j,3)=v(1,j,3)

       end do

c      6.10 Assignation 3D coordinates airfoil 0:

       i=1
       do j=1,np(1,1)
       xx(i,j)=-rib(i,6)+w(1,j,5)
       yy(i,j)=rib(i,3)+u(1,j,5)
       zz(i,j)=rib(i,7)-v(1,j,5)
       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.10+ Compute TE-anchor lenghts along airfoil contour
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss

       do klz=1,rib(i,15) ! Iterate in A,B,C,D,E

       do j=np(i,1),2,-1

c      Detect segment j-1,j where anchor A,B,C,D,E is and interpolate
c      point u,v = rib(i,110+klz) rib(i,120+klz)

       if (u(i,j-1,3).le.rib(i,65+klz).and.u(i,j,3).gt.rib(i,65+klz).
     + and.u(i,j,3).ge.0) then

c      Interpolation v=xm * u + xb
       rib(i,110+klz)=rib(i,65+klz)
       xm=(v(i,j,3)-v(i,j-1,3))/(u(i,j,3)-u(i,j-1,3))
       xb=v(i,j-1,3)-xm*u(i,j-1,3)
       rib(i,120+klz)=xm*rib(i,110+klz)+xb

c      Compute distances along bottom surface

       rib(i,130+klz)=0.
       do jj=np(i,1),j+1,-1
       rib(i,130+klz)=rib(i,130+klz)+sqrt((u(i,jj,3)-u(i,jj-1,3))**2+
     + (v(i,jj,3)-v(i,jj-1,3))**2)
       end do
       rib(i,130+klz)=rib(i,130+klz)+sqrt((u(i,j,3)-rib(i,110+klz))**2+
     + (v(i,j,3)-rib(i,120+klz))**2)

c      Verificar amb CAD!!!

       end if

       end do ! j

       end do ! klz

       end do ! rib i


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.11 Compute external cutt edges in airfoils (i,j,16)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      REVISAR LA PREOGRAMACIO. SIMPLIFICAR

       xcos=xrib/10. ! rib sewing allowance mm to cm

       do i=0,nribss
      
       do j=2,np(i,1)-1

c      Amplification factor
       xcosk=1.0

c      Fer mitja entre j-1 i j+1
       alpha1=(datan((v(i,j+1,3)-v(i,j,3))/((u(i,j+1,3)-u(i,j,3)))))
       alpha2=(datan((v(i,j,3)-v(i,j-1,3))/((u(i,j,3)-u(i,j-1,3)))))

       alpha=0.5*(alpha1+alpha2)

     
c      Alpha correction in sawtooht mono-surface airfoils
c      Dóna la volta a la vora superior

       if (alpha1.lt.0.and.alpha2.gt.0.and.j.ge.np(i,2)) then
c       alpha=alpha+pi
c       write (*,*) "correccio"
       end if     

       if (i.eq.1) then
c       write (*,*) "AQUI ",i,j,alpha1,alpha2,alpha
       end if


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Correcció xcosk a vores dent de serra
       if (atp.eq."ss".and.j.ge.np(i,2)+np(i,3)-1) then
       xcosk=1./(dsin(0.5*(pi+alpha1-alpha2))) 
       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       u(i,j,16)=u(i,j,3)-xcos*xcosk*dsin(alpha)

       if(v(i,j,3).ge.0.) then
       v(i,j,16)=v(i,j,3)+xcos*xcosk*dcos(alpha)
       end if

       if(v(i,j,3).ge.0.and.j.ge.np(i,2)) then
       u(i,j,16)=u(i,j,3)+xcos*xcosk*dsin(alpha)
       v(i,j,16)=v(i,j,3)-xcos*xcosk*dcos(alpha)
       end if

       if(v(i,j,3).lt.0.) then
       u(i,j,16)=u(i,j,3)+xcos*xcosk*dsin(alpha)
       v(i,j,16)=v(i,j,3)-xcos*xcosk*dcos(alpha)
       end if

       if(u(i,j,3).eq.0) then
       u(i,j,16)=u(i,j,3)-xcos*xcosk
       v(i,j,16)=v(i,j,3)
       end if

       end do

       j=1

       alpha=(datan((v(i,j+1,3)-v(i,j,3))/((u(i,j+1,3)-u(i,j,3)))))

       u(i,j,16)=u(i,j,3)-xcos*xcosk*dsin(alpha)

       if(v(i,j,3).ge.0.) then
       v(i,j,16)=v(i,j,3)+xcos*xcosk*dcos(alpha)
       end if

       if(v(i,j,3).lt.0.) then
       u(i,j,16)=u(i,j,3)+xcos*xcosk*dsin(alpha)
       v(i,j,16)=v(i,j,3)-xcos*xcosk*dcos(alpha)

       end if

       j=np(i,1)

       alpha=(datan((v(i,j,3)-v(i,j-1,3))/((u(i,j,3)-u(i,j-1,3)))))

       u(i,j,16)=u(i,j,3)-xcos*xcosk*dsin(alpha)

       if(v(i,j,3).ge.0.) then
       v(i,j,16)=v(i,j,3)+xcos*xcosk*dcos(alpha)
       end if

       if(v(i,j,3).le.0.) then
       u(i,j,16)=u(i,j,3)+xcos*xcosk*dsin(alpha)
       v(i,j,16)=v(i,j,3)-xcos*xcosk*dcos(alpha)
       end if

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.11+ Airfoils thickness
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Aproximate calculus (not inperpolated)
c      Special airfoils not considered
c      Please improve

       do i=0,nribss

c      Extrados thickness
       do j=1,np(i,1)-1
       if (v(i,j+1,3).ge.v(i,j,3).and.u(i,j+1,3).lt.u(i,j,3)) then
       xth1=v(i,j+1,3)
       end if
c      Intrados thickness
       if (v(i,j+1,3).le.v(i,j,3).and.u(i,j+1,3).gt.u(i,j,3)) then
       xth2=v(i,j+1,3)
       end if
       end do
c      Airfoil thickness
       rib(i,148)=xth1-xth2
       rib(i,149)=100.*rib(i,148)/rib(i,5)

c      write (*,*) "Thicknees= ", i, rib(i,148), rib(i,149)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.12 Airfoils drawing (complete)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
              
c      Box (1,2)
       
       sepxx=700.*xkf
       sepyy=100.*xkf
c      sepyy=100

       kx=0
       ky=0
       kyy=0

       do i=1,nribss

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*1.0*float(ky)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Numering ribs
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       call itxt(sepx-100.,sepy,10.0d0,0.0d0,i,7)
       call itxt(sepx-100.,sepy+890.95*xkf,10.0d0,0.0d0,i,7)
       call itxt(sepx-100.+2530.*xkf,sepy,10.0d0,0.0d0,i,7)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.12.0 Miniribs
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Upper surface minirib
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (rib(i,56).gt.1.and.rib(i,56).ne.100.and.atp.ne."ss") 
     + then

       rib(i,60)=0. ! Extrados minirib length

c      Detect point extrados
       do j=1,np(i,2)-1
       xminirib=rib(i-1,5)*rib(i,56)/100.       
       if (u(i-1,1,3)-u(i-1,j,3).lt.xminirib.and.u(i-1,1,3)-u(i-1,j+1,3)
     + .ge.xminirib) then
       jcontrole=j
       jcve(i)=j ! control vector extrados

       rib(i,107)=xminirib-(u(i-1,1,3)-u(i-1,j,3))
       xequise=u(i-1,j,3)-rib(i,107)
       yequise=v(i-1,j,3)-rib(i,107)*(v(i-1,j,3)-v(i-1,j+1,3))/
     + (u(i-1,j,3)-u(i-1,j+1,3))
       end if
       end do

c      Draw extrados minirib, Print and MC
       do j=1,jcontrole-1
       call line(sepx+u(i-1,j,3),-v(i-1,j,3)+sepy-sepriy*0.5,
     + sepx+u(i-1,j+1,3),-v(i-1,j+1,3)+sepy-sepriy*0.5,1)

       call line(sepx+u(i-1,j,16),-v(i-1,j,16)+sepy-sepriy*0.5,
     + sepx+u(i-1,j+1,16),-v(i-1,j+1,16)+sepy-sepriy*0.5,3)
       call line(2530.*xkf+sepx+u(i-1,j,16),-v(i-1,j,16)+sepy-sepriy*0.5
     + ,2530.*xkf+sepx+u(i-1,j+1,16),-v(i-1,j+1,16)+sepy-sepriy*0.5,1)

       call line(sepx+u(i-1,j,16),-v(i-1,j,16)+sepy-sepriy*0.5,
     + sepx+u(i-1,j,3),-v(i-1,j,3)+sepy-sepriy*0.5,5)

       rib(i,60)=rib(i,60)+sqrt((u(i-1,j,3)-u(i-1,j+1,3))**2.+
     + (v(i-1,j,3)-v(i-1,j+1,3))**2.)
       end do

       j=1
       call line(2530.*xkf+sepx+u(i-1,j,16),-v(i-1,j,16)+sepy-sepriy*0.5
     + ,2530.*xkf+sepx+u(i-1,j,3),-v(i-1,j,3)+sepy-sepriy*0.5,1)

c      Draw romano and itxt mark in minirib

       x1=2530.*xkf+sepx+u(i-1,j,3)
       y1=-v(i-1,j,3)+sepy-sepriy*0.5
c       call romano(i,x1-rib(i,60)*0.35,y1,0.0d0,1.0d0,7)
       x1=sepx+u(i-1,j,3)
       y1=-v(i-1,j,3)+sepy-sepriy*0.5
       call itxt(x1-rib(i,60)*0.35-30.,y1+1.,3.0d0,0.0d0,i,7)

c      Last segment
       j=jcontrole
       call line(sepx+u(i-1,j,3),-v(i-1,j,3)+sepy-sepriy*0.5,
     + sepx+xequise,-yequise+sepy-sepriy*0.5,1)
       alpha=datan(-(v(i-1,j,3)-v(i-1,j+1,3))/(u(i-1,j,3)-u(i-1,j+1,3)))
       xequisee=xequise+xrib*0.1*dsin(alpha)
       yequisee=yequise+xrib*0.1*dcos(alpha)

       call line(sepx+u(i-1,j,16),-v(i-1,j,16)+sepy-sepriy*0.5,
     + sepx+xequisee,-yequisee+sepy-sepriy*0.5,3)
       call line(2530.*xkf+sepx+u(i-1,j,16),-v(i-1,j,16)+sepy-sepriy*
     + 0.5,2530.*xkf+sepx+xequisee,-yequisee+sepy-sepriy*0.5,1)

       call line(sepx+xequisee,-yequisee+sepy-sepriy*0.5,
     + sepx+xequise,-yequise+sepy-sepriy*0.5,5)
       call line(2530.*xkf+sepx+xequisee,-yequisee+sepy-sepriy*0.5,
     + 2530.*xkf+sepx+xequise,-yequise+sepy-sepriy*0.5,1)

       rib(i,60)=rib(i,60)+sqrt((u(i-1,j,3)-xequisee)**2.+
     + (v(i-1,j,3)-yequisee)**2.)

       end if ! upper surface

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Bottom surface minirib
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (rib(i,56).gt.1.and.rib(i,56).ne.100.and.atp.ne."ss") 
     + then

       rib(i,61)=0. ! Intrados minirib length

c      Detect point intrados
       do j=np(i,1),np(i,2),-1
       xminirib=rib(i-1,5)*rib(i,56)/100.       
       if (u(i-1,1,3)-u(i-1,j,3).lt.xminirib.and.u(i-1,1,3)-u(i-1,j-1,3)
     + .ge.xminirib) then
       jcontroli=j
       jcvi(i)=j ! control vector intrados

       rib(i,107)=xminirib-(u(i-1,1,3)-u(i-1,j,3))
       xequisi=u(i-1,j,3)-rib(i,107)
       yequisi=v(i-1,j,3)-rib(i,107)*(v(i-1,j,3)-v(i-1,j-1,3))/
     + (u(i-1,j,3)-u(i-1,j-1,3))
       end if
       end do

c      Draw intrados minirib, Print and MC
       do J=np(i,1),jcontroli+1,-1
       call line(sepx+u(i-1,j,3),-v(i-1,j,3)+sepy-sepriy*0.5,
     + sepx+u(i-1,j-1,3),-v(i-1,j-1,3)+sepy-sepriy*0.5,1)

       call line(sepx+u(i-1,j,16),-v(i-1,j,16)+sepy-sepriy*0.5,
     + sepx+u(i-1,j-1,16),-v(i-1,j-1,16)+sepy-sepriy*0.5,3) 
       call line(2530.*xkf+sepx+u(i-1,j,16),-v(i-1,j,16)+sepy-sepriy*0.5
     + ,2530.*xkf+sepx+u(i-1,j-1,16),-v(i-1,j-1,16)+sepy-sepriy*0.5,1) 

       call line(sepx+u(i-1,j,16),-v(i-1,j,16)+sepy-sepriy*0.5,
     + sepx+u(i-1,j,3),-v(i-1,j,3)+sepy-sepriy*0.5,5)

       rib(i,61)=rib(i,61)+sqrt((u(i-1,j,3)-u(i-1,j-1,3))**2.+
     + (v(i-1,j,3)-v(i-1,j-1,3))**2.)

       end do

       j=np(i,1)
       call line(2530.*xkf+sepx+u(i-1,j,16),-v(i-1,j,16)+sepy-sepriy*0.5
     + ,2530.*xkf+sepx+u(i-1,j,3),-v(i-1,j,3)+sepy-sepriy*0.5,1)

c      Last segment
       j=jcontroli
       call line(sepx+u(i-1,j,3),-v(i-1,j,3)+sepy-sepriy*0.5,
     + sepx+xequisi,-yequisi+sepy-sepriy*0.5,1)
       alpha=datan((v(i-1,j,3)-v(i-1,j-1,3))/(u(i-1,j,3)-u(i-1,j-1,3)))
       xequisie=xequisi+xrib*0.1*dsin(alpha)
       yequisie=yequisi-xrib*0.1*dcos(alpha)

       call line(sepx+u(i-1,j,16),-v(i-1,j,16)+sepy-sepriy*0.5,
     + sepx+xequisie,-yequisie+sepy-sepriy*0.5,3)
       call line(2530.*xkf+sepx+u(i-1,j,16),-v(i-1,j,16)+sepy-sepriy*0.5
     + ,2530.*xkf+sepx+xequisie,-yequisie+sepy-sepriy*0.5,1)

       call line(sepx+xequisie,-yequisie+sepy-sepriy*0.5,
     + sepx+xequisi,-yequisi+sepy-sepriy*0.5,5)
       call line(2530.*xkf+sepx+xequisie,-yequisie+sepy-sepriy*0.5,
     + 2530.*xkf+sepx+xequisi,-yequisi+sepy-sepriy*0.5,1)


       rib(i,61)=rib(i,61)+sqrt((u(i-1,j,3)-xequisie)**2.+
     + (v(i-1,j,3)-yequisie)**2.)

c      Draw segment minirib
       call line(sepx+xequise,-yequise+sepy-sepriy*0.5,
     + sepx+xequisi,-yequisi+sepy-sepriy*0.5,1)
       call line(2530.*xkf+sepx+xequise,-yequise+sepy-sepriy*0.5,
     + 2530.*xkf+sepx+xequisi,-yequisi+sepy-sepriy*0.5,1)


c      Draw control romano point

       x1=2530.*xkf+sepx+0.5*(xequisi+xequise)
       y1=sepy-sepriy*0.5-0.5*(yequisi+yequise)
       call romano(i,x1+1.,y1+2.,0.0d0,1.0d0,7)

       end if ! bottom surface


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.12.1 Airfoil extrados
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

        do j=1,np(i,2)-1

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Dibuixa airfoils basic contour
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       call line(sepx+u(i,j,3),-v(i,j,3)+sepy,sepx+u(i,j+1,3),
     + -v(i,j+1,3)+sepy,1)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Dibuixa airfoils washin basic contour al seu lloc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       call line(sepx+u(i,j,4),-v(i,j,4)+sepy+xkf*890.95-rib(i,50),
     + sepx+u(i,j+1,4),-v(i,j+1,4)+sepy+xkf*890.95-rib(i,50),3)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Airfoils borders
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       call line(sepx+u(i,j,16),-v(i,j,16)+sepy,sepx+u(i,j+1,16),
     + -v(i,j+1,16)+sepy,3)

       call line(sepx+u(i,j,16),-v(i,j,16)+sepy,sepx+u(i,j,3),
     + -v(i,j,3)+sepy,5)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.12.2 Air inlets
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Case "pc"
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (atp.eq."pc") then

       j=np(i,2)
       k=np(i,2)+np(i,3)-1

c      Basic contour using straight line
       call line(sepx+u(i,j,3),-v(i,j,3)+sepy,sepx+u(i,k,3),
     + -v(i,k,3)+sepy,1)

c      Washin basic contour using straight line
       call line(sepx+u(i,j,4),-v(i,j,4)+sepy+xkf*890.85-rib(i,50),
     + sepx+u(i,k,4),-v(i,k,4)+sepy+xkf*890.85-rib(i,50),3)
 
c      Airfoil borders
       
       xdv=v(i,j,3)-v(i,k,3)
       xdu=u(i,k,3)-u(i,j,3)
       alpha=datan(xdv/xdu)
       if (xdv.eq.0) then
       alpha=0.
       end if

       u(i,j+2,16)=u(i,j,3)-xrib*0.1*dsin(alpha)
       v(i,j+2,16)=v(i,j,3)-xrib*0.1*dcos(alpha)
       u(i,k-2,16)=u(i,k,3)-xrib*0.1*dsin(alpha)
       v(i,k-2,16)=v(i,k,3)-xrib*0.1*dcos(alpha)

       if (rib(i,149).ne.0.) then
       call line(sepx+u(i,j+2,16),-v(i,j+2,16)+sepy,sepx+u(i,k-2,16),
     + -v(i,k-2,16)+sepy,3)
       end if

c      Two lines intersection

c      up nose
       
       xru(1)=u(i,j,16)
       xru(2)=u(i,j-1,16)
       xrv(1)=v(i,j,16)
       xrv(2)=v(i,j-1,16)
       xsu(1)=u(i,j+2,16)
       xsu(2)=u(i,k-2,16)
       xsv(1)=v(i,j+2,16)
       xsv(2)=v(i,k-2,16)

       call xrxs(xru,xrv,xsu,xsv,xtu,xtv)

       u(i,j+1,16)=xtu
       v(i,j+1,16)=xtv

       if (rib(i,149).ne.0.) then
       call line(sepx+u(i,j+1,16),-v(i,j+1,16)+sepy,sepx+u(i,j,16),
     + -v(i,j,16)+sepy,3)
       call line(sepx+u(i,j+1,16),-v(i,j+1,16)+sepy,sepx+u(i,j+2,16),
     + -v(i,j+2,16)+sepy,3)
       end if

c      bottom nose
       
       xru(1)=u(i,k,16)
       xru(2)=u(i,k+1,16)
       xrv(1)=v(i,k,16)
       xrv(2)=v(i,k+1,16)
       xsu(1)=u(i,j+2,16)
       xsu(2)=u(i,k-2,16)
       xsv(1)=v(i,j+2,16)
       xsv(2)=v(i,k-2,16)
      
       call xrxs(xru,xrv,xsu,xsv,xtu,xtv)

       u(i,k-1,16)=xtu
       v(i,k-1,16)=xtv

c      Print segments if not zero thickness
       if (rib(i,149).ne.0.) then
       call line(sepx+u(i,k-1,16),-v(i,k-1,16)+sepy,sepx+u(i,k-2,16),
     + -v(i,k-2,16)+sepy,3)
       call line(sepx+u(i,k-1,16),-v(i,k-1,16)+sepy,sepx+u(i,k,16),
     + -v(i,k,16)+sepy,3)
       end if

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
C      Case "ds" or "ss"
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (atp.eq."ds".or.atp.eq."ss") then

       do j=np(i,2),np(i,2)+np(i,3)-2

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Dibuixa airfoils basic contour
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       call line(sepx+u(i,j,3),-v(i,j,3)+sepy,sepx+u(i,j+1,3),
     + -v(i,j+1,3)+sepy,1)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Dibuixa airfoils washin basic contour al seu lloc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       call line(sepx+u(i,j,4),-v(i,j,4)+sepy+xkf*890.95-rib(i,50),
     + sepx+u(i,j+1,4),-v(i,j+1,4)+sepy+xkf*890.95-rib(i,50),3)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Airfoils borders
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       call line(sepx+u(i,j,16),-v(i,j,16)+sepy,sepx+u(i,j+1,16),
     + -v(i,j+1,16)+sepy,3)

       
       call line(sepx+u(i,j,16),-v(i,j,16)+sepy,sepx+u(i,j,3),
     + -v(i,j,3)+sepy,5)

       end do

       end if


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.12.3 Airfoil intrados
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c       do j=1,np(i,1)-1
        do j=np(i,2)+np(i,3)-1,np(i,1)-1

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Dibuixa airfoils basic contour
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       call line(sepx+u(i,j,3),-v(i,j,3)+sepy,sepx+u(i,j+1,3),
     + -v(i,j+1,3)+sepy,1)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Dibuixa airfoils washin basic contour al seu lloc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       call line(sepx+u(i,j,4),-v(i,j,4)+sepy+xkf*890.85-rib(i,50),
     + sepx+u(i,j+1,4),-v(i,j+1,4)+sepy+xkf*890.85-rib(i,50),3)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Airfoils borders
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       call line(sepx+u(i,j,16),-v(i,j,16)+sepy,sepx+u(i,j+1,16),
     + -v(i,j+1,16)+sepy,3)

       
       call line(sepx+u(i,j,16),-v(i,j,16)+sepy,sepx+u(i,j,3),
     + -v(i,j,3)+sepy,5)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.12.4 Dibuixa punts-segments singulars vores airfoils
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       
       j=np(i,1)

       call line(sepx+u(i,j,16),-v(i,j,16)+sepy,sepx+u(i,j,3),
     + -v(i,j,3)+sepy,5)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.12.5 Draw holes
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do l=1,hol(i,1,1)

c      Dibuixa forat tipus 1 (alleugerament elliptics)
       if (hol(i,l,9).eq.1) then

       xx0=(hol(i,l,2))*rib(i,5)/100.0d0+sepx
       yy0=(-(hol(i,l,3))*rib(i,5)/100.0d0+sepy)
       xxa=(hol(i,l,4))*rib(i,5)/100.0d0
       yyb=((hol(i,l,5))*rib(i,5)/100.0d0)

       call ellipse(xx0,yy0,xxa,yyb,(hol(i,l,6)),3)
       end if

c      Dibuixa forat tipus 3 (triangles)

       if (hol(i,l,9).eq.3) then

       alptri=hol(i,l,6)*pi/180.
       atri=hol(i,l,4)*rib(i,5)/100.
       btri=hol(i,l,5)*rib(i,5)/100.
       rtri=hol(i,l,7)*rib(i,5)/100.
       
c      Marcador de costat negatiu
       satri=atri/sqrt(atri*atri)

       atri=abs(atri)

       cgor=0.5*pi-alptri
       ctri=sqrt(atri*atri+btri*btri-2.*atri*btri*dcos(cgor))
       agor=dacos((ctri*ctri+btri*btri-atri*atri)/(2.*btri*ctri))
       bgor=dacos((ctri*ctri+atri*atri-btri*btri)/(2.*atri*ctri))
       aggor=pi-agor
       bggor=pi-bgor
       cggor=pi-cgor
       h1tri=rtri/dsin(0.5*cgor)
       h2tri=rtri/dsin(0.5*bgor)
       h3tri=rtri/dsin(0.5*agor)

       x1=hol(i,l,2)*rib(i,5)/100.
       y1=hol(i,l,3)*rib(i,5)/100.

       x2=x1+satri*atri*dcos(alptri)
       y2=y1+atri*dsin(alptri)

       x3=x1
       y3=y1+btri

       o1x=x1+satri*(h1tri*dcos(alptri+0.5*cgor))
       o1y=y1+h1tri*dsin(alptri+0.5*cgor)

       o2x=x2-satri*(h2tri*dcos(-alptri+0.5*bgor))
       o2y=y2+h2tri*dsin(-alptri+0.5*bgor)

       o3x=x3+satri*(h3tri*dsin(0.5*agor))
       o3y=y3-h3tri*dcos(0.5*agor)

c      Inicialitza comptatge punts triangle
       k=1

       step1=cggor/6.
       do tetha=0.,cggor+0.01,step1
       xtri(k)=o1x-satri*rtri*dcos(tetha)
       ytri(k)=o1y-rtri*dsin(tetha)
       k=k+1
       end do

       step2=bggor/6.
       do tetha=alptri,alptri+bggor+0.01,step2
       xtri(k)=o2x+satri*rtri*dsin(tetha)
       ytri(k)=o2y-rtri*dcos(tetha)
       k=k+1
       end do

       step3=aggor/6.
       do tetha=agor,pi+0.01,step3
       xtri(k)=o3x+satri*rtri*dcos(tetha)
       ytri(k)=o3y+rtri*dsin(tetha)
       k=k+1
       end do

       xtri(k)=xtri(1)
       ytri(k)=ytri(1)

c      Dibuixa triangles

       if (satri.eq.1.) then
       do k=1,21
       call line(sepx+xtri(k),-ytri(k)+sepy,
     + sepx+xtri(k+1),-ytri(k+1)+sepy,3)
       end do
       end if

       if (satri.eq.-1.) then
       do k=1,21
       call line(sepx+xtri(k),-ytri(k)+sepy,
     + sepx+xtri(k+1),-ytri(k+1)+sepy,3)
       end do
       end if

       end if

       
       end do

c      Change airfoil loction

       kx=int((float(i)/6.))
       ky=i-kx*6
       kyy=kyy+1

       end do


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.13 Airfoils drawing (para mesa de corte)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
              
c      Box (1,4)

       sepxx=700.*xkf
       sepyy=100.*xkf

       kx=0
       ky=0
       kyy=0

       do i=1,nribss

       sepx=2530.*xkf+sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky)


       call romano(i,sepx+0.89*rib(i,5),sepy-1.,0.0d0,1.0d0,4)


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.13.1 Airfoils borders
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Case "ds" or "ss"

       if (atp.eq."ds".or.atp.eq."ss") then

       do j=1,np(i,1)-1
       call line(sepx+u(i,j,16),-v(i,j,16)+sepy,sepx+u(i,j+1,16),
     + -v(i,j+1,16)+sepy,1)
       end do

       end if

c      Case "pc"

       if (atp.eq."pc") then

c      Extrados

       do j=1,np(i,2)-1
       call line(sepx+u(i,j,16),-v(i,j,16)+sepy,sepx+u(i,j+1,16),
     + -v(i,j+1,16)+sepy,1)

       end do

c      Nose

c      Print segments if not zero thickness
       if (rib(i,149).ne.0.) then
       call line(sepx+u(i,j+2,16),-v(i,j+2,16)+sepy,sepx+u(i,k-2,16),
     + -v(i,k-2,16)+sepy,3)

       call line(sepx+u(i,j+1,16),-v(i,j+1,16)+sepy,sepx+u(i,j,16),
     + -v(i,j,16)+sepy,3)
       call line(sepx+u(i,j+1,16),-v(i,j+1,16)+sepy,sepx+u(i,j+2,16),
     + -v(i,j+2,16)+sepy,3)

       call line(sepx+u(i,k-1,16),-v(i,k-1,16)+sepy,sepx+u(i,k-2,16),
     + -v(i,k-2,16)+sepy,3)
       call line(sepx+u(i,k-1,16),-v(i,k-1,16)+sepy,sepx+u(i,k,16),
     + -v(i,k,16)+sepy,3)
       end if

c      Intrados

       do j=np(i,2)+np(i,3)-1,np(i,1)-1
       call line(sepx+u(i,j,16),-v(i,j,16)+sepy,sepx+u(i,j+1,16),
     + -v(i,j+1,16)+sepy,1)

       end do

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.13.2 Draw singular points-segments in airfoils border
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       
       j=np(i,1)
       call line(sepx+u(i,j,16),-v(i,j,16)+sepy,sepx+u(i,j,3),
     + -v(i,j,3)+sepy,1)

       j=1
       call line(sepx+u(i,j,16),-v(i,j,16)+sepy,sepx+u(i,j,3),
     + -v(i,j,3)+sepy,1)

c See also: 9.3 Draw anchor points in airfoils


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      6.13.3 Draw elliptical holes (MC)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do l=1,hol(i,1,1)

c      Holes type 1 (ellipses)
       if (hol(i,l,9).eq.1) then

       xx0=hol(i,l,2)*rib(i,5)/100.+sepx
       yy0=(-hol(i,l,3)*rib(i,5)/100.+sepy)
       xxa=hol(i,l,4)*rib(i,5)/100.
       yyb=(hol(i,l,5)*rib(i,5)/100.)

       call ellipse(xx0,yy0,xxa,yyb,hol(i,l,6),1)

       end if

c      Dibuixa forat tipus 3 (triangles)

       if (hol(i,l,9).eq.3) then

       alptri=hol(i,l,6)*pi/180.
       atri=hol(i,l,4)*rib(i,5)/100.
       btri=hol(i,l,5)*rib(i,5)/100.
       rtri=hol(i,l,7)*rib(i,5)/100.
       
c      Marcador de costat negatiu
       satri=atri/sqrt(atri*atri)

       atri=abs(atri)

       cgor=0.5*pi-alptri
       ctri=sqrt(atri*atri+btri*btri-2.*atri*btri*dcos(cgor))
       agor=dacos((ctri*ctri+btri*btri-atri*atri)/(2.*btri*ctri))
       bgor=dacos((ctri*ctri+atri*atri-btri*btri)/(2.*atri*ctri))
       aggor=pi-agor
       bggor=pi-bgor
       cggor=pi-cgor
       h1tri=rtri/dsin(0.5*cgor)
       h2tri=rtri/dsin(0.5*bgor)
       h3tri=rtri/dsin(0.5*agor)

       x1=hol(i,l,2)*rib(i,5)/100.
       y1=hol(i,l,3)*rib(i,5)/100.

       x2=x1+satri*atri*dcos(alptri)
       y2=y1+atri*dsin(alptri)

       x3=x1
       y3=y1+btri

       o1x=x1+satri*(h1tri*dcos(alptri+0.5*cgor))
       o1y=y1+h1tri*dsin(alptri+0.5*cgor)

       o2x=x2-satri*(h2tri*dcos(-alptri+0.5*bgor))
       o2y=y2+h2tri*dsin(-alptri+0.5*bgor)

       o3x=x3+satri*(h3tri*dsin(0.5*agor))
       o3y=y3-h3tri*dcos(0.5*agor)

c       write (*,*) atri,btri,ctri,agor,bgor,cgor

c      Inicialitza comptatge punts triangle
       k=1

       step1=cggor/6.
       do tetha=0.,cggor+0.01,step1
       xtri(k)=o1x-satri*rtri*dcos(tetha)
       ytri(k)=o1y-rtri*dsin(tetha)
       k=k+1
       end do

       step2=bggor/6.
       do tetha=alptri,alptri+bggor+0.01,step2
       xtri(k)=o2x+satri*rtri*dsin(tetha)
       ytri(k)=o2y-rtri*dcos(tetha)
       k=k+1
       end do

       step3=aggor/6.
       do tetha=agor,pi+0.01,step3
       xtri(k)=o3x+satri*rtri*dcos(tetha)
       ytri(k)=o3y+rtri*dsin(tetha)
       k=k+1
       end do

       xtri(k)=xtri(1)
       ytri(k)=ytri(1)

c      Dibuixa triangles

       if (satri.eq.1.) then
       do k=1,21
       call line(sepx+xtri(k),-ytri(k)+sepy,
     + sepx+xtri(k+1),-ytri(k+1)+sepy,1)
       end do
       end if

       if (satri.eq.-1.) then
       do k=1,21
       call line(sepx+xtri(k),-ytri(k)+sepy,
     + sepx+xtri(k+1),-ytri(k+1)+sepy,1)
       end do
       end if

       end if

       end do

       kx=int((float(i)/6.))
       ky=i-kx*6
       kyy=kyy+1

       end do


     

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      5+ Drawing planform in 2D view x-y
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      5+.1 Planform

c      Box (3,1)

       x0=0.
       y0=2000.*xkf
       
c      Ribs

       do i=1,nribss

       do j=1,np(i,1)-1

       x1=x(i,j)+x0
       y1=y(i,j)+y0
       x2=x(i,j+1)+x0
       y2=y(i,j+1)+y0

       call line(x1,y1,x2,y2,1)
       call line(-x1,y1,-x2,y2,1)

       end do

       end do

c      Trailing edge

       do i=1,nribss-1

       call line(x(i,1)+x0,y(i,1)+y0,x(i+1,1)+x0,y(i+1,1)+y0,1)
       call line(-x(i,1)+x0,y(i,1)+y0,-x(i+1,1)+x0,y(i+1,1)+y0,1)

       end do

       call line(-x(1,1)+x0,y(1,1)+y0,x(1,1)+x0,y(1,1)+y0,1)


c      Leading edge

c      Calcula punt de LE
       do j=10,np(1,2)
       if (u(1,j,3).eq.0) then
       jzero=j
       end if
       end do

       j=jzero

       do i=1,nribss-1

       call line(x(i,j)+x0,y(i,j)+y0,x(i+1,j)+x0,y(i+1,j)+y0,1)
       call line(-x(i,j)+x0,y(i,j)+y0,-x(i+1,j)+x0,y(i+1,j)+y0,1)

       end do

       call line(-x(1,j)+x0,y(1,j)+y0,x(1,j)+x0,y(1,j)+y0,1)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Vents - Air intakes
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      
c      Vent in
       do i=1,nribss

       j=np(i,2)

c      Control if cell is closed

       if(int(rib(i,14)).eq.1) then
       call line(x(i-1,j)+x0,y(i-1,j)+y0,x(i,j)+x0,y(i,j)+y0,3)
       call line(-x(i-1,j)+x0,y(i-1,j)+y0,-x(i,j)+x0,y(i,j)+y0,3)
       end if
       if(int(rib(i,14)).eq.0) then
       call line(x(i-1,j)+x0,y(i-1,j)+y0,x(i,j)+x0,y(i,j)+y0,9)
       call line(-x(i-1,j)+x0,y(i-1,j)+y0,-x(i,j)+x0,y(i,j)+y0,9)
       end if


       end do

c      Vent out
       do i=1,nribss

       j=np(i,2)+np(i,3)-1

c      Control if cell is closed

       if(int(rib(i,14)).eq.1) then
       call line(x(i-1,j)+x0,y(i-1,j)+y0,x(i,j)+x0,y(i,j)+y0,3)
       call line(-x(i-1,j)+x0,y(i-1,j)+y0,-x(i,j)+x0,y(i,j)+y0,3)
       end if

       end do

       

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      5+.2 Drawing real*8 canopy in 2D view x-z
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box (4,1)

       x0=0.
       y0=3000.*xkf

       do i=1,nribss

       do j=1,np(i,1)-1

       x1=x(i,j)+0.
       y1=z(i,j)+3000.*xkf
       x2=x(i,j+1)+0.
       y2=z(i,j+1)+3000.*xkf

       call line(x1,y1,x2,y2,7)
       call line(-x1,y1,-x2,y2,7)

       end do

       end do

c      Vent in

       do i=1,nribss

       j=np(i,2)

c      Control if cell is closed

       if(int(rib(i,14)).eq.1) then
       call line(x(i-1,j)+x0,z(i-1,j)+y0,x(i,j)+x0,z(i,j)+y0,3)
       call line(-x(i-1,j)+x0,z(i-1,j)+y0,-x(i,j)+x0,z(i,j)+y0,3)
       end if
       if(int(rib(i,14)).eq.0) then
       call line(x(i-1,j)+x0,z(i-1,j)+y0,x(i,j)+x0,z(i,j)+y0,9)
       call line(-x(i-1,j)+x0,z(i-1,j)+y0,-x(i,j)+x0,z(i,j)+y0,9)
       end if


       end do

c      Vent out
       do i=1,nribss

       j=np(i,2)+np(i,3)-1

c      Control if cell is closed

       if(int(rib(i,14)).eq.1) then
       call line(x(i-1,j)+x0,z(i-1,j)+y0,x(i,j)+x0,z(i,j)+y0,3)
       call line(-x(i-1,j)+x0,z(i-1,j)+y0,-x(i,j)+x0,z(i,j)+y0,3)
       end if

       end do

c      Drawing leading edge
c      Calculus point in LE
       do j=10,np(1,2)
       if (u(1,j,3).eq.0) then
       jzero=j
       end if
       end do

       j=jzero

       do i=1,nribss-1

       call line(x(i,j)+x0,z(i,j)+y0,x(i+1,j)+x0,z(i+1,j)+y0,5)
       call line(-x(i,j)+x0,z(i,j)+y0,-x(i+1,j)+x0,z(i+1,j)+y0,5)

       end do

       call line(-x(1,j)+x0,z(1,j)+y0,x(1,j)+x0,z(1,j)+y0,5)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      5+.3 Drawing real*8 canopy in 2D view y-z
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box (4,2)

       x0=1260.*xkf
       y0=3000.*xkf

c      Airfoils y-z
       do i=1,nribss

       do j=1,np(i,1)-1
       call line(-y(i,j)+x0,z(i,j)+y0,-y(i,j+1)+x0,z(i,j+1)+y0,3)
       end do

c      Trailing edge
       j=np(i,1)
       call line(-y(i-1,j)+x0,z(i-1,j)+y0,-y(i,j)+x0,z(i,j)+y0,2)
c      Inlet in       
       j=np(i,2)
       if(rib(i,14).eq.1) then
       call line(-y(i-1,j)+x0,z(i-1,j)+y0,-y(i,j)+x0,z(i,j)+y0,1)
       end if
       if(rib(i,14).eq.0) then
       call line(-y(i-1,j)+x0,z(i-1,j)+y0,-y(i,j)+x0,z(i,j)+y0,9)
       end if

c      Inlet out     
c       if(rib(i-1,14).eq.1.and.rib(i,14).eq.1) then
       if(rib(i,14).eq.1) then
       j=np(i,2)+np(i,3)-1
       call line(-y(i-1,j)+x0,z(i-1,j)+y0,-y(i,j)+x0,z(i,j)+y0,1)
       end if

c      Long lines
       do j=2, np(i,2)-1,5
       call line(-y(i-1,j)+x0,z(i-1,j)+y0,-y(i,j)+x0,z(i,j)+y0,4)
       end do
       do j=np(i,2)+np(i,3)+1,np(i,1)-1,5
       call line(-y(i-1,j)+x0,z(i-1,j)+y0,-y(i,j)+x0,z(i,j)+y0,8)
       end do

       end do

c      Ultim perfil
c       i=nribss
c       do j=1,np(i,1)-1
c       call line(-y(i,j)+x0,z(i,j)+y0,-y(i,j+1)+x0,z(i,j+1)+y0,4)
c       end do



ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      7. PANEL DEVELOPMENT
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      7.1 Panel 1'-1 extrados
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=1

       px0=0.
       py0=0.
       ptheta=0.

       do j=1,np(1,2)-1 ! extrados panels point j

c      Distances between points rib 0 and 1
       pa=sqrt((x(i,j)-xx(i,j))**2.+(y(i,j)-yy(i,j))**2.+
     + (z(i,j)-zz(i,j))**2.)
       pb=sqrt((x(i,j+1)-xx(i,j))**2.+(y(i,j+1)-yy(i,j))**2.+
     + (z(i,j+1)-zz(i,j))**2.)
       pc=sqrt((x(i,j)-x(i,j+1))**2.+(y(i,j)-y(i,j+1))**2.+
     + (z(i,j)-z(i,j+1))**2.)
       pd=sqrt((x(i,j)-xx(i,j+1))**2.+(y(i,j)-yy(i,j+1))**2.+
     + (z(i,j)-zz(i,j+1))**2.)
       pe=sqrt((xx(i,j+1)-xx(i,j))**2.+(yy(i,j+1)-yy(i,j))**2.+
     + (zz(i,j+1)-zz(i,j))**2.)
       pf=sqrt((x(i,j+1)-xx(i,j+1))**2.+(y(i,j+1)-yy(i,j+1))**2.+
     + (z(i,j+1)-zz(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

       pb2t=(pb*pb-pe*pe+pf*pf)/(2.*pb)
       pb1t=pb-pb2t
       pht=sqrt(pf*pf-pb2t*pb2t)
       
       pw1=datan(phr/pa1r)
       phu=pb1t*dtan(pw1)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0
       
       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

c      Iteration
       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
      
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      REVISAR!!!!!
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       pl1x(0,j)=pl1x(i,j)
       pl1y(0,j)=pl1y(i,j)

       pr1x(0,j)=pr1x(i,j)
       pr1y(0,j)=pr1y(i,j)

       pl2x(0,j)=pl2x(i,j)
       pl2y(0,j)=pl2y(i,j)

       pr2x(0,j)=pr2x(i,j)
       pr2y(0,j)=pr2y(i,j)

c       write (*,*) "1: ", pl1y(0,j), pr1y(0,j)
c       write (*,*) "2: ", pl2y(0,j), pr2y(0,j)
c      Result OK y iguals!!!

       end do
       
c      Extrados

c      Box (1,3)

       i=1
       
       psep=1970.*xkf+seppix*float(i-1)
       psey=400.*xkf

       do j=1,np(1,2)-1

c      No cal dibuixar
c       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr1x(i,j),
c     + psey-pr1y(i,j),6)
c       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr2x(i,j),
c     + psey-pr2y(i,j),5)
c       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pl2x(i,j),
c     + psey-pl2y(i,j),4)
c       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pr2x(i,j),
c     + psey-pr2y(i,j),3)
c       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pl2x(i,j),
c     + psey-pl2y(i,j),2)
c       call line(psep+pl2x(i,j),psey-pl2y(i,j),psep+pr2x(i,j),
c     + psey-pr2y(i,j),3)

       end do


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      7.2 Panel 1'-1 intrados
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      7.2.1 Intrados

c      Box (2,3)

       i=1

       px0=0.
       py0=0.
       ptheta=0.

       do j=np(1,2)+np(1,3)-1,np(1,1)-1 ! extrados panels, point j

c      Distances between points
       pa=sqrt((x(i,j)-xx(i,j))**2.+(y(i,j)-yy(i,j))**2.+
     + (z(i,j)-zz(i,j))**2.)
       pb=sqrt((x(i,j+1)-xx(i,j))**2.+(y(i,j+1)-yy(i,j))**2.+
     + (z(i,j+1)-zz(i,j))**2.)
       pc=sqrt((x(i,j)-x(i,j+1))**2.+(y(i,j)-y(i,j+1))**2.+
     + (z(i,j)-z(i,j+1))**2.)
       pd=sqrt((x(i,j)-xx(i,j+1))**2.+(y(i,j)-yy(i,j+1))**2.+
     + (z(i,j)-zz(i,j+1))**2.)
       pe=sqrt((xx(i,j+1)-xx(i,j))**2.+(yy(i,j+1)-yy(i,j))**2.+
     + (zz(i,j+1)-zz(i,j))**2.)
       pf=sqrt((x(i,j+1)-xx(i,j+1))**2.+(y(i,j+1)-yy(i,j+1))**2.+
     + (z(i,j+1)-zz(i,j+1))**2.)
       
c       write (*,*) i,pa,pb,pc,pd,pe,pf

       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0

       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0


       pl1x(0,j)=pl1x(i,j)
       pl1y(0,j)=pl1y(i,j)

       pr1x(0,j)=pr1x(i,j)
       pr1y(0,j)=pr1y(i,j)

       pl2x(0,j)=pl2x(i,j)
       pl2y(0,j)=pl2y(i,j)

       pr2x(0,j)=pr2x(i,j)
       pr2y(0,j)=pr2y(i,j)

       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
       
       end do
       
c      Intrados

       i=1
       
       psep=1970.*xkf+seppix*float(i-1)
       psey=1291.*xkf
       ncontrol=1

c      Control if cell is closed
       if(int(rib(i,14)).eq.0.and.int(rib(i+1,14)).eq.0) then
       psey=400.*xkf
       ncontrol=0
       end if

       do j=np(1,2)+ncontrol*(np(1,3)-1),np(1,1)-1

c      No cal dibuixar
c       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr1x(i,j),
c     + psey-pr1y(i,j),6)
c       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr2x(i,j),
c     + psey-pr2y(i,j),5)
c       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pl2x(i,j),
c     + psey-pl2y(i,j),4)
c       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pr2x(i,j),
c     + psey-pr2y(i,j),3)
c       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pl2x(i,j),
c     + psey-pl2y(i,j),2)
c       call line(psep+pl2x(i,j),psey-pl2y(i,j),psep+pr2x(i,j),
c     + psey-pr2y(i,j),3)

       end do
       
c      7.2.2 Air intakes (vents) panels

       i=1

       px0=0.
       py0=0.
       ptheta=0.

       do j=np(1,2), np(1,2)+np(1,3)-2 ! vent panels, point j

c      Distances between points
       
       pa=sqrt((x(i,j)-xx(i,j))**2.+(y(i,j)-yy(i,j))**2.+
     + (z(i,j)-zz(i,j))**2.)
       pb=sqrt((x(i,j+1)-xx(i,j))**2.+(y(i,j+1)-yy(i,j))**2.+
     + (z(i,j+1)-zz(i,j))**2.)
       pc=sqrt((x(i,j)-x(i,j+1))**2.+(y(i,j)-y(i,j+1))**2.+
     + (z(i,j)-z(i,j+1))**2.)
       pd=sqrt((x(i,j)-xx(i,j+1))**2.+(y(i,j)-yy(i,j+1))**2.+
     + (z(i,j)-zz(i,j+1))**2.)
       pe=sqrt((xx(i,j+1)-xx(i,j))**2.+(yy(i,j+1)-yy(i,j))**2.+
     + (zz(i,j+1)-zz(i,j))**2.)
       pf=sqrt((x(i,j+1)-xx(i,j+1))**2.+(y(i,j+1)-yy(i,j+1))**2.+
     + (z(i,j+1)-zz(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0

       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Assigna panell 0 zona vents
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       pl1x(0,j)=pl1x(i,j)
       pl1y(0,j)=pl1y(i,j)

       pr1x(0,j)=pr1x(i,j)
       pr1y(0,j)=pr1y(i,j)

       pl2x(0,j)=pl2x(i,j)
       pl2y(0,j)=pl2y(i,j)

       pr2x(0,j)=pr2x(i,j)
       pr2y(0,j)=pr2y(i,j)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       end do

c      Vents drawing

c      Verify central cell width  
       if (cencell.ge.0.01)  then  

       i=1
       
       psep=1970.*xkf+seppix*float(i-1)
       psey=1371.*xkf
       ncontrol=0

c      Control if cell is closed
       if(int(rib(1,14)).eq.0.and.int(rib(1+1,14)).eq.0) then
       ncontrol=1
       end if
c      Dibuixa boques
       ncontrol=1

       do j=np(1,2),np(1,2)+ncontrol*(np(1,3)-2)+(ncontrol-1)

       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr1x(i,j),
     + psey-pr1y(i,j),6)
       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr2x(i,j),
     + psey-pr2y(i,j),5)
       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pl2x(i,j),
     + psey-pl2y(i,j),4)
       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pr2x(i,j),
     + psey-pr2y(i,j),3)
       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pl2x(i,j),
     + psey-pl2y(i,j),2)
       call line(psep+pl2x(i,j),psey-pl2y(i,j),psep+pr2x(i,j),
     + psey-pr2y(i,j),3)

       end do

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      7.3 Panels 1 to nribss-1 extrados
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=1,nribss-1 ! panel i

       px0=0.
       py0=0.
       ptheta=0.

c      Extrados

       do j=1,np(i,2)-1,1 ! extrados panels point j

c      Distances between points
       pa=sqrt((x(i+1,j)-x(i,j))**2.+(y(i+1,j)-y(i,j))**2.+
     + (z(i+1,j)-z(i,j))**2.)
       pb=sqrt((x(i+1,j+1)-x(i,j))**2.+(y(i+1,j+1)-y(i,j))**2.+
     + (z(i+1,j+1)-z(i,j))**2.)
       pc=sqrt((x(i+1,j+1)-x(i+1,j))**2.+(y(i+1,j+1)-y(i+1,j))**2.+
     + (z(i+1,j+1)-z(i+1,j))**2.)
       pd=sqrt((x(i+1,j)-x(i,j+1))**2.+(y(i+1,j)-y(i,j+1))**2.+
     + (z(i+1,j)-z(i,j+1))**2.)
       pe=sqrt((x(i,j+1)-x(i,j))**2.+(y(i,j+1)-y(i,j))**2.+
     + (z(i,j+1)-z(i,j))**2.)
       pf=sqrt((x(i+1,j+1)-x(i,j+1))**2.+(y(i+1,j+1)-y(i,j+1))**2.+
     + (z(i+1,j+1)-z(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

       pb2t=(pb*pb-pe*pe+pf*pf)/(2.*pb)
       pb1t=pb-pb2t
       pht=sqrt(pf*pf-pb2t*pb2t)
       
       pw1=datan(phr/pa1r)
       phu=pb1t*dtan(pw1)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0
       
       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

c      Iteration
       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
       
       end do
       
       end do

c      Extrados

       do i=1,nribss-1
       
       psep=1970.*xkf+seppix*float(i)
       psey=400.*xkf

       do j=1,np(i,2)-1

c       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr1x(i,j),
c     + psey-pr1y(i,j),6)
c       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr2x(i,j),
c     + psey-pr2y(i,j),5)
c       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pl2x(i,j),
c     + psey-pl2y(i,j),4)
c       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pr2x(i,j),
c     + psey-pr2y(i,j),3)
c       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pl2x(i,j),
c     + psey-pl2y(i,j),2)
c       call line(psep+pl2x(i,j),psey-pl2y(i,j),psep+pr2x(i,j),
c     + psey-pr2y(i,j),3)

       end do

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      7.4 Panels 1 to nribss-1 Intrados
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


c      7.4.1 Intrados

       do i=1,nribss-1 ! panel i

       px0=0.
       py0=0.
       ptheta=0.

       do j=np(i,2)+np(i,3)-1,np(i,1)-1 ! extrados panels, point j

c      Distances between points
       pa=sqrt((x(i+1,j)-x(i,j))**2.+(y(i+1,j)-y(i,j))**2.+
     + (z(i+1,j)-z(i,j))**2.)
       pb=sqrt((x(i+1,j+1)-x(i,j))**2.+(y(i+1,j+1)-y(i,j))**2.+
     + (z(i+1,j+1)-z(i,j))**2.)
       pc=sqrt((x(i+1,j+1)-x(i+1,j))**2.+(y(i+1,j+1)-y(i+1,j))**2.+
     + (z(i+1,j+1)-z(i+1,j))**2.)
       pd=sqrt((x(i+1,j)-x(i,j+1))**2.+(y(i+1,j)-y(i,j+1))**2.+
     + (z(i+1,j)-z(i,j+1))**2.)
       pe=sqrt((x(i,j+1)-x(i,j))**2.+(y(i,j+1)-y(i,j))**2.+
     + (z(i,j+1)-z(i,j))**2.)
       pf=sqrt((x(i+1,j+1)-x(i,j+1))**2.+(y(i+1,j+1)-y(i,j+1))**2.+
     + (z(i+1,j+1)-z(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0

       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
       
       end do
       
       end do

c      Intrados

       do i=1,nribss-1
       
       psep=1970.*xkf+seppix*float(i)
       psey=1291.*xkf
       ncontrol=1

c      Control if cell is closed
       if(int(rib(i,14)).eq.0.and.int(rib(i+1,14)).eq.0) then
       psey=1291.*xkf
       ncontrol=0
       end if

c       ncontrol=1

       do j=np(i,2)+ncontrol*(np(i,3)-1),np(i,1)-1

c       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr1x(i,j),
c     + psey-pr1y(i,j),6)
c       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr2x(i,j),
c     + psey-pr2y(i,j),5)
c       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pl2x(i,j),
c     + psey-pl2y(i,j),4)
c       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pr2x(i,j),
c     + psey-pr2y(i,j),3)
c       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pl2x(i,j),
c     + psey-pl2y(i,j),2)
c       call line(psep+pl2x(i,j),psey-pl2y(i,j),psep+pr2x(i,j),
c     + psey-pr2y(i,j),3)

       end do

       end do
       
c     7.4.2 Air intakes (vents) panels calculus and drawing

       do i=1,nribss-1 ! panel i

       px0=0.
       py0=0.
       ptheta=0.

       do j=np(i,2), np(i,2)+np(i,3)-2 ! vent panels, point j

c      Distances between points
       pa=sqrt((x(i+1,j)-x(i,j))**2.+(y(i+1,j)-y(i,j))**2.+
     + (z(i+1,j)-z(i,j))**2.)
       pb=sqrt((x(i+1,j+1)-x(i,j))**2.+(y(i+1,j+1)-y(i,j))**2.+
     + (z(i+1,j+1)-z(i,j))**2.)
       pc=sqrt((x(i+1,j+1)-x(i+1,j))**2.+(y(i+1,j+1)-y(i+1,j))**2.+
     + (z(i+1,j+1)-z(i+1,j))**2.)
       pd=sqrt((x(i+1,j)-x(i,j+1))**2.+(y(i+1,j)-y(i,j+1))**2.+
     + (z(i+1,j)-z(i,j+1))**2.)
       pe=sqrt((x(i,j+1)-x(i,j))**2.+(y(i,j+1)-y(i,j))**2.+
     + (z(i,j+1)-z(i,j))**2.)
       pf=sqrt((x(i+1,j+1)-x(i,j+1))**2.+(y(i+1,j+1)-y(i,j+1))**2.+
     + (z(i+1,j+1)-z(i,j+1))**2.)
       
c       write (*,*) i,pa,pb,pc,pd,pe,pf

       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0

       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
       
       end do
       
       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Vents drawing
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Saltar cella 0 si gruix nul
       iini=0
       if (cencell.lt.0.01) then
       iini=1
       end if

       do i=iini,nribss-1
       
       psep=1970.*xkf+seppix*float(i)
       psey=1371.*xkf
       ncontrol=0

c      Control if cell is closed
       if(int(rib(i,14)).eq.0.and.int(rib(i+1,14)).eq.0) then
       ncontrol=1
       end if

       ncontrol=1       

       do j=np(i,2),np(i,2)+ncontrol*(np(i,3)-2)+(ncontrol-1)

       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr1x(i,j),
     + psey-pr1y(i,j),6)
       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr2x(i,j),
     + psey-pr2y(i,j),5)
       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pl2x(i,j),
     + psey-pl2y(i,j),4)
       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pr2x(i,j),
     + psey-pr2y(i,j),3)
       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pl2x(i,j),
     + psey-pl2y(i,j),2)
       call line(psep+pl2x(i,j),psey-pl2y(i,j),psep+pr2x(i,j),
     + psey-pr2y(i,j),3)

       end do

       end do


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      7.4.3 Vents drawing Adre
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


c      Saltar cella 0 si gruix nul
       iini=0
       if (cencell.lt.0.01) then
       iini=1
       end if

c      Count in ribs
       do i=iini,nribss-1
       
       psep=1970.*xkf+2520.*xkf+seppix*float(i)
       psey=1371.*xkf
       ncontrol=0

c      Control if cell is closed
       if(int(rib(i,14)).eq.0.and.int(rib(i+1,14)).eq.0) then
       ncontrol=1
       end if

       ncontrol=1       

c      Verify central cell width  
   
       do j=np(i,2),np(i,2)+ncontrol*(np(i,3)-2)+(ncontrol-1)

       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr1x(i,j),
     + psey-pr1y(i,j),6)
c       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pr2x(i,j),
c     + psey-pr2y(i,j),5)
       call line(psep+pl1x(i,j),psey-pl1y(i,j),psep+pl2x(i,j),
     + psey-pl2y(i,j),4)
       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pr2x(i,j),
     + psey-pr2y(i,j),3)
c       call line(psep+pr1x(i,j),psey-pr1y(i,j),psep+pl2x(i,j),
c     + psey-pl2y(i,j),2)
       call line(psep+pl2x(i,j),psey-pl2y(i,j),psep+pr2x(i,j),
     + psey-pr2y(i,j),3)

       end do

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     8. SKIN TENSION
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.1 Calculs previs
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Vores de costura

       xcos=xupp/10. ! extrados

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Longituds i amples de celles
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      8.1.1 Extrados longitud cella extrema       
       i=nribss
       rib(nribss,23)=0.
       do j=1,np(nribss,2)-1
       rib(nribss,23)=rib(i,23)+sqrt((pr2x(i-1,j)-pr1x(i-1,j))**2+
     + (pr2y(i-1,j)-pr1y(i-1,j))**2)
       end do

c      8.1.2 Intrados longitud cella extrema       
       i=nribss
       rib(nribss,25)=0.
       do j=np(i,2)+np(i,3)-1,np(i,1)-1
       rib(i,25)=rib(i,25)+sqrt((pr2x(i-1,j)-pr1x(i-1,j))**2+
     + (pr2y(i-1,j)-pr1y(i-1,j))**2)
       end do

c      Resta de celles
       do i=0,nribss-1

       rib(i,23)=0.
       rib(i,25)=0.
       rib(i,26)=0.

c      8.1.3 Longitud extrados

       do j=1,np(i,2)-1

       rib(i,23)=rib(i,23)+sqrt((pl2x(i,j)-pl1x(i,j))**2+
     + (pl2y(i,j)-pl1y(i,j))**2)

       end do

c      8.1.4 Longitud intrados
       
       do j=np(i,2)+np(i,3)-1,np(i,1)-1

       rib(i,25)=rib(i,25)+sqrt((pl2x(i,j)-pl1x(i,j))**2+
     + (pl2y(i,j)-pl1y(i,j))**2)

       end do

c      8.1.5 Longitud inlet

       do j=np(i,2),np(i,2)+np(i,3)-2

       rib(i,26)=rib(i,26)+sqrt((pl2x(i,j)-pl1x(i,j))**2+
     + (pl2y(i,j)-pl1y(i,j))**2)

       end do

c      8.1.6 Punts de calcul amples de celles

c      Calcula punts je ji per definir ample celles, calcula ample

       je=int(np(i,2)/2)
       rib(i,22)=sqrt((pr1x(i,je)-pl1x(i,je))**2.+(pr1y(i,je)
     + -pl1y(i,je))**2.)

       ji=int((np(i,2)+np(i,3)-1+np(i,1))/2)
       rib(i,24)=sqrt((pr1x(i,ji)-pl1x(i,ji))**2.+(pr1y(i,ji)
     + -pl1y(i,ji))**2.)

       end do

c      Ample celles extremes       
       i=nribss
       je=int(np(i,2)/2)
       rib(i,22)=sqrt((pr1x(i-1,je)-pl1x(i-1,je))**2.+(pr1y(i-1,je)
     + -pl1y(i-1,je))**2.)

       ji=int((np(i,2)+np(i,3)-1+np(i,1))/2)
       rib(i,24)=sqrt((pr1x(i-1,ji)-pl1x(i-1,ji))**2.+(pr1y(i-1,ji)
     + -pl1y(i-1,ji))**2.)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.2 SOBREAMPLES EXTRADOS
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c        write (*,*) "pi 8.2. =",pi

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.2.1 Sobreamples esquerra extrados
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss

c      Initialize sob points

       do k=1,6

       xsob(k)=((100.-(skin(7-k,1)))/100.)*rib(i,23)
       ysob(k)=rib(i,22)*skin(7-k,2)/100.

       end do

c      Longituds u

       u(i,1,7)=0.
       
       do j=1,np(i,2)-1

       u(i,j+1,7)=u(i,j,7)+sqrt((pl2x(i,j)-pl1x(i,j))**2+
     + (pl2y(i,j)-pl1y(i,j))**2)

       end do

c      Sobreample v      

       v(i,1,7)=rib(i,22)*skin(6,2)/100.

       do j=1,np(i,2)-1

c      LE zone

       if(u(i,j+1,7).le.xsob(2)) then

       xm=(ysob(2)-ysob(1))/(xsob(2)-xsob(1))
       xn=ysob(2)-xm*xsob(2)

       v(i,j+1,7)=xm*(u(i,j+1,7))+xn

       xm1=xm
       xn1=xn

       end if
       
       if(u(i,j+1,7).gt.xsob(2).and.u(i,j+1,7).le.xsob(3)) then

       xm=(ysob(3)-ysob(2))/(xsob(3)-xsob(2))
       xn=ysob(2)-xm*xsob(2)

       v(i,j+1,7)=xm*(u(i,j+1,7))+xn

       xm2=xm
       xn2=xn

       end if

c      Central panel

       if(u(i,j+1,7).gt.xsob(3).and.u(i,j+1,7).le.xsob(4)) then

       xm=(ysob(4)-ysob(3))/(xsob(4)-xsob(3))
       xn=ysob(3)-xm*xsob(3)

       v(i,j+1,7)=xm*(u(i,j+1,7))+xn

       xm2=xm
       xn2=xn

       end if

c      TE zone


       if(u(i,j+1,7).gt.xsob(4).and.u(i,j+1,7).le.xsob(5)) then

       xm=(ysob(5)-ysob(4))/(xsob(5)-xsob(4))
       xn=ysob(4)-xm*xsob(4)

       v(i,j+1,7)=xm*(u(i,j+1,7))+xn

       xm3=xm
       xn3=xn

       end if

       if(u(i,j+1,7).gt.xsob(5)) then

       xm=(ysob(6)-ysob(5))/(xsob(6)-xsob(5))
       xn=ysob(5)-xm*xsob(5)

       v(i,j+1,7)=xm*(u(i,j+1,7))+xn

       xm3=xm
       xn3=xn

       end if

c      Calcula punts esquerra

       xdv=(pl2y(i,j)-pl1y(i,j))
       xdu=(pl2x(i,j)-pl1x(i,j))

       if (xdv.ne.0.) then
       alpl=abs(datan((pl2y(i,j)-pl1y(i,j))/(pl2x(i,j)-pl1x(i,j))))
       else
       alpl=2.*datan(1.0d0)
       end if

       if (xdu.ge.0.and.xdv.ge.0) then ! case 2-I
       siu(j)=-1.
       siv(j)=1.
       end if
       if (xdu.le.0.and.xdv.ge.0) then ! case 2-II
       siu(j)=-1.
       siv(j)=-1.
       end if
       if (xdu.ge.0.and.xdv.le.0) then ! case 2-III
       siu(j)=1.
       siv(j)=1.
       end if
       if (xdu.le.0.and.xdv.le.0) then ! case 2-IV
       siu(j)=1.
       siv(j)=-1.
       end if

c      ATENCIO!!!!!!!!!!! pl2x,pl2y or pl1x,pl1y?????????
c      Amb "2" fa un salt la vora esquerra...

       u(i,j+1,9)=pl2x(i,j)+siu(j)*v(i,j+1,7)*dsin(alpl)
       v(i,j+1,9)=pl2y(i,j)+siv(j)*v(i,j+1,7)*dcos(alpl)

       u(i,j+1,11)=u(i,j+1,9)+siu(j)*xupp*0.1*dsin(alpl)
       v(i,j+1,11)=v(i,j+1,9)+siv(j)*xupp*0.1*dcos(alpl)
       
       end do
       
       alpl=abs(datan((pl2y(i,1)-pl1y(i,1))/(pl2x(i,1)-pl1x(i,1))))

c      Potser hauria de ser pl1x i pl1y???? Yes
       u(i,1,9)=pl1x(i,j)+siu(1)*v(i,1,7)*dsin(alpl)
       v(i,1,9)=pl1y(i,j)+siv(1)*v(i,1,7)*dcos(alpl)

       u(i,1,11)=u(i,1,9)+siu(1)*xupp*0.1*dsin(alpl)
       v(i,1,11)=v(i,1,9)+siv(1)*xupp*0.1*dcos(alpl)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.2.2 Sobreamples dreta extrados
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Sobreamples dreta

       do i=0,nribss

c      Initialize sob points

       do k=1,6

       xsob(k)=((100.-(skin(7-k,1)))/100.)*rib(i+1,23)
       ysob(k)=rib(i,22)*skin(7-k,2)/100.

       end do

c      Longitud u

       u(i,1,8)=0.
       
       do j=1,np(i,2)-1

       u(i,j+1,8)=u(i,j,8)+sqrt((pr2x(i,j)-pr1x(i,j))**2+
     + (pr2y(i,j)-pr1y(i,j))**2)

       end do

c      Sobreample v      

       v(i,1,8)=rib(i,22)*skin(6,2)/100.

       do j=1,np(i,2)-1

c      LE zone

       if(u(i,j+1,8).le.xsob(2)) then

       xm=(ysob(2)-ysob(1))/(xsob(2)-xsob(1))
       xn=ysob(2)-xm*xsob(2)

       v(i,j+1,8)=xm*(u(i,j+1,8))+xn

       xm1=xm
       xn1=xn

       end if

       if(u(i,j+1,8).gt.xsob(2).and.u(i,j+1,8).le.xsob(3)) then

       xm=(ysob(3)-ysob(2))/(xsob(3)-xsob(2))
       xn=ysob(2)-xm*xsob(2)

       v(i,j+1,8)=xm*(u(i,j+1,8))+xn

       xm2=xm
       xn2=xn

       end if

c      Central panel

       if(u(i,j+1,8).gt.xsob(3).and.u(i,j+1,8).le.xsob(4)) then

       xm=(ysob(4)-ysob(3))/(xsob(4)-xsob(3))
       xn=ysob(3)-xm*xsob(3)

       v(i,j+1,8)=xm*(u(i,j+1,8))+xn

       xm2=xm
       xn2=xn

       end if

c      TE zone

       if(u(i,j+1,8).gt.xsob(4).and.u(i,j+1,8).le.xsob(5)) then

       xm=(ysob(5)-ysob(4))/(xsob(5)-xsob(4))
       xn=ysob(4)-xm*xsob(4)

       v(i,j+1,8)=xm*(u(i,j+1,8))+xn

       xm3=xm
       xn3=xn

       end if

       if(u(i,j+1,8).gt.xsob(5)) then

       xm=(ysob(6)-ysob(5))/(xsob(6)-xsob(5))
       xn=ysob(5)-xm*xsob(5)

       v(i,j+1,8)=xm*(u(i,j+1,8))+xn

       xm3=xm
       xn3=xn

       end if

c      Calcula punts dreta

       xdv=(pr2y(i,j)-pr1y(i,j))
       xdu=(pr2x(i,j)-pr1x(i,j))

       if (xdv.ne.0.) then
       alpr=abs(datan((pr2y(i,j)-pr1y(i,j))/(pr2x(i,j)-pr1x(i,j))))
       else
       alpr=2.*datan(1.0d0)
       end if

       if (xdu.ge.0.and.xdv.ge.0) then ! case 3-I
       siu(j)=1.
       siv(j)=-1.
       end if
       if (xdu.le.0.and.xdv.ge.0) then ! case 3-II
       siu(j)=1.
       siv(j)=1.
       end if
       if (xdu.ge.0.and.xdv.le.0) then ! case 3-III
       siu(j)=-1.
       siv(j)=-1.
       end if
       if (xdu.le.0.and.xdv.le.0) then ! case 3-IV
       siu(j)=-1.
       siv(j)=1.
       end if

       u(i,j+1,10)=pr2x(i,j)+siu(j)*v(i,j+1,8)*dsin(alpr)
       v(i,j+1,10)=pr2y(i,j)+siv(j)*v(i,j+1,8)*dcos(alpr)

       u(i,j+1,12)=u(i,j+1,10)+siu(j)*xupp*0.1*dsin(alpr)
       v(i,j+1,12)=v(i,j+1,10)+siv(j)*xupp*0.1*dcos(alpr)

       end do  ! j=1,np(i,2)-1

c      Initial point not defined in previous bucle

       alpr=abs(datan((pr2y(i,1)-pr1y(i,1))/(pr2x(i,1)-pr1x(i,1))))

       u(i,1,10)=pr1x(i,1)+siu(1)*v(i,1,8)*dsin(alpr)
       v(i,1,10)=pr1y(i,1)+siv(1)*v(i,1,8)*dcos(alpr)
       
       u(i,1,12)=u(i,1,10)+siu(1)*xupp*0.1*dsin(alpr)
       v(i,1,12)=v(i,1,10)+siv(1)*xupp*0.1*dcos(alpr)

c      Leading edge segment unformated rib(i,96) extra

       if (i.lt.nribss) then
       j=np(i,2)
       rib(i,96)=sqrt((u(i,j,9)-u(i,j,10))**2.+
     + ((v(i,j,9)-v(i,j,10))**2.))
       end if

       end do  ! i

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.2.3 Reformat right side of extrados panels (optional)
c            "antiprecission"
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Define provisional vector 29, used later in 11.4 (Panels marks)

       do i=0,nribss-1
       do j=1,np(i,2)
       u(i,j,29)=u(i,j,10)
       v(i,j,29)=v(i,j,10)
       end do
       end do

c      Jump to the end if ndif=1000 (no effect)
       if (ndif.eq.1000) then 
       goto 14
       end if

c      Avoid xndif=0
       if (xndif.eq.0.) then
       xndif=0.01
       end if

c      Salva punts corva interior a vector 29 per a usos posterior
c      rib(i,36)

       do i=0,nribss-1
       do j=1,np(i,2)

       u(i,j,29)=u(i,j,10)
       v(i,j,29)=v(i,j,10)

       end do
       end do

c      Calcula diferencies de longitud costat exterior - interior

c       ndif=15
c       xndif=0.9

       do i=1,nribss-1
       rib(i,80)=0.
       rib(i,79)=0.
       end do

       do i=1,nribss-1

       do j=np(i,2)-ndif,np(i,2)-1

       rib(i,80)=rib(i,80)+sqrt((u(i,j,11)-u(i,j+1,11))**2.+
     + (v(i,j,11)-v(i,j+1,11))**2.)

       rib(i,79)=rib(i,79)+sqrt((u(i-1,j,12)-u(i-1,j+1,12))**2.+
     + (v(i-1,j,12)-v(i-1,j+1,12))**2.)

       end do

       rib(i,81)=(rib(i,80)-rib(i,79))*xndif

c       write (*,*) "rib(i,81) ", i, rib(i,81)

       end do

c      Redefinir punts 10 i 12 del morro dels panells

       do i=1,nribss-1

       xxa=sqrt((u(i-1,np(i-1,2),9)-u(i-1,np(i-1,2),10))**2.+
     + (v(i-1,np(i-1,2),9)-v(i-1,np(i-1,2),10))**2.)

       tetha3=dacos(rib(i,81)/(2.*xxa))

       tetha1=datan((v(i-1,np(i-1,2),9)-v(i-1,np(i-1,2),10))/
     + (u(i-1,np(i-1,2),10)-u(i-1,np(i-1,2),9)))

       tetha2=pi-tetha3-tetha1

       u(i-1,np(i,2),28)=u(i-1,np(i,2),10)+rib(i,81)*dcos(tetha2)
       v(i-1,np(i,2),28)=v(i-1,np(i,2),10)+rib(i,81)*dsin(tetha2)
      
       end do


c      Alineació del tram modificat      

       do i=1,nribss-1

       tetha4=datan((v(i-1,np(i,2),28)-v(i-1,np(i,2),10))/
     + (u(i-1,np(i,2),28)-u(i-1,np(i,2),10)))

       rib(i,82)=sqrt((u(i-1,np(i-1,2)-ndif,10)-u(i-1,np(i-1,2),10))**2.
     + +(v(i-1,np(i-1,2)-ndif,10)-v(i-1,np(i-1,2),10))**2.)

       do j=np(i-1,2)-ndif, np(i-1,2)

       xdis=sqrt((u(i-1,j,10)-u(i-1,np(i-1,2)-ndif,10))**2.+
     + (v(i-1,j,10)-v(i-1,np(i-1,2)-ndif,10))**2.)

       u(i-1,j,10)=u(i-1,j,10)+(xdis**3./(rib(i,82)**3.))*
     + rib(i,81)*dcos(tetha4)
       v(i-1,j,10)=v(i-1,j,10)+(xdis**3./(rib(i,82)**3.))*
     + rib(i,81)*dsin(tetha4)

       end do

       end do

c      Actualitza les vores i punts especials

       do i=0,nribss-2

       do j=np(i,2)-ndif, np(i,2)

       alpr=abs(datan((v(i,j,10)-v(i,j-1,10))/
     + (u(i,j,10)-u(i,j-1,10))))
       u(i,j,12)=u(i,j,10)+xcos*dsin(alpr)
       v(i,j,12)=v(i,j,10)-xcos*dcos(alpr)

       end do

       alple=abs(datan((v(i,np(i,2),10)-v(i,np(i,2),9))/
     + (u(i,np(i,2),10)-u(i,np(i,2),9))))

       u(i,np(i,2),15)=u(i,np(i,2),10)+xupple*0.1*dsin(alple)
       v(i,np(i,2),15)=v(i,np(i,2),10)+xupple*0.1*dcos(alple)

       u(i,np(i,2),25)=u(i,np(i,2),15)+xupp*0.1*dcos(alple)
       v(i,np(i,2),25)=v(i,np(i,2),15)-xupp*0.1*dsin(alple)


       amle=(v(i,np(i,2),10)-v(i,np(i,2),9))/
     + (u(i,np(i,2),10)-u(i,np(i,2),9))

ccccccc Warning pr2y...       
       amler=((pr2y(i,np(i,2)-1)-pr1y(i,np(i,2)-1))/
     + (pr2x(i,np(i,2)-1)-pr1x(i,np(i,2)-1)))

       b1=v(i,np(i,2),15)-amle*u(i,np(i,2),15)
       b2=v(i,np(i,2),12)-amler*u(i,np(i,2),12)

       u(i,np(i,2),27)=(b2-b1)/(amle-amler)
       v(i,np(i,2),27)=amle*u(i,np(i,2),27)+b1

       end do

c       end if
       
14     continue

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.2.4 REFORMAT PANELS FOR PERFECT MATCHING
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Detect if ndif parameter is set for reformat
       if (ndif.eq.1000) then

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Compute rib and panels lenghts (also done in chapter 11. (!))
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss

       rib(i,30)=0. ! extra panel left
       rib(i,31)=0. ! extra rib
       rib(i,32)=0. ! extra panel right
       rib(i,33)=0. ! intra panel left
       rib(i,34)=0. ! intra rib
       rib(i,35)=0. ! intra panel right

       do j=1,np(i,2)-1

       rib(i,30)=rib(i,30)+sqrt((u(i-1,j,10)-u(i-1,j+1,10))**2.+
     + ((v(i-1,j,10)-v(i-1,j+1,10))**2.))

       rib(i,31)=rib(i,31)+sqrt((u(i,j,3)-u(i,j+1,3))**2.+((v(i,j,3)
     + -v(i,j+1,3))**2.))

       rib(i,32)=rib(i,32)+sqrt((u(i,j,9)-u(i,j+1,9))**2.+((v(i,j,9)
     + -v(i,j+1,9))**2.))

       end do

       do j=np(i,2)+np(i,3),np(i,1)-1

       rib(i,33)=rib(i,33)+sqrt((u(i-1,j,10)-u(i-1,j+1,10))**2.+
     + ((v(i-1,j,10)-v(i-1,j+1,10))**2.))

       rib(i,34)=rib(i,34)+sqrt((u(i,j,3)-u(i,j+1,3))**2.+((v(i,j,3)
     + -v(i,j+1,3))**2.))

       rib(i,35)=rib(i,35)+sqrt((u(i,j,9)-u(i,j+1,9))**2.+((v(i,j,9)
     + -v(i,j+1,9))**2.))

       end do

c      Amplification cofficients
       rib(i,36)=rib(i,30)/rib(i,31)
       rib(i,37)=rib(i,32)/rib(i,31)
       rib(i,38)=rib(i,33)/rib(i,34)
       rib(i,39)=rib(i,35)/rib(i,34)

       rib(0,36)=rib(1,36)
       rib(0,37)=rib(1,36)
       rib(0,38)=rib(1,38)
       rib(0,39)=rib(1,38)

c      Differences with control coefficient xndif

       rib(i,90)=xndif*(rib(i,31)-rib(i,30))
       rib(i,92)=xndif*(rib(i,31)-rib(i,32))

       end do

c      Define rib 0
       rib(0,30)=rib(1,32)
       rib(0,31)=rib(1,31)
       rib(0,32)=rib(1,30)

       rib(0,33)=rib(1,35)
       rib(0,34)=rib(1,34)
       rib(0,35)=rib(1,33)

       rib(0,90)=xndif*(rib(0,31)-rib(0,30))
       rib(0,92)=xndif*(rib(0,31)-rib(0,32))


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Identify point jirl-r where initialize reformating skin(3,1) in %
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss

c      Left side

       xirl(i)=rib(i,30)*skin(3,1)/100.

       rib(i,40)=0.
       do j=1,np(i,2)-1
       rib(i,40)=rib(i,40)+sqrt((u(i-1,j,10)-u(i-1,j+1,10))**2.+
     + (v(i-1,j,10)-v(i-1,j+1,10))**2.)
       if (rib(i,40).lt.rib(i,30)-xirl(i)) then
       x40=rib(i,40)
       jirl(i)=j
       end if
       end do

c      Right side

       xirr(i)=rib(i,32)*skin(3,1)/100.

       rib(i,42)=0.
       do j=1,np(i,2)-1
       rib(i,42)=rib(i,42)+sqrt((u(i,j,9)-u(i,j+1,9))**2.+
     + (v(i,j,9)-v(i,j+1,9))**2.)
       if (rib(i,42).lt.rib(i,32)-xirr(i)) then
       x42=rib(i,42)
       jirr(i)=j
       end if
       end do

       end do

c      Assign in rib 0
       jirl(0)=jirl(1)
       jirr(0)=jirr(1)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat the last segments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat left side - extrados
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=1,nribss

c      Calcule lenght of the reformating polyline

       dist1=0.
       do j=1,jirl(i)-1
       dist1=dist1+sqrt((v(i-1,j,10)-v(i-1,j+1,10))**2.+
     + (u(i-1,j,10)-u(i-1,j+1,10))**2.)
       end do
       
       dist2=0.
       do j=jirl(i),np(i,2)-1
       dist2=dist2+sqrt((v(i-1,j,10)-v(i-1,j+1,10))**2.+
     + (u(i-1,j,10)-u(i-1,j+1,10))**2.)
       end do

       dist3=dist2+rib(i,90)

       distk=dist3/dist2  ! amplification coefficient

c      Reformat
      
       j=jirl(i-1)-1
       u(i-1,j,30)=u(i-1,j,10)
       v(i-1,j,30)=v(i-1,j,10)

       dis22=0.

       do j=jirl(i),np(i,2)-1

c      Atention whit angle definition using abs tangents
c      Make subroutines
c      Angles and distances, left side

       xdv=(v(i-1,j+1,10)-v(i-1,j,10))
       xdu=(u(i-1,j+1,10)-u(i-1,j,10))
       if (xdu.ne.0.) then
       anglee(j)=abs(datan(xdv/xdu))
       else
       anglee(j)=2.*datan(1.0d0)
       end if

       if (xdu.ge.0.and.xdv.ge.0) then ! case 1-I
       siu(j)=1.
       siv(j)=1.
       end if
       if (xdu.le.0.and.xdv.ge.0) then ! case 1-II
       siu(j)=-1.
       siv(j)=1.
       end if
       if (xdu.ge.0.and.xdv.le.0) then ! case 1-III
       siu(j)=1.
       siv(j)=-1.
       end if
       if (xdu.le.0.and.xdv.le.0) then ! case 1-IV
       siu(j)=-1.
       siv(j)=-1.
       end if

       distee(j)=sqrt((v(i-1,j,10)-v(i-1,j+1,10))**2.+
     + (u(i-1,j,10)-u(i-1,j+1,10))**2.)

       end do

c      Define

       do j=jirl(i),np(i,2)-1
       u(i-1,j+1,30)=u(i-1,j,10)+siu(j)*distk*distee(j)*dcos(anglee(j))
       v(i-1,j+1,30)=v(i-1,j,10)+siv(j)*distk*distee(j)*dsin(anglee(j))
       u(i-1,j+1,10)=u(i-1,j+1,30)
       v(i-1,j+1,10)=v(i-1,j+1,30)
       end do

       j=np(i,2)+1
       u(i-1,j,10)=u(i-1,j-1,10)+u(i-1,j-1,10)-u(i-1,j-2,10)
       v(i-1,j,10)=v(i-1,j-1,10)+v(i-1,j-1,10)-v(i-1,j-2,10)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat right side - extrados
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss

c      Calcule lenght of the reformating polyline

       dist1=0.
       do j=1,jirr(i)-1
       dist1=dist1+sqrt((v(i,j,9)-v(i,j+1,9))**2.+
     + (u(i,j,9)-u(i,j+1,9))**2.)
       end do
       
       dist2=0.
       do j=jirr(i),np(i,2)-1
       dist2=dist2+sqrt((v(i,j,9)-v(i,j+1,9))**2.+
     + (u(i,j,9)-u(i,j+1,9))**2.)
       end do

       dist3=dist2+rib(i,92)

       distk=dist3/dist2  ! amplification coefficient

c      Reformat
      
       j=jirr(i-1)-1
       u(i,j,32)=u(i,j,9)
       v(i,j,32)=v(i,j,9)

       do j=jirr(i),np(i,2)-1

c      Atention whit angle definition using abs tangents
c      Make subroutines
c      Angles and distances, left side

       xdv=(v(i,j+1,9)-v(i,j,9))
       xdu=(u(i,j+1,9)-u(i,j,9))
       if (xdu.ne.0.) then
       anglee(j)=abs(datan(xdv/xdu))
       else
       anglee(j)=2.*datan(1.0d0)
       end if

       if (xdu.ge.0.and.xdv.ge.0) then ! case 1-I
       siu(j)=1.
       siv(j)=1.
       end if
       if (xdu.le.0.and.xdv.ge.0) then ! case 1-II
       siu(j)=-1.
       siv(j)=1.
       end if
       if (xdu.ge.0.and.xdv.le.0) then ! case 1-III
       siu(j)=1.
       siv(j)=-1.
       end if
       if (xdu.le.0.and.xdv.le.0) then ! case 1-IV
       siu(j)=-1.
       siv(j)=-1.
       end if

       distee(j)=sqrt((v(i,j,9)-v(i,j+1,9))**2.+
     + (u(i,j,9)-u(i,j+1,9))**2.)

       end do

c      Define

       do j=jirr(i),np(i,2)-1
       u(i,j+1,32)=u(i,j,9)+siu(j)*distk*distee(j)*dcos(anglee(j))
       v(i,j+1,32)=v(i,j,9)+siv(j)*distk*distee(j)*dsin(anglee(j))
       u(i,j+1,9)=u(i,j+1,32)
       v(i,j+1,9)=v(i,j+1,32)
       end do

       j=np(i,2)+1
       u(i,j,9)=u(i,j-1,9)+u(i,j-1,9)-u(i,j-2,9)
       v(i,j,9)=v(i,j-1,9)+v(i,j-1,9)-v(i,j-2,9)

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Final verification left and right side
c      Can be erased
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      
       do i=1,nribss

       rib(i,40)=0.
       do j=1,np(i,2)-1
       rib(i,40)=rib(i,40)+sqrt((u(i-1,j,10)-u(i-1,j+1,10))**2.+
     + (v(i-1,j,10)-v(i-1,j+1,10))**2.)
       end do
      
       rib(i,42)=0.
       do j=1,np(i,2)-1
       rib(i,42)=rib(i,42)+sqrt((u(i,j,9)-u(i,j+1,9))**2.+
     + (v(i,j,9)-v(i,j+1,9))**2.)
       end do

c       write (*,*) "IGUALS ",i,rib(i,40),rib(i,31),rib(i,42)

       end do

       end if ! end reformat 


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Distorsion calculus
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Leading edge segment formated rib(i,97) extra

       do i=0,nribss-1

       if (i.lt.nribss) then
       j=np(i,2)
       rib(i,97)=sqrt((u(i,j,9)-u(i,j,10))**2.+
     + ((v(i,j,9)-v(i,j,10))**2.))
c       write (*,*) "rib(i,97) ",i,rib(i,97)
       end if

       end do

       do i=0,nribss-1

c       write (*,*) "DISTORSION 1 LE (mm)",i,(rib(i,97)-rib(i,96))*10
      
       end do


c      Iterations
       do itera=1,5

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Distorsion correction
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Correction only for case ndif=1000

       if (ndif.eq.1000) then

       do i=1,nribss-1

       k=jirl(i)

       dist=sqrt(((u(i,k,9)-u(i,np(i,2),9))**2.)+
     + ((v(i,k,9)-v(i,np(i,2),9))**2.))
      
       epsilon=(rib(i,97)-rib(i,96))

c      Angle of rotation
       if (abs(epsilon).lt.0.01) then
       omega=0.
       else
c      Experimental correction
       omega=1.0*dasin(epsilon/dist)*epsilon/(abs(epsilon))
       end if

c      Rotate left side (all correction)

       do j=jirl(i),np(i,2)-1

c      Atention whit angle definition using abs tangents
c      Make subroutines
c      Angles and distances, left side

       xdv=(v(i,j+1,9)-v(i,j,9))
       xdu=(u(i,j+1,9)-u(i,j,9))
       if (xdu.ne.0.) then
       anglee(j)=abs(datan(xdv/xdu))+omega
       else
       anglee(j)=2.*datan(1.0d0)+omega
       end if

       if (xdu.ge.0.and.xdv.ge.0) then ! case 1-I
       siu(j)=1.
       siv(j)=1.
       end if
       if (xdu.le.0.and.xdv.ge.0) then ! case 1-II
       siu(j)=-1.
       siv(j)=1.
       end if
       if (xdu.ge.0.and.xdv.le.0) then ! case 1-III
       siu(j)=1.
       siv(j)=-1.
       end if
       if (xdu.le.0.and.xdv.le.0) then ! case 1-IV
       siu(j)=-1.
       siv(j)=-1.
       end if

       distee(j)=sqrt((v(i,j,9)-v(i,j+1,9))**2.+
     + (u(i,j,9)-u(i,j+1,9))**2.)

       end do  ! end j

c      Define

       do j=jirr(i),np(i,2)-1
       u(i,j+1,32)=u(i,j,9)+siu(j)*distee(j)*dcos(anglee(j))
       v(i,j+1,32)=v(i,j,9)+siv(j)*distee(j)*dsin(anglee(j))
       u(i,j+1,9)=u(i,j+1,32)
       v(i,j+1,9)=v(i,j+1,32)
       end do

       end do  ! end i

       end if  ! if ndif=1000


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Distorsion 2 calculus
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Leading edge segment formated rib(i,97) extra

       do i=0,nribss-1

       if (i.lt.nribss) then
       j=np(i,2)
       rib(i,97)=sqrt((u(i,j,9)-u(i,j,10))**2.+
     + ((v(i,j,9)-v(i,j,10))**2.))
       end if

       end do ! i

       end do ! itera


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     8.2.5 Calcule external points
c     Seam borders left (11) and right (12)
c     Points LE 11,12,14,15,24,25
c     Points TE 11,12,14,15,24,25,26,27
c     IMPROVE
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Cases corners

c      icasec=1 tangent
c      icasec=2 orthogonal

       icasecle=1
       icasecte=1

c      Virtual points in LE j=np(i,2)+1

       do i=0,nribss
       j=np(i,2)+1
       u(i,j,9)=u(i,j-1,9)+u(i,j-1,9)-u(i,j-2,9)
       v(i,j,9)=v(i,j-1,9)+v(i,j-1,9)-v(i,j-2,9)
       end do

       do i=0,nribss
       j=np(i,2)+1
       u(i-1,j,10)=u(i-1,j-1,10)+u(i-1,j-1,10)-u(i-1,j-2,10)
       v(i-1,j,10)=v(i-1,j-1,10)+v(i-1,j-1,10)-v(i-1,j-2,10)
       end do

c      External points

       do i=0,nribss

c      Points LE 14,15,24,25,26,27

       j=np(i,2)

c      LE case tangent

       if (icasecle.eq.1) then

       alple=abs(datan((v(i,np(i,2),10)-v(i,np(i,2),9))/
     + (u(i,np(i,2),10)-u(i,np(i,2),9))))

       u(i,np(i,2),14)=u(i,np(i,2),9)+xupple*0.1*dsin(alple)
       v(i,np(i,2),14)=v(i,np(i,2),9)+xupple*0.1*dcos(alple)

       u(i,np(i,2),15)=u(i,np(i,2),10)+xupple*0.1*dsin(alple)
       v(i,np(i,2),15)=v(i,np(i,2),10)+xupple*0.1*dcos(alple)

       u(i,np(i,2),24)=u(i,np(i,2),14)-xupp*0.1*dcos(alple)
       v(i,np(i,2),24)=v(i,np(i,2),14)+xupp*0.1*dsin(alple)

       u(i,np(i,2),25)=u(i,np(i,2),15)+xupp*0.1*dcos(alple)
       v(i,np(i,2),25)=v(i,np(i,2),15)-xupp*0.1*dsin(alple)

c      Recta LE using especial points 26,27
       
       amle=(v(i,np(i,2),10)-v(i,np(i,2),9))/
     + (u(i,np(i,2),10)-u(i,np(i,2),9))
       amler=((pr2y(i,np(i,2)-1)-pr1y(i,np(i,2)-1))/
     + (pr2x(i,np(i,2)-1)-pr1x(i,np(i,2)-1)))
       amlel=((pl2y(i,np(i,2)-1)-pl1y(i,np(i,2)-1))/
     + (pl2x(i,np(i,2)-1)-pl1x(i,np(i,2)-1)))

c      Interseccio esquerra
       b1=v(i,np(i,2),14)-amle*u(i,np(i,2),14)
       b2=v(i,np(i,2),11)-amlel*u(i,np(i,2),11)

       u(i,np(i,2),26)=(b2-b1)/(amle-amlel)
       v(i,np(i,2),26)=amle*u(i,np(i,2),26)+b1

       u(i,np(i,2),24)=u(i,np(i,2),26)
       v(i,np(i,2),24)=v(i,np(i,2),26)

c      Interseccio dreta       
       b1=v(i,np(i,2),15)-amle*u(i,np(i,2),15)
       b2=v(i,np(i,2),12)-amler*u(i,np(i,2),12)

       u(i,np(i,2),27)=(b2-b1)/(amle-amler)
       v(i,np(i,2),27)=amle*u(i,np(i,2),27)+b1

       u(i,np(i,2),25)=u(i,np(i,2),27)
       v(i,np(i,2),25)=v(i,np(i,2),27)


       end if

c      LE case orthogonal

       if (icasecle.eq.2) then

       alple=abs(datan((v(i,np(i,2),10)-v(i,np(i,2),9))/
     + (u(i,np(i,2),10)-u(i,np(i,2),9))))
     
       u(i,np(i,2),14)=u(i,np(i,2),9)+xupple*0.1*dsin(alple)
       v(i,np(i,2),14)=v(i,np(i,2),9)+xupple*0.1*dcos(alple)

       u(i,np(i,2),15)=u(i,np(i,2),10)+xupple*0.1*dsin(alple)
       v(i,np(i,2),15)=v(i,np(i,2),10)+xupple*0.1*dcos(alple)

       u(i,np(i,2),24)=u(i,np(i,2),14)-xupp*0.1*dcos(alple)
       v(i,np(i,2),24)=v(i,np(i,2),14)+xupp*0.1*dsin(alple)

       u(i,np(i,2),25)=u(i,np(i,2),15)+xupp*0.1*dcos(alple)
       v(i,np(i,2),25)=v(i,np(i,2),15)-xupp*0.1*dsin(alple)

       end if


c      Calcule points left 11 (case 2)

       do j=1,np(i,2)

       xdu=u(i,j+1,9)-u(i,j,9)
       xdv=v(i,j+1,9)-v(i,j,9)
       if (xdu.ne.0.) then
       alpl=abs(datan(xdv/xdu))
       else
       alpl=2.*datan(1.0d0)
       end if
      
       if (j.eq.np(i,2)-1) then
       alplfi=alpl
       end if
       if (j.eq.np(i,2)) then
       alpl=alplfi
       end if
      
       if (xdu.ge.0.and.xdv.ge.0) then
       u(i,j,11)=u(i,j,9)-xupp*0.1*dsin(alpl)
       v(i,j,11)=v(i,j,9)+xupp*0.1*dcos(alpl)
       end if

       if (xdu.le.0.and.xdv.ge.0) then
       u(i,j,11)=u(i,j,9)-xupp*0.1*dsin(alpl)
       v(i,j,11)=v(i,j,9)-xupp*0.1*dcos(alpl)
       end if

       if (xdu.ge.0.and.xdv.le.0) then
       u(i,j,11)=u(i,j,9)+xupp*0.1*dsin(alpl)
       v(i,j,11)=v(i,j,9)+xupp*0.1*dcos(alpl)
       end if

       if (xdu.le.0.and.xdv.le.0) then
       u(i,j,11)=u(i,j,9)+xupp*0.1*dsin(alpl)
       v(i,j,11)=v(i,j,9)-xupp*0.1*dcos(alpl)
       end if

c       call angdis2(u(i,j,9),v(i,j,9),v(i,j+1,9),v(i,j+1,9),
c     + p4u,p4v,angl,xupp*0.1)

c       u(i,j,11)=p4u
c       v(i,j,11)=p4v

c      Calcule points right 12 (case 3)

       xdu=u(i,j+1,10)-u(i,j,10)
       xdv=v(i,j+1,10)-v(i,j,10)
       if (xdu.ne.0.) then
       alpr=abs(datan(xdv/xdu))
       else
       alpr=2.*datan(1.0d0)
       end if
      
       if (j.eq.np(i,2)-1) then
       alprfi=alpr
       end if
       if (j.eq.np(i,2)) then
       alpr=alprfi
       end if
      
       if (xdu.ge.0.and.xdv.ge.0) then
       u(i,j,12)=u(i,j,10)+xupp*0.1*dsin(alpr)
       v(i,j,12)=v(i,j,10)-xupp*0.1*dcos(alpr)
       end if

       if (xdu.le.0.and.xdv.ge.0) then
       u(i,j,12)=u(i,j,10)+xupp*0.1*dsin(alpr)
       v(i,j,12)=v(i,j,10)+xupp*0.1*dcos(alpr)
       end if

       if (xdu.ge.0.and.xdv.le.0) then
       u(i,j,12)=u(i,j,10)-xupp*0.1*dsin(alpr)
       v(i,j,12)=v(i,j,10)-xupp*0.1*dcos(alpr)
       end if

       if (xdu.le.0.and.xdv.le.0) then
       u(i,j,12)=u(i,j,10)-xupp*0.1*dsin(alpr)
       v(i,j,12)=v(i,j,10)+xupp*0.1*dcos(alpr)
       end if

       end do  ! j

       end do  ! i

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Points trailing edge
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss

c      TE tangent

       If (icasecte.eq.1) then

       alpte=abs(datan((v(i,1,10)-v(i,1,9))/(u(i,1,10)-u(i,1,9))))

       u(i,1,14)=u(i,1,9)-xuppte*0.1*dsin(alpte)
       v(i,1,14)=v(i,1,9)-xuppte*0.1*dcos(alpte)

       u(i,1,15)=u(i,1,10)-xuppte*0.1*dsin(alpte)
       v(i,1,15)=v(i,1,10)-xuppte*0.1*dcos(alpte)

       u(i,1,24)=u(i,1,14)-xupp*0.1*dcos(alpte)
       v(i,1,24)=v(i,1,14)+xupp*0.1*dsin(alpte)
 
       u(i,1,25)=u(i,1,15)+xupp*0.1*dcos(alpte)
       v(i,1,25)=v(i,1,15)-xupp*0.1*dsin(alpte)

c      Recta TE using especial points 26,27

       amte=((v(i,1,10)-v(i,1,9))/(u(i,1,10)-u(i,1,9)))
       amter=((pr2y(i,1)-pr1y(i,1))/(pr2x(i,1)-pr1x(i,1)))
       amtel=((pl2y(i,1)-pl1y(i,1))/(pl2x(i,1)-pl1x(i,1)))

c      Interseccio esquerra
       b1=v(i,1,14)-amte*u(i,1,14)
       b2=v(i,1,11)-amtel*u(i,1,11)

       u(i,1,26)=(b2-b1)/(amte-amtel)
       v(i,1,26)=amte*u(i,1,26)+b1

       u(i,1,24)=u(i,1,26)
       v(i,1,24)=v(i,1,26)

c      Interseccio dreta       
       b1=v(i,1,15)-amte*u(i,1,15)
       b2=v(i,1,12)-amter*u(i,1,12)

       u(i,1,27)=(b2-b1)/(amte-amter)
       v(i,1,27)=amte*u(i,1,26)+b1

       u(i,1,25)=u(i,1,27)
       v(i,1,25)=v(i,1,27)

       end if

c      TE orthogonal

       If (icasecte.eq.2) then

       alpte=abs(datan((v(i,1,10)-v(i,1,9))/(u(i,1,10)-u(i,1,9))))

       u(i,1,14)=u(i,1,9)-xuppte*0.1*dsin(alpte)
       v(i,1,14)=v(i,1,9)-xuppte*0.1*dcos(alpte)

       u(i,1,15)=u(i,1,10)-xuppte*0.1*dsin(alpte)
       v(i,1,15)=v(i,1,10)-xuppte*0.1*dcos(alpte)

       u(i,1,24)=u(i,1,14)-xupp*0.1*dcos(alpte)
       v(i,1,24)=v(i,1,14)+xupp*0.1*dsin(alpte)
 
       u(i,1,25)=u(i,1,15)+xupp*0.1*dcos(alpte)
       v(i,1,25)=v(i,1,15)-xupp*0.1*dsin(alpte)

       end if

       end do  ! end i



cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.2.6 Draw sobreamples extrados panels
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       
c      Box (1,3)

c      Avoid central panel if thickness is 0
       iini=0  ! panel 0 (central)
       if (cencell.lt.0.01) then
       iini=1
       end if

       do i=iini,nribss-1


c       do i=0.,0.
       
       psep=1970.*xkf+seppix*float(i)
       psey=400.*xkf


cccccccccccccccccccccccccccccccccccccccccccccccccccccc    
c      Draw minirib extrados
cccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (i.ge.0.and.rib(i+1,56).gt.1.and.rib(i+1,56).ne.100
     + .and.atp.ne."ss") then

       xpo1=(u(i,1,9)+u(i,1,10))/2.
       ypo1=(v(i,1,9)+v(i,1,10))/2.
       j=jcve(i+1)
       xpo2=(u(i,j,9)+u(i,j,10))/2.
       ypo2=(v(i,j,9)+v(i,j,10))/2.

c      Avoid division by zero!!!
       if (xpo2-xpo1.ne.0.) then
       alpha=datan((ypo2-ypo1)/(xpo2-xpo1))
       end if
       if (abs(xpo2-xpo1).lt.0.00001) then
       alpha=pi/2.
       end if

       xpo3=xpo1+rib(i+1,60)*dcos(alpha)
       ypo3=ypo1+rib(i+1,60)*dsin(alpha)
       xdesx=xdes*dsin(alpha)
       xdesy=xdes*dcos(alpha)

       call line(psep+xpo1,psey-ypo1,psep+xpo3,psey-ypo3,5)
       call pointg(psep+xpo1-xdesx,-psey+ypo1+xdesy,xcir,1)
       call pointg(psep+xpo3-xdesx,-psey+ypo3+xdesy,xcir,1)

c      Laser cuting
       xadd=2520.*xkf
       call point(psep+xpo1+xadd,psey-ypo1,1)
       call point(psep+xpo3+xadd,psey-ypo3,1)

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccc


       do j=1,np(i,2)-1
      
c       write (*,*) "MIRA: ", j, v(i,j,9), v(i,j,10), v(i+1,j,9)
c      ATENCIO v(0,1,10) no assignat
 
c      Sobreamples esquerra

       call line(psep+u(i,j,9),psey-v(i,j,9),psep+u(i,j+1,9),
     + psey-v(i,j+1,9),1)

c      Sobreamples dreta

       call line(psep+u(i,j,10),psey-v(i,j,10),psep+u(i,j+1,10),
     + psey-v(i,j+1,10),1)

c      Vores de costura esquerra

       call line(psep+u(i,j,11),psey-v(i,j,11),psep+u(i,j+1,11),
     + psey-v(i,j+1,11),3)

c      Vores de costura dreta

       call line(psep+u(i,j,12),psey-v(i,j,12),psep+u(i,j+1,12),
     + psey-v(i,j+1,12),3)

       end do

c      Edges LE and TE

       call line(psep+u(i,np(i,2),11),psey-v(i,np(i,2),11),
     + psep+u(i,np(i,2),9),psey-v(i,np(i,2),9),3)

       call line(psep+u(i,np(i,2),10),psey-v(i,np(i,2),10),
     + psep+u(i,np(i,2),12),psey-v(i,np(i,2),12),3)

       call line(psep+u(i,1,11),psey-v(i,1,11),
     + psep+u(i,1,9),psey-v(i,1,9),3)

       call line(psep+u(i,1,10),psey-v(i,1,10),
     + psep+u(i,1,12),psey-v(i,1,12),3)

       call line(psep+u(i,1,10),psey-v(i,1,10),
     + psep+u(i,1,15),psey-v(i,1,15),3)

       call line(psep+u(i,np(i,2),10),psey-v(i,np(i,2),10),
     + psep+u(i,np(i,2),15),psey-v(i,np(i,2),15),3)
       
       call line(psep+u(i,1,9),psey-v(i,1,9),
     + psep+u(i,1,14),psey-v(i,1,14),3)

       call line(psep+u(i,np(i,2),9),psey-v(i,np(i,2),9),
     + psep+u(i,np(i,2),14),psey-v(i,np(i,2),14),3)

       call line(psep+u(i,1,14),psey-v(i,1,14),
     + psep+u(i,1,15),psey-v(i,1,15),3)

       call line(psep+u(i,np(i,2),14),psey-v(i,np(i,2),14),
     + psep+u(i,np(i,2),15),psey-v(i,np(i,2),15),3)

c      Dibuixa cantonades panells extrados

       call line(psep+u(i,1,14),psey-v(i,1,14),
     + psep+u(i,1,24),psey-v(i,1,24),3)

       call line(psep+u(i,1,11),psey-v(i,1,11),
     + psep+u(i,1,24),psey-v(i,1,24),3)

       call line(psep+u(i,1,15),psey-v(i,1,15),
     + psep+u(i,1,25),psey-v(i,1,25),3)
     
       call line(psep+u(i,1,12),psey-v(i,1,12),
     + psep+u(i,1,25),psey-v(i,1,25),3)

       call line(psep+u(i,np(i,2),14),psey-v(i,np(i,2),14),
     + psep+u(i,np(i,2),24),psey-v(i,np(i,2),24),3)

       call line(psep+u(i,np(i,2),11),psey-v(i,np(i,2),11),
     + psep+u(i,np(i,2),24),psey-v(i,np(i,2),24),3)

       call line(psep+u(i,np(i,2),15),psey-v(i,np(i,2),15),
     + psep+u(i,np(i,2),25),psey-v(i,np(i,2),25),3)
     
       call line(psep+u(i,np(i,2),12),psey-v(i,np(i,2),12),
     + psep+u(i,np(i,2),25),psey-v(i,np(i,2),25),3)

c     Segments LE and TE

c     Trailing edge extrados
       call line(psep+u(i,1,9),psey-v(i,1,9),
     + psep+u(i,1,10),psey-v(i,1,10),1)
       
c     Init extrados
       call line(psep+u(i,np(i,2),9),psey-v(i,np(i,2),9),
     + psep+u(i,np(i,2),10),psey-v(i,np(i,2),10),1)

       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.2.7 Dibuixa sobreamples panells extrados Adre
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box (1,5)

c      Avoid central panel if thickness is 0
       iini=0  ! panel 0 (central)
       if (cencell.lt.0.01) then
       iini=1
       end if

       do i=iini,nribss-1

c       do i=0.,0.
       
       psep=1970.*xkf+2520.*xkf+seppix*float(i)
       psey=400.*xkf

       do j=1,np(i,2)-1

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Dibuixa marques romanes AD
       call romano(i+1,psep+5.,psey+0.5,0.0d0,1.0d0,4)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       
c       write (*,*) "MIRA: ", j, v(i,j,9), v(i,j,10), v(i+1,j,9)
c      ATENCIO v(0,1,10) no assignat


c      Vores de costura esquerra

       call line(psep+u(i,j,11),psey-v(i,j,11),psep+u(i,j+1,11),
     + psey-v(i,j+1,11),3)

c      Vores de costura dreta

       call line(psep+u(i,j,12),psey-v(i,j,12),psep+u(i,j+1,12),
     + psey-v(i,j+1,12),3)

       end do

c      Vores LE and TE

       call line(psep+u(i,1,14),psey-v(i,1,14),
     + psep+u(i,1,15),psey-v(i,1,15),3)

       call line(psep+u(i,np(i,2),14),psey-v(i,np(i,2),14),
     + psep+u(i,np(i,2),15),psey-v(i,np(i,2),15),3)

c      Dibuixa cantonades panells extrados

       call line(psep+u(i,1,14),psey-v(i,1,14),
     + psep+u(i,1,24),psey-v(i,1,24),3)

       call line(psep+u(i,1,11),psey-v(i,1,11),
     + psep+u(i,1,24),psey-v(i,1,24),3)

       call line(psep+u(i,1,15),psey-v(i,1,15),
     + psep+u(i,1,25),psey-v(i,1,25),3)
     
       call line(psep+u(i,1,12),psey-v(i,1,12),
     + psep+u(i,1,25),psey-v(i,1,25),3)

       call line(psep+u(i,np(i,2),14),psey-v(i,np(i,2),14),
     + psep+u(i,np(i,2),24),psey-v(i,np(i,2),24),3)

       call line(psep+u(i,np(i,2),11),psey-v(i,np(i,2),11),
     + psep+u(i,np(i,2),24),psey-v(i,np(i,2),24),3)

       call line(psep+u(i,np(i,2),15),psey-v(i,np(i,2),15),
     + psep+u(i,np(i,2),25),psey-v(i,np(i,2),25),3)
     
       call line(psep+u(i,np(i,2),12),psey-v(i,np(i,2),12),
     + psep+u(i,np(i,2),25),psey-v(i,np(i,2),25),3)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.3- SOBREAMPLES VENTS
c      REVISAR, NO FINALITZAT
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Left side

c      Initialize sob points

       xsob(1)=0.
       ysob(1)=rib(i,22)*skin(1,2)/100.
       xsob(2)=rib(i,26)
       ysob(2)=rib(i,24)*skin(6,4)/100.

c      Longituds u

       u(i,np(i,2),7)=0.
       
       do j=np(i,2),np(i,2)+np(i,3)-2

       u(i,j+1,7)=u(i,j,7)+sqrt((pl2x(i,j)-pl1x(i,j))**2+
     + (pl2y(i,j)-pl1y(i,j))**2)

       end do

c      Sobreample v      

       v(i,np(i,2),7)=rib(i,24)*skin(1,2)/100.

       do j=np(i,2)+np(i,3)-1,np(i,1)-1


     


       end do







ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.3 SOBREAMPLES INTRADOS
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       xcos=xlow/10. ! intrados sewing allowance
       
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.3.1 Sobreamples esquerra intrados
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss

c      Initialize sob points

       do k=1,6

       xsob(k)=((100.-(skin(7-k,3)))/100.)*rib(i,25)
       ysob(k)=rib(i,24)*skin(7-k,4)/100.

       end do

c      Longituds u

       u(i,np(i,2)+np(i,3)-1,7)=0.
       
       do j=np(i,2)+np(i,3)-1,np(i,1)-1

       u(i,j+1,7)=u(i,j,7)+sqrt((pl2x(i,j)-pl1x(i,j))**2+
     + (pl2y(i,j)-pl1y(i,j))**2)

       end do

c      Sobreample v      

       v(i,np(i,2)+np(i,3)-1,7)=rib(i,24)*skin(6,4)/100.

       do j=np(i,2)+np(i,3)-1,np(i,1)-1

c      LE zone

       if(u(i,j+1,7).le.xsob(2)) then

       xm=(ysob(2)-ysob(1))/(xsob(2)-xsob(1))
       xn=ysob(2)-xm*xsob(2)

       v(i,j+1,7)=xm*(u(i,j+1,7))+xn

       xm1=xm
       xn1=xn

       end if
       
       if(u(i,j+1,7).gt.xsob(2).and.u(i,j+1,7).le.xsob(3)) then

       xm=(ysob(3)-ysob(2))/(xsob(3)-xsob(2))
       xn=ysob(2)-xm*xsob(2)

       v(i,j+1,7)=xm*(u(i,j+1,7))+xn

       xm2=xm
       xn2=xn

       end if

c      Central panel

       if(u(i,j+1,7).gt.xsob(3).and.u(i,j+1,7).le.xsob(4)) then

       xm=(ysob(4)-ysob(3))/(xsob(4)-xsob(3))
       xn=ysob(3)-xm*xsob(3)

       v(i,j+1,7)=xm*(u(i,j+1,7))+xn

       xm2=xm
       xn2=xn

       end if

c      TE zone

       if(u(i,j+1,7).gt.xsob(4).and.u(i,j+1,7).le.xsob(5)) then

       xm=(ysob(5)-ysob(4))/(xsob(5)-xsob(4))
       xn=ysob(4)-xm*xsob(4)

       v(i,j+1,7)=xm*(u(i,j+1,7))+xn

       xm3=xm
       xn3=xn

       end if

       if(u(i,j+1,7).gt.xsob(5)) then

       xm=(ysob(6)-ysob(5))/(xsob(6)-xsob(5))
       xn=ysob(5)-xm*xsob(5)

       v(i,j+1,7)=xm*(u(i,j+1,7))+xn

       xm3=xm
       xn3=xn

       end if

c      Calcula punts esquerra

       alpl=abs(datan((pl2y(i,j)-pl1y(i,j))/(pl2x(i,j)-pl1x(i,j))))

       u(i,j+1,9)=pl2x(i,j)-v(i,j+1,7)*dsin(alpl)
       v(i,j+1,9)=pl2y(i,j)+v(i,j+1,7)*dcos(alpl)

       u(i,j+1,11)=u(i,j+1,9)-xlow*0.1*dsin(alpl)
       v(i,j+1,11)=v(i,j+1,9)+xlow*0.1*dcos(alpl)
       
       end do

c       u(i,np(i,1),14)=u(i,np(i,1),9)+xlowte*0.1*dcos(alpl)
c       v(i,np(i,1),14)=v(i,np(i,1),9)+xlowte*0.1*dsin(alpl)
       
       npx=np(i,2)+np(i,3)-1

       alpl=abs(datan((pl2y(i,npx-1)-pl1y(i,npx-1))/
     + (pl2x(i,npx-1)-pl1x(i,npx-1))))
       alpl2=alpl

c      pl2x(i,npx-1) no correcte
       u(i,npx,9)=pl1x(i,npx)-v(i,npx,7)*dsin(alpl)
       v(i,npx,9)=pl1y(i,npx)+v(i,npx,7)*dcos(alpl)

       u(i,npx,11)=u(i,npx,9)-xlow*0.1*dsin(alpl)
       v(i,npx,11)=v(i,npx,9)+xlow*0.1*dcos(alpl)

c       u(i,npx,14)=u(i,npx,9)-xlowle*0.1*dcos(alpl)
c       v(i,npx,14)=v(i,npx,9)-xlowle*0.1*dsin(alpl)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.3.2 Sobreamples dreta intrados   
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Sobreamples dreta

       do i=0,nribss

c      Initialize sob points

       do k=1,6

       xsob(k)=((100.-(skin(7-k,3)))/100.)*rib(i+1,25)
       ysob(k)=rib(i,24)*skin(7-k,4)/100.

       end do

c      Longitud u

       u(i,np(i,2)+np(i,3)-1,8)=0.

       do j=np(i,2)+np(i,3)-1,np(i,1)-1

       u(i,j+1,8)=u(i,j,8)+sqrt((pr2x(i,j)-pr1x(i,j))**2+
     + (pr2y(i,j)-pr1y(i,j))**2)

       end do

c      Sobreample v      

       v(i,np(i,2)+np(i,3)-1,8)=rib(i,24)*skin(6,4)/100.

       do j=np(i,2)+np(i,3)-2,np(i,1)-1

c      LE zone

       if(u(i,j+1,8).le.xsob(2)) then

       xm=(ysob(2)-ysob(1))/(xsob(2)-xsob(1))
       xn=ysob(2)-xm*xsob(2)

       v(i,j+1,8)=xm*(u(i,j+1,8))+xn

       xm1=xm
       xn1=xn

       end if

       if(u(i,j+1,8).gt.xsob(2).and.u(i,j+1,8).le.xsob(3)) then

       xm=(ysob(3)-ysob(2))/(xsob(3)-xsob(2))
       xn=ysob(2)-xm*xsob(2)

       v(i,j+1,8)=xm*(u(i,j+1,8))+xn

       xm2=xm
       xn2=xn

       end if

c      Central panel

       if(u(i,j+1,8).gt.xsob(3).and.u(i,j+1,8).le.xsob(4)) then

       xm=(ysob(4)-ysob(3))/(xsob(4)-xsob(3))
       xn=ysob(3)-xm*xsob(3)

       v(i,j+1,8)=xm*(u(i,j+1,8))+xn

       xm2=xm
       xn2=xn

       end if

c      TE zone

       if(u(i,j+1,8).gt.xsob(4).and.u(i,j+1,8).le.xsob(5)) then

       xm=(ysob(5)-ysob(4))/(xsob(5)-xsob(4))
       xn=ysob(4)-xm*xsob(4)

       v(i,j+1,8)=xm*(u(i,j+1,8))+xn

       xm3=xm
       xn3=xn

       end if

       if(u(i,j+1,8).gt.xsob(5)) then

       xm=(ysob(6)-ysob(5))/(xsob(6)-xsob(5))
       xn=ysob(5)-xm*xsob(5)

       v(i,j+1,8)=xm*(u(i,j+1,8))+xn

       xm3=xm
       xn3=xn

       end if

c      Calcula punts dreta

       alpr=abs(datan((pr2y(i,j)-pr1y(i,j))/(pr2x(i,j)-pr1x(i,j))))

c      OPTION add corrections in sign (see 8.2.2)
c      But probably in normal intrados panels is not necessary

       u(i,j+1,10)=pr2x(i,j)+v(i,j+1,8)*dsin(alpr)
       v(i,j+1,10)=pr2y(i,j)-v(i,j+1,8)*dcos(alpr)

       u(i,j+1,12)=u(i,j+1,10)+xlow*0.1*dsin(alpr)
       v(i,j+1,12)=v(i,j+1,10)-xlow*0.1*dcos(alpr)

       end do  ! j=np(i,2)+np(i,3)-1,np(i,1)-1


c      Initial point not definined in previous bucle
       
       npx=np(i,2)+np(i,3)-1

       alpr=abs(datan((pr2y(i,npx)-pr1y(i,npx))/
     + (pr2x(i,npx)-pr1x(i,npx))))
       alpr2=alpr

       u(i,npx,10)=pr1x(i,npx)+v(i,npx,8)*dsin(alpr)
       v(i,npx,10)=pr1y(i,npx)-v(i,npx,8)*dcos(alpr)
       
       u(i,npx,12)=u(i,npx,10)+xlow*0.1*dsin(alpr)
       v(i,npx,12)=v(i,npx,10)-xlow*0.1*dcos(alpr)

c      Leading edge segment unformated rib(i,98) extra

       if (i.lt.nribss) then
       j=np(i,2)+np(i,3)-1
       rib(i,98)=sqrt((u(i,j,9)-u(i,j,10))**2.+
     + ((v(i,j,9)-v(i,j,10))**2.))
       end if

       end do  ! i

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.3.3 Not necessary
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.3.4 REFORMAT PANELS FOR PERFECT MATCHING
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc







c      Detect if ndif parameter is set for reformat
       if (ndif.eq.1000) then

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Compute rib and panels lenghts (also done in chapter 11. (!))
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss

       rib(i,33)=0. ! intra panel left
       rib(i,34)=0. ! intra rib
       rib(i,35)=0. ! intra panel right

       do j=np(i,2)+np(i,3)-1,np(i,1)-1

       rib(i,33)=rib(i,33)+sqrt((u(i-1,j,10)-u(i-1,j+1,10))**2.+
     + ((v(i-1,j,10)-v(i-1,j+1,10))**2.))

       rib(i,34)=rib(i,34)+sqrt((u(i,j,3)-u(i,j+1,3))**2.+((v(i,j,3)
     + -v(i,j+1,3))**2.))

       rib(i,35)=rib(i,35)+sqrt((u(i,j,9)-u(i,j+1,9))**2.+((v(i,j,9)
     + -v(i,j+1,9))**2.))

       end do

c      Amplification cofficients
       rib(i,38)=rib(i,33)/rib(i,34)
       rib(i,39)=rib(i,35)/rib(i,34)

       rib(0,38)=rib(1,38)
       rib(0,39)=rib(1,38)

c      Differences with control coefficient xndif

       rib(i,93)=xndif*(rib(i,34)-rib(i,33))
       rib(i,95)=xndif*(rib(i,34)-rib(i,35))

       end do

c      Define rib 0
     
       rib(0,33)=rib(1,35)
       rib(0,34)=rib(1,34)
       rib(0,35)=rib(1,33)

       rib(0,93)=xndif*(rib(0,34)-rib(0,33))
       rib(0,95)=xndif*(rib(0,34)-rib(0,35))

c      Define special rib (probably is not necessary)

       rib(nribss,35)=rib(nribss,34)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Identify point jirl-r where initialize reformating skin(3,3) in %
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss

c      Left side

       xirl(i)=rib(i,33)*skin(3,3)/100.

       rib(i,43)=0.
       do j=np(i,2)+np(i,3)-1,np(i,1)-1
       rib(i,43)=rib(i,43)+sqrt((u(i-1,j,10)-u(i-1,j+1,10))**2.+
     + (v(i-1,j,10)-v(i-1,j+1,10))**2.)
       if (rib(i,43).lt.xirl(i)) then
       x43=rib(i,43)
       jirl(i)=j
       end if
       end do

c       write (*,*) "AQUI 43",i,jirl(i),x43,rib(i,33)


c      Right side

       xirr(i)=rib(i,35)*skin(3,3)/100.

       rib(i,45)=0.
       do j=np(i,2)+np(i,3)-1,np(i,1)-1
       rib(i,45)=rib(i,45)+sqrt((u(i,j,9)-u(i,j+1,9))**2.+
     + (v(i,j,9)-v(i,j+1,9))**2.)
       if (rib(i,45).lt.xirr(i)) then
       x45=rib(i,45)
       jirr(i)=j
       end if
       end do

c       write (*,*) "AQUI 45",i,jirr(i),x45,rib(i,35)

       end do

c      Assign in rib 0
       jirl(0)=jirl(1)
       jirr(0)=jirr(1)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat the last segments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat left side - intrados
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=1,nribss

c      Calcule lenght of the reformating polyline

       dist1=0.0d0
       do j=jirl(i),np(i,1)-1
       dist1=dist1+dsqrt((v(i-1,j,10)-v(i-1,j+1,10))**2.+
     + (u(i-1,j,10)-u(i-1,j+1,10))**2.)
       end do
       
       dist2=0.0d0
       do j=np(i,2)+np(i,3)-1,jirl(i)-1
       dist2=dist2+dsqrt((v(i-1,j,10)-v(i-1,j+1,10))**2.+
     + (u(i-1,j,10)-u(i-1,j+1,10))**2.)
       end do

c       write (*,*) "rib(i,33)=",i,dist1+dist2,rib(i,33),
c     + dist1+dist2-rib(i,33)


       dist3=dist2+rib(i,93)

       distk=dist3/dist2  ! amplification coefficient

c      Reformat
      
       j=jirl(i-1)+1
       u(i-1,j,33)=u(i-1,j,10)
       v(i-1,j,33)=v(i-1,j,10)

c      Eliminar dis22!!!!!!!!!!!!!!!!!!!!!
       dis22=0.

       do j=jirl(i),np(i,2)+np(i,3),-1

c      Atention whit angle definition using abs tangents
c      Make subroutines
c      Angles and distances, left side

       xdv=(v(i-1,j-1,10)-v(i-1,j,10))
       xdu=(u(i-1,j-1,10)-u(i-1,j,10))
       if (xdu.ne.0.) then
       anglee(j)=abs(datan(xdv/xdu))
       else
       anglee(j)=2.*datan(1.0d0)
       end if

       if (xdu.ge.0.and.xdv.ge.0) then ! case 1-I
       siu(j)=1.
       siv(j)=1.
       end if
       if (xdu.le.0.and.xdv.ge.0) then ! case 1-II
       siu(j)=-1.
       siv(j)=1.
       end if
       if (xdu.ge.0.and.xdv.le.0) then ! case 1-III
       siu(j)=1.
       siv(j)=-1.
       end if
       if (xdu.le.0.and.xdv.le.0) then ! case 1-IV
       siu(j)=-1.
       siv(j)=-1.
       end if

       distee(j)=sqrt((v(i-1,j,10)-v(i-1,j-1,10))**2.+
     + (u(i-1,j,10)-u(i-1,j-1,10))**2.)

       end do

c      Define

       do j=jirl(i),np(i,2)+np(i,3),-1
       u(i-1,j-1,30)=u(i-1,j,10)+siu(j)*distk*distee(j)*dcos(anglee(j))
       v(i-1,j-1,30)=v(i-1,j,10)+siv(j)*distk*distee(j)*dsin(anglee(j))
       u(i-1,j-1,10)=u(i-1,j-1,30)
       v(i-1,j-1,10)=v(i-1,j-1,30)
       end do

c      AFEGIR calcul punts extrems!!!!!!!!!!!

c       j=np(i,2)+np(i,3)-1
c       u(i-1,j,10)=u(i-1,j-1,10)+u(i-1,j-1,10)-u(i-1,j-2,10)
c       v(i-1,j,10)=v(i-1,j-1,10)+v(i-1,j-1,10)-v(i-1,j-2,10)

c      VERIFICATION

       dist=0.0d0
       do j=np(i,2)+np(i,3)-1,np(i,1)-1
       dist=dist+sqrt((v(i-1,j,10)-v(i-1,j+1,10))**2.+
     + (u(i-1,j,10)-u(i-1,j+1,10))**2.)
       end do
c       write (*,*) "VERFICACIO L ",i,dist,rib(i,33),rib(i,34),rib(i,35)

       end do ! i

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat right side - intrados
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss

c      Calcule lenght of the reformating polyline

       dist1=0.0d0
       do j=jirr(i),np(i,1)-1
       dist1=dist1+sqrt((v(i,j,9)-v(i,j+1,9))**2.+
     + (u(i,j,9)-u(i,j+1,9))**2.)
       end do
       
       dist2=0.0d0
       do j=np(i,2)+np(i,3)-1,jirr(i)-1
       dist2=dist2+sqrt((v(i,j,9)-v(i,j+1,9))**2.+
     + (u(i,j,9)-u(i,j+1,9))**2.)
       end do

c       write (*,*) "rib(i,35)=",i,dist1+dist2,rib(i,35),
c     + dist1+dist2-rib(i,35)


       dist3=dist2+rib(i,95)

       distk=dist3/dist2  ! amplification coefficient

c      Reformat
      
       j=jirr(i-1)+1
       u(i,j,35)=u(i,j,9)
       v(i,j,35)=v(i,j,9)

       do j=jirl(i),np(i,2)+np(i,3),-1

c      Atention whit angle definition using abs tangents
c      Make subroutines
c      Angles and distances, left side

       xdv=(v(i,j-1,9)-v(i,j,9))
       xdu=(u(i,j-1,9)-u(i,j,9))
       if (xdu.ne.0.) then
       anglee(j)=abs(datan(xdv/xdu))
       else
       anglee(j)=2.*datan(1.0d0)
       end if

       if (xdu.ge.0.and.xdv.ge.0) then ! case 1-I
       siu(j)=1.
       siv(j)=1.
       end if
       if (xdu.le.0.and.xdv.ge.0) then ! case 1-II
       siu(j)=-1.
       siv(j)=1.
       end if
       if (xdu.ge.0.and.xdv.le.0) then ! case 1-III
       siu(j)=1.
       siv(j)=-1.
       end if
       if (xdu.le.0.and.xdv.le.0) then ! case 1-IV
       siu(j)=-1.
       siv(j)=-1.
       end if

       distee(j)=sqrt((v(i,j,9)-v(i,j-1,9))**2.+
     + (u(i,j,9)-u(i,j-1,9))**2.)

       end do

c      Define

       do j=jirl(i),np(i,2)+np(i,3),-1
       u(i,j-1,32)=u(i,j,9)+siu(j)*distk*distee(j)*dcos(anglee(j))
       v(i,j-1,32)=v(i,j,9)+siv(j)*distk*distee(j)*dsin(anglee(j))
       u(i,j-1,9)=u(i,j-1,32)
       v(i,j-1,9)=v(i,j-1,32)
       end do


c      AFEGIR calcul punts extrems!!!!!!!!!!!

       j=np(i,2)+np(i,3)-2
       u(i,j,9)=u(i,j-1,9)+u(i,j-1,9)-u(i,j,9)
       v(i,j,9)=v(i,j-1,9)+v(i,j-1,9)-v(i,j,9)

c      VERIFICATION

       dist=0.0d0
       do j=np(i,2)+np(i,3)-1,np(i,1)-1
       dist=dist+sqrt((v(i,j,9)-v(i,j+1,9))**2.+
     + (u(i,j,9)-u(i,j+1,9))**2.)
       end do
c       write (*,*) "VERFICACIO R ",i,dist,rib(i,33),rib(i,34),rib(i,35)


       end do ! i

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Final verification left and right side
c      Can be erased
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      
       do i=1,nribss

       rib(i,40)=0.
       do j=1,np(i,2)-1
       rib(i,40)=rib(i,40)+sqrt((u(i-1,j,10)-u(i-1,j+1,10))**2.+
     + (v(i-1,j,10)-v(i-1,j+1,10))**2.)
       end do
      
       rib(i,42)=0.
       do j=1,np(i,2)-1
       rib(i,42)=rib(i,42)+sqrt((u(i,j,9)-u(i,j+1,9))**2.+
     + (v(i,j,9)-v(i,j+1,9))**2.)
       end do

c       write (*,*) "IGUALS ",i,rib(i,40),rib(i,31),rib(i,42)

       end do

       end if ! end reformat 


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Distorsion calculus
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Leading edge segment formated rib(i,99) intra

       do i=0,nribss-1

       if (i.lt.nribss) then
       j=np(i,2)+np(i,3)-1
       rib(i,99)=sqrt((u(i,j,9)-u(i,j,10))**2.+
     + ((v(i,j,9)-v(i,j,10))**2.))
       end if

       end do


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Distorsion correction
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Correction only for case ndif=1000

c      NOT DISTORSION CORRECTION 1001 !!!!!!!!!!!!!!!!!!!!!!

c      Iterations

       do itera=1,5

       if (ndif.eq.1000) then

c      Not reformating rib 1 to preserve simmetry

       do i=2,nribss-1

       k1=jirl(i)
       k2=np(i,2)+np(i,3)-1

c      Straight distance in reformat area
       dist=sqrt(((u(i,k1,9)-u(i,k2,9))**2.)+
     + ((v(i,k1,9)-v(i,k2,9))**2.))
      
       epsilon=(rib(i,99)-rib(i,98))

c      Angle of rotation
       if (abs(epsilon).lt.0.01) then
       omega=0.
       else
c      Experimental correction
       omega=1.0*dasin(epsilon/dist)*epsilon/(abs(epsilon))
       end if

c      Rotate left side (all correction)

       do j=jirl(i),np(i,2)+np(i,3),-1

c      Atention whit angle definition using abs tangents
c      Make subroutines
c      Angles and distances, left side

       xdv=(v(i,j-1,9)-v(i,j,9))
       xdu=(u(i,j-1,9)-u(i,j,9))
       if (xdu.ne.0.) then
       anglee(j)=abs(datan(xdv/xdu))-omega
       else
       anglee(j)=2.*datan(1.0d0)-omega
       end if

       if (xdu.ge.0.and.xdv.ge.0) then ! case 1-I
       siu(j)=1.
       siv(j)=1.
       end if
       if (xdu.le.0.and.xdv.ge.0) then ! case 1-II
       siu(j)=-1.
       siv(j)=1.
       end if
       if (xdu.ge.0.and.xdv.le.0) then ! case 1-III
       siu(j)=1.
       siv(j)=-1.
       end if
       if (xdu.le.0.and.xdv.le.0) then ! case 1-IV
       siu(j)=-1.
       siv(j)=-1.
       end if

       distee(j)=sqrt((v(i,j,9)-v(i,j-1,9))**2.+
     + (u(i,j,9)-u(i,j-1,9))**2.)

       end do  ! end j

c      Define

       do j=jirl(i),np(i,2)+np(i,3),-1
       u(i,j-1,32)=u(i,j,9)+siu(j)*distee(j)*dcos(anglee(j))
       v(i,j-1,32)=v(i,j,9)+siv(j)*distee(j)*dsin(anglee(j))
       u(i,j-1,9)=u(i,j-1,32)
       v(i,j-1,9)=v(i,j-1,32)
       end do

c      AFEGIR calcul punts extrems!!!!!!!!!!! ?
c      com reformat normal

       end do  ! end i

       end if  ! if ndif=1000

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Distorsion 2 calculus
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Leading edge segment formated rib(i,99) extra

       do i=0,nribss-1

       if (i.lt.nribss) then
       j=np(i,2)+np(i,3)-1
       rib(i,99)=sqrt((u(i,j,9)-u(i,j,10))**2.+
     + ((v(i,j,9)-v(i,j,10))**2.))
       end if

       end do ! i

       end do ! itera


c      DISTORSIONS
       do i=0,nribss-1
c       write (*,*) "99-98 ",rib(i,99),rib(i,98),rib(i,99)-rib(i,98)
       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.3.5 Calcula cantonades panells intrados
c      Versio millorable segons 8.2.5
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss-1

       npk=np(i,2)+np(i,3)-1
       
       alpte=abs(datan((v(i,np(i,1),10)-v(i,np(i,1),9))/
     + (u(i,np(i,1),10)-u(i,np(i,1),9))))
       
       alple=abs(datan((v(i,npk,10)-v(i,npk,9))/
     + (u(i,npk,10)-u(i,npk,9))))


       u(i,np(i,1),14)=u(i,np(i,1),9)+xuppte*0.1*dsin(alpte)
       v(i,np(i,1),14)=v(i,np(i,1),9)+xuppte*0.1*dcos(alpte)

       u(i,np(i,1),15)=u(i,np(i,1),10)+xuppte*0.1*dsin(alpte)
       v(i,np(i,1),15)=v(i,np(i,1),10)+xuppte*0.1*dcos(alpte)

       u(i,np(i,1),24)=u(i,np(i,1),14)-xupp*0.1*dcos(alpte)*dcos(alpl)
       v(i,np(i,1),24)=v(i,np(i,1),14)+xupp*0.1*dsin(alpte)*dcos(alpl)
 
       u(i,np(i,1),25)=u(i,np(i,1),15)+xupp*0.1*dcos(alpte)*dcos(alpr)
       v(i,np(i,1),25)=v(i,np(i,1),15)-xupp*0.1*dsin(alpte)*dcos(alpr)


       u(i,npk,14)=u(i,npk,9)+xupple*0.1*dsin(alple)
       v(i,npk,14)=v(i,npk,9)-xupple*0.1*dcos(alple)

       u(i,npk,15)=u(i,npk,10)+xupple*0.1*dsin(alple)
       v(i,npk,15)=v(i,npk,10)-xupple*0.1*dcos(alple)

       u(i,npk,24)=u(i,npk,14)-xupp*0.1*dcos(alple)
       v(i,npk,24)=v(i,npk,14)+xupp*0.1*dsin(alple)

       u(i,npk,25)=u(i,npk,15)+xupp*0.1*dcos(alple)
       v(i,npk,25)=v(i,npk,15)-xupp*0.1*dsin(alple)


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Calcula intersecció de rectes per a cantonades 26 i 27 intrados
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Recta TE
           
       amte=((v(i,np(i,1),10)-v(i,np(i,1),9))/
     + (u(i,np(i,1),10)-u(i,np(i,1),9)))
       amter=((pr2y(i,np(i,1)-1)-pr1y(i,np(i,1)-1))/
     + (pr2x(i,np(i,1)-1)-pr1x(i,np(i,1)-1)))
       amtel=((pl2y(i,np(i,1)-1)-pl1y(i,np(i,1)-1))/
     + (pl2x(i,np(i,1)-1)-pl1x(i,np(i,1)-1)))

c      Interseccio esquerra
       b1=v(i,np(i,1),14)-amte*u(i,np(i,1),14)
       b2=v(i,np(i,1),11)-amtel*u(i,np(i,1),11)

       u(i,np(i,1),26)=(b2-b1)/(amte-amtel)
       v(i,np(i,1),26)=amte*u(i,np(i,1),26)+b1

       u(i,np(i,1),24)=u(i,np(i,1),26)
       v(i,np(i,1),24)=v(i,np(i,1),26)

c      Interseccio dreta       
       b1=v(i,np(i,1),15)-amte*u(i,np(i,1),15)
       b2=v(i,np(i,1),12)-amter*u(i,np(i,1),12)

       u(i,np(i,1),27)=(b2-b1)/(amte-amter)
       v(i,np(i,1),27)=amte*u(i,np(i,1),27)+b1

       u(i,np(i,1),25)=u(i,np(i,1),27)
       v(i,np(i,1),25)=v(i,np(i,1),27)

c      Recta LE
       
       amle=(v(i,npk,10)-v(i,npk,9))/
     + (u(i,np(i,2),10)-u(i,np(i,2),9))
       amler=((pr2y(i,npk-1)-pr1y(i,npk-1))/
     + (pr2x(i,npk-1)-pr1x(i,npk-1)))
       amlel=((pl2y(i,npk-1)-pl1y(i,npk-1))/
     + (pl2x(i,npk-1)-pl1x(i,npk-1)))

c      Interseccio esquerra
       b1=v(i,npk,14)-amle*u(i,npk,14)
       b2=v(i,npk,11)-amlel*u(i,npk,11)

       u(i,npk,26)=(b2-b1)/(amle-amlel)
       v(i,npk,26)=amle*u(i,npk,26)+b1

       u(i,npk,24)=u(i,npk,26)
       v(i,npk,24)=v(i,npk,26)

c      Interseccio dreta       
       b1=v(i,npk,15)-amle*u(i,npk,15)
       b2=v(i,npk,12)-amler*u(i,npk,12)

       u(i,npk,27)=(b2-b1)/(amle-amler)
       v(i,npk,27)=amle*u(i,npk,27)+b1

       u(i,npk,25)=u(i,npk,27)
       v(i,npk,25)=v(i,npk,27)

c       write (*,*) ">>>> ",
c     + u(i,npk,24),v(i,npk,24),u(i,npk,25),v(i,npk,25)


       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.3.6 Dibuixa sobreamples panells intrados i vores de costura
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Control if type is not "ss"
       if (atp.ne."ss") then

c      Box

c      Saltar cella 0 si gruix nul
       iini=0
       if (cencell.lt.0.01) then
       iini=1
       end if

       do i=iini,nribss-1
       
       psep=1970.*xkf+seppix*float(i)
       psey=1291.*xkf


cccccccccccccccccccccccccccccccccccccccccccccccccccccc    
c      Draw minirib intrados
cccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (i.ge.0.and.rib(i+1,56).gt.1.and.rib(i+1,56).ne.100.and
     + .atp.ne."ss") then

       xpo1=(u(i,np(i,1),9)+u(i,np(i,1),10))/2.
       ypo1=(v(i,np(i,1),9)+v(i,np(i,1),10))/2.
       j=jcvi(i+1)
       xpo2=(u(i,j,9)+u(i,j,10))/2.
       ypo2=(v(i,j,9)+v(i,j,10))/2.

c      Evita divisions per zero!!!
       if (xpo2-xpo1.ne.0.) then
       alpha=datan((ypo2-ypo1)/(xpo2-xpo1))
       end if
       if (abs(xpo2-xpo1).lt.0.00001) then
       alpha=pi/2.
       end if

       xpo3=xpo1-rib(i+1,61)*dcos(alpha)
       ypo3=ypo1-rib(i+1,61)*dsin(alpha)
       xdesx=xdes*dsin(alpha)
       xdesy=xdes*dcos(alpha)

       call line(psep+xpo1,psey-ypo1,psep+xpo3,psey-ypo3,5)
       call pointg(psep+xpo1-xdesx,-psey+ypo1+xdesy,xcir,1)
       call pointg(psep+xpo3-xdesx,-psey+ypo3+xdesy,xcir,1)

c      Laser cuting
       xadd=2520.*xkf
       call point(psep+xpo1+xadd,psey-ypo1,1)
       call point(psep+xpo3+xadd,psey-ypo3,1)

       end if


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do j=np(i,2)+np(i,3)-1,np(i,1)-1

c      Sobreamples esquerra

       call line(psep+u(i,j,9),psey-v(i,j,9),psep+u(i,j+1,9),
     + psey-v(i,j+1,9),1)

c      Sobreamples dreta

       call line(psep+u(i,j,10),psey-v(i,j,10),psep+u(i,j+1,10),
     + psey-v(i,j+1,10),1)

c      Vores de costura esquerra

       call line(psep+u(i,j,11),psey-v(i,j,11),psep+u(i,j+1,11),
     + psey-v(i,j+1,11),3)

c      Vores de costura dreta

       call line(psep+u(i,j,12),psey-v(i,j,12),psep+u(i,j+1,12),
     + psey-v(i,j+1,12),3)

       end do

c      Vores LE and TE

       npk=np(i,2)+np(i,3)-1
       

       call line(psep+u(i,np(i,1),11),psey-v(i,np(i,1),11),
     + psep+u(i,np(i,1),9),psey-v(i,np(i,1),9),3)

       call line(psep+u(i,np(i,1),10),psey-v(i,np(i,1),10),
     + psep+u(i,np(i,1),12),psey-v(i,np(i,1),12),3)

       call line(psep+u(i,npk,11),psey-v(i,npk,11),
     + psep+u(i,npk,9),psey-v(i,npk,9),3)

       call line(psep+u(i,npk,10),psey-v(i,npk,10),
     + psep+u(i,npk,12),psey-v(i,npk,12),3)

       call line(psep+u(i,npk,10),psey-v(i,npk,10),
     + psep+u(i,npk,15),psey-v(i,npk,15),3)

       call line(psep+u(i,np(i,1),10),psey-v(i,np(i,1),10),
     + psep+u(i,np(i,1),15),psey-v(i,np(i,1),15),3)
       
       call line(psep+u(i,npk,9),psey-v(i,npk,9),
     + psep+u(i,npk,14),psey-v(i,npk,14),3)

       call line(psep+u(i,np(i,1),9),psey-v(i,np(i,1),9),
     + psep+u(i,np(i,1),14),psey-v(i,np(i,1),14),3)

       call line(psep+u(i,npk,14),psey-v(i,npk,14),
     + psep+u(i,npk,15),psey-v(i,npk,15),3)

       call line(psep+u(i,np(i,1),14),psey-v(i,np(i,1),14),
     + psep+u(i,np(i,1),15),psey-v(i,np(i,1),15),3)


c      Dibuixa cantonades panells intrados

       call line(psep+u(i,np(i,1),14),psey-v(i,np(i,1),14),
     + psep+u(i,np(i,1),24),psey-v(i,np(i,1),24),3)

       call line(psep+u(i,np(i,1),11),psey-v(i,np(i,1),11),
     + psep+u(i,np(i,1),24),psey-v(i,np(i,1),24),3)

       call line(psep+u(i,np(i,1),15),psey-v(i,np(i,1),15),
     + psep+u(i,np(i,1),25),psey-v(i,np(i,1),25),3)
     
       call line(psep+u(i,np(i,1),12),psey-v(i,np(i,1),12),
     + psep+u(i,np(i,1),25),psey-v(i,np(i,1),25),3)

       call line(psep+u(i,npk,14),psey-v(i,npk,14),
     + psep+u(i,npk,24),psey-v(i,npk,24),3)

       call line(psep+u(i,npk,11),psey-v(i,npk,11),
     + psep+u(i,npk,24),psey-v(i,npk,24),3)

       call line(psep+u(i,npk,15),psey-v(i,npk,15),
     + psep+u(i,npk,25),psey-v(i,npk,25),3)
     
       call line(psep+u(i,npk,12),psey-v(i,npk,12),
     + psep+u(i,npk,25),psey-v(i,npk,25),3)


c     Trailing edge intrados
       call line(psep+u(i,np(i,1),9),psey-v(i,np(i,1),9),
     + psep+u(i,np(i,1),10),psey-v(i,np(i,1),10),1)
       
c     Init intrados
       call line(psep+u(i,npk,9),psey-v(i,npk,9),
     + psep+u(i,npk,10),psey-v(i,npk,10),1)

       end do

c       i=nribss
c       do j=np(i,2)+np(i,3)-1,np(i,1)-1
c       call line(psep+u(i,j,10),psey-v(i,j,10),psep+u(i,j+1,10),
c     + psey-v(i,j+1,10),5)
c       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      8.3.7 Dibuixa sobreamples panells intrados i vores de costura
c      Adre
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box

c      Saltar cella 0 si gruix nul
       iini=0
       if (cencell.lt.0.01) then
       iini=1
       end if

       do i=iini,nribss-1
       
       psep=1970.*xkf+2520.*xkf+seppix*float(i)
       psey=1291.*xkf
 
       do j=np(i,2)+np(i,3)-1,np(i,1)-1

c      Sobreamples esquerra

c       call line(psep+u(i,j,9),psey-v(i,j,9),psep+u(i,j+1,9),
c     + psey-v(i,j+1,9),1)

c      Sobreamples dreta

c       call line(psep+u(i,j,10),psey-v(i,j,10),psep+u(i,j+1,10),
c     + psey-v(i,j+1,10),1)

c      Vores de costura esquerra

       call line(psep+u(i,j,11),psey-v(i,j,11),psep+u(i,j+1,11),
     + psey-v(i,j+1,11),3)

c      Vores de costura dreta

       call line(psep+u(i,j,12),psey-v(i,j,12),psep+u(i,j+1,12),
     + psey-v(i,j+1,12),3)

       end do

c      Vores LE and TE

       npk=np(i,2)+np(i,3)-1
       

c       call line(psep+u(i,np(i,1),11),psey-v(i,np(i,1),11),
c     + psep+u(i,np(i,1),9),psey-v(i,np(i,1),9),3)

c       call line(psep+u(i,np(i,1),10),psey-v(i,np(i,1),10),
c     + psep+u(i,np(i,1),12),psey-v(i,np(i,1),12),3)

c       call line(psep+u(i,npk,11),psey-v(i,npk,11),
c     + psep+u(i,npk,9),psey-v(i,npk,9),3)

c       call line(psep+u(i,npk,10),psey-v(i,npk,10),
c     + psep+u(i,npk,12),psey-v(i,npk,12),3)

c       call line(psep+u(i,npk,10),psey-v(i,npk,10),
c     + psep+u(i,npk,15),psey-v(i,npk,15),3)

c       call line(psep+u(i,np(i,1),10),psey-v(i,np(i,1),10),
c     + psep+u(i,np(i,1),15),psey-v(i,np(i,1),15),3)
       
c       call line(psep+u(i,npk,9),psey-v(i,npk,9),
c     + psep+u(i,npk,14),psey-v(i,npk,14),3)

c       call line(psep+u(i,np(i,1),9),psey-v(i,np(i,1),9),
c     + psep+u(i,np(i,1),14),psey-v(i,np(i,1),14),3)

       call line(psep+u(i,npk,14),psey-v(i,npk,14),
     + psep+u(i,npk,15),psey-v(i,npk,15),3)

       call line(psep+u(i,np(i,1),14),psey-v(i,np(i,1),14),
     + psep+u(i,np(i,1),15),psey-v(i,np(i,1),15),3)


c      Dibuixa cantonades panells intrados

       call line(psep+u(i,np(i,1),14),psey-v(i,np(i,1),14),
     + psep+u(i,np(i,1),24),psey-v(i,np(i,1),24),3)

       call line(psep+u(i,np(i,1),11),psey-v(i,np(i,1),11),
     + psep+u(i,np(i,1),24),psey-v(i,np(i,1),24),3)

       call line(psep+u(i,np(i,1),15),psey-v(i,np(i,1),15),
     + psep+u(i,np(i,1),25),psey-v(i,np(i,1),25),3)
     
       call line(psep+u(i,np(i,1),12),psey-v(i,np(i,1),12),
     + psep+u(i,np(i,1),25),psey-v(i,np(i,1),25),3)

       call line(psep+u(i,npk,14),psey-v(i,npk,14),
     + psep+u(i,npk,24),psey-v(i,npk,24),3)

       call line(psep+u(i,npk,11),psey-v(i,npk,11),
     + psep+u(i,npk,24),psey-v(i,npk,24),3)

       call line(psep+u(i,npk,15),psey-v(i,npk,15),
     + psep+u(i,npk,25),psey-v(i,npk,25),3)
     
       call line(psep+u(i,npk,12),psey-v(i,npk,12),
     + psep+u(i,npk,25),psey-v(i,npk,25),3)


c     Trailing edge intrados
c       call line(psep+u(i,np(i,1),9),psey-v(i,np(i,1),9),
c     + psep+u(i,np(i,1),10),psey-v(i,np(i,1),10),1)
       
c     Init intrados
c       call line(psep+u(i,npk,9),psey-v(i,npk,9),
c     + psep+u(i,npk,10),psey-v(i,npk,10),1)

       end do

c       i=nribss
c       do j=np(i,2)+np(i,3)-1,np(i,1)-1
c       call line(psep+u(i,j,10),psey-v(i,j,10),psep+u(i,j+1,10),
c     + psey-v(i,j+1,10),3)

c       end do

c      End if control if not "ss"
       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc       
c      9. SINGULAR RIB POINTS
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       
c        write (*,*) "pi 9. =",pi

c      9.1 Compute anchor points

       do i=0,nribss         ! Itera in ribs

       do k=1,6 ! Itera in A,B,C,D,E,F

       do j=1,np(i,1)

       if(u(i,j,3).le.rib(i,5)*rib(i,15+k)/100.and.u(i,j+1,3)
     + .ge.rib(i,5)*rib(i,15+k)/100.and.j.ge.np(i,2)) then

       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xn=v(i,j,3)-xm*u(i,j,3)
       u(i,k,6)=rib(i,5)*rib(i,15+k)/100.
       v(i,k,6)=xm*u(i,k,6)+xn

c       anccont(i,k)=j

c       write (*,*) "Anchor control i,k,j = ",i,k,anccont(i,k)


       end if

       end do

       end do

       end do

c      9.1+ Detecta punts j a extrados propers a ancoratges

       
c        write (*,*) "pi 9.1+ =",pi

       do i=0,nribss         ! Itera in ribs

       do k=1,6 ! Itera in A,B,C,D,E,F

       do j=np(i,2),2,-1

       if(u(i,j,3).le.rib(i,5)*rib(i,15+k)/100..and.u(i,j-1,3)
     + .ge.rib(i,5)*rib(i,15+k)/100..and.j.le.np(i,2)) then

       anccont(i,k)=j

       end if

       end do

       end do

       end do
       

c      9.2 Compute inlets points

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      ENTRE 9.1+ i 9.2 es perd el valor de pi INEXPLICABLE
       pi=4.*datan(1.0d0)   
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c        write (*,*) "pi 9.2. =",pi

       do i=1,nribss         ! Itera in ribs

       do k=11,12 ! air in out

       do j=1,np(i,1)

       if(u(i,j,3).le.rib(i,5)*rib(i,k)/100.and.u(i,j+1,3)
     + .ge.rib(i,5)*rib(i,k)/100.and.j.ge.np(i,2)-1) then

       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xn=v(i,j,3)-xm*u(i,j,3)
       u(i,k-4,6)=rib(i,5)*rib(i,k)/100.
       v(i,k-4,6)=xm*u(i,k,6)+xn

       end if

       end do

       end do

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.3 Draw anchor points in airfoils
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       
c        write (*,*) "pi 9.3 =",pi

c      Box (1,2)

       sepxx=700.*xkf
       sepyy=100.*xkf

       kx=0
       ky=0
       kyy=0

       do i=1,nribss

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky)

       do j=1,rib(i,15)

c      9.3.1 Anchor points
       call line(sepx+u(i,j,6),-v(i,j,6)+sepy,sepx+u(i,j,6),
     + -0.+sepy,7)

c      9.3.2 Anchor points in mesa de corte

       call point(2530.*xkf+sepx+u(i,j,6),-v(i,j,6)+sepy+xdes,30)
       call point(2530.*xkf+sepx+u(i,j,6),-v(i,j,6)+sepy-1.+xdes,30)
       call point(2530.*xkf+sepx+u(i,j,6),-v(i,j,6)+sepy-2.+xdes,30)

       end do

c      9.4 Marca entrada aire a les costelles

c      ini
       j=np(i,2)
       alpha1=datan((v(i,j,3)-v(i,j-1,3))/(u(i,j,3)-u(i,j-1,3)))
       call line(sepx+u(i,j,3),-v(i,j,3)+sepy,sepx+u(i,j,3)-
     + 4.*dsin(alpha1),-v(i,j,3)-4.*dcos(alpha1)+sepy,1)

       call point(2530.*xkf+sepx+u(i,j,3)+xdes*dsin(alpha1),
     + -v(i,j,3)+sepy+xdes*dcos(alpha1),3)
       call point(2530.*xkf+sepx+u(i,j,3)-1.8*dsin(alpha1),
     + -1.8*dcos(alpha1)-v(i,j,3)+sepy,3)

c      fi
       j=np(i,2)+np(i,3)-1
       alpha1=datan((v(i,j+1,3)-v(i,j-1,3))/(u(i,j+1,3)-u(i,j-1,3)))
       call line(sepx+u(i,j,3),-v(i,j,3)+sepy,sepx+u(i,j,3)-
     + 4.*dsin(alpha1),-v(i,j,3)-4.*dcos(alpha1)+sepy,1)

       call point(2530.*xkf+sepx+u(i,j,3)+xdes*dsin(alpha1),
     + -v(i,j,3)+sepy+xdes*dcos(alpha1),3)
       call point(2530.*xkf+sepx+u(i,j,3)-2.*dsin(alpha1),
     + -2*dcos(alpha1)-v(i,j,3)+sepy,3)


c     9.5 Aditional points (junquillos)

       do l=1,narp

       call point(2530.*xkf+sepx+xarp(l)*rib(i,5)/100.,
     + -yarp(l)*rib(i,5)/100.+sepy,5)
c       call point(2530.*xkf+sepx+10.8*rib(i,5)/100.,
c     + +5.53*rib(i,5)/100.+sepy,5)

       end do

       kx=int((float(i)/6.))
       ky=i-kx*6
       kyy=kyy+1

       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.9 MIDDLE PANEL UNLOADED RIBS
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box (1,6)
c      1260.*4.*xkf
       
       sepxx=1260.*4.*xkf+700.*xkf
       sepyy=100.*xkf
c      sepyy=100

       kx=0
       ky=0
       kyy=0

       do i=1,nribss

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*1.0*float(ky)

c      Detect complete unloaded rib
       if (rib(i,56).eq.100.and.atp.ne."ss") then

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.9.1 Define intermediate airfoil beetwen i-1 and i
c      Interpole chord and thickness
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do j=1,np(i,1)
       u(i,j,43)=u(i-1,j,2)*0.5*(rib(i,5)+rib(i-1,5))/100.
       v(i,j,43)=v(i-1,j,2)*(0.5*(rib(i,149)+rib(i-1,149))/
     + rib(i-1,149))*0.5*(rib(i,5)+rib(i-1,5))/100.
       end do

c      Calculate midline in panel

       do j=1,np(i,1)
       u(i,j,44)=(u(i-1,j,9)+u(i-1,j,10))/2.
       v(i,j,44)=(v(i-1,j,9)+v(i-1,j,10))/2.

c       u(i,j,44)=u(i-1,j,9)
c       v(i,j,44)=v(i-1,j,9)

       end do

c      Compare lenghts extra in rib (150) and panels (153)
       
       rib(i,150)=0.
       rib(i,153)=0.
       do j=1,np(i,2)-1    
       rib(i,150)=rib(i,150)+dsqrt((u(i,j,43)-u(i,j+1,43))**2.+
     + (v(i,j,43)-v(i,j+1,43))**2.)
       rib(i,153)=rib(i,153)+dsqrt((u(i,j,44)-u(i,j+1,44))**2.+
     + (v(i,j,44)-v(i,j+1,44))**2.)
       end do
       rib(i,156)=rib(i,150)-rib(i,153)

c      Compare lenghts vent in rib (151) and panels (154)
c      9-10 Vent panel still not defined (!)
       
       rib(i,151)=0.
       rib(i,154)=0.
       do j=np(i,2),np(i,2)+np(i,3)-2
       rib(i,151)=rib(i,151)+dsqrt((u(i,j,43)-u(i,j+1,43))**2.+
     + (v(i,j,43)-v(i,j+1,43))**2.)
       rib(i,154)=rib(i,154)+dsqrt((u(i,j,44)-u(i,j+1,44))**2.+
     + (v(i,j,44)-v(i,j+1,44))**2.)
       end do
       rib(i,157)=rib(i,151)-rib(i,154)
       j1=np(i,2)
       j2=np(i,2)+np(i,3)-1
c       rib(i,151)=dsqrt((u(i,j1,44)-u(i,j2,44))**2.+
c     + (v(i,j1,44)-v(i,j2,44))**2.)

c      Compare lenghts intra in rib (152) and panels (155)
       
       rib(i,152)=0.
       rib(i,155)=0.
       do j=np(i,2)+np(i,3)-1,np(i,1)-1
       rib(i,152)=rib(i,152)+dsqrt((u(i,j,43)-u(i,j+1,43))**2.+
     + (v(i,j,43)-v(i,j+1,43))**2.)
       rib(i,155)=rib(i,155)+dsqrt((u(i,j,44)-u(i,j+1,44))**2.+
     + (v(i,j,44)-v(i,j+1,44))**2.)
       end do
       rib(i,158)=rib(i,152)-rib(i,155)

c       write (*,*) i,rib(i,150),rib(i,153),rib(i,156)
c       write (*,*) i,rib(i,151),rib(i,154),rib(i,157)
c       write (*,*) i,rib(i,152),rib(i,155),rib(i,158)

c      Reformat rib extrados

       do j=1,np(i,2)-1  ! all extrados

       xdv=(v(i,j+1,43)-v(i,j,43))
       xdu=(u(i,j+1,43)-u(i,j,43))
       if (xdu.ne.0.) then
       anglee(j)=abs(datan(xdv/xdu))
       else
       anglee(j)=2.*datan(1.0d0)
       end if

       if (xdu.ge.0.and.xdv.ge.0) then ! case 1-I
       siu(j)=1.
       siv(j)=1.
       end if
       if (xdu.le.0.and.xdv.ge.0) then ! case 1-II
       siu(j)=-1.
       siv(j)=1.
       end if
       if (xdu.ge.0.and.xdv.le.0) then ! case 1-III
       siu(j)=1.
       siv(j)=-1.
       end if
       if (xdu.le.0.and.xdv.le.0) then ! case 1-IV
       siu(j)=-1.
       siv(j)=-1.
       end if

       distee(j)=sqrt((v(i,j,43)-v(i,j+1,43))**2.+
     + (u(i,j,43)-u(i,j+1,43))**2.)

       end do

c      Define reformated airfoil extrados

       distk=rib(i,153)/rib(i,150)
       do j=1,np(i,2)-1
       u(i,j+1,45)=u(i,j,43)+siu(j)*distk*distee(j)*dcos(anglee(j))
       v(i,j+1,45)=v(i,j,43)+siv(j)*distk*distee(j)*dsin(anglee(j))
       u(i,j+1,43)=u(i,j+1,45)
       v(i,j+1,43)=v(i,j+1,45)
       end do

c      Verify reformated airfoil extrados

       rib(i,150)=0.
       do j=1,np(i,2)-1
       rib(i,150)=rib(i,150)+dsqrt((u(i,j,43)-u(i,j+1,43))**2.+
     + (v(i,j,43)-v(i,j+1,43))**2.)
       end do
c       write (*,*) "RE ",i,rib(i,150),rib(i,153),rib(i,150)-rib(i,153)


c      Reformat rib intrados

       do j=np(i,1),np(i,2)+np(i,3),-1  ! all intrados

       xdv=(v(i,j,43)-v(i,j-1,43))
       xdu=(u(i,j,43)-u(i,j-1,43))
       if (xdu.ne.0.) then
       anglee(j)=abs(datan(xdv/xdu))
       else
       anglee(j)=2.*datan(1.0d0)
       end if

c       write (*,*) "ANGLE ",i,j,anglee(j)

       if (xdu.ge.0.and.xdv.ge.0) then ! case 1-I
       siu(j)=1.
       siv(j)=1.
       end if
       if (xdu.le.0.and.xdv.ge.0) then ! case 1-II
       siu(j)=-1.
       siv(j)=1.
       end if
       if (xdu.ge.0.and.xdv.le.0) then ! case 1-III
       siu(j)=1.
       siv(j)=-1.
       end if
       if (xdu.le.0.and.xdv.le.0) then ! case 1-IV
       siu(j)=-1.
       siv(j)=-1.
       end if

       distee(j)=sqrt((v(i,j,43)-v(i,j-1,43))**2.+
     + (u(i,j,43)-u(i,j-1,43))**2.)

       end do

c      Define reformated airfoil intrados

       distk=rib(i,155)/rib(i,152)
       do j=np(i,1),np(i,2)+np(i,3),-1        
       u(i,j-1,45)=u(i,j,43)-siu(j)*distk*distee(j)*dcos(anglee(j))
       v(i,j-1,45)=v(i,j,43)-siv(j)*distk*distee(j)*dsin(anglee(j))
       u(i,j-1,43)=u(i,j-1,45)
       v(i,j-1,43)=v(i,j-1,45)
       end do

c      Verify reformated airfoil intrados

       rib(i,152)=0.
       do j=np(i,1),np(i,2)+np(i,3),-1         
       rib(i,152)=rib(i,152)+dsqrt((u(i,j,43)-u(i,j-1,43))**2.+
     + (v(i,j,43)-v(i,j-1,43))**2.)
       end do
c       write (*,*) "RI ",i,rib(i,152),rib(i,155),rib(i,152)-rib(i,155)

c      Reformat vent ds (simplified method)

       if (atp.eq."ds") then

       if (np(i,3).eq.3) then ! interpolate only 1 point
       j=np(i,2)+1
       u(i,j,43)=(u(i,j-1,43)+u(i,j+1,43))*0.5
       v(i,j,43)=(v(i,j-1,43)+v(i,j+1,43))*0.5
       end if

       if (np(i,3).ge.4) then ! interpolate only 2 point
       j=np(i,2)+1
       u(i,j,43)=(2.*u(i,j-1,43)+1.*u(i,j+2,43))/3.
       v(i,j,43)=(2.*v(i,j-1,43)+1.*v(i,j+2,43))/3.
       j=np(i,2)+2
       u(i,j,43)=(1.*u(i,j-2,43)+2.*u(i,j+1,43))/3.
       v(i,j,43)=(1.*v(i,j-2,43)+2.*v(i,j+1,43))/3.
       end if

       end if

c      Reformat vent pc (lineal vent)

       if (atp.eq."pc") then

       xdu=(u(i,np(i,2)+np(i,3)-1,43)-u(i,np(i,2),43))/(np(i,3)-1)
       xdv=(v(i,np(i,2)+np(i,3)-1,43)-v(i,np(i,2),43))/(np(i,3)-1)
       do j=np(i,2),np(i,2)+np(i,3)-2
       u(i,j+1,43)=u(i,j,43)+xdu
       v(i,j+1,43)=v(i,j,43)+xdv
       end do

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.9.2 Compute external cut edges in airfoils (i,j,46)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       xcos=xrib/10. ! rib sewing allowance mm to cm
      
       do j=2,np(i,1)-1

c      Amplification factor
       xcosk=1.0

c      Fer mitja entre j-1 i j+1
       alpha1=(datan((v(i,j+1,43)-v(i,j,43))/((u(i,j+1,43)-u(i,j,43)))))
       alpha2=(datan((v(i,j,43)-v(i,j-1,43))/((u(i,j,43)-u(i,j-1,43)))))

       alpha=0.5*(alpha1+alpha2)

c      Alpha correction in sawtooht mono-surface airfoils
c      Dóna la volta a la vora superior

       if (alpha1.lt.0.and.alpha2.gt.0.and.j.ge.np(i,2)) then
       alpha=alpha+pi
       end if

       u(i,j,46)=u(i,j,43)-xcos*xcosk*dsin(alpha)

       if(v(i,j,43).ge.0.) then
       v(i,j,46)=v(i,j,43)+xcos*xcosk*dcos(alpha)
       end if

       if(v(i,j,43).lt.0.) then
       u(i,j,46)=u(i,j,43)+xcos*xcosk*dsin(alpha)
       v(i,j,46)=v(i,j,43)-xcos*xcosk*dcos(alpha)
       end if

       if(u(i,j,3).eq.0) then
       u(i,j,46)=u(i,j,43)-xcos*xcosk
       v(i,j,46)=v(i,j,43)
       end if

       end do

       j=1

       alpha=(datan((v(i,j+1,43)-v(i,j,43))/((u(i,j+1,43)-u(i,j,43)))))

       u(i,j,46)=u(i,j,43)-xcos*xcosk*dsin(alpha)

       if(v(i,j,43).ge.0.) then
       v(i,j,46)=v(i,j,43)+xcos*xcosk*dcos(alpha)
       end if

       if(v(i,j,43).lt.0.) then
       u(i,j,46)=u(i,j,43)+xcos*xcosk*dsin(alpha)
       v(i,j,46)=v(i,j,43)-xcos*xcosk*dcos(alpha)

       end if

       j=np(i,1)

       alpha=(datan((v(i,j,43)-v(i,j-1,43))/((u(i,j,43)-u(i,j-1,43)))))

       u(i,j,46)=u(i,j,43)-xcos*xcosk*dsin(alpha)

       if(v(i,j,43).ge.0.) then
       v(i,j,46)=v(i,j,43)+xcos*xcosk*dcos(alpha)
       end if

       if(v(i,j,43).le.0.) then
       u(i,j,46)=u(i,j,43)+xcos*xcosk*dsin(alpha)
       v(i,j,46)=v(i,j,43)-xcos*xcosk*dcos(alpha)
       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.9.3 Print unloaded ribs, internal line (i,j,43)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c       Now not used

c       do j=1,np(i,2)-1
c       call line(sepx+u(i,j,43),-v(i,j,43)+sepy-sepriy*0.5,
c     + sepx+u(i,j+1,43),-v(i,j+1,43)+sepy-sepriy*0.5,1)
c       end do
c       do j=np(i,2),np(i,2)+np(i,3)-2
c       call line(sepx+u(i,j,43),-v(i,j,43)+sepy-sepriy*0.5,
c     + sepx+u(i,j+1,43),-v(i,j+1,43)+sepy-sepriy*0.5,2)
c       end do
c       do j=np(i,2)+np(i,3)-1,np(i,1)-1
c       call line(sepx+u(i,j,43),-v(i,j,43)+sepy-sepriy*0.5,
c     + sepx+u(i,j+1,43),-v(i,j+1,43)+sepy-sepriy*0.5,3)
c       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.9.4 Print unloaded ribs, external line (i,j,46)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do j=1,np(i,2)-1
       call line(sepx+u(i,j,46),-v(i,j,46)+sepy-sepriy*0.5,
     + sepx+u(i,j+1,46),-v(i,j+1,46)+sepy-sepriy*0.5,1)
       end do
       do j=np(i,2),np(i,2)+np(i,3)-2
       call line(sepx+u(i,j,46),-v(i,j,46)+sepy-sepriy*0.5,
     + sepx+u(i,j+1,46),-v(i,j+1,46)+sepy-sepriy*0.5,2)
       end do
       do j=np(i,2)+np(i,3)-1,np(i,1)-1
       call line(sepx+u(i,j,46),-v(i,j,46)+sepy-sepriy*0.5,
     + sepx+u(i,j+1,46),-v(i,j+1,46)+sepy-sepriy*0.5,1)
       end do

       j=1
       call line(sepx+u(i,j,46),-v(i,j,46)+sepy-sepriy*0.5,
     + sepx+u(i,j,43),-v(i,j,43)+sepy-sepriy*0.5,1)
       j=np(i,1)
       call line(sepx+u(i,j,46),-v(i,j,46)+sepy-sepriy*0.5,
     + sepx+u(i,j,43),-v(i,j,43)+sepy-sepriy*0.5,1)
      
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.9.5 Draw romano and itxt mark in rib
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc     
       j=1
       x1=sepx+u(i,j,43)
       y1=-v(i,j,43)+sepy-sepriy*0.5
       call romano(i,x1-20.,y1,0.0d0,1.0d0,7)
       call itxt(x1,y1,5.0d0,0.0d0,i,7)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.9.6 Draw vents
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      ini
       j=np(i,2)

       alpha1=datan((v(i,j,43)-v(i,j-1,43))/(u(i,j,43)-u(i,j-1,43)))
      
       call point(sepx+u(i,j,43)+xdes*dsin(alpha1),
     + -v(i,j,43)+sepy-sepriy*0.5+xdes*dcos(alpha1),3)
       call point(sepx+u(i,j,43)-1.8*dsin(alpha1),
     + -1.8*dcos(alpha1)-v(i,j,43)+sepy-sepriy*0.5,3)

c      fi
       j=np(i,2)+np(i,3)-1

       alpha1=datan((v(i,j+1,43)-v(i,j-1,43))/(u(i,j+1,43)-u(i,j-1,43)))
       
       call point(sepx+u(i,j,43)+xdes*dsin(alpha1),
     + -v(i,j,43)+sepy-sepriy*0.5+xdes*dcos(alpha1),3)
       call point(sepx+u(i,j,43)-2.*dsin(alpha1),
     + -2*dcos(alpha1)-v(i,j,43)+sepy-sepriy*0.5,3)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.9.7 Marks extrados
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do k=1,60  ! Up to 60 marks

c      Partial lengths init

       rib(i,40)=0.
       rib(i,41)=0.
       rib(i,42)=0.
       rib(i,43)=0.
       rib(i,44)=0.
       rib(i,45)=0.

       xmk=xmark*float(k)

       do j=1,np(i,2)-1

       xprev=rib(i,41)

       rib(i,41)=rib(i,41)+sqrt((u(i,j,43)-u(i,j+1,43))**2.+((v(i,j,43)
     + -v(i,j+1,43))**2.))

       xpost=rib(i,41)

       if(xmk.lt.xpost.and.xmk.ge.xprev) then

c      dibuixa marca

       dist=sqrt((u(i,j,43)-u(i,j+1,43))**2.+((v(i,j,43)
     + -v(i,j+1,43))**2.))

       dist1=xmk-xprev

       xu=u(i,j,43)+(u(i,j+1,43)-u(i,j,43))*(dist1/dist)
       xv=v(i,j,43)+(v(i,j+1,43)-v(i,j,43))*(dist1/dist)

c      Despla a vores punts de control de costures
       alp=(datan((v(i,j+1,43)-v(i,j,43))/(u(i,j+1,43)-u(i,j,43))))
       if (xv.lt.0.) then
       xu=xu+xdes*dsin(alp)
       xv=xv-xdes*dcos(alp)
       end if
       if (xv.ge.0.) then
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)
       end if

c      Dibuixa punt a les costelles

       call point(sepx+xu,sepy-sepriy*0.5-xv,7)
       
       end if 

       end do ! j extrados

       end do ! mark K

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.9.8 Marks intrados
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do k=1,60

c      Partial lengths init

       rib(i,40)=0.
       rib(i,41)=0.
       rib(i,42)=0.
       rib(i,43)=0.
       rib(i,44)=0.
       rib(i,45)=0.

       xmk=xmark*float(k)

       do j=np(i,1),np(i,2)+np(i,3),-1

       xprev=rib(i,44)

       rib(i,44)=rib(i,44)+sqrt((u(i,j,43)-u(i,j-1,43))**2.+((v(i,j,43)
     + -v(i,j-1,43))**2.))

       xpost=rib(i,44)

       if(xmk.lt.xpost.and.xmk.ge.xprev) then

c      dibuixa marca

       dist=sqrt((u(i,j,43)-u(i,j-1,43))**2.+((v(i,j,43)
     + -v(i,j-1,43))**2.))

       dist1=xmk-xprev

       xu=u(i,j,43)+(u(i,j-1,43)-u(i,j,43))*(dist1/dist)
       xv=v(i,j,43)+(v(i,j-1,43)-v(i,j,43))*(dist1/dist)

c      Despla a vores punts de control de costures
       alp=(datan((v(i,j,43)-v(i,j-1,43))/(u(i,j,43)-u(i,j-1,43))))
       xu=xu+xdes*dsin(alp)
       xv=xv-xdes*dcos(alp)

c      Dibuixa punt a les costelles
       call point(sepx+xu,sepy-sepriy*0.5-xv,7)

       end if

       end do ! j intrados

       end do ! k


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.9.9 Draw holes in unloaded ribs
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       
       do l=1,nhols11

c       write (*,*) i,nhols11,ii11

c      Dibuixa forat tipus 11 (alleugerament elliptics)
     
       xx0=(hol(ii11,l,2))*0.5*(rib(i-1,5)+rib(i,5))/100.0d0+sepx
       yy0=(-(hol(ii11,l,3))*0.5*(rib(i-1,5)+rib(i,5))
     + /100.0d0+sepy-sepriy*0.5)
       xxa=(hol(ii11,l,4))*0.5*(rib(i-1,5)+rib(i,5))/100.0d0
       yyb=((hol(ii11,l,5))*0.5*(rib(i-1,5)+rib(i,5))/100.0d0)

       call ellipse(xx0,yy0,xxa,yyb,(hol(ii11,l,6)),1)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Change airfoil location
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       end if  ! Calcule and draw rib i

       kx=int((float(i)/6.))
       ky=i-kx*6
       kyy=kyy+1

       end do ! rib i


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.9.10 Draw equidistant points in panels
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.9.10.1 Extrados
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss

       psep=1970.*xkf+2520.*xkf+seppix*float(i)
       psey=400.*xkf

c      Detect complete unloaded rib
       if (rib(i,56).eq.100.and.atp.ne."ss") then

c      Initial point

       j=1
       xu=u(i,j,44)
       xv=v(i,j,44)

       alp=abs(datan((v(i,j+1,44)-v(i,j,44))/(u(i,j+1,44)-u(i,j,44))))
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)

       call point(psep+xu-seppix,psey-xv,4)
       call point(psep+xu-seppix-2520.*xkf,psey-xv,4)

c      Final point

       j=np(i,2)
       xu=u(i,j,44)
       xv=v(i,j,44)

       alp=abs(datan((v(i,j-1,44)-v(i,j,44))/(u(i,j-1,44)-u(i,j,44))))
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)

       call point(psep+xu-seppix,psey-xv,4)
       call point(psep+xu-seppix-2520.*xkf,psey-xv,4)

c      Internal equidistant points

       do k=1,60  ! Up to 60 marks

c      Partial lengths init

       rib(i,40)=0.
       rib(i,41)=0.
       rib(i,42)=0.
       rib(i,43)=0.
       rib(i,44)=0.
       rib(i,45)=0.

       xmk=xmark*float(k)

       do j=1,np(i,2)-1

       xprev=rib(i,41)

       rib(i,41)=rib(i,41)+sqrt((u(i,j,44)-u(i,j+1,44))**2.+
     + ((v(i,j,44)-v(i,j+1,44))**2.))

       xpost=rib(i,41)

       if(xmk.lt.xpost.and.xmk.ge.xprev) then

c      dibuixa marca

       dist=sqrt((u(i,j,44)-u(i,j+1,44))**2.+((v(i,j,44)
     + -v(i,j+1,44))**2.))

       dist1=xmk-xprev

       xu=u(i,j,44)+(u(i,j+1,44)-u(i,j,44))*(dist1/dist)
       xv=v(i,j,44)+(v(i,j+1,44)-v(i,j,44))*(dist1/dist)

c      Despla a vores punts de control de costures
c       alp=(datan((v(i,j+1,44)-v(i,j,44))/(u(i,j+1,44)-u(i,j,44))))
c       if (xv.lt.0.) then
c       xu=xu+xdes*dsin(alp)
c       xv=xv-xdes*dcos(alp)
c       end if
c       if (xv.ge.0.) then
c       xu=xu-xdes*dsin(alp)
c       xv=xv+xdes*dcos(alp)
c       end if

c      Dibuixa punt a les costelles

c       call point(psep+xu-seppix,psey-xv,1)

c      Despla a vores punts de control de costures
       alp=(datan((v(i,j+1,44)-v(i,j,44))/(u(i,j+1,44)-u(i,j,44))))
       if (xv.lt.0.) then
       xu=xu+xdes*dsin(alp)
       xv=xv-xdes*dcos(alp)
       end if
       if (xv.ge.0.) then
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)
       end if

       call point(psep+xu-seppix,psey-xv,1)
       call point(psep+xu-seppix-2520.*xkf,psey-xv,1)

       end if ! xmk

       end do ! j extrados

       end do ! mark K

       end if ! unloaded rib

       end do ! rib i


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      9.9.10.2 Intrados
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss

       psep=1970.*xkf+2520.*xkf+seppix*float(i)
       psey=1291.*xkf

c      Detect complete unloaded rib
       if (rib(i,56).eq.100.and.atp.ne."ss") then

c      Initial point

       j=np(i,1)
       xu=u(i,j,44)
       xv=v(i,j,44)

       alp=abs(datan((v(i,j-1,44)-v(i,j,44))/(u(i,j-1,44)-u(i,j,44))))
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)

       call point(psep+xu-seppix,psey-xv,4)
       call point(psep+xu-seppix-2520.*xkf,psey-xv,4)

c      Final point

       j=np(i,2)+np(i,3)-1
       xu=u(i,j,44)
       xv=v(i,j,44)

       alp=abs(datan((v(i,j-1,44)-v(i,j,44))/(u(i,j-1,44)-u(i,j,44))))
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)

       call point(psep+xu-seppix,psey-xv,4)
       call point(psep+xu-seppix-2520.*xkf,psey-xv,4)

c      Internal equidistant points

       do k=1,60  ! Up to 60 marks

c      Partial lengths init

       rib(i,40)=0.
       rib(i,41)=0.
       rib(i,42)=0.
       rib(i,43)=0.
       rib(i,44)=0.
       rib(i,45)=0.

       xmk=xmark*float(k)

       do j=np(i,1),np(i,2)+np(i,3),-1

       xprev=rib(i,43)

       rib(i,43)=rib(i,43)+sqrt((u(i,j,44)-u(i,j-1,44))**2.+
     + ((v(i,j,44)-v(i,j-1,44))**2.))

       xpost=rib(i,43)

       if(xmk.lt.xpost.and.xmk.ge.xprev) then

c      dibuixa marca

       dist=sqrt((u(i,j,44)-u(i,j-1,44))**2.+((v(i,j,44)
     + -v(i,j-1,44))**2.))

       dist1=xmk-xprev

       xu=u(i,j,44)+(u(i,j-1,44)-u(i,j,44))*(dist1/dist)
       xv=v(i,j,44)+(v(i,j-1,44)-v(i,j,44))*(dist1/dist)

c      Despla a vores punts de control de costures
c       alp=(datan((v(i,j+1,44)-v(i,j,44))/(u(i,j+1,44)-u(i,j,44))))
c       if (xv.lt.0.) then
c       xu=xu+xdes*dsin(alp)
c       xv=xv-xdes*dcos(alp)
c       end if
c       if (xv.ge.0.) then
c       xu=xu-xdes*dsin(alp)
c       xv=xv+xdes*dcos(alp)
c       end if

c      Dibuixa punt a les costelles

c       call point(psep+xu-seppix,psey-xv,1)

c      Despla a vores punts de control de costures
       alp=(datan((v(i,j-1,44)-v(i,j,44))/(u(i,j-1,44)-u(i,j,44))))
c       if (xv.lt.0.) then
c       xu=xu+xdes*dsin(alp)
c       xv=xv-xdes*dcos(alp)
c       end if
c       if (xv.ge.0.) then
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)
c       end if

       call point(psep+xu-seppix,psey-xv,1)
       call point(psep+xu-seppix-2520.*xkf,psey-xv,1)

       end if ! xmk

       end do ! j extrados

       end do ! mark K

       end if ! unloaded rib

       end do ! rib i


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      10. CALAGE
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       
c        write (*,*) "pi 10. =",pi

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      10.1 Basic calculus
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       calag=(calage/100.)*rib(1,5) ! calage in cm
       hcp=clengl+clengr            ! height karabiners-canopy
       cple=(cpress/100.)*rib(1,5)  ! center or pressure in cm
       assiette=dasin(((cple-calag)/hcp))*(180./pi)
       afinesse=(datan(1./finesse))*(180./pi)
       aoa=afinesse-assiette

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      10.2 Karabiners location
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       xkar=clengk/2.
       ykar=calag+rib(1,3)
       zkar=hcp

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      10.3 Dibuixa calage
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box (2,1)

       x0=0.
       y0=900.*xkf

c      Central airfoil
       i=1

       do j=1,np(i,1)-1

       call line(x0+u(i,j,3),-v(i,j,3)+y0,x0+u(i,j+1,3),
     + -v(i,j+1,3)+y0,1)

       end do

c      Chord
       call line(x0,y0,x0+rib(i,5),y0,8)

c      Pilot-CP and Pilot-C
       call line(x0+ykar,y0+0.,x0+ykar,y0+zkar,1)
       call line(x0+cple,y0+0.,x0+ykar,y0+zkar,3)

c      Assiette and AoA angles
       call line(x0+cple,y0+0.,x0-100.,y0-(100.+cple)*
     + dtan(assiette*pi/180.),4)
       call line(x0+cple,y0+0.,x0-100.,y0+(100.+cple)*
     + dtan(aoa*pi/180.),5)

       xtext="pilot"
       call txt(x0+ykar+20.,y0+zkar,10.0d0,0.0d0,xtext,7)
       xtext="C"
       call txt(x0+ykar,y0-10.,10.0d0,0.0d0,xtext,7)
       xtext="Cp"
       call txt(x0+cple,y0-10.,10.0d0,0.0d0,xtext,7)
       
c      Write text about calage parameters
       xtext="calage= "
       call txt(x0-220*xkf,y0+60.,10.0d0,0.0d0,xtext,7)
       write (xtext, '(F5.2)') calage
       call txt(x0-50*xkf,y0+60.,10.0d0,0.0d0,xtext,7)
       
       xtext="center pressure= "
       call txt(x0-220*xkf,y0+80,10.0d0,0.0d0,xtext,7)
       write (xtext, '(F5.2)') cpress
       call txt(x0-50*xkf,y0+80,10.0d0,0.0d0,xtext,7)
       
       xtext="glide ratio= "
       call txt(x0-220*xkf,y0+100,10.0d0,0.0d0,xtext,7)
       write (xtext, '(F5.2)') finesse
       call txt(x0-50*xkf,y0+100,10.0d0,0.0d0,xtext,7)
       
       xtext="glide angle= "
       call txt(x0-220*xkf,y0+120,10.0d0,0.0d0,xtext,7)
       write (xtext, '(F5.2)') afinesse
       call txt(x0-50*xkf,y0+120,10.0d0,0.0d0,xtext,7)
       
       xtext="angle of attack= "
       call txt(x0-220*xkf,y0+140,10.0d0,0.0d0,xtext,7)
       write (xtext, '(F5.2)') aoa
       call txt(x0-50*xkf,y0+140,10.0d0,0.0d0,xtext,7)
       
       xtext="assiette= "
       call txt(x0-220*xkf,y0+160,10.0d0,0.0d0,xtext,7)
       write (xtext, '(F5.2)') assiette
       call txt(x0-50*xkf,y0+160,10.0d0,0.0d0,xtext,7)


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     11. CALCULA LONGITUDS EXTRA INTRA EN PANELLS I PERFILS. MARKS
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      
c        write (*,*) "pi 11. =",pi

c      11.1 Extrados

       do i=1,nribss

       rib(i,30)=0. ! extra panel left
       rib(i,31)=0. ! extra rib
       rib(i,32)=0. ! extra panel right
       rib(i,33)=0. ! intra panel left
       rib(i,34)=0. ! intra rib
       rib(i,35)=0. ! intra panel right

       do j=1,np(i,2)-1

c      WARNING longituds a dreta i esquerra de la costella extrados!
c      Arreglat amb el vector 29 definit mes enrera

c       rib(i,30)=rib(i,30)+sqrt((u(i-1,j,29)-u(i-1,j+1,29))**2.+
c     + ((v(i-1,j,29)-v(i-1,j+1,29))**2.))

c      ATENCIO, veure si compatible amb cas reformat especial

       rib(i,30)=rib(i,30)+sqrt((u(i-1,j,10)-u(i-1,j+1,10))**2.+
     + ((v(i-1,j,10)-v(i-1,j+1,10))**2.))

       rib(i,31)=rib(i,31)+sqrt((u(i,j,3)-u(i,j+1,3))**2.+((v(i,j,3)
     + -v(i,j+1,3))**2.))

       rib(i,32)=rib(i,32)+sqrt((u(i,j,9)-u(i,j+1,9))**2.+((v(i,j,9)
     + -v(i,j+1,9))**2.))

       end do

       do j=np(i,2)+np(i,3),np(i,1)-1

       rib(i,33)=rib(i,33)+sqrt((u(i-1,j,10)-u(i-1,j+1,10))**2.+
     + ((v(i-1,j,10)-v(i-1,j+1,10))**2.))

       rib(i,34)=rib(i,34)+sqrt((u(i,j,3)-u(i,j+1,3))**2.+((v(i,j,3)
     + -v(i,j+1,3))**2.))

       rib(i,35)=rib(i,35)+sqrt((u(i,j,9)-u(i,j+1,9))**2.+((v(i,j,9)
     + -v(i,j+1,9))**2.))

       end do

c      Amplification cofficients
       rib(i,36)=rib(i,30)/rib(i,31)
       rib(i,37)=rib(i,32)/rib(i,31)
       rib(i,38)=rib(i,33)/rib(i,34)
       rib(i,39)=rib(i,35)/rib(i,34)

       rib(0,36)=rib(1,36)
       rib(0,37)=rib(1,36)
       rib(0,38)=rib(1,38)
       rib(0,39)=rib(1,38)

c       write (*,*) "rib(i,36) ",i, rib(i,36), rib(i,30)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      11.2 Comprobació de longituds
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=1,nribss

c       write (*,*) "Extrados ", i, rib(i,30), rib(i,31), rib(i,32) 

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc      
c      11.3 Dibuixa marques a costelles
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       sepxx=700.*xkf
       sepyy=100.*xkf

       kx=0
       ky=0
       kyy=0

c      Verify thickness of last rib
       
       xsum=0.
       ic=0
       i=nribss
       do j=1,np(i,1)
       xsum=xsum+abs(v(i,j,3))
       end do
       if (xsum.ne.0.0) then
       ic=1
       end if


ccccccccccccccccccccccccccccccccccccccccccccccc
c     11.3.1 Extrados
ccccccccccccccccccccccccccccccccccccccccccccccc

c      Iteration in ribs    
       do i=1,nribss-1+ic

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky)

c      Punt TE
       j=1

       xu=u(i,j,3)
       xv=v(i,j,3)

c      Despla a vores punts de control de costures
       alp=pi/2.
       if (xv.lt.0.) then
c       xu=xu+xdes*dsin(alp)
c       xv=xv-xdes*dcos(alp)
       end if
       if (xv.ge.0.) then
c       xu=xu+xdes*dsin(alp)
c       xv=xv-xdes*dcos(alp)
       end if

c      Dibuixa creu
       call line(sepx+xu-xcir,-(xv)+sepy,sepx+xu+xcir,
     + -(xv)+sepy,3)
       call line(sepx+xu,-(xv-xcir)+sepy,sepx+xu,
     + -(xv+xcir)+sepy,3)

c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(sepx+xu+xlu1,-(xv+xlv1)+sepy,sepx+xu+xlu2,
     + -(xv+xlv2)+sepy,3)

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Marks in ribs
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Punts interiors
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do k=1,60

c      Partial lengths init

       rib(i,40)=0.
       rib(i,41)=0.
       rib(i,42)=0.
       rib(i,43)=0.
       rib(i,44)=0.
       rib(i,45)=0.

       xmk=xmark*float(k)


       do j=1,np(i,2)-1

       xprev=rib(i,41)

       rib(i,41)=rib(i,41)+sqrt((u(i,j,3)-u(i,j+1,3))**2.+((v(i,j,3)
     + -v(i,j+1,3))**2.))

       xpost=rib(i,41)

       if(xmk.lt.xpost.and.xmk.ge.xprev) then

c      dibuixa marca

       dist=sqrt((u(i,j,3)-u(i,j+1,3))**2.+((v(i,j,3)
     + -v(i,j+1,3))**2.))

       dist1=xmk-xprev

       xu=u(i,j,3)+(u(i,j+1,3)-u(i,j,3))*(dist1/dist)
       xv=v(i,j,3)+(v(i,j+1,3)-v(i,j,3))*(dist1/dist)

c      Despla a vores punts de control de costures
       alp=(datan((v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))))
       if (xv.lt.0.) then
       xu=xu+xdes*dsin(alp)
       xv=xv-xdes*dcos(alp)
       end if
       if (xv.ge.0.) then
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)
       end if

c      Dibuixa creu
       call line(sepx+xu-xcir,-(xv)+sepy,sepx+xu+xcir,
     + -(xv)+sepy,3)
       call line(sepx+xu,-(xv-xcir)+sepy,sepx+xu,
     + -(xv+xcir)+sepy,3)

c      Dibuixa punt a les costelles de la taula de tall
c      2530 per ajustar a BOX(1,4)
       call point(2530.*xkf+sepx+xu,sepy-xv,7)

c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(sepx+xu+xlu1,-(xv+xlv1)+sepy,sepx+xu+xlu2,
     + -(xv+xlv2)+sepy,3)

       end do
       
       end if

       end do ! j extrados

c      new
       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      11.3.2 Intrados
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Punts interiors

       do k=1,60

c      Partial lengths init

       rib(i,40)=0.
       rib(i,41)=0.
       rib(i,42)=0.
       rib(i,43)=0.
       rib(i,44)=0.
       rib(i,45)=0.

       xmk=xmark*float(k)

c      Comprova si el parapent es tipus "ds" or "pc"
c      If type "ss" not needed

       if (atp.eq."ds".or.atp.eq."pc") then

       do j=np(i,1),np(i,2)+np(i,3),-1

       xprev=rib(i,44)

       rib(i,44)=rib(i,44)+sqrt((u(i,j,3)-u(i,j-1,3))**2.+((v(i,j,3)
     + -v(i,j-1,3))**2.))

       xpost=rib(i,44)

       if(xmk.lt.xpost.and.xmk.ge.xprev) then

c      dibuixa marca

       dist=sqrt((u(i,j,3)-u(i,j-1,3))**2.+((v(i,j,3)
     + -v(i,j-1,3))**2.))

       dist1=xmk-xprev

       xu=u(i,j,3)+(u(i,j-1,3)-u(i,j,3))*(dist1/dist)
       xv=v(i,j,3)+(v(i,j-1,3)-v(i,j,3))*(dist1/dist)

c      Despla a vores punts de control de costures
       alp=(datan((v(i,j,3)-v(i,j-1,3))/(u(i,j,3)-u(i,j-1,3))))
       xu=xu+xdes*dsin(alp)
       xv=xv-xdes*dcos(alp)

c      Dibuixa creu
       call line(sepx+xu-xcir,-(xv)+sepy,sepx+xu+xcir,
     + -(xv)+sepy,3)
       call line(sepx+xu,-(xv-xcir)+sepy,sepx+xu,
     + -(xv+xcir)+sepy,3)

c      Dibuixa punt a les costelles de la taula de tall
c      2530 per ajustar a BOX(1,4)
       call point(2530.*xkf+sepx+xu,sepy-xv,7)

c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(sepx+xu+xlu1,-(xv+xlv1)+sepy,sepx+xu+xlu2,
     + -(xv+xlv2)+sepy,3)

       end do
       
       end if

       end do ! j intrados

c      Final verificació ds
       end if

       end do ! k

       kx=int((float(i)/6.))
       ky=i-kx*6
       kyy=kyy+1
       
       end do  ! i

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      11.4 Panels marks
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      11.4.1 Extrados panels mark 
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss-1
       
       psep=1970.*xkf+seppix*float(i)
       psey=400.*xkf

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      11.4.1.2 Marks extrados left  
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Initial and final points

c      Initial point
       j=1

       xu=u(i,j,9)
       xv=v(i,j,9)

c      Despla a vores punts de control de costures
       alp=abs(datan((v(i,j+1,9)-v(i,j,9))/(u(i,j+1,9)-u(i,j,9))))
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)

c      Dibuixa creu
       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
     + -(xv)+psey,4)
       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
     + -(xv+xcir)+psey,4)

c      Point Adre       
       call point(psep+xu+2520.*xkf,-xv+psey,7)

c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(psep+xu+xlu1,-(xv+xlv1)+psey,psep+xu+xlu2,
     + -(xv+xlv2)+psey,4)

       end do

c      Final point
       j=np(i,2)

       xu=u(i,j,9)
       xv=v(i,j,9)

c      Despla a vores punts de control de costures
       alp=abs(datan((v(i,j-1,9)-v(i,j,9))/(u(i,j-1,9)-u(i,j,9))))
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)

c      Dibuixa creu
       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
     + -(xv)+psey,4)
       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
     + -(xv+xcir)+psey,4)

c      Point Adre       
       call point(psep+xu+2520.*xkf,-xv+psey,7)

c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(psep+xu+xlu1,-(xv+xlv1)+psey,psep+xu+xlu2,
     + -(xv+xlv2)+psey,4)

       end do

c      Interior points

       do k=1,60

c      Partial lengths init

       rib(i,40)=0.
       rib(i,41)=0.
       rib(i,42)=0.
       rib(i,43)=0.
       rib(i,44)=0.
       rib(i,45)=0.

       xmk=xmark*float(k)

       xmk=xmk*rib(i,36) ! amplificacio de segment

c       write (*,*) "i ",i," K ",k,rib(i,36),xmk
      
c      Dibuixa a extrados left     

       do j=1,np(i,2)-1

       xprev=rib(i,40)

       rib(i,40)=rib(i,40)+sqrt((u(i,j,9)-u(i,j+1,9))**2.+((v(i,j,9)
     + -v(i,j+1,9))**2.))

       xpost=rib(i,40)

       if(xmk.le.xpost.and.xmk.ge.xprev) then

c      dibuixa marca

       dist=sqrt((u(i,j,9)-u(i,j+1,9))**2.+((v(i,j,9)
     + -v(i,j+1,9))**2.))

       dist1=xmk-xprev

       xu=u(i,j,9)+(u(i,j+1,9)-u(i,j,9))*(dist1/dist)
       xv=v(i,j,9)+(v(i,j+1,9)-v(i,j,9))*(dist1/dist)

c      Despla a vores punts de control de costures
       alp=abs(datan((v(i,j+1,9)-v(i,j,9))/(u(i,j+1,9)-u(i,j,9))))
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)

c      Dibuixa creu
       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
     + -(xv)+psey,3)
       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
     + -(xv+xcir)+psey,3)

c      Point Adre       
       call point(psep+xu+2520.*xkf,-xv+psey,7)

c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(psep+xu+xlu1,-(xv+xlv1)+psey,psep+xu+xlu2,
     + -(xv+xlv2)+psey,3)

       end do
       
       end if

       end do ! j extrados left

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      11.4.1.3 Marks Panel extrados right
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Initial and final points

c      Initial point
       j=1

       xu=u(i,j,10)
       xv=v(i,j,10)

c      Dibuixa creu vora
c       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
c     + -(xv)+psey,1)
c       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
c     + -(xv+xcir)+psey,1)

c      Despla a vores punts de control de costures
       alp=abs(datan((v(i,j+1,10)-v(i,j,10))/(u(i,j+1,10)-u(i,j,10))))
       xu=xu+xdes*dsin(alp)
       xv=xv-xdes*dcos(alp)

c      Dibuixa creu
       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
     + -(xv)+psey,4)
       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
     + -(xv+xcir)+psey,4)

c      Point Adre       
       call point(psep+xu+2520.*xkf,-xv+psey,7)

c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(psep+xu+xlu1,-(xv+xlv1)+psey,psep+xu+xlu2,
     + -(xv+xlv2)+psey,4)

       end do

c      Final point
       j=np(i,2)

       xu=u(i,j,10)
       xv=v(i,j,10)

c      Dibuixa creu vora
c       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
c     + -(xv)+psey,1)
c       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
c     + -(xv+xcir)+psey,1)

c      Despla a vores punts de control de costures
       alp=abs(datan((v(i,j-1,10)-v(i,j,10))/(u(i,j-1,10)-u(i,j,10))))
       xu=xu+xdes*dsin(alp)
       xv=xv-xdes*dcos(alp)

c      Dibuixa creu
       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
     + -(xv)+psey,4)
       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
     + -(xv+xcir)+psey,4)

c      Point Adre       
       call point(psep+xu+2520.*xkf,-xv+psey,7)

c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(psep+xu+xlu1,-(xv+xlv1)+psey,psep+xu+xlu2,
     + -(xv+xlv2)+psey,4)

       end do


c      Interiors

       xmk=xmark*float(k)

       xmk=xmk*rib(i,37) ! amplificacio de segment

c      Dibuixa a extrados right     

       do j=1,np(i,2)-1

       xprev=rib(i,42)

       rib(i,42)=rib(i,42)+sqrt((u(i,j,10)-u(i,j+1,10))**2.+((v(i,j,10)
     + -v(i,j+1,10))**2.))

       xpost=rib(i,42)

       if(xmk.le.xpost.and.xmk.ge.xprev) then

c      dibuixa marca

       dist=sqrt((u(i,j,10)-u(i,j+1,10))**2.+((v(i,j,10)
     + -v(i,j+1,10))**2.))

       dist1=xmk-xprev

       xu=u(i,j,10)+(u(i,j+1,10)-u(i,j,10))*(dist1/dist)
       xv=v(i,j,10)+(v(i,j+1,10)-v(i,j,10))*(dist1/dist)

c      Dibuixa creu vora
c       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
c     + -(xv)+psey,1)
c       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
c     + -(xv+xcir)+psey,1)


c      Despla a vores punts de control de costures
       alp=abs(datan((v(i,j+1,10)-v(i,j,10))/(u(i,j+1,10)-u(i,j,10))))
       xu=xu+xdes*dsin(alp)
       xv=xv-xdes*dcos(alp)

c      Dibuixa creu
       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
     + -(xv)+psey,3)
       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
     + -(xv+xcir)+psey,3)

c      Point Adre       
       call point(psep+xu+2520.*xkf,-xv+psey,7)

c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(psep+xu+xlu1,-(xv+xlv1)+psey,psep+xu+xlu2,
     + -(xv+xlv2)+psey,3)

       end do
       
       end if

       end do ! j extrados right

       end do ! k

       end do ! i

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      11.4.2 Intrados panel marks
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Control if type is not "ss"
       if (atp.ne."ss") then

c        write (*,*) "pi 11.4.2. =",pi

       do i=0,nribss-1
       
       psep=1970.*xkf+seppix*float(i)
       psey=1291.*xkf

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      11.4.2.1 Intrados panel marks Left
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Initial

       j=np(i,2)+np(i,3)-1

       xu=u(i,j,9)
       xv=v(i,j,9)

c      Dibuixa creu vora
c       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
c     + -(xv)+psey,1)
c       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
c     + -(xv+xcir)+psey,1)


c      Despla a vores punts de control de costures
       alp=abs(datan((v(i,j,9)-v(i,j+1,9))/(u(i,j,9)-u(i,j+1,9))))
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)

c      Dibuixa creu
       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
     + -(xv)+psey,4)
       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
     + -(xv+xcir)+psey,4)

c      Point Adre       
       call point(psep+xu+2520.*xkf,-xv+psey,7)

c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(psep+xu+xlu1,-(xv+xlv1)+psey,psep+xu+xlu2,
     + -(xv+xlv2)+psey,4)

       end do

c      Final

       j=np(i,1)

       xu=u(i,j,9)
       xv=v(i,j,9)

c      Dibuixa creu vora
c       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
c     + -(xv)+psey,1)
c       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
c     + -(xv+xcir)+psey,1)


c      Despla a vores punts de control de costures
       alp=abs(datan((v(i,j-1,9)-v(i,j,9))/(u(i,j-1,9)-u(i,j,9))))
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)

c      Dibuixa creu
       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
     + -(xv)+psey,4)
       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
     + -(xv+xcir)+psey,4)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Point Adre AD       
       call point(psep+xu+2520.*xkf,-xv+psey,7)
c      Per calcular angle vora de fuga:
       xlll=psep+xu
       ylll=-xv+psey
cccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(psep+xu+xlu1,-(xv+xlv1)+psey,psep+xu+xlu2,
     + -(xv+xlv2)+psey,4)

       end do


c     Interior

       do k=1,60

c      Partial lengths init

       rib(i,40)=0.
       rib(i,41)=0.
       rib(i,42)=0.
       rib(i,43)=0.
       rib(i,44)=0.
       rib(i,45)=0.

       xmk=xmark*float(k)

       xmk=xmk*rib(i,38) ! amplificacio de segment
      
c      Dibuixa a intrados left     

       do j=np(i,1),np(i,2)+np(i,3),-1

       xprev=rib(i,43)

       rib(i,43)=rib(i,43)+sqrt((u(i,j,9)-u(i,j-1,9))**2.+((v(i,j,9)
     + -v(i,j-1,9))**2.))

       xpost=rib(i,43)

       if(xmk.le.xpost.and.xmk.ge.xprev) then

c      dibuixa marca

       dist=sqrt((u(i,j,9)-u(i,j-1,9))**2.+((v(i,j,9)
     + -v(i,j-1,9))**2.))

       dist1=xmk-xprev

       xu=u(i,j,9)+(u(i,j-1,9)-u(i,j,9))*(dist1/dist)
       xv=v(i,j,9)+(v(i,j-1,9)-v(i,j,9))*(dist1/dist)

c      Dibuixa creu vora
c       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
c     + -(xv)+psey,1)
c       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
c     + -(xv+xcir)+psey,1)


c      Despla a vores punts de control de costures
       alp=abs(datan((v(i,j-1,9)-v(i,j,9))/(u(i,j-1,9)-u(i,j,9))))
       xu=xu-xdes*dsin(alp)
       xv=xv+xdes*dcos(alp)

c      Dibuixa creu
       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
     + -(xv)+psey,3)
       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
     + -(xv+xcir)+psey,3)

c      Point Adre       
       call point(psep+xu+2520.*xkf,-xv+psey,7)

c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(psep+xu+xlu1,-(xv+xlv1)+psey,psep+xu+xlu2,
     + -(xv+xlv2)+psey,3)

       end do
       
       end if

       end do ! j intrados left

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      11.4.2.2 Marks Panel intrados right
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Initial

       j=np(i,2)+np(i,3)-1

       xu=u(i,j,10)
       xv=v(i,j,10)

c      Dibuixa creu vora
c       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
c     + -(xv)+psey,1)
c       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
c     + -(xv+xcir)+psey,1)


c      Despla a vores punts de control de costures
       alp=abs(datan((v(i,j,10)-v(i,j+1,10))/(u(i,j,10)-u(i,j+1,10))))
       xu=xu+xdes*dsin(alp)
       xv=xv-xdes*dcos(alp)

c      Dibuixa creu
       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
     + -(xv)+psey,4)
       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
     + -(xv+xcir)+psey,4)

c      Point Adre       
       call point(psep+xu+2520.*xkf,-xv+psey,7)
       
c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(psep+xu+xlu1,-(xv+xlv1)+psey,psep+xu+xlu2,
     + -(xv+xlv2)+psey,4)

       end do

c      Final

       j=np(i,1)

       xu=u(i,j,10)
       xv=v(i,j,10)

c      Dibuixa creu vora
c       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
c     + -(xv)+psey,1)
c       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
c     + -(xv+xcir)+psey,1)


c      Despla a vores punts de control de costures
       alp=abs(datan((v(i,j-1,10)-v(i,j,10))/(u(i,j-1,10)-u(i,j,10))))
       xu=xu+xdes*dsin(alp)
       xv=xv-xdes*dcos(alp)

c      Dibuixa creu
       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
     + -(xv)+psey,4)
       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
     + -(xv+xcir)+psey,4)

cccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Point Adre       
       call point(psep+xu+2520.*xkf,-xv+psey,7)
c      Per calcular angle vora de fuga:
       xrrr=psep+xu
       yrrr=-xv+psey
       alprom=abs(datan((yrrr-ylll)/(xrrr-xlll)))


cccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Dibuixa marques romanes AD
cccccccccccccccccccccccccccccccccccccccccccccccccccc
       call romano(i+1,psep-5.*dcos(alprom)+xu+2520.*xkf, 
     + -xv+psey-0.7*dcos(alprom)-5.*dsin(alprom),pi-alprom,1.0d0,4)


c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(psep+xu+xlu1,-(xv+xlv1)+psey,psep+xu+xlu2,
     + -(xv+xlv2)+psey,4)

       end do


c      Interior

       xmk=xmark*float(k)

       xmk=xmk*rib(i,39) ! amplificacio de segment

c      Dibuixa a intrados right     

       do j=np(i,1),np(i,2)+np(i,3),-1

       xprev=rib(i,45)

       rib(i,45)=rib(i,45)+sqrt((u(i,j,10)-u(i,j-1,10))**2.+((v(i,j,10)
     + -v(i,j-1,10))**2.))

       xpost=rib(i,45)

       if(xmk.le.xpost.and.xmk.ge.xprev) then

c      dibuixa marca

       dist=sqrt((u(i,j,10)-u(i,j-1,10))**2.+((v(i,j,10)
     + -v(i,j-1,10))**2.))

       dist1=xmk-xprev

       xu=u(i,j,10)+(u(i,j-1,10)-u(i,j,10))*(dist1/dist)
       xv=v(i,j,10)+(v(i,j-1,10)-v(i,j,10))*(dist1/dist)

c      Dibuixa creu vora
c       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
c     + -(xv)+psey,1)
c       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
c     + -(xv+xcir)+psey,1)


c      Despla a vores punts de control de costures
       alp=abs(datan((v(i,j-1,10)-v(i,j,10))/(u(i,j-1,10)-u(i,j,10))))
       xu=xu+xdes*dsin(alp)
       xv=xv-xdes*dcos(alp)

c      Dibuixa creu
       call line(psep+xu-xcir,-(xv)+psey,psep+xu+xcir,
     + -(xv)+psey,3)
       call line(psep+xu,-(xv-xcir)+psey,psep+xu,
     + -(xv+xcir)+psey,3)

c      Point Adre       
       call point(psep+xu+2520.*xkf,-xv+psey,7)

c      Dibuixa cercles petits
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(psep+xu+xlu1,-(xv+xlv1)+psey,psep+xu+xlu2,
     + -(xv+xlv2)+psey,3)

       end do
       
       end if

       end do ! j intrados right

       end do ! k


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      11.4.3 Anchor points mark in intrados (Experimental)
c      2015-09-06 Request by Scott
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Draw intrados marks
       icontrolmi=1

       if (icontrolmi.eq.1) then

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Left side
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do klz=1,rib(i,15)

       xlen=0.
       j=np(i,1)
       xlenp=sqrt((v(i,j,9)-v(i,j-1,9))**2.+(u(i,j,9)-u(i,j-1,9))**2.)

       do j=np(i,1),np(i,2)+1,-1

c      Detect and draw anchor point
       if (rib(i,130+klz).ge.xlen.and.rib(i,130+klz).lt.xlenp) then

c       write (*,*) "Anchors ",i,j,klz,xlen,rib(i,130+klz),xlenp

       rib(i,107)=rib(i,130+klz)-xlen
       rib(i,108)=sqrt((v(i,j,9)-v(i,j-1,9))**2.+(u(i,j,9)-u(i,j-1,9))
     + **2.)

c      Interpolate
       xequis=u(i,j,9)-(rib(i,107)*(u(i,j,9)-u(i,j-1,9)))/
     + rib(i,108)
       yequis=v(i,j,9)-(rib(i,107)*(v(i,j,9)-v(i,j-1,9)))/
     + rib(i,108)

c      Define anchor points in planar panel
       xanchoril(i,klz)=xequis
       yanchoril(i,klz)=yequis

c      Draw
       xdu=u(i,j,9)-u(i,j-1,9)
       xdv=v(i,j,9)-v(i,j-1,9)

       if (xdu.ne.0) then
       alpha=-(datan(xdv/xdu))
       end if
       if (xdu.eq.0.) then
       alpha=pi/2.
       end if
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

c       write (*,*) "alpha ", i,klz,alpha*180./pi

c      Line 4*xrib in plotting panels
       call line(psep+xequis,psey-yequis,psep+xequis-0.4*xrib*
     + dsin(-alpha),psey-yequis-0.4*xrib*dcos(-alpha),30)
       
       xpeq=xequis-1.*xdes*dsin(alpha)
       ypeq=yequis+1.*xdes*dcos(alpha)

       xdesp=1.0*(0.5*(xrib-20.*xdes))/10.
       xdesp1x=-xdesp*dsin(alpha)
       xdesp1y=-xdesp*dcos(alpha)
       xdesp2x=-2.*xdesp*dsin(alpha)
       xdesp2y=-2.*xdesp*dcos(alpha)

c      Tree point in MC panels
       call point (psep+xpeq+2520*xkf,psey-ypeq,30)
       call point (psep+xpeq+xdesp1x+2520*xkf,psey-ypeq-xdesp1y,30)
       call point (psep+xpeq+xdesp2x+2520*xkf,psey-ypeq-xdesp2y,30)

       end if

       xlen=xlen+sqrt((v(i,j,9)-v(i,j-1,9))**2.+(u(i,j,9)-u(i,j-1,9))
     + **2.)
       xlenp=xlen+sqrt((v(i,j-1,9)-v(i,j-2,9))**2.+
     + (u(i,j-1,9)-u(i,j-2,9))**2.)

       end do ! j

       end do ! klz


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Right side
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do klz=1,rib(i+1,15)

       xlen=0.
       j=np(i,1)
       xlenp=sqrt((v(i,j,10)-v(i,j-1,10))**2.+(u(i,j,10)-u(i,j-1,10))
     + **2.)

       do j=np(i,1),np(i,2)+1,-1

c      Detect and draw anchor point
       if (rib(i+1,130+klz).ge.xlen.and.rib(i+1,130+klz).lt.xlenp) then

c       write (*,*) "Anchors ",i,j,klz,xlen,rib(i,130+klz),xlenp

       rib(i+1,107)=rib(i+1,130+klz)-xlen
       rib(i+1,108)=sqrt((v(i,j,10)-v(i,j-1,10))**2.+(u(i,j,10)-
     + u(i,j-1,10))**2.)

c      Interpolate
       xequis=u(i,j,10)-(rib(i+1,107)*(u(i,j,10)-u(i,j-1,10)))/
     + rib(i+1,108)
       yequis=v(i,j,10)-(rib(i+1,107)*(v(i,j,10)-v(i,j-1,10)))/
     + rib(i+1,108)

       if (i.eq.0) then
c       write (*,*) "000 ",klz,xequis,yequis
       end if

c      Define anchor points in planar panel
       xanchorir(i,klz)=xequis
       yanchorir(i,klz)=yequis

c      Draw
       alpha=-(datan((v(i,j,10)-v(i,j-1,10))/(u(i,j,10)-u(i,j-1,10))))
c       write (*,*) "alpha ", alpha*180./pi
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

c      Line 4*xrib in plotting panels
       call line(psep+xequis,psey-yequis,psep+xequis+0.4*xrib*
     + dsin(-alpha),psey-yequis+0.4*xrib*dcos(-alpha),30)

c       write (*,*) "xdes ", xdes

       xpeq=xequis-1.*xdes*dsin(-alpha)
       ypeq=yequis+1.*xdes*dcos(-alpha)

       xdesp=1.0*(0.5*(xrib-20.*xdes))/10.
       xdesp1x=xdesp*dsin(-alpha)
       xdesp1y=-xdesp*dcos(-alpha)
       xdesp2x=2.*xdesp*dsin(-alpha)
       xdesp2y=-2.*xdesp*dcos(-alpha)

c      Tree point in MC panels
       call point (psep+xpeq+2520*xkf,psey-ypeq,30)
       call point (psep+xpeq-xdesp1x+2520*xkf,psey-ypeq+xdesp1y,30)
       call point (psep+xpeq-xdesp2x+2520*xkf,psey-ypeq+xdesp2y,30)

       end if

       xlen=xlen+sqrt((v(i,j,10)-v(i,j-1,10))**2.+(u(i,j,10)-
     + u(i,j-1,10))**2.)
       xlenp=xlen+sqrt((v(i,j-1,10)-v(i,j-2,10))**2.+
     + (u(i,j-1,10)-u(i,j-2,10))**2.)

       end do ! j

       end do ! klz

       end if ! icontrol-mi



ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       end do ! i

c      End if control is not "ss"
       end if


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      12. LINES
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c        write (*,*) "pi 12. =",pi
c        pi=4.*datan(1.)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      12.1 Write lines matrix
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do ii=1,slp

       do j=1,cam(ii)

c       write (*,*) ii,j, mc(ii,j,2), mc(ii,j,3), mc(ii,j,4), mc(ii,j,5),
c     + mc(ii,j,6), mc(ii,j,7)," - "  ,mc(ii,j,14), mc(ii,j,15)


       end do
       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      12.2 Identifica les cordes a calcular
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       ic1=0
       ic2=1

       do ii=1,slp      ! Itera en numero de plans

       do k=2,8,2       ! Explora fins 4 nivells
       
       do j=1,cam(ii)-1 ! Itera en camins de cada pla

       if (mc(ii,j,1).le.4.and.k.le.8) then ! Detecta fins 4 nivells

       a=float(mc(ii,j,k))
       b=float(mc(ii,j,k+1))
       aa=float(mc(ii,j+1,k))
       bb=float(mc(ii,j+1,k+1))

       endif

       if (mc(ii,j,1).eq.5.and.k.eq.10) then ! Llegeix nivell 5

       a=float(mc(ii,j,k))
       b=float(mc(ii,j,k+1))
       aa=float(mc(ii,j+1,k))
       bb=float(mc(ii,j+1,k+1))

       endif


       if (a.ne.0.0d0.and.b.ne.0.0d0) then ! count pair line

c      While pair is equal, increase counter
       if (a.eq.aa.and.b.eq.bb) then

       ic2=ic2+1 ! comptabilitza cordes iguals

c      Si arribem a final del cami comptabilitzar la corda
       if (j.eq.cam(ii)-1) then

       ic1=ic1+1

       corda(ic1,1)=ii                    !planol
       corda(ic1,2)=mc(ii,j+1,k)          !nivell
       corda(ic1,3)=mc(ii,j+1,k+1)        !ordre
       corda(ic1,4)=ic2                   !punts d'acciÃ³
       corda(ic1,5)=mc(ii,j+1,1)          !ramificacions del camÃ­
       corda(ic1,6)=mc(ii,j+1,14)         !final row
       corda(ic1,7)=mc(ii,j+1,15)         !final rib
      
       ic2=1

       end if

       end if

c      Si canvia la corda al mateix nivell
       if (a.ne.aa.or.b.ne.bb) then

c       write (*,*) "Ep ",b,bb

       ic1=ic1+1

       corda(ic1,1)=ii                  !planol
       corda(ic1,2)=mc(ii,j,k)          !nivell
       corda(ic1,3)=mc(ii,j,k+1)        !ordre
       corda(ic1,4)=ic2                 !punts d'acciÃ³
       corda(ic1,5)=mc(ii,j,1)          !ramificacions del camÃ­
       corda(ic1,6)=mc(ii,j,14)         !final row
       corda(ic1,7)=mc(ii,j,15)         !final rib
       
       ic2=1

       end if

c      Si arribem a l'ultima linia i no es zero
       if (j.eq.cam(ii)-1) then

       a=float(mc(ii,j,k))
       b=float(mc(ii,j,k+1))
       aa=float(mc(ii,j+1,k))
       bb=float(mc(ii,j+1,k+1))

c      Last level
       if ((a.ne.aa.or.b.ne.bb).and.(aa.ne.0.0d0.and.bb.ne.0.0d0)) then

       ic1=ic1+1

       corda(ic1,1)=ii                    !planol
       corda(ic1,2)=mc(ii,j+1,k)          !nivell
       corda(ic1,3)=mc(ii,j+1,k+1)        !ordre
       corda(ic1,4)=ic2                   !punts d'accio
       corda(ic1,5)=mc(ii,j+1,1)          !ramificacions del camÃ­
       corda(ic1,6)=mc(ii,j+1,14)         !final row
       corda(ic1,7)=mc(ii,j+1,15)         !final rib
 
       ic2=1

       end if

       end if

       end if

       end do  ! j path
       end do  ! k level 2 4 6 8 10 
       end do  ! ii plan

       cordam=ic1 ! maxim nombre de cordes

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      12.3 Compute anchor points in 3D space
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=1,nribss

       tetha=rib(i,8)*pi/180.

       do j=1,rib(i,15) ! anchor number

c      Airfoil anchor washin coordinates
       u(i,j,17)=(u(i,j,6)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + v(i,j,6)*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       v(i,j,17)=(-u(i,j,6)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + v(i,j,6)*dcos(tetha)-rib(i,50)

c      Airfoil anchor (u,v,w) espace coordinates
       u(i,j,18)=u(i,j,17)
       v(i,j,18)=v(i,j,17)*dcos(rib(i,9)*pi/180.)
       w(i,j,18)=-v(i,j,17)*dsin(rib(i,9)*pi/180.)

c      Airfoil anchor (x,y,z) absolute coordinates

       u(i,j,19)=rib(i,6)-w(i,j,18)
       v(i,j,19)=rib(i,3)+u(i,j,18)
       w(i,j,19)=rib(i,7)-v(i,j,18)
    
       end do
       end do

       i=0
       do j=1,rib(1,15)
       u(i,j,19)=-u(1,j,19)
       v(i,j,19)=v(1,j,19)
       w(i,j,19)=w(1,j,19)
       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     12.4 Compute singular rib points in 3D space
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=0,nribss

       tetha=rib(i,8)*pi/180.

       do j=6,8 ! singular point number, brakes, inlet in, inlet out

c      Airfoil anchor washin coordinates
       u(i,j,17)=(u(i,j,6)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + v(i,j,6)*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       v(i,j,17)=(-u(i,j,6)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + v(i,j,6)*dcos(tetha)-rib(i,50)

c      Airfoil anchor (u,v,w) espace coordinates
       u(i,j,18)=u(i,j,17)
       v(i,j,18)=v(i,j,17)*dcos(rib(i,9)*pi/180.)
       w(i,j,18)=-v(i,j,17)*dsin(rib(i,9)*pi/180.)

c      Airfoil anchor (x,y,z) absolute coordinates

       u(i,j,19)=rib(i,6)-w(i,j,18)
       v(i,j,19)=rib(i,3)+u(i,j,18)
       w(i,j,19)=rib(i,7)-v(i,j,18)

c      Brake distribution

       if (j.eq.6) then

       xprib=(rib(i,2)/rib(nribss,2))*100.
       
       if (xprib.ge.bd(1,1).and.xprib.lt.bd(2,1)) then
       xm=(bd(2,2)-bd(1,2))/(bd(2,1)-bd(1,1))
       xb=bd(1,2)-xm*bd(1,1)
       xxl=xm*xprib+xb
       xlx=xxl*dsin(rib(i,9)*pi/180.)
       xly=xxl*dcos(rib(i,9)*pi/180.)
       end if

       if (xprib.ge.bd(2,1).and.xprib.lt.bd(3,1)) then
       xm=(bd(3,2)-bd(2,2))/(bd(3,1)-bd(2,1))
       xb=bd(2,2)-xm*bd(2,1)
       xxl=xm*xprib+xb
       xlx=xxl*dsin(rib(i,9)*pi/180.)
       xly=xxl*dcos(rib(i,9)*pi/180.)
       end if

       if (xprib.ge.bd(3,1).and.xprib.lt.bd(4,1)) then
       xm=(bd(4,2)-bd(3,2))/(bd(4,1)-bd(3,1))
       xb=bd(3,2)-xm*bd(3,1)
       xxl=xm*xprib+xb
       xlx=xxl*dsin(rib(i,9)*pi/180.)
       xly=xxl*dcos(rib(i,9)*pi/180.)
       end if

       if (xprib.ge.bd(4,1).and.xprib.le.bd(5,1)) then
       xm=(bd(5,2)-bd(4,2))/(bd(5,1)-bd(4,1))
       xb=bd(4,2)-xm*bd(4,1)
       xxl=xm*xprib+xb
       xlx=xxl*dsin(rib(i,9)*pi/180.)
       xly=xxl*dcos(rib(i,9)*pi/180.)
       end if

       u(i,j,19)=u(i,j,19)+xlx
       w(I,j,19)=w(i,j,19)-xly

       end if
    
       end do
       end do


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      12.4+ Redefineix punts ancoratge per a parapents tipus ss
c      Atencio als parametres atp i kaaa
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Punts tipus 19 definits a extrados
       if (atp.eq."ss") then

       do i=0,nribss
       do j=1,rib(i,15)

c      Desa ancoratges originals a vector 20       
       u(i,j,20)=u(i,j,19)
       v(i,j,20)=v(i,j,19)
       w(i,j,20)=w(i,j,19)

c      Defineix ancoratges virtuals extrados       
       jp=anccont(i,j)

       u(i,j,19)=(x(i,jp)+x(i,jp-1))/2.
       v(i,j,19)=(y(i,jp)+y(i,jp-1))/2.
       w(i,j,19)=(z(i,jp)+z(i,jp-1))/2.

c      Activar kaaa=1 nomes al fer suspentes banda A deixar morro on es
    
       if (kaaa.eq.1) then
       u(i,1,19)=u(i,1,20)
       v(i,1,19)=v(i,1,20)
       w(i,1,19)=w(i,1,20)
       end if

c       write (*,*) "19 ss ",i,j,u(i,j,19),v(i,j,19),w(i,j,19)
c       write (*,*) "20 ds ",i,j,u(i,j,20),v(i,j,20),w(i,j,20)


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      ESPECIAL BHL-PAMPA
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c      if rib(i,56) eq 0 not rotate triangle

       if (rib(i,56).eq.0.) then
       u(i,j,19)=u(i,j,20)
       v(i,j,19)=v(i,j,20)
       w(i,j,19)=w(i,j,20)
       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      ESPECIAL BHL-PAMPA
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       end do
       end do
       
       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     12.4++ Calcula carregues a cada ancoratge
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Calcula suma de ribs i suma de pesos relatius

       rib1t=0.
       rib2t=0.
       rib3t=0.

       do i=1,nribss

       if (rib(i,55).ne.0) then
       rib1t=rib1t+rib(i,5)
       rib2t=rib2t+rib(i,55)
       rib3t=rib3t+rib(i,5)*rib(i,55)
       end if

       end do

c       write (*,*) "rib1t, rib2t ", rib1t, rib2t

c      Assigna carregues a cada ancoratge       
       do i=1,nribss

       if (rib(i,55).ne.0) then

       do j=1,rib(i,15)
       aload(i,j)=(csusl/2.)*(cdis(int(rib(i,15)),j)/100.)*
     + (rib(i,55)*rib(i,5)/rib3t)

c       write (*,*) "A ", i, j, aload(i,j)

       end do

       end if

       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     12.5 Linies d'accio de cada corda
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Important
c      zcontrol=0 geometric action points, 
c      zcontrol=1 pondered ap
c      zcontrol=2 pondered ap 
c      comprovar les divergències

c      zcontrol=0

c      Defineix punt final de la linia d'accio de cada corda

       do i=1,cordam ! For all lines

       xcorda(i,3)=0.
       ycorda(i,3)=0.
       zcorda(i,3)=0.
       corda(i,8)=0.
       xload(i)=0.

       do ii=1,slp    !For all plans

       do k=2,8,2     ! For all levels (max=4)

       do j=1,cam(ii) ! For all paths

       if (ii.eq.corda(i,1)) then

       if (corda(i,2).eq.mc(ii,j,k).and.mc(ii,j,k+1).eq.corda(i,3)) then

       if (zcontrol.eq.0) then

c      Suma de les coordenades dels ancoratges finals
       xcorda(i,3)=xcorda(i,3)+u(mc(ii,j,15),mc(ii,j,14),19)
       ycorda(i,3)=ycorda(i,3)+v(mc(ii,j,15),mc(ii,j,14),19)
       zcorda(i,3)=zcorda(i,3)+w(mc(ii,j,15),mc(ii,j,14),19)

c      Carrega total a linia i
       xload(i)=xload(i)+aload(mc(ii,j,15),mc(ii,j,14))

       end if

       if(zcontrol.eq.1) then

c      Suma coordanades ancoratges ponderades per la long de rib
       xcorda(i,3)=xcorda(i,3)+u(mc(ii,j,15),mc(ii,j,14),19)*
     + rib(corda(i,7),5)
       ycorda(i,3)=ycorda(i,3)+v(mc(ii,j,15),mc(ii,j,14),19)*
     + rib(corda(i,7),5)
       zcorda(i,3)=zcorda(i,3)+w(mc(ii,j,15),mc(ii,j,14),19)*
     + rib(corda(i,7),5)

c      Suma longitud de ribs associats a i
       corda(i,8)=corda(i,8)+rib(corda(i,7),5)

       xload(i)=xload(i)+aload(mc(ii,j,15),mc(ii,j,14))

       end if

       if(zcontrol.eq.2) then

c      Coordenades ponderades per rib i pes relatiu
       xcorda(i,3)=xcorda(i,3)+u(mc(ii,j,15),mc(ii,j,14),19)*
     + rib(corda(i,7),5)*rib(corda(i,7),55)
       ycorda(i,3)=ycorda(i,3)+v(mc(ii,j,15),mc(ii,j,14),19)*
     + rib(corda(i,7),5)*rib(corda(i,7),55)
       zcorda(i,3)=zcorda(i,3)+w(mc(ii,j,15),mc(ii,j,14),19)*
     + rib(corda(i,7),5)*rib(corda(i,7),55)

       corda(i,8)=corda(i,8)+rib(corda(i,7),5)*rib(corda(i,7),55)

       xload(i)=xload(i)+aload(mc(ii,j,15),mc(ii,j,14))

       end if


       if(zcontrol.eq.3) then

c      Coordenades ponderades pel pes
       xcorda(i,3)=xcorda(i,3)+u(mc(ii,j,15),mc(ii,j,14),19)*
     + aload(mc(ii,j,15),mc(ii,j,14))
       ycorda(i,3)=ycorda(i,3)+v(mc(ii,j,15),mc(ii,j,14),19)*
     + aload(mc(ii,j,15),mc(ii,j,14))
       zcorda(i,3)=zcorda(i,3)+w(mc(ii,j,15),mc(ii,j,14),19)*
     + aload(mc(ii,j,15),mc(ii,j,14))

       corda(i,8)=corda(i,8)+aload(mc(ii,j,15),mc(ii,j,14))

       xload(i)=xload(i)+aload(mc(ii,j,15),mc(ii,j,14))

       end if


       end if

       end if

       end do

       end do

       end do

c      Center of gravity line i
       
       if(zcontrol.eq.0) then
       xcorda(i,3)=xcorda(i,3)/float(corda(i,4))
       ycorda(i,3)=ycorda(i,3)/float(corda(i,4))
       zcorda(i,3)=zcorda(i,3)/float(corda(i,4))
       end if

       if(zcontrol.eq.1) then
       xcorda(i,3)=xcorda(i,3)/corda(i,8)
       ycorda(i,3)=ycorda(i,3)/corda(i,8)
       zcorda(i,3)=zcorda(i,3)/corda(i,8)
       end if

       if(zcontrol.eq.2) then
       xcorda(i,3)=xcorda(i,3)/corda(i,8)
       ycorda(i,3)=ycorda(i,3)/corda(i,8)
       zcorda(i,3)=zcorda(i,3)/corda(i,8)
       end if

       if(zcontrol.eq.3) then
       xcorda(i,3)=xcorda(i,3)/xload(i)
       ycorda(i,3)=ycorda(i,3)/xload(i)
       zcorda(i,3)=zcorda(i,3)/xload(i)
       end if

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      12.6 Punts inicial i final de cada corda
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      12.6.1 LEVEL 1 (risers)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=1,cordam

       if (corda(i,2).eq.1) then

c      Cordes 1 tenen l'inici a mosquetons principals
       xcorda(i,1)=xkar
       ycorda(i,1)=ykar
       zcorda(i,1)=zkar

c      Equacio parametrica de la recta que passa per P1-P3

       dist=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-
     + ycorda(i,1))**2+(zcorda(i,3)-zcorda(i,1))**2)

       cdl=(xcorda(i,3)-xcorda(i,1))/dist
       cdm=(ycorda(i,3)-ycorda(i,1))/dist
       cdn=(zcorda(i,3)-zcorda(i,1))/dist

c      Parametre necesari a la distancia objectiu

       t=clengr/(sqrt(cdl*cdl+cdm*cdm+cdn*cdn))

c      Punt P2 amb equacio parametrica
       xcorda(i,2)=xcorda(i,1)+cdl*t
       ycorda(i,2)=ycorda(i,1)+cdm*t
       zcorda(i,2)=zcorda(i,1)+cdn*t

       ii=corda(i,1)

       x1line(ii,1,corda(i,3))=xcorda(i,1)
       y1line(ii,1,corda(i,3))=ycorda(i,1)
       z1line(ii,1,corda(i,3))=zcorda(i,1)
       x2line(ii,1,corda(i,3))=xcorda(i,2)
       y2line(ii,1,corda(i,3))=ycorda(i,2)
       z2line(ii,1,corda(i,3))=zcorda(i,2)

c      comprobacio

       disto=sqrt((xcorda(i,2)-xcorda(i,1))**2+(ycorda(i,2)-
     + ycorda(i,1))**2+(zcorda(i,2)-zcorda(i,1))**2)

       end if

       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      12.6.2 LEVEL 2
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=1,cordam

       if (corda(i,2).eq.2) then

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      LEVEL 2 Si només dos nivells
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (corda(i,5).eq.2) then !directe a l'ancoratge

       xcorda(i,1)=x2line(corda(i,1),1,1)
       ycorda(i,1)=y2line(corda(i,1),1,1)
       zcorda(i,1)=z2line(corda(i,1),1,1)
      
       xcorda(i,2)=u(corda(i,7),corda(i,6),19)
       ycorda(i,2)=v(corda(i,7),corda(i,6),19)
       zcorda(i,2)=w(corda(i,7),corda(i,6),19)

       ii=corda(i,1)

       x1line(ii,2,corda(i,3))=xcorda(i,1)
       y1line(ii,2,corda(i,3))=ycorda(i,1)
       z1line(ii,2,corda(i,3))=zcorda(i,1)
       x2line(ii,2,corda(i,3))=xcorda(i,2)
       y2line(ii,2,corda(i,3))=ycorda(i,2)
       z2line(ii,2,corda(i,3))=zcorda(i,2)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Correccions necessaries a parapents ss (a nivell 2)
c      Calcula angles de gir phi0=phi1-phi2 a aplicar a triangles ss
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Per que es perd el valor de pi?
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c       pi=4.*datan(1.)

       if (atp.eq."ss") then

       phi1(ii,2,corda(i,3))=(180./pi)*datan((x2line(ii,2,corda(i,3))-
     + x1line(ii,2,corda(i,3)))/(z1line(ii,2,corda(i,3))-
     + z2line(ii,2,corda(i,3))))

       if (kaaa.eq.1.and.corda(i,6).eq.1) then
       phi2(ii,2,corda(i,3))=0.
       else
       phi2(ii,2,corda(i,3))=(180./pi)*datan((u(corda(i,7),corda(i,6),19
     + )-u(corda(i,7),corda(i,6),20))/(w(corda(i,7),corda(i,6),20
     + )-w(corda(i,7),corda(i,6),19)))
       end if

       phi2(ii,2,corda(i,3))=rib(corda(i,7),9)

       phi0(ii,2,corda(i,3))=phi1(ii,2,corda(i,3))-phi2(ii,2,corda(i,3))

       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       
       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      LEVEL 2 Si tres nivells
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (corda(i,5).eq.3) then ! tres nivells

       xcorda(i,1)=x2line(corda(i,1),1,1)
       ycorda(i,1)=y2line(corda(i,1),1,1)
       zcorda(i,1)=z2line(corda(i,1),1,1)
                    
       dist=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-
     + ycorda(i,1))**2+(zcorda(i,3)-zcorda(i,1))**2)

       cdl=(xcorda(i,3)-xcorda(i,1))/dist
       cdm=(ycorda(i,3)-ycorda(i,1))/dist
       cdn=(zcorda(i,3)-zcorda(i,1))/dist

c      Parametre necesari a la distancia objectiu

       d13=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-ycorda(i,1))
     + **2+(zcorda(i,3)-zcorda(i,1))**2)
       
       t=(d13-raml(3,3))/(sqrt(cdl*cdl+cdm*cdm+cdn*cdn))

c      Punt P2 amb equacio parametrica
       xcorda(i,2)=xcorda(i,1)+cdl*t
       ycorda(i,2)=ycorda(i,1)+cdm*t
       zcorda(i,2)=zcorda(i,1)+cdn*t

       ii=corda(i,1)

       x1line(ii,2,corda(i,3))=xcorda(i,1)
       y1line(ii,2,corda(i,3))=ycorda(i,1)
       z1line(ii,2,corda(i,3))=zcorda(i,1)
       x2line(ii,2,corda(i,3))=xcorda(i,2)
       y2line(ii,2,corda(i,3))=ycorda(i,2)
       z2line(ii,2,corda(i,3))=zcorda(i,2)
       
       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      LEVEL 2 Si quatre nivells
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (corda(i,5).eq.4) then ! Quatre nivells

       xcorda(i,1)=x2line(corda(i,1),1,1)
       ycorda(i,1)=y2line(corda(i,1),1,1)
       zcorda(i,1)=z2line(corda(i,1),1,1)
                    
       dist=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-
     + ycorda(i,1))**2+(zcorda(i,3)-zcorda(i,1))**2)

       cdl=(xcorda(i,3)-xcorda(i,1))/dist
       cdm=(ycorda(i,3)-ycorda(i,1))/dist
       cdn=(zcorda(i,3)-zcorda(i,1))/dist

c      Parametre necesari a la distancia objectiu

       d13=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-ycorda(i,1))
     + **2+(zcorda(i,3)-zcorda(i,1))**2)
       
       t=(d13-raml(4,3))/(sqrt(cdl*cdl+cdm*cdm+cdn*cdn))

c      Punt P2 amb equacio parametrica
       xcorda(i,2)=xcorda(i,1)+cdl*t
       ycorda(i,2)=ycorda(i,1)+cdm*t
       zcorda(i,2)=zcorda(i,1)+cdn*t

       ii=corda(i,1)

       x1line(ii,2,corda(i,3))=xcorda(i,1)
       y1line(ii,2,corda(i,3))=ycorda(i,1)
       z1line(ii,2,corda(i,3))=zcorda(i,1)
       x2line(ii,2,corda(i,3))=xcorda(i,2)
       y2line(ii,2,corda(i,3))=ycorda(i,2)
       z2line(ii,2,corda(i,3))=zcorda(i,2)

       end if

       end if

       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      12.6.3 LEVEL 3
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Inici al final de les cordes 2

       do i=1,cordam

       if (corda(i,2).eq.3) then

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Si només 3 nivells
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (corda(i,5).eq.3) then !directe a l'ancoratge

c      Explora mc i troba quin origen emprar
       do kk=1,slp
       do k=1,cam(kk)

       if (corda(i,2).eq.mc(kk,k,6).and.mc(kk,k,7).eq.corda(i,3)) then

       comp1(kk)=mc(kk,k,4)
       comp2(kk)=mc(kk,k,5)

       end if

       end do
       
       end do

c      Origen
       xcorda(i,1)=x2line(corda(i,1),2,int(comp2(corda(i,1))))
       ycorda(i,1)=y2line(corda(i,1),2,int(comp2(corda(i,1))))
       zcorda(i,1)=z2line(corda(i,1),2,int(comp2(corda(i,1))))

c      Final
       xcorda(i,2)=u(corda(i,7),corda(i,6),19)
       ycorda(i,2)=v(corda(i,7),corda(i,6),19)
       zcorda(i,2)=w(corda(i,7),corda(i,6),19)

       ii=corda(i,1)

       x1line(ii,3,corda(i,3))=xcorda(i,1)
       y1line(ii,3,corda(i,3))=ycorda(i,1)
       z1line(ii,3,corda(i,3))=zcorda(i,1)
       x2line(ii,3,corda(i,3))=xcorda(i,2)
       y2line(ii,3,corda(i,3))=ycorda(i,2)
       z2line(ii,3,corda(i,3))=zcorda(i,2)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Correccions necessaries a parapents ss (a nivell 3)
c      Calcula angles de gir phi0=phi1-phi2 a aplicar a triangles ss
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Per que es perd el valor de pi?
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c       pi=4.*datan(1.)

       if (atp.eq."ss") then

       phi1(ii,3,corda(i,3))=(180./pi)*datan((x2line(ii,3,corda(i,3))-
     + x1line(ii,3,corda(i,3)))/(z1line(ii,3,corda(i,3))-
     + z2line(ii,3,corda(i,3))))

       if (kaaa.eq.1.and.corda(i,6).eq.1) then
       phi2(ii,3,corda(i,3))=0.
       else
       phi2(ii,3,corda(i,3))=(180./pi)*datan((u(corda(i,7),corda(i,6),19
     + )-u(corda(i,7),corda(i,6),20))/(w(corda(i,7),corda(i,6),20
     + )-w(corda(i,7),corda(i,6),19)))
       end if

       phi2(ii,3,corda(i,3))=rib(corda(i,7),9)

       phi0(ii,3,corda(i,3))=phi1(ii,3,corda(i,3))-phi2(ii,3,corda(i,3))

c       write (*,*) ii, corda(i,2), corda(i,3), "phi0= ", 
c     + phi0(ii,3,corda(i,3))

c       write (*,*) "girs ",i,corda(i,1),corda(i,3),phi1(ii,4,corda(i,3))
c     + ,phi2(ii,4,corda(i,3)),phi0(ii,4,corda(i,3))

c      Fi angles de gir

       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       
       end if

c      Si hi ha quatre nivells
       if (corda(i,5).eq.4) then

c      Explora mc i troba quin origen emprar
       do kk=1,slp
       do k=1,cam(kk)

       if (corda(i,2).eq.mc(kk,k,6).and.mc(kk,k,7).eq.corda(i,3)) then

       comp1(kk)=mc(kk,k,4)
       comp2(kk)=mc(kk,k,5)

       end if

       end do
       
       end do

c      Origen
       xcorda(i,1)=x2line(corda(i,1),2,int(comp2(corda(i,1))))
       ycorda(i,1)=y2line(corda(i,1),2,int(comp2(corda(i,1))))
       zcorda(i,1)=z2line(corda(i,1),2,int(comp2(corda(i,1))))

       dist=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-
     + ycorda(i,1))**2+(zcorda(i,3)-zcorda(i,1))**2)

       cdl=(xcorda(i,3)-xcorda(i,1))/dist
       cdm=(ycorda(i,3)-ycorda(i,1))/dist
       cdn=(zcorda(i,3)-zcorda(i,1))/dist

c      Parametre necesari a la distancia objectiu

       d13=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-ycorda(i,1))
     + **2+(zcorda(i,3)-zcorda(i,1))**2)
       
c       t=(raml(4,4)-dl3)/(sqrt(cdl*cdl+cdm*cdm+cdn*cdn))
        
        t=(raml(4,3)-raml(4,4))/(sqrt(cdl*cdl+cdm*cdm+cdn*cdn))

c      Punt P2 amb equacio parametrica
       xcorda(i,2)=xcorda(i,1)+cdl*t
       ycorda(i,2)=ycorda(i,1)+cdm*t
       zcorda(i,2)=zcorda(i,1)+cdn*t

       ii=corda(i,1)

       x1line(ii,3,corda(i,3))=xcorda(i,1)
       y1line(ii,3,corda(i,3))=ycorda(i,1)
       z1line(ii,3,corda(i,3))=zcorda(i,1)
       x2line(ii,3,corda(i,3))=xcorda(i,2)
       y2line(ii,3,corda(i,3))=ycorda(i,2)
       z2line(ii,3,corda(i,3))=zcorda(i,2)
       
       end if

       end if

       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     12.6.4 LEVEL 4
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Inici al final de les cordes 3

       do i=1,cordam

       if (corda(i,2).eq.4) then

       if (corda(i,5).eq.4) then !directe a l'ancoratge

c      Explora mc i troba quin origen emprar
       do kk=1,slp
       do k=1,cam(kk)

       if (corda(i,2).eq.mc(kk,k,8).and.mc(kk,k,9).eq.corda(i,3)) then

       comp1(kk)=mc(kk,k,6)
       comp2(kk)=mc(kk,k,7)

       end if

       end do
       
       end do

c      Origen
       xcorda(i,1)=x2line(corda(i,1),3,int(comp2(corda(i,1))))
       ycorda(i,1)=y2line(corda(i,1),3,int(comp2(corda(i,1))))
       zcorda(i,1)=z2line(corda(i,1),3,int(comp2(corda(i,1))))

c      Final als ancoratges (parapents ds)
       xcorda(i,2)=u(corda(i,7),corda(i,6),19)
       ycorda(i,2)=v(corda(i,7),corda(i,6),19)
       zcorda(i,2)=w(corda(i,7),corda(i,6),19)

       ii=corda(i,1)

       x1line(ii,4,corda(i,3))=xcorda(i,1)
       y1line(ii,4,corda(i,3))=ycorda(i,1)
       z1line(ii,4,corda(i,3))=zcorda(i,1)
       x2line(ii,4,corda(i,3))=xcorda(i,2)
       y2line(ii,4,corda(i,3))=ycorda(i,2)
       z2line(ii,4,corda(i,3))=zcorda(i,2)


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Correccions necessaries a parapents ss (a nivell 4)
c      Calcula angles de gir phi0=phi1-phi2 a aplicar a triangles ss
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Per que es perd el valor de pi?
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c       pi=4.*datan(1.)

       if (atp.eq."ss") then

       phi1(ii,4,corda(i,3))=(180./pi)*datan((x2line(ii,4,corda(i,3))-
     + x1line(ii,4,corda(i,3)))/(z1line(ii,4,corda(i,3))-
     + z2line(ii,4,corda(i,3))))

       if (kaaa.eq.1.and.corda(i,6).eq.1) then
       phi2(ii,4,corda(i,3))=0.
       else
       phi2(ii,4,corda(i,3))=(180./pi)*datan((u(corda(i,7),corda(i,6),19
     + )-u(corda(i,7),corda(i,6),20))/(w(corda(i,7),corda(i,6),20
     + )-w(corda(i,7),corda(i,6),19)))
       end if

       phi2(ii,4,corda(i,3))=rib(corda(i,7),9)

       phi0(ii,4,corda(i,3))=phi1(ii,4,corda(i,3))-phi2(ii,4,corda(i,3))

c       write (*,*) "girs ",i,corda(i,1),corda(i,3),phi1(ii,4,corda(i,3))
c     + ,phi2(ii,4,corda(i,3)),phi0(ii,4,corda(i,3))

c      Fi angles de gir

       end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       
       end if

       end if

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     12.7 Gir dels triangles parapents ss
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (atp.eq."ss") then

c      Verify thickness of last rib (escrit ja a 11.3)
       
       xsum=0.
       ic=0
       i=nribss
       do j=1,np(i,1)
       xsum=xsum+abs(v(i,j,3))
       end do
       if (xsum.ne.0.0) then
       ic=1
       end if

c      Calcula punt 4 situat al triangle 1-2-3

c      Recorre punts de l'extrados

       do i=1,cordam

c      No estabilo
       if (corda(i,7).ne.nribss*float(ic-1)*float(ic-1)) then

       ii=corda(i,1)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Gir cordes en quart nivell
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Gir en cordes de tercer nivell
       if (corda(i,2).eq.4) then

c      write (*,*) "corda(i,2)=", corda(i,2), corda(i,5)

       if (corda(i,5).eq.4) then !directe a l'ancoratge

       jp=anccont(corda(i,7),corda(i,6))

       xpt1=x(corda(i,7),jp-3)
       ypt1=y(corda(i,7),jp-3)
       zpt1=z(corda(i,7),jp-3)

       xpt2=x(corda(i,7),jp+3)
       ypt2=y(corda(i,7),jp+3)
       zpt2=z(corda(i,7),jp+3)

       xpt3=u(corda(i,7),corda(i,6),20)
       ypt3=v(corda(i,7),corda(i,6),20)
       zpt3=w(corda(i,7),corda(i,6),20)

c      Dibuixa els triangles a girar

       call line3d(xpt1,ypt1,zpt1,xpt2,ypt2,zpt2,1)
       call line3d(xpt1,ypt1,zpt1,xpt3,ypt3,zpt3,1)
       call line3d(xpt2,ypt2,zpt2,xpt3,ypt3,zpt3,1)

c      Calcula punt 4

c      Cosinus directors rectes 2-1 i 3-1

       xd21=sqrt((xpt1-xpt2)**2.+(ypt1-ypt2)**2.+(zpt1-zpt2)**2.)
       xd31=sqrt((xpt1-xpt3)**2.+(ypt1-ypt3)**2.+(zpt1-zpt3)**2.)
       xd32=sqrt((xpt2-xpt3)**2.+(ypt2-ypt3)**2.+(zpt2-zpt3)**2.)

       cl21=(xpt1-xpt2)/xd21
       cm21=(ypt1-ypt2)/xd21
       cn21=(zpt1-zpt2)/xd21

       cl31=(xpt1-xpt3)/xd31
       cm31=(ypt1-ypt3)/xd31
       cn31=(zpt1-zpt3)/xd31

c      Punt 4 a recta que passa per 1-2 parametrica xt

       xt=xd31*(cl21*cl21+cm21*cm21+cn21*cn21)*
     + (cl21*cl31+cm21*cm31+cn21*cn31)

       xpt4=xpt1-cl21*xt
       ypt4=ypt1-cm21*xt
       zpt4=zpt1-cn21*xt

       call line3d(xpt4,ypt4,zpt4,xpt3,ypt3,zpt3,7)

       xd41=sqrt((xpt1-xpt4)**2.+(ypt1-ypt4)**2.+(zpt1-zpt4)**2.)
      
       cl41=(xpt1-xpt4)/xd41
       cm41=(ypt1-ypt4)/xd41
       cn41=(zpt1-zpt4)/xd41

       xd43=sqrt((xpt3-xpt4)**2.+(ypt3-ypt4)**2.+(zpt3-zpt4)**2.)

       cl43=(xpt3-xpt4)/xd43
       cm43=(ypt3-ypt4)/xd43
       cn43=(zpt3-zpt4)/xd43

c      Planol 1-2-3 (determinant)

       A1=(ypt2-ypt1)*(zpt3-zpt1)-(zpt2-zpt1)*(ypt3-ypt1)
       B1=(zpt2-zpt1)*(xpt3-xpt1)-(xpt2-xpt1)*(zpt3-zpt1)
       C1=(xpt2-xpt1)*(ypt3-ypt1)-(ypt2-ypt1)*(xpt3-xpt1)
       D1=-A1*xpt1-B1*ypt1-C1*zpt1

c      Punt 5 situat a la recta normal a 1-2-3 per 4

       xpt5=xpt4+A1*0.1
       ypt5=ypt4+B1*0.1
       zpt5=zpt4+C1*0.1

c      Eix normal al pla 1-2-3
c       call line3d(xpt4,ypt4,zpt4,xpt5,ypt5,zpt5,1)

       xd45=sqrt((xpt5-xpt4)**2.+(ypt5-ypt4)**2.+(zpt5-zpt4)**2.)

       cl45=(xpt5-xpt4)/xd45
       cm45=(ypt5-ypt4)/xd45
       cn45=(zpt5-zpt4)/xd45

c       phi0(ii,corda(i,2),corda(i,3))=0.

       xptp6=xd43*dsin((pi/180.)*phi0(ii,4,corda(i,3)))
       yptp6=0.
       zptp6=-xd43*dcos((pi/180.)*phi0(ii,4,corda(i,3)))

c      "-" sign before cn41 in ypt6 be aware, review!!! however works!

       xpt6=cl45*xptp6+cm45*yptp6-cn45*zptp6+xpt4
       ypt6=cl41*xptp6+cm41*yptp6+cn41*zptp6+ypt4
       zpt6=cl43*xptp6+cm43*yptp6-cn43*zptp6+zpt4

c      Truc per ajustar posicio Y !!!!!!!!!!!!!!!!!
c      Funciona força be
c      REVISAR !!!!!!!!!!!!!!!!!!!!!!!!!!!!
c      ypt6=ypt3

c       write (*,*) "ypt6 ypt4 phi0 ", ypt6, ypt4, 
c     + phi0(ii,4,corda(i,3))

c      Segona definició, per recta perpendicular al pla 1-2-3
 
       xt=xd43*dcos((pi/180.)*phi0(ii,4,corda(i,3)))
       xpt7=xpt4+cl43*xt
       ypt7=ypt4+cm43*xt
       zpt7=zpt4+cn43*xt
c       call line3d(0.,0.,0.,xpt7,ypt7,zpt7,5)

       xt=(((xd43*xd43*(dsin((pi/180.)*phi0(ii,4,corda(i,3)))))/
     + (sqrt(A1*A1+B1*B1+C1*C1))))

c       write (*,*) "xt ", xt

c       xpt6=xpt7+A1*xt
c       ypt6=ypt7+B1*xt
c       zpt6=zpt7+C1*xt

c      Dibuixa triangles girats

       if (kaaa.eq.0.or.corda(i,6).ne.1) then
       call line3d(xpt3,ypt3,zpt3,xpt6,ypt6,zpt6,1)
       call line3d(xpt1,ypt1,zpt1,xpt6,ypt6,zpt6,2)
       call line3d(xpt2,ypt2,zpt2,xpt6,ypt6,zpt6,2)
       end if

       u(corda(i,7),corda(i,6),19)=xpt6
       v(corda(i,7),corda(i,6),19)=ypt6
       w(corda(i,7),corda(i,6),19)=zpt6

c      No gira b.a. si kaaa=1

       if (kaaa.eq.1.and.corda(i,6).eq.1) then
       u(corda(i,7),corda(i,6),19)=u(corda(i,7),corda(i,6),20)
       v(corda(i,7),corda(i,6),19)=v(corda(i,7),corda(i,6),20)
       w(corda(i,7),corda(i,6),19)=w(corda(i,7),corda(i,6),20)
       end if


       end if

       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Gir cordes en tercer nivell
c      opcionalment es podria fer servir rutina anterior amb corda(i,2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Gir en cordes de tercer nivell
       if (corda(i,2).eq.3) then

c      write (*,*) "corda(i,2)=", corda(i,2), corda(i,5)

       if (corda(i,5).eq.3) then !directe a l'ancoratge

       jp=anccont(corda(i,7),corda(i,6))

       xpt1=x(corda(i,7),jp-3)
       ypt1=y(corda(i,7),jp-3)
       zpt1=z(corda(i,7),jp-3)

       xpt2=x(corda(i,7),jp+3)
       ypt2=y(corda(i,7),jp+3)
       zpt2=z(corda(i,7),jp+3)

       xpt3=u(corda(i,7),corda(i,6),20)
       ypt3=v(corda(i,7),corda(i,6),20)
       zpt3=w(corda(i,7),corda(i,6),20)

c      Dibuixa els triangles a girar

       call line3d(xpt1,ypt1,zpt1,xpt2,ypt2,zpt2,1)
       call line3d(xpt1,ypt1,zpt1,xpt3,ypt3,zpt3,1)
       call line3d(xpt2,ypt2,zpt2,xpt3,ypt3,zpt3,1)

c      Calcula punt 4

c      Cosinus directors rectes 2-1 i 3-1

       xd21=sqrt((xpt1-xpt2)**2.+(ypt1-ypt2)**2.+(zpt1-zpt2)**2.)
       xd31=sqrt((xpt1-xpt3)**2.+(ypt1-ypt3)**2.+(zpt1-zpt3)**2.)
       xd32=sqrt((xpt2-xpt3)**2.+(ypt2-ypt3)**2.+(zpt2-zpt3)**2.)

       cl21=(xpt1-xpt2)/xd21
       cm21=(ypt1-ypt2)/xd21
       cn21=(zpt1-zpt2)/xd21

       cl31=(xpt1-xpt3)/xd31
       cm31=(ypt1-ypt3)/xd31
       cn31=(zpt1-zpt3)/xd31

c      Punt 4 a recta que passa per 1-2 parametrica xt

       xt=xd31*(cl21*cl21+cm21*cm21+cn21*cn21)*
     + (cl21*cl31+cm21*cm31+cn21*cn31)

       xpt4=xpt1-cl21*xt
       ypt4=ypt1-cm21*xt
       zpt4=zpt1-cn21*xt

       call line3d(xpt4,ypt4,zpt4,xpt3,ypt3,zpt3,7)

       xd41=sqrt((xpt1-xpt4)**2.+(ypt1-ypt4)**2.+(zpt1-zpt4)**2.)
       xd43=sqrt((xpt3-xpt4)**2.+(ypt3-ypt4)**2.+(zpt3-zpt4)**2.)

       cl43=(xpt3-xpt4)/xd43
       cm43=(ypt3-ypt4)/xd43
       cn43=(zpt3-zpt4)/xd43
      
c      Planol 1-2-3 (determinant)

       A1=(ypt2-ypt1)*(zpt3-zpt1)-(zpt2-zpt1)*(ypt3-ypt1)
       B1=(zpt2-zpt1)*(xpt3-xpt1)-(xpt2-xpt1)*(zpt3-zpt1)
       C1=(xpt2-xpt1)*(ypt3-ypt1)-(ypt2-ypt1)*(xpt3-xpt1)
       D1=-A1*xpt1-B1*ypt1-C1*zpt1

c      Punt 5 situat a la recta normal a 1-2-3 per 4

       xpt5=xpt4+A1*1.
       ypt5=ypt4+B1*1.
       zpt5=zpt4+C1*1.

c       call line3d(xpt4,ypt4,zpt4,xpt5,ypt5,zpt5,4)

       xd45=sqrt((xpt5-xpt4)**2.+(ypt5-ypt4)**2.+(zpt5-zpt4)**2.)

       cl45=(xpt5-xpt4)/xd45
       cm45=(ypt5-ypt4)/xd45
       cn45=(zpt5-zpt4)/xd45

c      Transformacio de coordenades per traslacio i rotacio

       xptp6=xd43*dsin((pi/180.)*phi0(ii,3,corda(i,3)))
       yptp6=0.
       zptp6=xd43*dcos((pi/180.)*phi0(ii,3,corda(i,3)))

       xpt6=cl45*xptp6+cm45*yptp6+cn45*zptp6+xpt4
       ypt6=cl21*xptp6+cm21*yptp6-cn21*zptp6+ypt4
       zpt6=cl43*xptp6+cm43*yptp6+cn43*zptp6+zpt4


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      ESPECIAL BHL-PAMPA
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c       iv=corda(i,7)
c       if (iv.eq.0.or.iv.eq.1.or.iv.eq.4.or.iv.eq.5.or.iv.eq.8.or.
c     + iv.eq.9) then
c       xpt6=u(corda(i,7),corda(i,6),19)
c       ypt6=v(corda(i,7),corda(i,6),19)
c       zpt6=w(corda(i,7),corda(i,6),19)
c
c       end if

       iv=corda(i,7)
       if (rib(iv,56).eq.0.) then
       xpt6=u(corda(i,7),corda(i,6),19)
       ypt6=v(corda(i,7),corda(i,6),19)
       zpt6=w(corda(i,7),corda(i,6),19)
       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      ESPECIAL BHL-PAMPA
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


c      Dibuixa triangles girats

       if (kaaa.eq.0.or.corda(i,6).ne.1) then
       call line3d(xpt3,ypt3,zpt3,xpt6,ypt6,zpt6,1)
       call line3d(xpt1,ypt1,zpt1,xpt6,ypt6,zpt6,2)
       call line3d(xpt2,ypt2,zpt2,xpt6,ypt6,zpt6,2)
       end if

       u(corda(i,7),corda(i,6),19)=xpt6
       v(corda(i,7),corda(i,6),19)=ypt6
       w(corda(i,7),corda(i,6),19)=zpt6

c      No gira b.a. si kaaa=1

       if (kaaa.eq.1.and.corda(i,6).eq.1) then
       u(corda(i,7),corda(i,6),19)=u(corda(i,7),corda(i,6),20)
       v(corda(i,7),corda(i,6),19)=v(corda(i,7),corda(i,6),20)
       w(corda(i,7),corda(i,6),19)=w(corda(i,7),corda(i,6),20)
       end if


       end if

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       end if

       end do

       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     12.8 Longituds de les cordes
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=1,cordam

       xx2=x2line(corda(i,1),corda(i,2),corda(i,3))
       xx1=x1line(corda(i,1),corda(i,2),corda(i,3))
       yy2=y2line(corda(i,1),corda(i,2),corda(i,3))
       yy1=y1line(corda(i,1),corda(i,2),corda(i,3))
       zz2=z2line(corda(i,1),corda(i,2),corda(i,3))
       zz1=z1line(corda(i,1),corda(i,2),corda(i,3))

c      Si parapent ss actualitza posicio ancoratges
       if (atp.eq."ss") then

c      Actualitza nivell 4
       if (corda(i,2).eq.4.and.corda(i,5).eq.4) then

       xx2=u(corda(i,7),corda(i,6),19)
       yy2=v(corda(i,7),corda(i,6),19)
       zz2=w(corda(i,7),corda(i,6),19)

       x2line(corda(i,1),corda(i,2),corda(i,3))=xx2
       y2line(corda(i,1),corda(i,2),corda(i,3))=yy2
       z2line(corda(i,1),corda(i,2),corda(i,3))=zz2

       end if     

c      Actualitza nivell 3
       if (corda(i,2).eq.3.and.corda(i,5).eq.3) then

       xx2=u(corda(i,7),corda(i,6),19)
       yy2=v(corda(i,7),corda(i,6),19)
       zz2=w(corda(i,7),corda(i,6),19)

       x2line(corda(i,1),corda(i,2),corda(i,3))=xx2
       y2line(corda(i,1),corda(i,2),corda(i,3))=yy2
       z2line(corda(i,1),corda(i,2),corda(i,3))=zz2

       end if     

c      Actualitza nivell 2
       if (corda(i,2).eq.2.and.corda(i,5).eq.2) then

       xx2=u(corda(i,7),corda(i,6),19)
       yy2=v(corda(i,7),corda(i,6),19)
       zz2=w(corda(i,7),corda(i,6),19)

       x2line(corda(i,1),corda(i,2),corda(i,3))=xx2
       y2line(corda(i,1),corda(i,2),corda(i,3))=yy2
       z2line(corda(i,1),corda(i,2),corda(i,3))=zz2

       end if

       end if

       xline(i)=sqrt((xx2-xx1)**2+(yy2-yy1)**2+(zz2-zz1)**2)
       xline2(i)=sqrt((xcorda(i,2)-xcorda(i,1))**2.+
     + (ycorda(i,2)-ycorda(i,1))**2.+(zcorda(i,2)-zcorda(i,1))**2.)

c      write (*,*) "xline, xline2 ",i,xline(i),xline2(i)

c      write (*,*) "loads ",i, xline(i), xload(i)

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     12.9 Correccions elastiques
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c       write(*,*) "i, xline(i), corda(i,1), corda(i,2), csus(corda(i,1),
c     + corda(i,2)), xload(i), xlide(i)"

       cttt2=0.
       cttt3=0.
       cttt4=0.

       do i=1,cordam

       xlide(i)=xline(i)*(xload(i)/10.)*csus(corda(i,1),corda(i,2))/100.

       if (corda(i,2).eq.1) then
       xlide(i)=0.
       end if

       xlifi(i)=xline(i)-xlide(i)

       if (corda(i,2).eq.2) then
       cttt2=cttt2+xload(i)
       end if

       if (corda(i,2).eq.3) then
       cttt3=cttt3+xload(i)
       end if

       if (corda(i,2).eq.4) then
       cttt4=cttt4+xload(i)
       end if

       end do

c       write (*,*) "Carrega total: ", cttt2*2., cttt3*2., cttt4*2.

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     12.10 Dibuixar cordes 2D
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       corda1=cordam

       do i=1,corda1

       x0=(1260.-160.)*xkf
       y0=1800.*xkf

       x00=1260.*xkf*float(corda(i,1)-1)

c      Colors
       if (corda(i,1).eq.1) then
       icc=1 ! line color
       end if
       if (corda(i,1).eq.2) then
       icc=30 ! line color
       end if
       if (corda(i,1).eq.3) then
       icc=3 ! line color
       end if
       if (corda(i,1).eq.4) then
       icc=4 ! line color
       end if
       if (corda(i,1).eq.5) then
       icc=5 ! line color
       end if
       if (corda(i,1).eq.6) then
       icc=6 ! line color
       end if

       call line(x1line(corda(i,1),corda(i,2),corda(i,3))+x0+x00,
     + z1line(corda(i,1),corda(i,2),corda(i,3))+y0,
     + x2line(corda(i,1),corda(i,2),corda(i,3))+x0+x00,
     + z2line(corda(i,1),corda(i,2),corda(i,3))+y0,icc)

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      14. BRAKE CALCULUS
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      14.2 Identifica les cordes a calcular
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       ic1=cordam
       ic2=1

       ii=slp+1 ! Pla de frens

       do k=2,8,2 ! Explora fins 4 nivells
       
       do j=1,cam(ii)-1 ! Itera en camins de cada pla

       a=float(mc(ii,j,k))
       b=float(mc(ii,j,k+1))
       aa=float(mc(ii,j+1,k))
       bb=float(mc(ii,j+1,k+1))

       if (a.ne.0..and.b.ne.0.) then ! saltar cordes 0 0

c      Mentre la corda sigui igual augmentar comptador
       if (a.eq.aa.and.b.eq.bb) then

       ic2=ic2+1 ! comptabilitza cordes iguals

c      Si arribem a final del camÃ­ comptabilitzar la corda
       if (j.eq.cam(ii)-1) then

       ic1=ic1+1

c       write (*,*) "corda ", ic1, ic2, " = ", mc(ii,j,k),mc(ii,j,k+1)

       corda(ic1,1)=ii                    !planol
       corda(ic1,2)=mc(ii,j+1,k)          !nivell
       corda(ic1,3)=mc(ii,j+1,k+1)        !ordre
       corda(ic1,4)=ic2                   !punts d'acciÃ³
       corda(ic1,5)=mc(ii,j+1,1)          !ramificacions del camÃ­
       corda(ic1,6)=mc(ii,j+1,14)         !final row
       corda(ic1,7)=mc(ii,j+1,15)         !final rib
       
       ic2=1

       end if

       end if

c      Si canvia la corda al mateix nivell
       if (a.ne.aa.or.b.ne.bb) then

       ic1=ic1+1

c       write (*,*) "corda ", ic1, ic2, " = ", mc(ii,j,k),mc(ii,j,k+1)

       corda(ic1,1)=ii                  !planol
       corda(ic1,2)=mc(ii,j,k)          !nivell
       corda(ic1,3)=mc(ii,j,k+1)        !ordre
       corda(ic1,4)=ic2                 !punts d'acciÃ³
       corda(ic1,5)=mc(ii,j,1)          !ramificacions del camÃ­
       corda(ic1,6)=mc(ii,j,14)         !final row
       corda(ic1,7)=mc(ii,j,15)         !final rib
       
       ic2=1

       end if

c      Si arribem a l'ultima linia i no es zero
       if (j.eq.cam(ii)-1) then

       a=float(mc(ii,j,k))
       b=float(mc(ii,j,k+1))
       aa=float(mc(ii,j+1,k))
       bb=float(mc(ii,j+1,k+1))

       if ((a.ne.aa.or.b.ne.bb).and.(aa.ne.0..and.bb.ne.0.)) then

       ic1=ic1+1

c       write (*,*) "corda ",ic1,ic2," = ", mc(ii,j+1,k),mc(ii,j+1,k+1)

       corda(ic1,1)=ii                    !planol
       corda(ic1,2)=mc(ii,j+1,k)          !nivell
       corda(ic1,3)=mc(ii,j+1,k+1)        !ordre
       corda(ic1,4)=ic2                   !punts d'acciÃ³
       corda(ic1,5)=mc(ii,j+1,1)          !ramificacions del camÃ­
       corda(ic1,6)=mc(ii,j+1,14)         !final row
       corda(ic1,7)=mc(ii,j+1,15)         !final rib
       
       ic2=1

       end if

       end if

       end if

       end do
       end do

       cordat=ic1 ! maxim nombre de cordes inclos les de fre

c      Escriu el vector corda de fre
       do i=cordam+1,cordat

c       write(*,*) "Line ",i," Plan ", corda(i,1)," Level ", corda(i,2),
c     + " Number ", corda(i,3), " Punts A ", corda(i,4)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      14.3 Compute anchor points in 3D space
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=1,nribss

       tetha=rib(i,8)*pi/180.

       do j=1,rib(i,15) ! anchor number

c      Airfoil anchor washin coordinates
       u(i,j,17)=(u(i,j,6)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + v(i,j,6)*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       v(i,j,17)=(-u(i,j,6)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + v(i,j,6)*dcos(tetha)-rib(i,50)

c      Airfoil anchor (u,v,w) espace coordinates
       u(i,j,18)=u(i,j,17)
       v(i,j,18)=v(i,j,17)*dcos(rib(i,9)*pi/180.)
       w(i,j,18)=-v(i,j,17)*dsin(rib(i,9)*pi/180.)

c      Airfoil anchor (x,y,z) absolute coordinates

c       u(i,j,19)=rib(i,6)-w(i,j,18)
c       v(i,j,19)=rib(i,3)+u(i,j,18)
c       w(i,j,19)=rib(i,7)-v(i,j,18) 
     

       end do
       end do

       do i=1,nribss
       do j=1,rib(i,15)

       end do

       end do
       
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     14.4 Linies d'accio de cada corda
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Recompute anchors of the brakes, for fractional option

       ii=slp+1
       do j=1,cam(ii)
       if (mc(ii,j,15).lt.nribss) then
       i=mc(ii,j,15)
       u(i,6,19)=(1-brake(j,2))*u(i,6,19)+brake(j,2)*u(i+1,6,19)
       v(i,6,19)=(1-brake(j,2))*v(i,6,19)+brake(j,2)*v(i+1,6,19)
       w(i,6,19)=(1-brake(j,2))*w(i,6,19)+brake(j,2)*w(i+1,6,19)
       end if
       end do

c      Linies d'acció

       do i=cordam+1,cordat ! For all lines

       xcorda(i,3)=0.
       ycorda(i,3)=0.
       zcorda(i,3)=0.

       ii=slp+1 !For brake plans

       do k=2,8,2 ! For all levels

       do j=1,cam(ii) ! For all paths

       if (ii.eq.corda(i,1)) then

       if (corda(i,2).eq.mc(ii,j,k).and.mc(ii,j,k+1).eq.corda(i,3)) then

c      Adaptat a punts d'ancoratge de frens (6)
       xcorda(i,3)=xcorda(i,3)+u(mc(ii,j,15),mc(ii,j,14),19)
       ycorda(i,3)=ycorda(i,3)+v(mc(ii,j,15),mc(ii,j,14),19)
       zcorda(i,3)=zcorda(i,3)+w(mc(ii,j,15),mc(ii,j,14),19)

       end if

       end if

       end do

       end do

c      Center of gravity line i
       xcorda(i,3)=xcorda(i,3)/float(corda(i,4))
       ycorda(i,3)=ycorda(i,3)/float(corda(i,4))
       zcorda(i,3)=zcorda(i,3)/float(corda(i,4))

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      14.5 Punts inicial i final de cada corda
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Level 1 (main brake line)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=cordam+1,cordat

       if (corda(i,2).eq.1) then

c      Frens iniciats sota maillons bandes darrera
       xcorda(i,1)=x2line(slp,1,1)
       ycorda(i,1)=y2line(slp,1,1)
       zcorda(i,1)=z2line(slp,1,1)

c      Equacio parametrica de la recta que passa per P1-P3

       dist=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-
     + ycorda(i,1))**2+(zcorda(i,3)-zcorda(i,1))**2)

       cdl=(xcorda(i,3)-xcorda(i,1))/dist
       cdm=(ycorda(i,3)-ycorda(i,1))/dist
       cdn=(zcorda(i,3)-zcorda(i,1))/dist

c      Parametre necessari a la distancia objectiu

       t=clengb/(sqrt(cdl*cdl+cdm*cdm+cdn*cdn))

c      Punt P2 amb equacio parametrica
       xcorda(i,2)=xcorda(i,1)+cdl*t
       ycorda(i,2)=ycorda(i,1)+cdm*t
       zcorda(i,2)=zcorda(i,1)+cdn*t

       ii=corda(i,1)

       x1line(ii,1,corda(i,3))=xcorda(i,1)
       y1line(ii,1,corda(i,3))=ycorda(i,1)
       z1line(ii,1,corda(i,3))=zcorda(i,1)
       x2line(ii,1,corda(i,3))=xcorda(i,2)
       y2line(ii,1,corda(i,3))=ycorda(i,2)
       z2line(ii,1,corda(i,3))=zcorda(i,2)

c      comprobacio

       disto=sqrt((xcorda(i,2)-xcorda(i,1))**2+(ycorda(i,2)-
     + ycorda(i,1))**2+(zcorda(i,2)-zcorda(i,1))**2)

       end if

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Level 2
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=cordam+1,cordat

       if (corda(i,2).eq.2) then

       if (corda(i,5).eq.2) then ! un nivell adicional


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      REVISAT 2013-05-17 !!!!!!!!!!!!!!!!!!

c      Explora mc i troba quin origen emprar
       kk=slp+1
       do k=1,cam(kk)

       if (corda(i,2).eq.mc(kk,k,4).and.mc(kk,k,5).eq.corda(i,3)) then

       comp1(kk)=mc(kk,k,2)
       comp2(kk)=mc(kk,k,3)

       end if

       end do

c      Origen
       xcorda(i,1)=x2line(corda(i,1),1,int(comp2(corda(i,1))))
       ycorda(i,1)=y2line(corda(i,1),1,int(comp2(corda(i,1))))
       zcorda(i,1)=z2line(corda(i,1),1,int(comp2(corda(i,1))))

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc




c       xcorda(i,1)=x2line(corda(i,1),corda(i,2),corda(i,3))
c       ycorda(i,1)=y2line(corda(i,1),corda(i,2),corda(i,3))
c       zcorda(i,1)=z2line(corda(i,1),corda(i,2),corda(i,3))      

       xcorda(i,2)=u(corda(i,7),corda(i,6),19)
       ycorda(i,2)=v(corda(i,7),corda(i,6),19)
       zcorda(i,2)=w(corda(i,7),corda(i,6),19)

       ii=corda(i,1)

       x1line(ii,2,corda(i,3))=xcorda(i,1)
       y1line(ii,2,corda(i,3))=ycorda(i,1)
       z1line(ii,2,corda(i,3))=zcorda(i,1)
       x2line(ii,2,corda(i,3))=xcorda(i,2)
       y2line(ii,2,corda(i,3))=ycorda(i,2)
       z2line(ii,2,corda(i,3))=zcorda(i,2)
       
       end if

       if (corda(i,5).eq.3) then ! dos nivells adicionals

c       write (*,*) ">>> ", i, corda(i,1), corda(i,2), corda(i,3) 

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      REVISAT 2013-05-03 !!!!!!!!!!!!!!!!!!

c      Explora mc i troba quin origen emprar
       kk=slp+1
       do k=1,cam(kk)

       if (corda(i,2).eq.mc(kk,k,4).and.mc(kk,k,5).eq.corda(i,3)) then

       comp1(kk)=mc(kk,k,2)
       comp2(kk)=mc(kk,k,3)

       end if

       end do

c      Origen
       xcorda(i,1)=x2line(corda(i,1),1,int(comp2(corda(i,1))))
       ycorda(i,1)=y2line(corda(i,1),1,int(comp2(corda(i,1))))
       zcorda(i,1)=z2line(corda(i,1),1,int(comp2(corda(i,1))))

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


c       write (*,*) ">>> ", xcorda(i,1), ycorda(i,1),zcorda(i,1)
                    
       dist=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-
     + ycorda(i,1))**2+(zcorda(i,3)-zcorda(i,1))**2)

       cdl=(xcorda(i,3)-xcorda(i,1))/dist
       cdm=(ycorda(i,3)-ycorda(i,1))/dist
       cdn=(zcorda(i,3)-zcorda(i,1))/dist

c      Parametre necesari a la distancia objectiu

       d13=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-ycorda(i,1))
     + **2+(zcorda(i,3)-zcorda(i,1))**2)
       
       t=(d13-raml(5,3))/(sqrt(cdl*cdl+cdm*cdm+cdn*cdn))

c      Punt P2 amb equacio parametrica
       xcorda(i,2)=xcorda(i,1)+cdl*t
       ycorda(i,2)=ycorda(i,1)+cdm*t
       zcorda(i,2)=zcorda(i,1)+cdn*t

       ii=corda(i,1)

       x1line(ii,2,corda(i,3))=xcorda(i,1)
       y1line(ii,2,corda(i,3))=ycorda(i,1)
       z1line(ii,2,corda(i,3))=zcorda(i,1)
       x2line(ii,2,corda(i,3))=xcorda(i,2)
       y2line(ii,2,corda(i,3))=ycorda(i,2)
       z2line(ii,2,corda(i,3))=zcorda(i,2)
       
       end if

       if (corda(i,5).eq.4) then ! Tres nivells adicionals

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      REVISAT 2013-05-03 !!!!!!!!!!!!!!!!!!

c      Explora mc i troba quin origen emprar
       kk=slp+1
       do k=1,cam(kk)

       if (corda(i,2).eq.mc(kk,k,4).and.mc(kk,k,5).eq.corda(i,3)) then

       comp1(kk)=mc(kk,k,2)
       comp2(kk)=mc(kk,k,3)

       end if

       end do

c      Origen
       xcorda(i,1)=x2line(corda(i,1),1,int(comp2(corda(i,1))))
       ycorda(i,1)=y2line(corda(i,1),1,int(comp2(corda(i,1))))
       zcorda(i,1)=z2line(corda(i,1),1,int(comp2(corda(i,1))))


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c       xcorda(i,1)=x2line(corda(i,1),corda(i,2),corda(i,3))
c       ycorda(i,1)=y2line(corda(i,1),corda(i,2),corda(i,3))
c       zcorda(i,1)=z2line(corda(i,1),corda(i,2),corda(i,3))
                    
       dist=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-
     + ycorda(i,1))**2+(zcorda(i,3)-zcorda(i,1))**2)

       cdl=(xcorda(i,3)-xcorda(i,1))/dist
       cdm=(ycorda(i,3)-ycorda(i,1))/dist
       cdn=(zcorda(i,3)-zcorda(i,1))/dist

c      Parametre necesari a la distancia objectiu

       d13=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-ycorda(i,1))
     + **2+(zcorda(i,3)-zcorda(i,1))**2)
       
       t=(d13-raml(6,3))/(sqrt(cdl*cdl+cdm*cdm+cdn*cdn))

c      Punt P2 amb equacio parametrica
       xcorda(i,2)=xcorda(i,1)+cdl*t
       ycorda(i,2)=ycorda(i,1)+cdm*t
       zcorda(i,2)=zcorda(i,1)+cdn*t

       ii=corda(i,1)

       x1line(ii,2,corda(i,3))=xcorda(i,1)
       y1line(ii,2,corda(i,3))=ycorda(i,1)
       z1line(ii,2,corda(i,3))=zcorda(i,1)
       x2line(ii,2,corda(i,3))=xcorda(i,2)
       y2line(ii,2,corda(i,3))=ycorda(i,2)
       z2line(ii,2,corda(i,3))=zcorda(i,2)

       end if

       end if

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Level 3
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Inici al final de les cordes 2

       do i=cordam+1,cordat

       if (corda(i,2).eq.3) then

       if (corda(i,5).eq.3) then !directe a l'ancoratge

c      Explora mc i troba quin origen emprar
       kk=slp+1
       do k=1,cam(kk)

       if (corda(i,2).eq.mc(kk,k,6).and.mc(kk,k,7).eq.corda(i,3)) then

       comp1(kk)=mc(kk,k,4)
       comp2(kk)=mc(kk,k,5)

       end if

       end do

c      Origen
       xcorda(i,1)=x2line(corda(i,1),2,int(comp2(corda(i,1))))
       ycorda(i,1)=y2line(corda(i,1),2,int(comp2(corda(i,1))))
       zcorda(i,1)=z2line(corda(i,1),2,int(comp2(corda(i,1))))

       xcorda(i,2)=u(corda(i,7),corda(i,6),19)
       ycorda(i,2)=v(corda(i,7),corda(i,6),19)
       zcorda(i,2)=w(corda(i,7),corda(i,6),19)

       ii=corda(i,1)

       x1line(ii,3,corda(i,3))=xcorda(i,1)
       y1line(ii,3,corda(i,3))=ycorda(i,1)
       z1line(ii,3,corda(i,3))=zcorda(i,1)
       x2line(ii,3,corda(i,3))=xcorda(i,2)
       y2line(ii,3,corda(i,3))=ycorda(i,2)
       z2line(ii,3,corda(i,3))=zcorda(i,2)
       
       end if

c      Si hi ha quatre nivells
       if (corda(i,5).eq.4) then

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      LEVEL 2
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc



ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      LEVEL 3
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Explora mc i troba quin origen emprar
       kk=slp+1
       do k=1,cam(kk)

       if (corda(i,2).eq.mc(kk,k,6).and.mc(kk,k,7).eq.corda(i,3)) then

       comp1(kk)=mc(kk,k,4)
       comp2(kk)=mc(kk,k,5)

       end if
       
       end do

c      Origen
       xcorda(i,1)=x2line(corda(i,1),2,int(comp2(corda(i,1))))
       ycorda(i,1)=y2line(corda(i,1),2,int(comp2(corda(i,1))))
       zcorda(i,1)=z2line(corda(i,1),2,int(comp2(corda(i,1))))

       dist=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-
     + ycorda(i,1))**2+(zcorda(i,3)-zcorda(i,1))**2)

       cdl=(xcorda(i,3)-xcorda(i,1))/dist
       cdm=(ycorda(i,3)-ycorda(i,1))/dist
       cdn=(zcorda(i,3)-zcorda(i,1))/dist

c      Parametre necesari a la distancia objectiu

       d13=sqrt((xcorda(i,3)-xcorda(i,1))**2+(ycorda(i,3)-ycorda(i,1))
     + **2+(zcorda(i,3)-zcorda(i,1))**2)
       
c       t=(raml(6,4)-dl3)/(sqrt(cdl*cdl+cdm*cdm+cdn*cdn))
       t=(raml(6,3)-raml(6,4))/(sqrt(cdl*cdl+cdm*cdm+cdn*cdn))

c      Punt P2 amb equacio parametrica
       xcorda(i,2)=xcorda(i,1)+cdl*t
       ycorda(i,2)=ycorda(i,1)+cdm*t
       zcorda(i,2)=zcorda(i,1)+cdn*t

       ii=corda(i,1)

       x1line(ii,3,corda(i,3))=xcorda(i,1)
       y1line(ii,3,corda(i,3))=ycorda(i,1)
       z1line(ii,3,corda(i,3))=zcorda(i,1)
       x2line(ii,3,corda(i,3))=xcorda(i,2)
       y2line(ii,3,corda(i,3))=ycorda(i,2)
       z2line(ii,3,corda(i,3))=zcorda(i,2)
       
       end if

       end if

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Level 4
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Inici al final de les cordes 3

       do i=cordam+1,cordat

       if (corda(i,2).eq.4) then

       if (corda(i,5).eq.4) then !directe a l'ancoratge

c      Explora mc i troba quin origen emprar
       kk=slp+1
       do k=1,cam(kk)

       if (corda(i,2).eq.mc(kk,k,8).and.mc(kk,k,9).eq.corda(i,3)) then

       comp1(kk)=mc(kk,k,6)
       comp2(kk)=mc(kk,k,7)

       end if
       
       end do

c      Origen
       xcorda(i,1)=x2line(corda(i,1),3,int(comp2(corda(i,1))))
       ycorda(i,1)=y2line(corda(i,1),3,int(comp2(corda(i,1))))
       zcorda(i,1)=z2line(corda(i,1),3,int(comp2(corda(i,1))))

       xcorda(i,2)=u(corda(i,7),corda(i,6),19)
       ycorda(i,2)=v(corda(i,7),corda(i,6),19)
       zcorda(i,2)=w(corda(i,7),corda(i,6),19)

       ii=corda(i,1)

       x1line(ii,4,corda(i,3))=xcorda(i,1)
       y1line(ii,4,corda(i,3))=ycorda(i,1)
       z1line(ii,4,corda(i,3))=zcorda(i,1)
       x2line(ii,4,corda(i,3))=xcorda(i,2)
       y2line(ii,4,corda(i,3))=ycorda(i,2)
       z2line(ii,4,corda(i,3))=zcorda(i,2)
       
       end if

       end if

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     14.6 Longituds de les cordes
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


      do i=cordam+1,cordat

      xx2=x2line(corda(i,1),corda(i,2),corda(i,3))
      xx1=x1line(corda(i,1),corda(i,2),corda(i,3))
      yy2=y2line(corda(i,1),corda(i,2),corda(i,3))
      yy1=y1line(corda(i,1),corda(i,2),corda(i,3))
      zz2=z2line(corda(i,1),corda(i,2),corda(i,3))
      zz1=z1line(corda(i,1),corda(i,2),corda(i,3))

      xline(i)=sqrt((xx2-xx1)**2+(yy2-yy1)**2+(zz2-zz1)**2)

      end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     14.7 Dibuixar brakes 2D
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do i=cordam+1,cordat

       x0=(1260.-160.)*xkf
       y0=(1800.+890.95)*xkf

       x00=1260.*xkf*float(corda(i,1)-1)

       call line(x1line(corda(i,1),corda(i,2),corda(i,3))+x0+x00,
     + z1line(corda(i,1),corda(i,2),corda(i,3))+y0,
     + x2line(corda(i,1),corda(i,2),corda(i,3))+x0+x00,
     + z2line(corda(i,1),corda(i,2),corda(i,3))+y0,corda(i,1))

       end do

c      Dibuixa distribucio de frenat

       x0=(1260.+890.)*xkf
       y0=(1800.+1000.)*xkf

       xf=rib(nribss,2)/100.

       string1="BRAKE_DISTRIBUTION"
       string2="CENTER"
       string3="WING_TIP"

       call txt(x0,y0-100.*xkf,10.0d0,0.0d0,string1,7)
       call txt(x0,y0-80.*xkf,10.0d0,0.0d0,string2,7)
       call txt(x0+100.*xf,y0-80.*xkf,10.0d0,0.0d0,string3,7)


       call line(x0,y0,x0+rib(nribss,2),y0,4)

       do k=1,5
       call line(x0+bd(k,1)*xf,y0,x0+bd(k,1)*xf,y0-bd(k,2),1)

       write (xstring,'(F6.2)') bd(k,1)
       call txt(x0+bd(k,1)*xf-20.,y0+30.*xkf,10.0d0,0.0d0,xstring,7)

       write (xstring,'(F6.2)') bd(k,2)
       call txt(x0+bd(k,1)*xf-20.,y0-50.*xkf,10.0d0,0.0d0,xstring,7)

       end do

       do k=1,4
       call line(x0+bd(k,1)*xf,y0-bd(k,2),x0+bd(k+1,1)*xf,
     + y0-bd(k+1,2),5)
       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      15. Marques de colors
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      15.1 Extrados marks
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Marques colors extrados panell i
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do k=1,npce ! ribs number with color marks

c      l=mark number in k rib
       do l=1,npc2e(k) ! marks in rib k

c      Detect if mark is exactly in the rib

       if (xpc2e(k,l).eq.0) then

       i=npc1e(k) ! rib number corresponding to k order

c      Detect segment (j,j+1) where color changes
       do j=1,np(i,2)-1

       if ((100.-(u(i,j,2)).le.xpc1e(k,l).and.
     + (100.-u(i,j+1,2)).gt.xpc1e(k,l))) then

       jcontrol=j        

       end if

       end do

c      Calcula longitud extrados fins punt j

       xle(k,l)=0.
       xleinc(k,l)=0.

       do j=1,jcontrol-1
       xle(k,l)=xle(k,l)+sqrt(((v(i,j+1,2)-v(i,j,2))**2)+
     + ((u(i,j+1,2)-u(i,j,2))**2))
       end do

c      Interpolacio punt color

       xmc=(v(i,j+1,2)-v(i,j,2))/(u(i,j+1,2)-u(i,j,2))
       xbc=v(i,j,2)-xmc*u(i,j,2)
       
       xpc3e(k,l)=100.-xpc1e(k,l)
       ypc3e(k,l)=xmc*xpc3e(k,l)+xbc

       xleinc(k,l)=sqrt(((ypc3e(k,l)-v(i,j,2))**2)+
     + ((xpc3e(k,l)-u(i,j,2))**2))

       xle(k,l)=xle(k,l)+xleinc(k,l)
       
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Dibuixa marques color esquerra panell i
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Localitza punts 
       psep=1970.*xkf+seppix*float(i)
       psey=400.*xkf

       j=jcontrol

       xu=u(i,j,9)
       xv=v(i,j,9)

c      Calcula punt de color
       alp=abs(datan((v(i,j+1,9)-v(i,j,9))/(u(i,j+1,9)-u(i,j,9))))
       xu=xu+(xleinc(k,l)*(rib(i,5)/100.))*dcos(alp)
       xv=xv+(xleinc(k,l)*(rib(i,5)/100.))*dsin(alp)

c      Dibuixa creu
       call line(psep+xu-3.,-(xv)+psey,psep+xu+3.,
     + -(xv)+psey,7)
       call line(psep+xu,-(xv-3.)+psey,psep+xu,
     + -(xv+3.)+psey,7)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Dibuixa marques color dreta panell i-1
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c       if (i.eq.nribss) then


       i=i-1

c      Localitza punts 
       psep=1970.*xkf+seppix*float(i)
       psey=400.*xkf

       j=jcontrol

       xu=u(i,j,10)
       xv=v(i,j,10)

c      Calcula punt de color
       alp=abs(datan((v(i,j+1,10)-v(i,j,10))/(u(i,j+1,10)-u(i,j,10))))
       xu=xu+(xleinc(k,l)*(rib(i,5)/100.))*dcos(alp)
       xv=xv+(xleinc(k,l)*(rib(i,5)/100.))*dsin(alp)

c      Dibuixa creu
       call line(psep+xu-3.,-(xv)+psey,psep+xu+3.,
     + -(xv)+psey,7)
       call line(psep+xu,-(xv-3.)+psey,psep+xu,
     + -(xv+3.)+psey,7)

c       i=i+1


       end if

       end do

       end do ! rib c colors
 


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      15.2 Intrados marks
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Control if type is not "ss"
       if (atp.ne."ss") then
       
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Marques colors intrados panell i
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do k=1,npci ! ribs number with color marks

c      l=mark number in k rib
       do l=1,npc2i(k) ! marks in rib k

c      Detect if mark is exactly in the rib

       if (xpc2i(k,l).eq.0) then

       i=npc1i(k) ! rib number corresponding to k order

c      Detect segment (j,j-1) where color changes

       do j=np(i,1),np(i,2)+1,-1

       if ((100.-(u(i,j,2)).le.xpc1i(k,l).and.
     + (100.-u(i,j-1,2)).gt.xpc1i(k,l))) then

       jcontrol=j        

       end if

       end do  ! in j

c      Calcula longitud extrados fins punt j

       xli(k,l)=0.
       xliinc(k,l)=0.

       do j=np(i,1),jcontrol+1,-1
       xli(k,l)=xli(k,l)+sqrt(((v(i,j-1,2)-v(i,j,2))**2)+
     + ((u(i,j-1,2)-u(i,j,2))**2))
       end do

c      Interpolacio punt color

       xmc=(v(i,j,2)-v(i,j-1,2))/(u(i,j,2)-u(i,j-1,2))
       xbc=v(i,j-1,2)-xmc*u(i,j-1,2)
       
       xpc3i(k,l)=100.-xpc1i(k,l)
       ypc3i(k,l)=xmc*xpc3i(k,l)+xbc

       xliinc(k,l)=sqrt(((ypc3i(k,l)-v(i,j,2))**2)+
     + ((xpc3i(k,l)-u(i,j,2))**2))

       xli(k,l)=xli(k,l)+xliinc(k,l)
       
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Dibuixa marques color esquerra panell i
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Localitza punts 
       psep=1970.*xkf+seppix*float(i)
       psey=1291.*xkf

       j=jcontrol

       xu=u(i,j,9)
       xv=v(i,j,9)

c      Calcula punt de color
       alp=abs(datan((v(i,j,9)-v(i,j-1,9))/(u(i,j,9)-u(i,j-1,9))))
       xu=xu-(xliinc(k,l)*(rib(i,5)/100.))*dcos(alp)
       xv=xv-(xliinc(k,l)*(rib(i,5)/100.))*dsin(alp)

c      Dibuixa creu
       call line(psep+xu-3.,-(xv)+psey,psep+xu+3.,
     + -(xv)+psey,7)
       call line(psep+xu,-(xv-3.)+psey,psep+xu,
     + -(xv+3.)+psey,7)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Dibuixa marques color dreta panell i-1
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=i-1

c      Localitza punts 
       psep=1970.*xkf+seppix*float(i)
       psey=1291.*xkf

       j=jcontrol

       xu=u(i,j,10)
       xv=v(i,j,10)

c      Calcula punt de color
       alp=abs(datan((v(i,j,10)-v(i,j-1,10))/(u(i,j,10)-u(i,j-1,10))))
       xu=xu-(xliinc(k,l)*(rib(i,5)/100.))*dcos(alp)
       xv=xv-(xliinc(k,l)*(rib(i,5)/100.))*dsin(alp)

c      Dibuixa creu
       call line(psep+xu-3.,-(xv)+psey,psep+xu+3.,
     + -(xv)+psey,7)
       call line(psep+xu,-(xv-3.)+psey,psep+xu,
     + -(xv+3.)+psey,7)

       i=1+1

       end if

       end do

       end do ! rib c colors intra

       end if ! not "ss"

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16. H V and HV ribs
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       xvrib=xvrib/10.

c       write (*,*) "xvrib=",xvrib
       
       do i=0,nribss

c      Impressions de control
c       ii=1

c       write (*,*) "u(i,ii,6) ",i,ii,u(i,ii,6)
c       write (*,*) "np(i,2) ",i, np(i,2),np(i,1)
c       write (*,*) "jcon(i,ii,2) ",jcon(i,ii,2)

       end do

       do k=1,nhvr

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.1 H straps
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


       if (hvr(k,2).eq.1) then

c      Control central cell width
       if (hvr(k,3).gt.0.or.cencell.gt.0.01) then

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.1.1 Line i (2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)
       ii=hvr(k,4)

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,7)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,7)

c      Points 2,3,4 interpolation in rib i
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,2).and.u(i,j+1,3).ge.ucnt(i,ii,2)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,2)=xm*ucnt(i,ii,2)+xb
       jcon(i,ii,2)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       jcon(i,ii,3)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,4).and.u(i,j+1,3).ge.ucnt(i,ii,4)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,4)=xm*ucnt(i,ii,4)+xb
       jcon(i,ii,4)=j
       end if

       end do
         

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat line 2-3-4 in n regular spaces   
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       uinc=0.
       vinc=0.

       do j=1,21
       ucnt2(i,ii,j)=ucnt(i,ii,2)+uinc
       uinc=uinc+(ucnt(i,ii,4)-ucnt(i,ii,2))/20.

c      warning u=v
c       write (*,*) "u-v ", i,j,u(i,j,3),v(i,j,3)

c      Between 2 and jcon(i,ii,2)+1
       if (ucnt2(i,ii,j).le.u(i,jcon(i,ii,2)+1,3)) then
       xm=(v(i,jcon(i,ii,2)+1,3)-vcnt(i,ii,2))/(u(i,jcon(i,ii,2)+1,3)-
     + ucnt(i,ii,2))
       xb=vcnt(i,ii,2)-xm*ucnt(i,ii,2)
       vcnt2(i,ii,j)=xm*ucnt2(i,ii,j)+xb
       end if

c      Between jcon(i,ii,2)+1 and jcon(i,ii,4)

       if (ucnt2(i,ii,j).ge.u(i,jcon(i,ii,2)+1,3).and.ucnt2(i,ii,j)
     + .le.u(i,jcon(i,ii,4),3)) then
c      
       do l=jcon(i,ii,2)+1,jcon(i,ii,4)-1

c      Seleccionar tram d'interpolació

       if (ucnt2(i,ii,j).ge.u(i,l,3).and.ucnt2(i,ii,j).le.u(i,l+1,3)) 
     + then
       xm=(v(i,l+1,3)-v(i,l,3))/(u(i,l+1,3)-u(i,l,3))
       xb=v(i,l,3)-xm*u(i,l,3)
       end if
       end do
       vcnt2(i,ii,j)=xm*ucnt2(i,ii,j)+xb
c       write (*,*) "xm, xb ", xm,xb
       end if

c      Between jcon(i,ii,4) and 4       
       if (ucnt2(i,ii,j).gt.u(i,jcon(i,ii,4),3)) then
       xm=(vcnt(i,ii,4)-v(i,jcon(i,ii,4),3))/(ucnt(i,ii,4)-
     + u(i,jcon(i,ii,4),3))
       xb=vcnt(i,ii,4)-xm*ucnt(i,ii,4)
       vcnt2(i,ii,j)=xm*ucnt2(i,ii,j)+xb
       end if

c       write (*,*) "Line 2 ",i,j,ucnt2(i,ii,j),vcnt2(i,ii,j)

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.1.2 Line i+1 (3)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,5)
       ii=hvr(k,6)

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,7)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,7)

c      Points 2,3,4 interpolation in rib i
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,2).and.u(i,j+1,3).ge.ucnt(i,ii,2)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,2)=xm*ucnt(i,ii,2)+xb
       jcon(i,ii,2)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       jcon(i,ii,3)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,4).and.u(i,j+1,3).ge.ucnt(i,ii,4)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,4)=xm*ucnt(i,ii,4)+xb
       jcon(i,ii,4)=j
       end if

       end do
         
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat line 2-3-4 in n regular spaces   
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       uinc=0.
       vinc=0.

       do j=1,21
       ucnt3(i,ii,j)=ucnt(i,ii,2)+uinc
       uinc=uinc+(ucnt(i,ii,4)-ucnt(i,ii,2))/20.

c      Between 2 and jcon(i,ii,2)+1
       if (ucnt3(i,ii,j).le.u(i,jcon(i,ii,2)+1,3)) then
       xm=(v(i,jcon(i,ii,2)+1,3)-vcnt(i,ii,2))/(u(i,jcon(i,ii,2)+1,3)-
     + ucnt(i,ii,2))
       xb=vcnt(i,ii,2)-xm*ucnt(i,ii,2)
       vcnt3(i,ii,j)=xm*ucnt3(i,ii,j)+xb
       end if

c      Between jcon(i,ii,2)+1 and jcon(i,ii,4)

       if (ucnt3(i,ii,j).ge.u(i,jcon(i,ii,2)+1,3).and.ucnt3(i,ii,j)
     + .le.u(i,jcon(i,ii,4),3)) then
c      
       do l=jcon(i,ii,2)+1,jcon(i,ii,4)-1

c      Seleccionar tram d'interpolació

       if (ucnt3(i,ii,j).ge.u(i,l,3).and.ucnt3(i,ii,j).le.u(i,l+1,3)) 
     + then
       xm=(v(i,l+1,3)-v(i,l,3))/(u(i,l+1,3)-u(i,l,3))
       xb=v(i,l,3)-xm*u(i,l,3)
       end if
       end do
       vcnt3(i,ii,j)=xm*ucnt3(i,ii,j)+xb
       end if

c      Between jcon(i,ii,4) and 4       
       if (ucnt3(i,ii,j).gt.u(i,jcon(i,ii,4),3)) then
       xm=(vcnt(i,ii,4)-v(i,jcon(i,ii,4),3))/(ucnt(i,ii,4)-
     + u(i,jcon(i,ii,4),3))
       xb=vcnt(i,ii,4)-xm*ucnt(i,ii,4)
       vcnt3(i,ii,j)=xm*ucnt3(i,ii,j)+xb
       end if

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.1.3 Lines 2 and 3 transportation on the space
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Rib i (Line 2)

       i=hvr(k,3)
       ii=hvr(k,4)

       tetha=rib(i,8)*pi/180.
       
       do j=1,21
       ru(i,j,3)=ucnt2(i,ii,j)
       rv(i,j,3)=vcnt2(i,ii,j)-rib(i,50)
       end do

       do j=1,21

c      V-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      V-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)
       if (i.eq.0) then
       rw(i,j,5)=-rw(i,j,5)
       end if

c      V-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       hx2(i,j,ii)=rx(i,j)
       hy2(i,j,ii)=ry(i,j)
       hz2(i,j,ii)=rz(i,j)

       end do

c      Rib i+1 (Line 3)

       i=hvr(k,5)
       ii=hvr(k,6)

       tetha=rib(i,8)*pi/180.

       do j=1,21
       ru(i,j,3)=ucnt3(i,ii,j)
       rv(i,j,3)=vcnt3(i,ii,j)-rib(i,50)
c      COMPTE AMB el rib(i,50) A ESTUDIAR       
       end do

       do j=1,21

c      H-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      H-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      H-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       hx3(i-1,j,ii)=rx(i,j)
       hy3(i-1,j,ii)=ry(i,j)
       hz3(i-1,j,ii)=rz(i,j)

       end do


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.1.4 H-rib 2-3 in 2D model
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)

       px0=0.
       py0=0.
       ptheta=0.

       do j=1,21

c      Distances between points
       pa=sqrt((rx(i+1,j)-rx(i,j))**2.+(ry(i+1,j)-ry(i,j))**2.+
     + (rz(i+1,j)-rz(i,j))**2.)
       pb=sqrt((rx(i+1,j+1)-rx(i,j))**2.+(ry(i+1,j+1)-ry(i,j))**2.+
     + (rz(i+1,j+1)-rz(i,j))**2.)
       pc=sqrt((rx(i+1,j+1)-rx(i+1,j))**2.+(ry(i+1,j+1)-ry(i+1,j))**2.+
     + (rz(i+1,j+1)-rz(i+1,j))**2.)
       pd=sqrt((rx(i+1,j)-rx(i,j+1))**2.+(ry(i+1,j)-ry(i,j+1))**2.+
     + (rz(i+1,j)-rz(i,j+1))**2.)
       pe=sqrt((rx(i,j+1)-rx(i,j))**2.+(ry(i,j+1)-ry(i,j))**2.+
     + (rz(i,j+1)-rz(i,j))**2.)
       pf=sqrt((rx(i+1,j+1)-rx(i,j+1))**2.+(ry(i+1,j+1)-ry(i,j+1))**2.+
     + (rz(i+1,j+1)-rz(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

       pb2t=(pb*pb-pe*pe+pf*pf)/(2.*pb)
       pb1t=pb-pb2t
       pht=sqrt(pf*pf-pb2t*pb2t)
       
       pw1=datan(phr/pa1r)
       phu=pb1t*tan(pw1)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0
       
       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

c      Iteration
       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Tensa cintes. Calcula i imprimeix distancies...
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       j=10


       hdist(i)=sqrt((pl1y(i,j)-pr1y(i,j))**2.+
     + (pl1x(i,j)-pr1x(i,J))**2.)
       hangle(i)=datan((pr1y(i,j)-pl1y(i,j))/(pr1x(i,j)-pl1x(i,j)))

c      Ajusta tensió de la cinta

c      Note: if use variable htens not work, I renamed htensi

       htens=htensi

       do j=1,21

       pr1x(i,j)=pr1x(i,j)-htensi*hdist(i)*dcos(hangle(i))
       pr1y(i,j)=pr1y(i,j)-htensi*hdist(i)*dsin(hangle(i))
       pr2x(i,j)=pr2x(i,j)-htensi*hdist(i)*dcos(hangle(i))
       pr2y(i,j)=pr2y(i,j)-htensi*hdist(i)*dsin(hangle(i))

       end do

c      Cintes tensades
       j=10

       hdist(i)=sqrt((pl1y(i,j)-pr1y(i,j))**2.+
     + (pl1x(i,j)-pr1x(i,J))**2.)
       hangle(i)=datan((pr1y(i,j)-pl1y(i,j))/(pr1x(i,j)-pl1x(i,j)))

c       write (*,*) "dist tensades ", i, "-", i+1, hdist(i), hangle(i)

c      Drawing in 2D model
       
       psep=3300.*xkf+xrsep*float(i)
       psey=800.*xkf+yrsep*float(ii)

c       write (*,*) i,ii,psep,psey

       j=1

       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),30)

       j=21

       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),30)

       do j=1,21-1

c      Dibuixa limit esquerre
c       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pl2x(i,j),
c     + psey+pl2y(i,j),1)

c      Dibuixa limit dret
c       call line(psep+pr1x(i,j),psey+pr1y(i,j),psep+pr2x(i,j),
c     + psey+pr2y(i,j),1)


c       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
c     + psey+pr1y(i,j),4)


c      Vores de costura esquerra
       alpl=-(datan((pl1y(i,j)-pl2y(i,j))/(pl1x(i,j)-pl2x(i,j))))
       if (alpl.lt.0.) then
       alpl=alpl+pi
       end if

       lvcx(i,j)=psep+pl1x(i,j)-xvrib*dsin(alpl)
       lvcy(i,j)=psey+pl1y(i,j)-xvrib*dcos(alpl)

c      Vores de costura dreta
       alpr=-(datan((pr1y(i,j)-pr2y(i,j))/(pr1x(i,j)-pr2x(i,j))))
       if (alpr.lt.0.) then
       alpr=alpr+pi
       end if

       rvcx(i,j)=psep+pr1x(i,j)+xvrib*dsin(alpr)
       rvcy(i,j)=psey+pr1y(i,j)+xvrib*dcos(alpr)

c      Tancament lateral inici
       if (j.eq.1) then
       call line(psep+pl1x(i,j)-xvrib*dsin(alpl),psey+pl1y(i,j)
     + -xvrib*dcos(alpl),psep+pl1x(i,j),psey+pl1y(i,j),30)
       call line(psep+pr1x(i,j)+xvrib*dsin(alpr),psey+pr1y(i,j)
     + +xvrib*dcos(alpr),psep+pr1x(i,j),psey+pr1y(i,j),30)
       end if

c      Tancament lateral fi
       if (j.eq.20) then
       call line(psep+pl2x(i,j)-xvrib*dsin(alpl),psey+pl2y(i,j)
     + -xvrib*dcos(alpl),psep+pl2x(i,j),psey+pl2y(i,j),30)
       call line(psep+pr2x(i,j)+xvrib*dsin(alpr),psey+pr2y(i,j)
     + +xvrib*dcos(alpr),psep+pr2x(i,j),psey+pr2y(i,j),30)

       lvcx(i,j+1)=psep+pl2x(i,j)-xvrib*dsin(alpl)
       lvcy(i,j+1)=psey+pl2y(i,j)-xvrib*dcos(alpl)
       
       rvcx(i,j+1)=psep+pr2x(i,j)+xvrib*dsin(alpr)
       rvcy(i,j+1)=psey+pr2y(i,j)+xvrib*dcos(alpr)

       end if

       end do

c      Dibuixa punt central de control de costura AD

       alpl=-(datan((pl1y(i,1)-pl2y(i,20))/(pl1x(i,1)-pl2x(i,20))))
       if (alpl.lt.0.) then
       alpl=alpl+pi
       end if

       xpx=(pl1x(i,1)+pl2x(i,20))/2.-xdes*dsin(alpl)
       xpy=(pl1y(i,1)+pl2y(i,20))/2.-xdes*dcos(alpl)

       call point(psep+xpx,psey+xpy,3)

       alpr=-(datan((pr1y(i,1)-pr2y(i,20))/(pr1x(i,1)-pr2x(i,20))))
       if (alpr.lt.0.) then
       alpr=alpr+pi
       end if

       xpx=(pr1x(i,1)+pr2x(i,20))/2.+xdes*dsin(alpr)
       xpy=(pr1y(i,1)+pr2y(i,20))/2.+xdes*dcos(alpr)

       call point(psep+xpx,psey+xpy,1)


c      Etiqueta cintes en romans AD

       pi=4.*datan(1.0d0)

       xpx=(pl1x(i,1)+pl2x(i,20))/2.-xdes*dsin(alpl)
       xpy=(pl1y(i,1)+pl2y(i,20))/2.-xdes*dcos(alpl)

c       alpl=(datan((pl2y(i,20)-pl1y(i,1))/(pl2x(i,20)-pl1x(i,1))))

c      write (*,*) "romano", hvr(k,3), hvr(k,4), xvrib, alpl

       xpx2=psep+xpx+0.4*hvr(k,7)*dcos(alpl)-0.6*xvrib*dsin(alpl)
       xpy2=psey+xpy-0.4*hvr(k,7)*dsin(alpl)-0.6*xvrib*dcos(alpl)
       
       call romano(int(hvr(k,3)),xpx2,xpy2,alpl,0.4d0,1)

       xpx2=psep+xpx-0.6*hvr(k,7)*dcos(alpl)-0.6*xvrib*dsin(alpl)
       xpy2=psey+xpy+0.6*hvr(k,7)*dsin(alpl)-0.6*xvrib*dcos(alpl)
       
       call romano(int(hvr(k,4)),xpx2,xpy2,alpl,0.4d0,7)

c       call line(psep+xpx,psey+xpy,psep+xpx+4.*dcos(alpl),
c     + psey+xpy+4.*dsin(alpl),1)

c      H-rib lenght
       hvr(k,15)=sqrt((lvcx(i,1)-rvcx(i,1))**2.+
     + (lvcy(i,1)-rvcy(i,1))**2.)
     
c      Numera cintes H en decimals
       call itxt(psep-xrsep,psey-10,10.0d0,0.0d0,i,7)
       call itxt(psep+hvr(k,15)-xrsep,psey-10,10.0d0,0.0d0,i+1,7)

       pi=4.*datan(1.0d0)

c      Dibuixa vores amb segments completament enllaçats       

       do j=1,20

       call line(lvcx(i,j),lvcy(i,j),lvcx(i,j+1),lvcy(i,j+1),30)
       call line(rvcx(i,j),rvcy(i,j),rvcx(i,j+1),rvcy(i,j+1),30)

       end do

       end if

       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.2 V ribs partial
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,2).eq.2) then

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.2.1 Rib i
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Define main points

       i=hvr(k,3)    ! rib i
       ii=hvr(k,4)   ! row ii

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,1)=ucnt(i,ii,3)-hvr(k,8)
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,7)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,7)
       ucnt(i,ii,5)=ucnt(i,ii,3)+hvr(k,8)
       ucnt(i,ii,6)=ucnt(i,ii,1)
       ucnt(i,ii,7)=ucnt(i,ii,3)
       ucnt(i,ii,8)=ucnt(i,ii,5)
       ucnt(i,ii,9)=ucnt(i,ii,1)
       ucnt(i,ii,10)=ucnt(i,ii,3)
       ucnt(i,ii,11)=ucnt(i,ii,5)


c      Points 2,3,4 interpolation in rib i
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,2).and.u(i,j+1,3).ge.ucnt(i,ii,2)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,2)=xm*ucnt(i,ii,2)+xb
       jcon(i,ii,2)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       jcon(i,ii,3)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,4).and.u(i,j+1,3).ge.ucnt(i,ii,4)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,4)=xm*ucnt(i,ii,4)+xb
       jcon(i,ii,4)=j
       end if

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat line 2-3-4 in n regular spaces   
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       uinc=0.
       vinc=0.

       do j=1,21
       ucnt2(i,ii,j)=ucnt(i,ii,2)+uinc
       uinc=uinc+(ucnt(i,ii,4)-ucnt(i,ii,2))/20.

c      Between 2 and jcon(i,ii,2)+1
       if (ucnt2(i,ii,j).le.u(i,jcon(i,ii,2)+1,3)) then
       xm=(v(i,jcon(i,ii,2)+1,3)-vcnt(i,ii,2))/(u(i,jcon(i,ii,2)+1,3)-
     + ucnt(i,ii,2))
       xb=vcnt(i,ii,2)-xm*ucnt(i,ii,2)
       vcnt2(i,ii,j)=xm*ucnt2(i,ii,j)+xb
       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Between jcon(i,ii,2)+1 and jcon(i,ii,4)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (ucnt2(i,ii,j).ge.u(i,jcon(i,ii,2)+1,3).and.ucnt2(i,ii,j)
     + .le.u(i,jcon(i,ii,4),3)) then
c      
       do l=jcon(i,ii,2)+1,jcon(i,ii,4)-1

c      Seleccionar tram d'interpolació

       if (ucnt2(i,ii,j).ge.u(i,l,3).and.ucnt2(i,ii,j).le.u(i,l+1,3)) 
     + then
       xm=(v(i,l+1,3)-v(i,l,3))/(u(i,l+1,3)-u(i,l,3))
       xb=v(i,l,3)-xm*u(i,l,3)
       end if
       end do
c       xm=(v(i,jcon(i,ii,2)+j,3)-v(i,jcon(i,ii,2)+j-1,3))/
c     + (u(i,jcon(i,ii,2)+j,3)-u(i,jcon(i,ii,2)+j-1,3))
c       xb=v(i,jcon(i,ii,2)+j-1,3)-xm*u(i,jcon(i,ii,2)+j-1,3)
       vcnt2(i,ii,j)=xm*ucnt2(i,ii,j)+xb
       end if

c      Between jcon(i,ii,4) and 4       
       if (ucnt2(i,ii,j).gt.u(i,jcon(i,ii,4),3)) then
       xm=(vcnt(i,ii,4)-v(i,jcon(i,ii,4),3))/(ucnt(i,ii,4)-
     + u(i,jcon(i,ii,4),3))
       xb=vcnt(i,ii,4)-xm*ucnt(i,ii,4)
       vcnt2(i,ii,j)=xm*ucnt2(i,ii,j)+xb
       end if

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.2.2 Rib i-1
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)-1
       ii=hvr(k,4)

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,1)=ucnt(i,ii,3)-hvr(k,8)
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,7)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,7)
       ucnt(i,ii,5)=ucnt(i,ii,3)+hvr(k,8)
       ucnt(i,ii,6)=ucnt(i,ii,1)
       ucnt(i,ii,7)=ucnt(i,ii,3)
       ucnt(i,ii,8)=ucnt(i,ii,5)
       ucnt(i,ii,9)=ucnt(i,ii,1)
       ucnt(i,ii,10)=ucnt(i,ii,3)
       ucnt(i,ii,11)=ucnt(i,ii,5)

c      Points 1,3,5 interpolation in rib i-1
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,1).and.u(i,j+1,3).ge.ucnt(i,ii,1)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,1)=xm*ucnt(i,ii,1)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,5).and.u(i,j+1,3).ge.ucnt(i,ii,5)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,5)=xm*ucnt(i,ii,5)+xb
       end if

       end do

c      Points 9,10,11 interpolation in rib i-1
       do j=1,np(i,2)

       if (u(i,j,3).ge.ucnt(i,ii,9).and.u(i,j+1,3).le.ucnt(i,ii,9)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,9)=xm*ucnt(i,ii,9)+xb
       end if

       if (u(i,j,3).ge.ucnt(i,ii,10).and.u(i,j+1,3).le.ucnt(i,ii,10)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,10)=xm*ucnt(i,ii,10)+xb
       end if

       if (u(i,j,3).ge.ucnt(i,ii,11).and.u(i,j+1,3).le.ucnt(i,ii,11)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,11)=xm*ucnt(i,ii,11)+xb
       end if

       end do

c      Calculus of 6,7,8 points in rib i-1
       vcnt(i,ii,6)=(vcnt(i,ii,9)-vcnt(i,ii,1))*(hvr(k,9)/100.)+
     + vcnt(i,ii,1)
       vcnt(i,ii,7)=(vcnt(i,ii,10)-vcnt(i,ii,3))*(hvr(k,9)/100.)+
     + vcnt(i,ii,3)
       vcnt(i,ii,8)=(vcnt(i,ii,11)-vcnt(i,ii,5))*(hvr(k,9)/100.)+
     + vcnt(i,ii,5)

c      Redefinition of points 6,8 if angle is not 90     
       if (hvr(k,10).ne.90.) then
       ucnt(i,ii,6)=ucnt(i,ii,7)-hvr(k,8)*dcos((pi/180.)*hvr(k,10))
       ucnt(i,ii,8)=ucnt(i,ii,7)+hvr(k,8)*dcos((pi/180.)*hvr(k,10))
       vcnt(i,ii,6)=vcnt(i,ii,7)-hvr(k,8)*dsin((pi/180.)*hvr(k,10))
       vcnt(i,ii,8)=vcnt(i,ii,7)+hvr(k,8)*dsin((pi/180.)*hvr(k,10))
       end if

c      Divide line 6-8 in n segments

       uinc=0.
       vinc=0.
       do j=1,21
       ucnt1(i,ii,j)=ucnt(i,ii,6)+uinc
       uinc=uinc+(ucnt(i,ii,8)-ucnt(i,ii,6))/20.
       vcnt1(i,ii,j)=vcnt(i,ii,6)+vinc
       vinc=vinc+(vcnt(i,ii,8)-vcnt(i,ii,6))/20.
       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.2.3 Rib i+1
cccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)+1
       ii=hvr(k,4)

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,1)=ucnt(i,ii,3)-hvr(k,8)
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,7)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,7)
       ucnt(i,ii,5)=ucnt(i,ii,3)+hvr(k,8)
       ucnt(i,ii,6)=ucnt(i,ii,1)
       ucnt(i,ii,7)=ucnt(i,ii,3)
       ucnt(i,ii,8)=ucnt(i,ii,5)
       ucnt(i,ii,9)=ucnt(i,ii,1)
       ucnt(i,ii,10)=ucnt(i,ii,3)
       ucnt(i,ii,11)=ucnt(i,ii,5)

c      Points 1,3,5 interpolation in rib i+1
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,1).and.u(i,j+1,3).ge.ucnt(i,ii,1)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,1)=xm*ucnt(i,ii,1)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,5).and.u(i,j+1,3).ge.ucnt(i,ii,5)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,5)=xm*ucnt(i,ii,5)+xb
       end if

       end do

c      Points 9,10,11 interpolation in rib i+1
       do j=1,np(i,2)

       if (u(i,j,3).ge.ucnt(i,ii,9).and.u(i,j+1,3).le.ucnt(i,ii,9)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,9)=xm*ucnt(i,ii,9)+xb
       end if

       if (u(i,j,3).ge.ucnt(i,ii,10).and.u(i,j+1,3).le.ucnt(i,ii,10)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,10)=xm*ucnt(i,ii,10)+xb
       end if

       if (u(i,j,3).ge.ucnt(i,ii,11).and.u(i,j+1,3).le.ucnt(i,ii,11)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,11)=xm*ucnt(i,ii,11)+xb
       end if

       end do

c      Calculus of 6,7,8 points in rib i+1
       vcnt(i,ii,6)=(vcnt(i,ii,9)-vcnt(i,ii,1))*(hvr(k,9)/100.)+
     + vcnt(i,ii,1)
       vcnt(i,ii,7)=(vcnt(i,ii,10)-vcnt(i,ii,3))*(hvr(k,9)/100.)+
     + vcnt(i,ii,3)
       vcnt(i,ii,8)=(vcnt(i,ii,11)-vcnt(i,ii,5))*(hvr(k,9)/100.)+
     + vcnt(i,ii,5)

c      Redefinition of points 7,8 if angle is not 90     
       if (hvr(k,10).ne.90.) then
       ucnt(i,ii,6)=ucnt(i,ii,7)-hvr(k,8)*dcos((pi/180.)*hvr(k,10))
       ucnt(i,ii,8)=ucnt(i,ii,7)+hvr(k,8)*dcos((pi/180.)*hvr(k,10))
       vcnt(i,ii,6)=vcnt(i,ii,7)-hvr(k,8)*dsin((pi/180.)*hvr(k,10))
       vcnt(i,ii,8)=vcnt(i,ii,7)+hvr(k,8)*dsin((pi/180.)*hvr(k,10))
       end if

c      Divide line 6-8 in n segments

       uinc=0.
       vinc=0.
       do j=1,21
       ucnt3(i,ii,j)=ucnt(i,ii,6)+uinc
       uinc=uinc+(ucnt(i,ii,8)-ucnt(i,ii,6))/20.
       vcnt3(i,ii,j)=vcnt(i,ii,6)+vinc
       vinc=vinc+(vcnt(i,ii,8)-vcnt(i,ii,6))/20.
       end do

c      Rib localisation
       i=hvr(k,3)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.2.4 V-ribs lines 1 2 3 transportation to 3D espace
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Rib i-1 (Line 1)

       i=hvr(k,3)-1

       tetha=rib(i,8)*pi/180.

       do j=1,21
       ru(i,j,3)=ucnt1(i,ii,j)
       rv(i,j,3)=vcnt1(i,ii,j)-rib(i,50)
       end do

       do j=1,21

c      V-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      V-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      V-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       rx1(i+1,j,ii)=rx(i,j)
       ry1(i+1,j,ii)=ry(i,j)
       rz1(i+1,j,ii)=rz(i,j)

       end do

c      Rib i (Line 2)

       i=hvr(k,3)

       tetha=rib(i,8)*pi/180.
       
       do j=1,21
       ru(i,j,3)=ucnt2(i,ii,j)
       rv(i,j,3)=vcnt2(i,ii,j)-rib(i,50)
       end do

       do j=1,21

c      V-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      V-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      V-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       rx2(i,j,ii)=rx(i,j)
       ry2(i,j,ii)=ry(i,j)
       rz2(i,j,ii)=rz(i,j)

       end do

c      Rib i+1 (Line 3)

       i=hvr(k,3)+1

       tetha=rib(i,8)*pi/180.

       do j=1,21
       ru(i,j,3)=ucnt3(i,ii,j)
       rv(i,j,3)=vcnt3(i,ii,j)-rib(i,50)
c      COMPTE AMB el rib(i,50) A ESTUDIAR       
       end do

       do j=1,21

c      V-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      V-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      V-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       rx3(i-1,j,ii)=rx(i,j)
       ry3(i-1,j,ii)=ry(i,j)
       rz3(i-1,j,ii)=rz(i,j)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.2.5 V-ribs calculus and drawing in 3D and 2D
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.2.5.1 V-rib 1-2 in 2D model (blue)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)-1

       px0=0.
       py0=0.
       ptheta=0.

       do j=1,21

c      Distances between points
       pa=sqrt((rx(i+1,j)-rx(i,j))**2.+(ry(i+1,j)-ry(i,j))**2.+
     + (rz(i+1,j)-rz(i,j))**2.)
       pb=sqrt((rx(i+1,j+1)-rx(i,j))**2.+(ry(i+1,j+1)-ry(i,j))**2.+
     + (rz(i+1,j+1)-rz(i,j))**2.)
       pc=sqrt((rx(i+1,j+1)-rx(i+1,j))**2.+(ry(i+1,j+1)-ry(i+1,j))**2.+
     + (rz(i+1,j+1)-rz(i+1,j))**2.)
       pd=sqrt((rx(i+1,j)-rx(i,j+1))**2.+(ry(i+1,j)-ry(i,j+1))**2.+
     + (rz(i+1,j)-rz(i,j+1))**2.)
       pe=sqrt((rx(i,j+1)-rx(i,j))**2.+(ry(i,j+1)-ry(i,j))**2.+
     + (rz(i,j+1)-rz(i,j))**2.)
       pf=sqrt((rx(i+1,j+1)-rx(i,j+1))**2.+(ry(i+1,j+1)-ry(i,j+1))**2.+
     + (rz(i+1,j+1)-rz(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

       pb2t=(pb*pb-pe*pe+pf*pf)/(2.*pb)
       pb1t=pb-pb2t
       pht=sqrt(pf*pf-pb2t*pb2t)
       
       pw1=datan(phr/pa1r)
       phu=pb1t*dtan(pw1)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0
       
       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

c      Iteration
       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
       
       end do

c      Drawing in 2D model
       
       psep=3300.*xkf+xrsep*float(i)
       psey=800.*xkf+yrsep*float(ii)

       if (hvr(k,5).eq.1) then

       j=1

c      Costat vora atac
       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),5)

       j=21
c      Costat fuga
       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),5)

c      Marca punts MC a l'esquerra

       alpha=-(datan((pl1y(i,1)-pl2y(i,20))/(pl1x(i,1)-pl2x(i,20))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xp6=pl1x(i,1)-xdes*dsin(alpha)-2.*xdes*dcos(alpha)
       yp6=pl1y(i,1)-xdes*dcos(alpha)+2.*xdes*dsin(alpha)
       xp8=pl1x(i,21)-xdes*dsin(alpha)+2.*xdes*dcos(alpha)
       yp8=pl1y(i,21)-xdes*dcos(alpha)-2.*xdes*dsin(alpha)
       xp7=0.5*(xp6+xp8)
       yp7=0.5*(yp6+yp8)

       call point(psep+xp6,psey+yp6,1)
       call point(psep+xp7,psey+yp7,1)
       call point(psep+xp8,psey+yp8,1)

c     Romano costat esquerra

      sl=1.
       
      xpx=(pl1x(i,1)+pl2x(i,20))/2.-xdes*dsin(alpha)
      xpy=(pl1y(i,1)+pl2y(i,20))/2.-xdes*dcos(alpha)

      xpx2=psep+xpx+0.5*hvr(k,8)*dcos(alpha)-0.3*xvrib*dsin(alpha)
      xpy2=psey+xpy-0.5*hvr(k,8)*dsin(alpha)-0.3*xvrib*dcos(alpha) 

      call romano(i,xpx2,xpy2,alpha,0.4d0,3)

      xpx2=psep+xpx-0.5*hvr(k,8)*dcos(alpha)-0.3*xvrib*dsin(alpha)
      xpy2=psey+xpy+0.5*hvr(k,8)*dsin(alpha)-0.3*xvrib*dcos(alpha) 

      call romano(int(hvr(k,4)),xpx2,xpy2,alpha,0.4d0,7)


c      Marca punts MC a la dreta

       alpha=-(datan((pr1y(i,1)-pr2y(i,20))/(pr1x(i,1)-pr2x(i,20))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xp7=0.5*(pr1x(i,1)+pr2x(i,20))+xdes*dsin(alpha)
       yp7=0.5*(pr1y(i,1)+pr2y(i,20))+xdes*dcos(alpha)

       call point(psep+xp7,psey+yp7,3)


c     Romano costat dret

      sr=1.
       
      xpx=(pr1x(i,1)+pr2x(i,20))/2.+xdes*dsin(alpha)
      xpy=(pr1y(i,1)+pr2y(i,20))/2.+xdes*dcos(alpha)

      xpx2=psep+xpx+0.3*hvr(k,7)*dcos(alpha)+0.3*xvrib*dsin(alpha)
      xpy2=psey+xpy-0.3*hvr(k,7)*dsin(alpha)+0.3*xvrib*dcos(alpha) 

      call romano(i+1,xpx2,xpy2,alpha,0.4d0,3)
       
       do j=1,21-1

c      Vores de costura esquerra
       alpl=-(datan((pl1y(i,j)-pl2y(i,j))/(pl1x(i,j)-pl2x(i,j))))
       if (alpl.lt.0.) then
       alpl=alpl+pi
       end if

       lvcx(i,j)=psep+pl1x(i,j)-xvrib*dsin(alpl)
       lvcy(i,j)=psey+pl1y(i,j)-xvrib*dcos(alpl)

c      Vores de costura dreta
       alpr=-(datan((pr1y(i,j)-pr2y(i,j))/(pr1x(i,j)-pr2x(i,j))))
       if (alpr.lt.0.) then
       alpr=alpr+pi
       end if

       rvcx(i,j)=psep+pr1x(i,j)+xvrib*dsin(alpr)
       rvcy(I,j)=psey+pr1y(i,j)+xvrib*dcos(alpr)

c      Tancament lateral inici
       if (j.eq.1) then
       call line(psep+pl1x(i,j)-xvrib*dsin(alpl),psey+pl1y(i,j)
     + -xvrib*dcos(alpl),psep+pl1x(i,j),psey+pl1y(i,j),5)
       call line(psep+pr1x(i,j)+xvrib*dsin(alpr),psey+pr1y(i,j)
     + +xvrib*dcos(alpr),psep+pr1x(i,j),psey+pr1y(i,j),5)
       end if

c      Tancament lateral fi
       if (j.eq.20) then
       call line(psep+pl2x(i,j)-xvrib*dsin(alpl),psey+pl2y(i,j)
     + -xvrib*dcos(alpl),psep+pl2x(i,j),psey+pl2y(i,j),5)
       call line(psep+pr2x(i,j)+xvrib*dsin(alpr),psey+pr2y(i,j)
     + +xvrib*dcos(alpr),psep+pr2x(i,j),psey+pr2y(i,j),5)

       lvcx(i,j+1)=psep+pl2x(i,j)-xvrib*dsin(alpl)
       lvcy(i,j+1)=psey+pl2y(i,j)-xvrib*dcos(alpl)

       rvcx(i,j+1)=psep+pr2x(i,j)+xvrib*dsin(alpr)
       rvcy(i,j+1)=psey+pr2y(i,j)+xvrib*dcos(alpr)

       end if

c      V-rib length
       hvr(k,15)=sqrt((lvcx(i,1)-rvcx(i,1))**2.+
     + (lvcy(i,1)-rvcy(i,1))**2.)

c      Numera cintes V
       call itxt(psep-xrsep,psey-10,10.0d0,0.0d0,i,7)
       call itxt(psep+hvr(k,15)-xrsep,psey-10,10.0d0,0.0d0,i+1,7)
   
       end do

c      Dibuixa vores amb segments completament enllaçats       
       do j=1,20

       call line(lvcx(i,j),lvcy(i,j),lvcx(i,j+1),lvcy(i,j+1),5)
       call line(rvcx(i,j),rvcy(i,j),rvcx(i,j+1),rvcy(i,j+1),5)

       end do

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.2.5.2 V-rib 2-3 in 2D model (red)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)

       px0=0.
       py0=0.
       ptheta=0.

       do j=1,21

c      Distances between points
       pa=sqrt((rx(i+1,j)-rx(i,j))**2.+(ry(i+1,j)-ry(i,j))**2.+
     + (rz(i+1,j)-rz(i,j))**2.)
       pb=sqrt((rx(i+1,j+1)-rx(i,j))**2.+(ry(i+1,j+1)-ry(i,j))**2.+
     + (rz(i+1,j+1)-rz(i,j))**2.)
       pc=sqrt((rx(i+1,j+1)-rx(i+1,j))**2.+(ry(i+1,j+1)-ry(i+1,j))**2.+
     + (rz(i+1,j+1)-rz(i+1,j))**2.)
       pd=sqrt((rx(i+1,j)-rx(i,j+1))**2.+(ry(i+1,j)-ry(i,j+1))**2.+
     + (rz(i+1,j)-rz(i,j+1))**2.)
       pe=sqrt((rx(i,j+1)-rx(i,j))**2.+(ry(i,j+1)-ry(i,j))**2.+
     + (rz(i,j+1)-rz(i,j))**2.)
       pf=sqrt((rx(i+1,j+1)-rx(i,j+1))**2.+(ry(i+1,j+1)-ry(i,j+1))**2.+
     + (rz(i+1,j+1)-rz(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

       pb2t=(pb*pb-pe*pe+pf*pf)/(2.*pb)
       pb1t=pb-pb2t
       pht=sqrt(pf*pf-pb2t*pb2t)
       
       pw1=datan(phr/pa1r)
       phu=pb1t*dtan(pw1)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0
       
       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

c      Iteration
       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
       
       
       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Drawing in 2D model
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       
       psep=3300.*xkf+xrsep*float(i)
       psey=800.*xkf+yrsep*float(ii)

       if (hvr(k,6).eq.1) then

       j=1

c      Costat vora d'atac
       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),1)

       j=21
c      Costat fuga
       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),1)


c      Marca punts MC a l'esquerra

       alpha=-(datan((pl1y(i,1)-pl2y(i,20))/(pl1x(i,1)-pl2x(i,20))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xp7=0.5*(pl1x(i,1)+pl1x(i,21))-xdes*dsin(alpha)
       yp7=0.5*(pl1y(i,1)+pl1y(i,21))-xdes*dcos(alpha)

       call point(psep+xp7,psey+yp7,1)

c      Romano costat esquerra

       sl=1.
       
       xpx=(pl1x(i,1)+pl2x(i,20))/2.-sl*xdes*dsin(alpha)
       xpy=(pl1y(i,1)+pl2y(i,20))/2.-sl*xdes*dcos(alpha)

       xpx2=psep+xpx+0.3*hvr(k,7)*dcos(alpha)-0.3*xvrib*dsin(alpha)
       xpy2=psey+xpy-0.3*hvr(k,7)*dsin(alpha)-0.3*xvrib*dcos(alpha) 

       call romano(i,xpx2,xpy2,alpha,0.4d0,3)

c      Marca punts MC a la dreta

       alpha=-(datan((pr1y(i,1)-pr2y(i,20))/(pr1x(i,1)
     + -pr2x(i,20))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xp6=pr1x(i,1)+xdes*dsin(alpha)-2.*xdes*dcos(alpha)
       yp6=pr1y(i,1)+xdes*dcos(alpha)+2.*xdes*dsin(alpha)
       xp8=pr1x(i,21)+xdes*dsin(alpha)+2.*xdes*dcos(alpha)
       yp8=pr1y(i,21)+xdes*dcos(alpha)-2.*xdes*dsin(alpha)
       xp7=0.5*(xp6+xp8)
       yp7=0.5*(yp6+yp8)

       call point(psep+xp6,psey+yp6,1)
       call point(psep+xp7,psey+yp7,1)
       call point(psep+xp8,psey+yp8,1)

c      Romano costat dret

       sr=1.
       
       xpx=(pr1x(i,1)+pr2x(i,20))/2.+xdes*dsin(alpha)
       xpy=(pr1y(i,1)+pr2y(i,20))/2.+xdes*dcos(alpha)

       xpx2=psep+xpx+0.5*hvr(k,8)*dcos(alpha)+0.3*xvrib*dsin(alpha)
       xpy2=psey+xpy-0.5*hvr(k,8)*dsin(alpha)+0.3*xvrib*dcos(alpha) 

       call romano(i+1,xpx2,xpy2,alpha,0.4d0,3)

       xpx2=psep+xpx-0.5*hvr(k,8)*dcos(alpha)+0.3*xvrib*dsin(alpha)
       xpy2=psey+xpy+0.5*hvr(k,8)*dsin(alpha)+0.3*xvrib*dcos(alpha) 

       call romano(int(hvr(k,4)),xpx2,xpy2,alpha,0.4d0,3)

c      Vores de costura

       do j=1,21-1

c      Vores de costura esquerra
       alpl=-(datan((pl1y(i,j)-pl2y(i,j))/(pl1x(i,j)-pl2x(i,j))))
       if (alpl.lt.0.) then
       alpl=alpl+pi
       end if

       lvcx(i,j)=psep+pl1x(i,j)-xvrib*dsin(alpl)
       lvcy(i,j)=psey+pl1y(i,j)-xvrib*dcos(alpl)

c      Vores de costura dreta
       alpr=-(datan((pr1y(i,j)-pr2y(i,j))/(pr1x(i,j)-pr2x(i,j))))
       if (alpr.lt.0.) then
       alpr=alpr+pi
       end if

       rvcx(i,j)=psep+pr1x(i,j)+xvrib*dsin(alpr)
       rvcy(i,j)=psey+pr1y(i,j)+xvrib*dcos(alpr)

c      Tancament lateral inici
       if (j.eq.1) then
       call line(psep+pl1x(i,j)-xvrib*dsin(alpl),psey+pl1y(i,j)
     + -xvrib*dcos(alpl),psep+pl1x(i,j),psey+pl1y(i,j),1)
       call line(psep+pr1x(i,j)+xvrib*dsin(alpr),psey+pr1y(i,j)
     + +xvrib*dcos(alpr),psep+pr1x(i,j),psey+pr1y(i,j),1)
       end if

c      Tancament lateral fi
       if (j.eq.20) then
       call line(psep+pl2x(i,j)-xvrib*dsin(alpl),psey+pl2y(i,j)
     + -xvrib*dcos(alpl),psep+pl2x(i,j),psey+pl2y(i,j),1)
       call line(psep+pr2x(i,j)+xvrib*dsin(alpr),psey+pr2y(i,j)
     + +xvrib*dcos(alpr),psep+pr2x(i,j),psey+pr2y(i,j),1)

       lvcx(i,j+1)=psep+pl2x(i,j)-xvrib*dsin(alpl)
       lvcy(i,j+1)=psey+pl2y(i,j)-xvrib*dcos(alpl)

       rvcx(i,j+1)=psep+pr2x(i,j)+xvrib*dsin(alpr)
       rvcy(i,j+1)=psey+pr2y(i,j)+xvrib*dcos(alpr)

       end if

c      Numera cintes V
c       call itxt(psep-20-xrsep,psey-10,10.0d0,0.0d0,i,7)
c       call itxt(psep+20-xrsep,psey-10,10.0d0,0.0d0,i+1,7)

c      V-rib length
       hvr(k,15)=sqrt((lvcx(i,1)-rvcx(i,1))**2.+
     + (lvcy(i,1)-rvcy(i,1))**2.)

c      Numera cintes V
       call itxt(psep-xrsep,psey-10,10.0d0,0.0d0,i,7)
       call itxt(psep+hvr(k,15)-xrsep,psey-10,10.0d0,0.0d0,i+1,7)

       end do

c      Dibuixa vores amb segments completament enllaçats       
       do j=1,20

       call line(lvcx(i,j),lvcy(i,j),lvcx(i,j+1),lvcy(i,j+1),1)
       call line(rvcx(i,j),rvcy(i,j),rvcx(i,j+1),rvcy(i,j+1),1)

       end do

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.2.5.3 Drawing V-ribs in 2D ribs, Print and MC
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box (1,2)

       sepxx=700.*xkf
       sepyy=100.*xkf

c      Rib i-1
       kx=int((float(i-2)/6.))
       ky=i-1-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

       if (hvr(k,5).eq.1) then

c      Segment
       call line(sepx+ucnt(i-1,ii,6),-vcnt(i-1,ii,6)+sepy,
     + sepx+ucnt(i-1,ii,8),-vcnt(i-1,ii,8)+sepy,1)
       call line(sepx+2530.*xkf+ucnt(i-1,ii,6),-vcnt(i-1,ii,6)+sepy,
     + sepx+2530.*xkf+ucnt(i-1,ii,8),-vcnt(i-1,ii,8)+sepy,1)

c      Punts marcatge V-rib
       alpha=datan((vcnt(i-1,ii,8)-vcnt(i-1,ii,6))/
     + (ucnt(i-1,ii,8)-ucnt(i-1,ii,6)))
       xp6=ucnt(i-1,ii,6)-xdes*dsin(alpha)+2.*xdes*dcos(alpha)
       yp6=vcnt(i-1,ii,6)+xdes*dcos(alpha)+2.*xdes*dsin(alpha)
       xp8=ucnt(i-1,ii,8)-xdes*dsin(alpha)-2.*xdes*dcos(alpha)
       yp8=vcnt(i-1,ii,8)+xdes*dcos(alpha)-2.*xdes*dsin(alpha)
       xp7=0.5*(xp6+xp8)
       yp7=0.5*(yp6+yp8)
       call point(sepx+xp6,sepy-yp6,1)
       call point(sepx+xp7,sepy-yp7,1)
       call point(sepx+xp8,sepy-yp8,1)
       call point(sepx+2530.*xkf+xp6,sepy-yp6,1)
       call point(sepx+2530.*xkf+xp7,sepy-yp7,1)
       call point(sepx+2530.*xkf+xp8,sepy-yp8,1)

       end if

c      Rib i (center)

       kx=int((float(i-1)/6.))
       ky=i-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

       call line(sepx+ucnt(i,ii,2),-vcnt(i,ii,2)+sepy,
     + sepx+ucnt(i,ii,4),-vcnt(i,ii,4)+sepy,4)

c      Rib i+1
       kx=int((float(i)/6.))
       ky=i+1-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

       if (hvr(k,6).eq.1) then

c      Segment
       call line(sepx+ucnt(i+1,ii,6),-vcnt(i+1,ii,6)+sepy,
     + sepx+ucnt(i+1,ii,8),-vcnt(i+1,ii,8)+sepy,5)
       call line(sepx+2530.*xkf+ucnt(i+1,ii,6),-vcnt(i+1,ii,6)+sepy,
     + sepx+2530.*xkf+ucnt(i+1,ii,8),-vcnt(i+1,ii,8)+sepy,5)

c      Punts marcatge V-rib
       alpha=datan((vcnt(i+1,ii,8)-vcnt(i+1,ii,6))/
     + (ucnt(i+1,ii,8)-ucnt(i+1,ii,6)))
       xp6=ucnt(i+1,ii,6)-xdes*dsin(alpha)
       yp6=vcnt(i+1,ii,6)+xdes*dcos(alpha)
       xp8=ucnt(i+1,ii,8)-xdes*dsin(alpha)
       yp8=vcnt(i+1,ii,8)+xdes*dcos(alpha)
       xp7=0.5*(xp6+xp8)
       yp7=0.5*(yp6+yp8)
       call point(sepx+xp6,sepy-yp6,1)
       call point(sepx+xp7,sepy-yp7,1)
       call point(sepx+xp8,sepy-yp8,1)
       call point(sepx+2530.*xkf+xp6,sepy-yp6,1)
       call point(sepx+2530.*xkf+xp7,sepy-yp7,1)
       call point(sepx+2530.*xkf+xp8,sepy-yp8,1)

       end if

       end if ! Type 2



ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3 V ribs full
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.1 V-ribs full but independent strips
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.1.1 Rib i
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,2).eq.3) then

c      Define main points 2,3,4,9,10,11

       i=hvr(k,3)    ! rib i
       ii=hvr(k,4)   ! row ii

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,7)*xkf
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,7)*xkf
       ucnt(i,ii,9)=ucnt(i,ii,3)-hvr(k,8)*xkf
       ucnt(i,ii,10)=ucnt(i,ii,3)
       ucnt(i,ii,11)=ucnt(i,ii,5)+hvr(k,8)*xkf

c      Points 2,3,4 interpolation in rib i
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,2).and.u(i,j+1,3).ge.ucnt(i,ii,2)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,2)=xm*ucnt(i,ii,2)+xb
       jcon(i,ii,2)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       jcon(i,ii,3)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,4).and.u(i,j+1,3).ge.ucnt(i,ii,4)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,4)=xm*ucnt(i,ii,4)+xb
       jcon(i,ii,4)=j
       end if

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat line 2-3-4 in n regular spaces   
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       uinc=0.
       vinc=0.

       do j=1,21
       ucnt2(i,ii,j)=ucnt(i,ii,2)+uinc
       uinc=uinc+(ucnt(i,ii,4)-ucnt(i,ii,2))/20.

c      Between 2 and jcon(i,ii,2)+1
       if (ucnt2(i,ii,j).le.u(i,jcon(i,ii,2)+1,3)) then
       xm=(v(i,jcon(i,ii,2)+1,3)-vcnt(i,ii,2))/(u(i,jcon(i,ii,2)+1,3)-
     + ucnt(i,ii,2))
       xb=vcnt(i,ii,2)-xm*ucnt(i,ii,2)
       vcnt2(i,ii,j)=xm*ucnt2(i,ii,j)+xb
       end if

c      Between jcon(i,ii,2)+1 and jcon(i,ii,4)

       if (ucnt2(i,ii,j).ge.u(i,jcon(i,ii,2)+1,3).and.ucnt2(i,ii,j)
     + .le.u(i,jcon(i,ii,4),3)) then
c      
       do l=jcon(i,ii,2)+1,jcon(i,ii,4)-1

c      Seleccionar tram d'interpolació

       if (ucnt2(i,ii,j).ge.u(i,l,3).and.ucnt2(i,ii,j).le.u(i,l+1,3)) 
     + then
       xm=(v(i,l+1,3)-v(i,l,3))/(u(i,l+1,3)-u(i,l,3))
       xb=v(i,l,3)-xm*u(i,l,3)
       end if
       end do
c       xm=(v(i,jcon(i,ii,2)+j,3)-v(i,jcon(i,ii,2)+j-1,3))/
c     + (u(i,jcon(i,ii,2)+j,3)-u(i,jcon(i,ii,2)+j-1,3))
c       xb=v(i,jcon(i,ii,2)+j-1,3)-xm*u(i,jcon(i,ii,2)+j-1,3)
c      !!!!!!!!!!!!!Revisar
       vcnt2(i,ii,j)=xm*ucnt2(i,ii,j)+xb
       end if

c      Between jcon(i,ii,4) and 4       
       if (ucnt2(i,ii,j).gt.u(i,jcon(i,ii,4),3)) then
       xm=(vcnt(i,ii,4)-v(i,jcon(i,ii,4),3))/(ucnt(i,ii,4)-
     + u(i,jcon(i,ii,4),3))
       xb=vcnt(i,ii,4)-xm*ucnt(i,ii,4)
       vcnt2(i,ii,j)=xm*ucnt2(i,ii,j)+xb
       end if

       end do



ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.1.2 Rib i-1
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)-1
       ii=hvr(k,4)

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,1)=ucnt(i,ii,3)-hvr(k,8)*xkf
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,7)*xkf
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,7)*xkf
       ucnt(i,ii,5)=ucnt(i,ii,3)+hvr(k,8)*xkf
       ucnt(i,ii,6)=ucnt(i,ii,1)
       ucnt(i,ii,7)=ucnt(i,ii,3)
       ucnt(i,ii,8)=ucnt(i,ii,5)
       ucnt(i,ii,9)=ucnt(i,ii,1)
       ucnt(i,ii,10)=ucnt(i,ii,3)
       ucnt(i,ii,11)=ucnt(i,ii,5)

c      Points 1,3,5 interpolation in rib i-1
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,1).and.u(i,j+1,3).ge.ucnt(i,ii,1)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,1)=xm*ucnt(i,ii,1)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,5).and.u(i,j+1,3).ge.ucnt(i,ii,5)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,5)=xm*ucnt(i,ii,5)+xb
       end if

       end do

c      Points 9,10,11 interpolation in rib i-1
       do j=1,np(i,2)

       if (u(i,j,3).gt.ucnt(i,ii,9).and.u(i,j+1,3).le.ucnt(i,ii,9)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,9)=xm*ucnt(i,ii,9)+xb
       jcon(i,ii,9)=j+1
       end if

       if (u(i,j,3).gt.ucnt(i,ii,10).and.u(i,j+1,3).le.ucnt(i,ii,10)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,10)=xm*ucnt(i,ii,10)+xb
       jcon(i,ii,10)=j+1
       end if

       if (u(i,j,3).gt.ucnt(i,ii,11).and.u(i,j+1,3).le.ucnt(i,ii,11)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,11)=xm*ucnt(i,ii,11)+xb
       jcon(i,ii,11)=j+1
       end if

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat 9-10-11 in n spaces (rib i-1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
   
c      Reformat in 20 spaces

       n1vr=jcon(i,ii,9)-jcon(i,ii,11)+1    
       n2vr=20+1

c      Load data polyline
       xlin1(1)=ucnt(i,ii,9)
       ylin1(1)=vcnt(i,ii,9)
       do j=2,n1vr-1
       xlin1(j)=u(i,jcon(i,ii,9)-j+1,3)
       ylin1(j)=v(i,jcon(i,ii,9)-j+1,3)
c      MIRAR SI CAL +-1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       end do
       xlin1(n1vr)=ucnt(i,ii,11)
       ylin1(n1vr)=vcnt(i,ii,11)

c      Call subroutine vector redistribution

       call vredis(xlin1,ylin1,xlin3,ylin3,n1vr,n2vr)

c      Load result polyline

       do j=1,n2vr
       ucnt1(i,ii,j)=xlin3(j)
       vcnt1(i,ii,j)=ylin3(j)
       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.1.3 Rib i+1
cccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)+1
       ii=hvr(k,4)

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,1)=ucnt(i,ii,3)-hvr(k,8)*xkf
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,7)*xkf
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,7)*xkf
       ucnt(i,ii,5)=ucnt(i,ii,3)+hvr(k,8)*xkf
       ucnt(i,ii,6)=ucnt(i,ii,1)
       ucnt(i,ii,7)=ucnt(i,ii,3)
       ucnt(i,ii,8)=ucnt(i,ii,5)
       ucnt(i,ii,9)=ucnt(i,ii,1)
       ucnt(i,ii,10)=ucnt(i,ii,3)
       ucnt(i,ii,11)=ucnt(i,ii,5)

c      Points 1,3,5 interpolation in rib i+1
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,1).and.u(i,j+1,3).ge.ucnt(i,ii,1)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,1)=xm*ucnt(i,ii,1)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,5).and.u(i,j+1,3).ge.ucnt(i,ii,5)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,5)=xm*ucnt(i,ii,5)+xb
       end if

       end do

c      Points 9,10,11 interpolation in rib i+1
       do j=1,np(i,2)

       if (u(i,j,3).gt.ucnt(i,ii,9).and.u(i,j+1,3).le.ucnt(i,ii,9)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,9)=xm*ucnt(i,ii,9)+xb
       jcon(i,ii,9)=j+1
       end if

       if (u(i,j,3).gt.ucnt(i,ii,10).and.u(i,j+1,3).le.ucnt(i,ii,10)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,10)=xm*ucnt(i,ii,10)+xb
       jcon(i,ii,10)=j+1
       end if

       if (u(i,j,3).gt.ucnt(i,ii,11).and.u(i,j+1,3).le.ucnt(i,ii,11)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,11)=xm*ucnt(i,ii,11)+xb
       jcon(i,ii,11)=j+1
       end if

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat 9-10-11 in n spaces (rib i+1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Experimental version     
c      Reformat in 20 spaces

       n1vr=jcon(i,ii,9)-jcon(i,ii,11)+1
       n2vr=20+1

c      Load data polyline
       xlin1(1)=ucnt(i,ii,9)
       ylin1(1)=vcnt(i,ii,9)
       do j=2,n1vr-1
       xlin1(j)=u(i,jcon(i,ii,9)-j+1,3)
       ylin1(j)=v(i,jcon(i,ii,9)-j+1,3)
c      MIRAR SI CAL +-1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       end do
       xlin1(n1vr)=ucnt(i,ii,11)
       ylin1(n1vr)=vcnt(i,ii,11)

c      Call subroutine vector redistribution

       call vredis(xlin1,ylin1,xlin3,ylin3,n1vr,n2vr)

c      Load result polyline

       do j=1,n2vr
       ucnt3(i,ii,j)=xlin3(j)
       vcnt3(i,ii,j)=ylin3(j)
       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Rib localisation
       i=hvr(k,3)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.1.4 V-ribs lines 1 2 3 transportation to 3D espace
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Rib i-1 (Line 1)

       i=hvr(k,3)-1

       tetha=rib(i,8)*pi/180.

       do j=1,21
       ru(i,j,3)=ucnt1(i,ii,j)
       rv(i,j,3)=vcnt1(i,ii,j)-rib(i,50)
       end do

       do j=1,21

c      V-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      V-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      V-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       rx1(i+1,j,ii)=rx(i,j)
       ry1(i+1,j,ii)=ry(i,j)
       rz1(i+1,j,ii)=rz(i,j)

       end do

c      Rib i (Line 2)

       i=hvr(k,3)

       tetha=rib(i,8)*pi/180.
       
       do j=1,21
       ru(i,j,3)=ucnt2(i,ii,j)
       rv(i,j,3)=vcnt2(i,ii,j)-rib(i,50)
       end do

       do j=1,21

c      V-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      V-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      V-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       rx2(i,j,ii)=rx(i,j)
       ry2(i,j,ii)=ry(i,j)
       rz2(i,j,ii)=rz(i,j)

       end do

c      Rib i+1 (Line 3)

       i=hvr(k,3)+1

       tetha=rib(i,8)*pi/180.

       do j=1,21
       ru(i,j,3)=ucnt3(i,ii,j)
       rv(i,j,3)=vcnt3(i,ii,j)-rib(i,50)
c      COMPTE AMB el rib(i,50) A ESTUDIAR       
       end do

       do j=1,21

c      V-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      V-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      V-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       rx3(i-1,j,ii)=rx(i,j)
       ry3(i-1,j,ii)=ry(i,j)
       rz3(i-1,j,ii)=rz(i,j)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.1.5 V-ribs calculus and drawing in 3D and 2D
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.1.5.1 V-rib 1-2 in 2D model (blue)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)-1

       px0=0.
       py0=0.
       ptheta=0.

       do j=1,21

c      Distances between points
       pa=sqrt((rx(i+1,j)-rx(i,j))**2.+(ry(i+1,j)-ry(i,j))**2.+
     + (rz(i+1,j)-rz(i,j))**2.)
       pb=sqrt((rx(i+1,j+1)-rx(i,j))**2.+(ry(i+1,j+1)-ry(i,j))**2.+
     + (rz(i+1,j+1)-rz(i,j))**2.)
       pc=sqrt((rx(i+1,j+1)-rx(i+1,j))**2.+(ry(i+1,j+1)-ry(i+1,j))**2.+
     + (rz(i+1,j+1)-rz(i+1,j))**2.)
       pd=sqrt((rx(i+1,j)-rx(i,j+1))**2.+(ry(i+1,j)-ry(i,j+1))**2.+
     + (rz(i+1,j)-rz(i,j+1))**2.)
       pe=sqrt((rx(i,j+1)-rx(i,j))**2.+(ry(i,j+1)-ry(i,j))**2.+
     + (rz(i,j+1)-rz(i,j))**2.)
       pf=sqrt((rx(i+1,j+1)-rx(i,j+1))**2.+(ry(i+1,j+1)-ry(i,j+1))**2.+
     + (rz(i+1,j+1)-rz(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

       pb2t=(pb*pb-pe*pe+pf*pf)/(2.*pb)
       pb1t=pb-pb2t
       pht=sqrt(pf*pf-pb2t*pb2t)
       
       pw1=datan(phr/pa1r)
       phu=pb1t*dtan(pw1)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0
       
       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

c      Iteration
       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
       
       end do

c      Drawing in 2D model
       
       psep=3300.*xkf+xrsep*float(i)
       psey=800.*xkf+yrsep*float(ii)

       if (hvr(k,5).eq.1) then

       j=1
c      Costat vora atac
       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),5)

       j=21
c      Costat fuga
       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),5)

c      Marca punts MC a l'esquerra

       alpha=-(datan((pl1y(i,1)-pl2y(i,20))/(pl1x(i,1)-pl2x(i,20))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xp6=pl1x(i,1)-xdes*dsin(alpha)-2.*xdes*dcos(alpha)
       yp6=pl1y(i,1)-xdes*dcos(alpha)+2.*xdes*dsin(alpha)
       xp8=pl1x(i,21)-xdes*dsin(alpha)+2.*xdes*dcos(alpha)
       yp8=pl1y(i,21)-xdes*dcos(alpha)-2.*xdes*dsin(alpha)
       xp7=0.5*(xp6+xp8)
       yp7=0.5*(yp6+yp8)

       call point(psep+xp6,psey+yp6,1)
c       call point(psep+xp7,psey+yp7,1)
       call point(psep+xp8,psey+yp8,1)

c     Romano costat esquerra

      sl=1.
       
      xpx=(pl1x(i,1)+pl2x(i,20))/2.-xdes*dsin(alpha)
      xpy=(pl1y(i,1)+pl2y(i,20))/2.-xdes*dcos(alpha)

      xpx2=psep+xpx+0.5*hvr(k,8)*dcos(alpha)-0.3*xvrib*dsin(alpha)
      xpy2=psey+xpy-0.5*hvr(k,8)*dsin(alpha)-0.3*xvrib*dcos(alpha) 

      call romano(i,xpx2,xpy2,alpha,0.4d0,3)

      xpx2=psep+xpx-0.5*hvr(k,8)*dcos(alpha)-0.3*xvrib*dsin(alpha)
      xpy2=psey+xpy+0.5*hvr(k,8)*dsin(alpha)-0.3*xvrib*dcos(alpha) 

      call romano(int(hvr(k,4)),xpx2,xpy2,alpha,0.4d0,7)


c      Marca punts MC a la dreta

       alpha=-(datan((pr1y(i,1)-pr2y(i,20))/(pr1x(i,1)-pr2x(i,20))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xp7=0.5*(pr1x(i,1)+pr2x(i,20))+xdes*dsin(alpha)
       yp7=0.5*(pr1y(i,1)+pr2y(i,20))+xdes*dcos(alpha)

       call point(psep+xp7,psey+yp7,3)


c     Romano costat dret

      sr=1.
       
      xpx=(pr1x(i,1)+pr2x(i,20))/2.+xdes*dsin(alpha)
      xpy=(pr1y(i,1)+pr2y(i,20))/2.+xdes*dcos(alpha)

      xpx2=psep+xpx+0.3*hvr(k,7)*dcos(alpha)+0.3*xvrib*dsin(alpha)
      xpy2=psey+xpy-0.3*hvr(k,7)*dsin(alpha)+0.3*xvrib*dcos(alpha) 

      call romano(i+1,xpx2,xpy2,alpha,0.4d0,3)
       
       do j=1,21-1

c      Vores de costura esquerra
       alpl=-(datan((pl1y(i,j)-pl2y(i,j))/(pl1x(i,j)-pl2x(i,j))))
       if (alpl.lt.0.) then
       alpl=alpl+pi
       end if

       lvcx(i,j)=psep+pl1x(i,j)-xvrib*dsin(alpl)
       lvcy(i,j)=psey+pl1y(i,j)-xvrib*dcos(alpl)

c      Vores de costura dreta
       alpr=-(datan((pr1y(i,j)-pr2y(i,j))/(pr1x(i,j)-pr2x(i,j))))
       if (alpr.lt.0.) then
       alpr=alpr+pi
       end if

       rvcx(i,j)=psep+pr1x(i,j)+xvrib*dsin(alpr)
       rvcy(I,j)=psey+pr1y(i,j)+xvrib*dcos(alpr)

c      Tancament lateral inici
       if (j.eq.1) then
       call line(psep+pl1x(i,j)-xvrib*dsin(alpl),psey+pl1y(i,j)
     + -xvrib*dcos(alpl),psep+pl1x(i,j),psey+pl1y(i,j),5)
       call line(psep+pr1x(i,j)+xvrib*dsin(alpr),psey+pr1y(i,j)
     + +xvrib*dcos(alpr),psep+pr1x(i,j),psey+pr1y(i,j),5)
       end if

c      Tancament lateral fi
       if (j.eq.20) then
       call line(psep+pl2x(i,j)-xvrib*dsin(alpl),psey+pl2y(i,j)
     + -xvrib*dcos(alpl),psep+pl2x(i,j),psey+pl2y(i,j),5)
       call line(psep+pr2x(i,j)+xvrib*dsin(alpr),psey+pr2y(i,j)
     + +xvrib*dcos(alpr),psep+pr2x(i,j),psey+pr2y(i,j),5)

       lvcx(i,j+1)=psep+pl2x(i,j)-xvrib*dsin(alpl)
       lvcy(i,j+1)=psey+pl2y(i,j)-xvrib*dcos(alpl)

       rvcx(i,j+1)=psep+pr2x(i,j)+xvrib*dsin(alpr)
       rvcy(i,j+1)=psey+pr2y(i,j)+xvrib*dcos(alpr)

       end if

c      V-rib length
       hvr(k,15)=sqrt((lvcx(i,1)-rvcx(i,1))**2.+
     + (lvcy(i,1)-rvcy(i,1))**2.)

c      Numera cintes V Type 3
       call itxt(psep-xrsep,psey-10,10.0d0,0.0d0,i,7)
       call itxt(psep+hvr(k,15)-xrsep,psey-10,10.0d0,0.0d0,i+1,7)
       
       end do

c      Dibuixa vores amb segments completament enllaçats       
       do j=1,20

       call line(lvcx(i,j),lvcy(i,j),lvcx(i,j+1),lvcy(i,j+1),5)
       call line(rvcx(i,j),rvcy(i,j),rvcx(i,j+1),rvcy(i,j+1),5)

       end do

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.1.5.2 V-rib 2-3 in 2D model (red)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)

       px0=0.
       py0=0.
       ptheta=0.

       do j=1,21

c      Distances between points
       pa=sqrt((rx(i+1,j)-rx(i,j))**2.+(ry(i+1,j)-ry(i,j))**2.+
     + (rz(i+1,j)-rz(i,j))**2.)
       pb=sqrt((rx(i+1,j+1)-rx(i,j))**2.+(ry(i+1,j+1)-ry(i,j))**2.+
     + (rz(i+1,j+1)-rz(i,j))**2.)
       pc=sqrt((rx(i+1,j+1)-rx(i+1,j))**2.+(ry(i+1,j+1)-ry(i+1,j))**2.+
     + (rz(i+1,j+1)-rz(i+1,j))**2.)
       pd=sqrt((rx(i+1,j)-rx(i,j+1))**2.+(ry(i+1,j)-ry(i,j+1))**2.+
     + (rz(i+1,j)-rz(i,j+1))**2.)
       pe=sqrt((rx(i,j+1)-rx(i,j))**2.+(ry(i,j+1)-ry(i,j))**2.+
     + (rz(i,j+1)-rz(i,j))**2.)
       pf=sqrt((rx(i+1,j+1)-rx(i,j+1))**2.+(ry(i+1,j+1)-ry(i,j+1))**2.+
     + (rz(i+1,j+1)-rz(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

       pb2t=(pb*pb-pe*pe+pf*pf)/(2.*pb)
       pb1t=pb-pb2t
       pht=sqrt(pf*pf-pb2t*pb2t)
       
       pw1=datan(phr/pa1r)
       phu=pb1t*dtan(pw1)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0
       
       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

c      Iteration
       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
       
       
       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Drawing in 2D model
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       
       psep=3300.*xkf+xrsep*float(i)
       psey=800.*xkf+yrsep*float(ii)

       if (hvr(k,6).eq.1) then

       j=1

c      Costat vora d'atac
       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),1)

       j=21
c      Costat fuga
       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),1)


c      Marca punts MC a l'esquerra

       alpha=-(datan((pl1y(i,1)-pl2y(i,20))/(pl1x(i,1)-pl2x(i,20))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xp7=0.5*(pl1x(i,1)+pl1x(i,21))-xdes*dsin(alpha)
       yp7=0.5*(pl1y(i,1)+pl1y(i,21))-xdes*dcos(alpha)

       call point(psep+xp7,psey+yp7,1)

c      Romano costat esquerra

       sl=1.
       
       xpx=(pl1x(i,1)+pl2x(i,20))/2.-sl*xdes*dsin(alpha)
       xpy=(pl1y(i,1)+pl2y(i,20))/2.-sl*xdes*dcos(alpha)

       xpx2=psep+xpx+0.3*hvr(k,7)*dcos(alpha)-0.3*xvrib*dsin(alpha)
       xpy2=psey+xpy-0.3*hvr(k,7)*dsin(alpha)-0.3*xvrib*dcos(alpha) 

       call romano(i,xpx2,xpy2,alpha,0.4d0,3)

c      Marca punts MC a la dreta

       alpha=-(datan((pr1y(i,1)-pr2y(i,20))/(pr1x(i,1)
     + -pr2x(i,20))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xp6=pr1x(i,1)+xdes*dsin(alpha)-2.*xdes*dcos(alpha)
       yp6=pr1y(i,1)+xdes*dcos(alpha)+2.*xdes*dsin(alpha)
       xp8=pr1x(i,21)+xdes*dsin(alpha)+2.*xdes*dcos(alpha)
       yp8=pr1y(i,21)+xdes*dcos(alpha)-2.*xdes*dsin(alpha)
       xp7=0.5*(xp6+xp8)
       yp7=0.5*(yp6+yp8)

       call point(psep+xp6,psey+yp6,1)
c       call point(psep+xp7,psey+yp7,1)
       call point(psep+xp8,psey+yp8,1)

c      Romano costat dret

       sr=1.
       
       xpx=(pr1x(i,1)+pr2x(i,20))/2.+xdes*dsin(alpha)
       xpy=(pr1y(i,1)+pr2y(i,20))/2.+xdes*dcos(alpha)

       xpx2=psep+xpx+0.5*hvr(k,8)*dcos(alpha)+0.3*xvrib*dsin(alpha)
       xpy2=psey+xpy-0.5*hvr(k,8)*dsin(alpha)+0.3*xvrib*dcos(alpha) 

       call romano(i+1,xpx2,xpy2,alpha,0.4d0,3)

       xpx2=psep+xpx-0.5*hvr(k,8)*dcos(alpha)+0.3*xvrib*dsin(alpha)
       xpy2=psey+xpy+0.5*hvr(k,8)*dsin(alpha)+0.3*xvrib*dcos(alpha) 

       call romano(int(hvr(k,4)),xpx2,xpy2,alpha,0.4d0,3)

c      Vores de costura

       do j=1,21-1

c      Vores de costura esquerra
       alpl=-(datan((pl1y(i,j)-pl2y(i,j))/(pl1x(i,j)-pl2x(i,j))))
       if (alpl.lt.0.) then
       alpl=alpl+pi
       end if

       lvcx(i,j)=psep+pl1x(i,j)-xvrib*dsin(alpl)
       lvcy(i,j)=psey+pl1y(i,j)-xvrib*dcos(alpl)

c      Vores de costura dreta
       alpr=-(datan((pr1y(i,j)-pr2y(i,j))/(pr1x(i,j)-pr2x(i,j))))
       if (alpr.lt.0.) then
       alpr=alpr+pi
       end if

       rvcx(i,j)=psep+pr1x(i,j)+xvrib*dsin(alpr)
       rvcy(i,j)=psey+pr1y(i,j)+xvrib*dcos(alpr)

c      Tancament lateral inici
       if (j.eq.1) then
       call line(psep+pl1x(i,j)-xvrib*dsin(alpl),psey+pl1y(i,j)
     + -xvrib*dcos(alpl),psep+pl1x(i,j),psey+pl1y(i,j),1)
       call line(psep+pr1x(i,j)+xvrib*dsin(alpr),psey+pr1y(i,j)
     + +xvrib*dcos(alpr),psep+pr1x(i,j),psey+pr1y(i,j),1)
       end if

c      Tancament lateral fi
       if (j.eq.20) then
       call line(psep+pl2x(i,j)-xvrib*dsin(alpl),psey+pl2y(i,j)
     + -xvrib*dcos(alpl),psep+pl2x(i,j),psey+pl2y(i,j),1)
       call line(psep+pr2x(i,j)+xvrib*dsin(alpr),psey+pr2y(i,j)
     + +xvrib*dcos(alpr),psep+pr2x(i,j),psey+pr2y(i,j),1)

       lvcx(i,j+1)=psep+pl2x(i,j)-xvrib*dsin(alpl)
       lvcy(i,j+1)=psey+pl2y(i,j)-xvrib*dcos(alpl)

       rvcx(i,j+1)=psep+pr2x(i,j)+xvrib*dsin(alpr)
       rvcy(i,j+1)=psey+pr2y(i,j)+xvrib*dcos(alpr)

       end if

c      V-rib length
       hvr(k,15)=sqrt((lvcx(i,1)-rvcx(i,1))**2.+
     + (lvcy(i,1)-rvcy(i,1))**2.)

c      Numera cintes V Type 3
       call itxt(psep-xrsep,psey-10,10.0d0,0.0d0,i,7)
       call itxt(psep+hvr(k,15)-xrsep,psey-10,10.0d0,0.0d0,i+1,7)

       end do

c      Dibuixa vores amb segments completament enllaçats       
       do j=1,20

       call line(lvcx(i,j),lvcy(i,j),lvcx(i,j+1),lvcy(i,j+1),1)
       call line(rvcx(i,j),rvcy(i,j),rvcx(i,j+1),rvcy(i,j+1),1)

       end do

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.1.5.3 Drawing V-ribs marks in 2D ribs
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Drawing in 2D ribs printing
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box (1,2)

       sepxx=700.*xkf
       sepyy=100.*xkf

c      Rib i-1
       kx=int((float(i-2)/6.))
       ky=i-1-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

       if (hvr(k,5).eq.1) then
       call line(sepx+ucnt(i-1,ii,9),-vcnt(i-1,ii,9)+sepy,
     + sepx+ucnt(i-1,ii,11),-vcnt(i-1,ii,11)+sepy,4)

c      Draw 3 point in 9 and 11

       alpha=(datan((v(i-1,jcon(i-1,ii,9)-1,3)-v(i-1,jcon(i-1,ii,9)+1,
     + 3))/(u(i-1,jcon(i-1,ii,9)-1,3)-u(i-1,jcon(i-1,ii,9)+1,3))))
       if (alpha.lt.0.) then
c       alpha=alpha+pi
       end if

       xpeq=ucnt(i-1,ii,9)-1.*xdes*dsin(alpha)
       ypeq=vcnt(i-1,ii,9)+1.*xdes*dcos(alpha)

       call point(sepx+xpeq,sepy-ypeq,92)
       call point(sepx+xpeq+1*dsin(alpha),sepy-ypeq+1*dcos(alpha),92)
       call point(sepx+xpeq+2*dsin(alpha),sepy-ypeq+2*dcos(alpha),92)

       call point(2530.*xkf+sepx+xpeq,sepy-ypeq,2)
       call point(2530.*xkf+sepx+xpeq+1*dsin(alpha),sepy-ypeq+
     + 1*dcos(alpha),92)
       call point(2530.*xkf+sepx+xpeq+2*dsin(alpha),sepy-ypeq+
     + 2*dcos(alpha),92)


       alpha=(datan((v(i-1,jcon(i-1,ii,11)-1,3)-v(i-1,jcon(i-1,ii,11)+1,
     + 3))/(u(i-1,jcon(i-1,ii,11)-1,3)-u(i-1,jcon(i-1,ii,11)+1,3))))
       if (alpha.lt.0.) then
c       alpha=alpha+pi
       end if

       xpeq=ucnt(i-1,ii,11)-1.*xdes*dsin(alpha)
       ypeq=vcnt(i-1,ii,11)+1.*xdes*dcos(alpha)

       call point(sepx+xpeq,sepy-ypeq,92)
       call point(sepx+xpeq+1*dsin(alpha),sepy-ypeq+1*dcos(alpha),92)
       call point(sepx+xpeq+2*dsin(alpha),sepy-ypeq+2*dcos(alpha),92)

       call point(2530.*xkf+sepx+xpeq,sepy-ypeq,92)
       call point(2530.*xkf+sepx+xpeq+1*dsin(alpha),sepy-ypeq+
     + 1*dcos(alpha),92)
       call point(2530.*xkf+sepx+xpeq+2*dsin(alpha),sepy-ypeq+
     + 2*dcos(alpha),92)

c      Marks in V-rib
       alpha=datan((vcnt(i-1,ii,11)-vcnt(i-1,ii,9))/
     + (ucnt(i-1,ii,11)-ucnt(i-1,ii,9)))

       xp9=ucnt(i-1,ii,9)-xdes*dsin(alpha)+2.*xdes*dcos(alpha)
       yp9=vcnt(i-1,ii,9)+xdes*dcos(alpha)+2.*xdes*dsin(alpha)

       xp11=ucnt(i-1,ii,11)-xdes*dsin(alpha)-2.*xdes*dcos(alpha)
       yp11=vcnt(i-1,ii,11)+xdes*dcos(alpha)-2.*xdes*dsin(alpha)

       xu=sepx+xp9
       xv=-sepy+yp9
c       call pointg(xu,xv,xcir,1)
       xu=sepx+xp11
       xv=-sepy+yp11
c       call pointg(xu,xv,xcir,1)

       end if

c      Rib i (center)
       kx=int((float(i-1)/6.))
       ky=i-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

       call line(sepx+ucnt(i,ii,2),-vcnt(i,ii,2)+sepy,
     + sepx+ucnt(i,ii,4),-vcnt(i,ii,4)+sepy,4)

c      Rib i+1
       kx=int((float(i)/6.))
       ky=i+1-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

       if (hvr(k,6).eq.1) then
       call line(sepx+ucnt(i+1,ii,9),-vcnt(i+1,ii,9)+sepy,
     + sepx+ucnt(i+1,ii,11),-vcnt(i+1,ii,11)+sepy,3)

c      Punts marcatge V-rib
       alpha=datan((vcnt(i+1,ii,11)-vcnt(i+1,ii,9))/
     + (ucnt(i+1,ii,11)-ucnt(i+1,ii,9)))

       xp9=ucnt(i+1,ii,9)-xdes*dsin(alpha)
       yp9=vcnt(i+1,ii,9)+xdes*dcos(alpha)

       xp11=ucnt(i+1,ii,11)-xdes*dsin(alpha)
       yp11=vcnt(i+1,ii,11)+xdes*dcos(alpha)

       xu=sepx+xp9
       xv=-sepy+yp9
c       call pointg(xu,xv,xcir,1)
       xu=sepx+xp11
       xv=-sepy+yp11
c       call pointg(xu,xv,xcir,1)

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Drawing V-ribs in 2D ribs mesa corte
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box (1,2)

       sepxx=700.*xkf
       sepyy=100.*xkf

c      Rib i-1
       kx=int((float(i-2)/6.))
       ky=i-1-kx*6

       sepx=2530.*xkf+sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

       if (hvr(k,5).eq.1) then
c      Segment               
       call line(sepx+ucnt(i-1,ii,9),-vcnt(i-1,ii,9)+sepy,
     + sepx+ucnt(i-1,ii,11),-vcnt(i-1,ii,11)+sepy,4)

c      Punts marcatge V-rib
       alpha=datan((vcnt(i-1,ii,11)-vcnt(i-1,ii,9))/
     + (ucnt(i-1,ii,11)-ucnt(i-1,ii,9)))

       xp9=ucnt(i-1,ii,9)-xdes*dsin(alpha)+2.*xdes*dcos(alpha)
       yp9=vcnt(i-1,ii,9)+xdes*dcos(alpha)+2.*xdes*dsin(alpha)

       xp11=ucnt(i-1,ii,11)-xdes*dsin(alpha)-2.*xdes*dcos(alpha)
       yp11=vcnt(i-1,ii,11)+xdes*dcos(alpha)-2.*xdes*dsin(alpha)

       call point(sepx+xp9,sepy-yp9,3)
       call point(sepx+xp11,sepy-yp11,3)

       end if


c      Rib i+1
       kx=int((float(i)/6.))
       ky=i+1-kx*6

       sepx=2530.*xkf+sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

       if (hvr(k,6).eq.1) then
c      Segment  
       call line(sepx+ucnt(i+1,ii,9),-vcnt(i+1,ii,9)+sepy,
     + sepx+ucnt(i+1,ii,11),-vcnt(i+1,ii,11)+sepy,3)


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Draw 3 point in 9 and 11

       alpha=(datan((v(i+1,jcon(i+1,ii,9)-1,3)-v(i+1,jcon(i+1,ii,9)+1,
     + 3))/(u(i+1,jcon(i+1,ii,9)-1,3)-u(i+1,jcon(i+1,ii,9)+1,3))))
       if (alpha.lt.0.) then
c       alpha=alpha+pi
       end if

       xpeq=ucnt(i+1,ii,9)-1.*xdes*dsin(alpha)
       ypeq=vcnt(i+1,ii,9)+1.*xdes*dcos(alpha)

       call point(sepx+xpeq,sepy-ypeq,92)
       call point(sepx+xpeq+1*dsin(alpha),sepy-ypeq+1*dcos(alpha),92)
       call point(sepx+xpeq+2*dsin(alpha),sepy-ypeq+2*dcos(alpha),92)

       call point(-2530.*xkf+sepx+xpeq,sepy-ypeq,92)
       call point(-2530.*xkf+sepx+xpeq+1*dsin(alpha),sepy-ypeq+
     + 1*dcos(alpha),92)
       call point(-2530.*xkf+sepx+xpeq+2*dsin(alpha),sepy-ypeq+
     + 2*dcos(alpha),92)


       alpha=(datan((v(i+1,jcon(i+1,ii,11)-1,3)-v(i+1,jcon(i+1,ii,11)+1,
     + 3))/(u(i+1,jcon(i+1,ii,11)-1,3)-u(i+1,jcon(i+1,ii,11)+1,3))))
       if (alpha.lt.0.) then
c       alpha=alpha+pi
       end if

       xpeq=ucnt(i+1,ii,11)-1.*xdes*dsin(alpha)
       ypeq=vcnt(i+1,ii,11)+1.*xdes*dcos(alpha)

       call point(sepx+xpeq,sepy-ypeq,92)
       call point(sepx+xpeq+1*dsin(alpha),sepy-ypeq+1*dcos(alpha),92)
       call point(sepx+xpeq+2*dsin(alpha),sepy-ypeq+2*dcos(alpha),92)

       call point(-2530.*xkf+sepx+xpeq,sepy-ypeq,5)
       call point(-2530.*xkf+sepx+xpeq+1*dsin(alpha),sepy-ypeq+
     + 1*dcos(alpha),92)
       call point(-2530.*xkf+sepx+xpeq+2*dsin(alpha),sepy-ypeq+
     + 2*dcos(alpha),92)



ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

           
c      Punts marcatge V-rib
       alpha=datan((vcnt(i+1,ii,11)-vcnt(i+1,ii,9))/
     + (ucnt(i+1,ii,11)-ucnt(i+1,ii,9)))

       xp9=ucnt(i+1,ii,9)-xdes*dsin(alpha)
       yp9=vcnt(i+1,ii,9)+xdes*dcos(alpha)

       xp11=ucnt(i+1,ii,11)-xdes*dsin(alpha)
       yp11=vcnt(i+1,ii,11)+xdes*dcos(alpha)

       call point(sepx+xp9,sepy-yp9,3)
       call point(sepx+xp11,sepy-yp11,3)

       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Draw V-rib type 3 in 3D model
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Left rib
       if (hvr(k,5).eq.1) then

       do j=1,21
       call line3d(rx2(i,j,ii),ry2(i,j,ii),rz2(i,j,ii),
     + rx1(i,j,ii),ry1(i,j,ii),rz1(i,j,ii),4)
       call line3d(-rx2(i,j,ii),ry2(i,j,ii),rz2(i,j,ii),
     + -rx1(i,j,ii),ry1(i,j,ii),rz1(i,j,ii),4)
       end do

       end if


c      Right rib
       if (hvr(k,6).eq.1) then

       do j=1,21
       call line3d(rx2(i,j,ii),ry2(i,j,ii),rz2(i,j,ii),
     + rx3(i,j,ii),ry3(i,j,ii),rz3(i,j,ii),3)
       call line3d(-rx2(i,j,ii),ry2(i,j,ii),rz2(i,j,ii),
     + -rx3(i,j,ii),ry3(i,j,ii),rz3(i,j,ii),3)
       end do

       end if


c      end if V-rib type 3

       end if




ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.2 Continuous full V-rib
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,2).eq.5) then

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.2.1 Rib i points 2,3,4
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Define main points 2,3,4,9,10,11

       i=hvr(k,3)    ! rib i
c      PLEASE make max hvr(k,4)=rib(i,15)
       ii=hvr(k,4)   ! row ii
      
       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,10)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,10)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Points 2,3,4 interpolation in rib i
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,2).and.u(i,j+1,3).ge.ucnt(i,ii,2)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,2)=xm*ucnt(i,ii,2)+xb
       jcon(i,ii,2)=j

c      First 2
       if (ii.eq.1) then
       xtu2(i)=ucnt(i,ii,2)
       xtv2(i)=vcnt(i,ii,2)
       jcon2(i,ii,2)=jcon(i,ii,2)

c      Calcule te-2
       rib(i,102)=0.
       do jj=np(i,1),jcon2(i,ii,2)+2,-1
       rib(i,102)=rib(i,102)+sqrt((u(i,jj-1,3)-u(i,jj,3))**2+
     + (v(i,jj-1,3)-v(i,jj,3))**2)
       end do
       rib(i,102)=rib(i,102)+sqrt((u(i,jcon2(i,ii,2)+1,3)-ucnt(i,ii,2))
     + **2+(v(i,jcon2(i,ii,2)+1,3)-vcnt(i,ii,2))**2)

       end if

       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       jcon(i,ii,3)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,4).and.u(i,j+1,3).ge.ucnt(i,ii,4)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,4)=xm*ucnt(i,ii,4)+xb
       jcon(i,ii,4)=j

c      Last 4
       if (ii.eq.rib(i,15)) then
       xtu4(i)=ucnt(i,ii,4)
       xtv4(i)=vcnt(i,ii,4)
       jcon4(i,ii,4)=jcon(i,ii,4)

c      Calcule te-4
       rib(i,104)=0.
       do jj=np(i,1),jcon4(i,ii,4)+2,-1
       rib(i,104)=rib(i,104)+sqrt((u(i,jj-1,3)-u(i,jj,3))**2+
     + (v(i,jj-1,3)-v(i,jj,3))**2)
       end do
       rib(i,104)=rib(i,104)+sqrt((u(i,jcon4(i,ii,4)+1,3)-ucnt(i,ii,4))
     + **2+(v(i,jcon4(i,ii,4)+1,3)-vcnt(i,ii,4))**2)
c      Verificar graficament que OK

       end if

       end if

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Continue calculus c ii max
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,4).eq.rib(i,15)) then

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat line "2" in n spaces
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Reformat in 120 spaces
       n1vr=jcon4(i,int(rib(i,15)),4)-jcon2(i,1,2)+1
       n2vr=121

c      Load data polyline
       xlin1(1)=xtu2(i)
       ylin1(1)=xtv2(i)
       do j=2,n1vr-1
       xlin1(j)=u(i,jcon2(i,1,2)+j-1,3)
       ylin1(j)=v(i,jcon2(i,1,2)+j-1,3)
c      MIRAR SI CAL +-1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       end do
       xlin1(n1vr)=xtu4(i)
       ylin1(n1vr)=xtv4(i)
      
c      Call subroutine vector redistribution

       call vredis(xlin1,ylin1,xlin3,ylin3,n1vr,n2vr)

c      Load result polyline

       do j=1,n2vr
       ucnt2(i,ii,j)=xlin3(j)
       vcnt2(i,ii,j)=ylin3(j)
c       write (*,*) "Line 2f: ", j, xlin3(j),ylin3(j)
       end do
       
       end if ! Enf if in ii max
   

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.2.2 Points 9-10-11 in Rib i-1 and reformat
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      We only need first "9" and last "11"

       i=hvr(k,3)-1
       ii=hvr(k,4)

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,1)=ucnt(i,ii,3)-hvr(k,10)
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,10)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,10)
       ucnt(i,ii,5)=ucnt(i,ii,3)+hvr(k,10)
       ucnt(i,ii,6)=ucnt(i,ii,1)
       ucnt(i,ii,7)=ucnt(i,ii,3)
       ucnt(i,ii,8)=ucnt(i,ii,5)
       ucnt(i,ii,9)=ucnt(i,ii,1)
       ucnt(i,ii,10)=ucnt(i,ii,3)
       ucnt(i,ii,11)=ucnt(i,ii,5)

c      Points 2,3,4 interpolation in rib i-1
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,2).and.u(i,j+1,3).ge.ucnt(i,ii,2)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,2)=xm*ucnt(i,ii,2)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,4).and.u(i,j+1,3).ge.ucnt(i,ii,4)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,4)=xm*ucnt(i,ii,4)+xb
       end if

       end do

c      Points 9,10,11 interpolation in rib i-1 (not used)
       do j=1,np(i,2)

       if (u(i,j,3).gt.ucnt(i,ii,9).and.u(i,j+1,3).le.ucnt(i,ii,9)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,9)=xm*ucnt(i,ii,9)+xb
       jcon(i,ii,9)=j+1
       end if

       if (u(i,j,3).gt.ucnt(i,ii,10).and.u(i,j+1,3).le.ucnt(i,ii,10)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,10)=xm*ucnt(i,ii,10)+xb
       jcon(i,ii,10)=j+1
       end if

       if (u(i,j,3).gt.ucnt(i,ii,11).and.u(i,j+1,3).le.ucnt(i,ii,11)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,11)=xm*ucnt(i,ii,11)+xb
       jcon(i,ii,11)=j+1
       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Detect first 9 and last 11 (rib i-1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      First 9
       if (ii.eq.1) then

c      Line "r"
       xru(1)=ucnt(i,ii,2)
       xrv(1)=vcnt(i,ii,2)
       xru(2)=ucnt(i,ii,2)-1.
       xrv(2)=vcnt(i,ii,2)+dtan(hvr(k,7)*pi/180.)

c      Look at segments near "A"
       do ki=jcon(i,ii,10),np(i,2)

c      Line "s"
       xsu(1)=u(i,ki,3)
       xsv(1)=v(i,ki,3)
       xsu(2)=u(i,ki+1,3)
       xsv(2)=v(i,ki+1,3)

       call xrxs(xru,xrv,xsu,xsv,xtu,xtv)

       if (xsu(1).ge.xtu.and.xsu(2).lt.xtu.and.xsv(2).ge.0.) then
       xtu9(i)=xtu
       xtv9(i)=xtv
       jcon9(i,ii,2)=ki+1
       end if
     
       end do

c      Dibuix provisional, but in vertical rib!    
c       call line(xru(1),-300-xrv(1),xtu9(i),-300-xtv9(i),7)

       end if   ! First 9

       
c      Last 11
       if (ii.eq.rib(i,15)) then

c      Line "r"
       xru(1)=ucnt(i,ii,4)
       xrv(1)=vcnt(i,ii,4)
       xru(2)=ucnt(i,ii,4)+1.
       xrv(2)=vcnt(i,ii,4)+dtan(hvr(k,8)*pi/180.)

c      Look at segments near "A"
       do ki=1,np(i,2)

c      Line "s"
       xsu(1)=u(i,ki,3)
       xsv(1)=v(i,ki,3)
       xsu(2)=u(i,ki+1,3)
       xsv(2)=v(i,ki+1,3)

       call xrxs(xru,xrv,xsu,xsv,xtu,xtv)

       if (xsu(1).ge.xtu.and.xsu(2).lt.xtu.and.xsv(2).ge.0.) then
       xtu11(i)=xtu
       xtv11(i)=xtv
       jcon11(i,ii,2)=ki+1

c      Calcule te-11
       rib(i,105)=0.
       do jj=1,jcon11(i,ii,2)-2
       rib(i,105)=rib(i,105)+sqrt((u(i,jj+1,3)-u(i,jj,3))**2+
     + (v(i,jj+1,3)-v(i,jj,3))**2)
       end do
       rib(i,105)=rib(1,105)+sqrt((u(i,jcon11(i,ii,2)-1,3)-xtu11(i))
     + **2+(v(i,jcon11(i,ii,2)-1,3)-xtv11(i))**2)
c      Verificar graficament que OK

       end if
     
       end do

c      Dibuix provisional, but in vertical rib!
c       call line(xru(1),-300-xrv(1),xtu11(i),-300-xtv11(i),7)

       end if   ! Last 11

       end do   ! in points upper surface

c      Calculus of partial lenghts in rib i-1

c      Calculus of te-11 length
       if (ii.eq.rib(i,15)) then
       xlte11(i)=0.
       do kl=1,jcon11(i,ii,2)-2
       xlte11(i)=xlte11(i)+sqrt((u(i,kl+1,3)-u(i,kl,3))**2+
     + (v(i,kl+1,3)-v(i,kl,3))**2)
       end do 
       kl=jcon11(i,ii,2)-1
       xlte11(i)=xlte11(i)+sqrt((u(i,kl,3)-xtu11(i))**2+
     + (v(i,kl,3)-xtv11(i))**2)
       end if

c      Calculus of le-9 length
       if (ii.eq.1) then
c       write (*,*) "Epppp   ", jcon9(i,ii,2),np(i,2)
       xlle9(i)=0.
       do kl=jcon9(i,ii,2),np(i,2)-1
       xlle9(i)=xlle9(i)+sqrt((u(i,kl+1,3)-u(i,kl,3))**2+
     + (v(i,kl+1,3)-v(i,kl,3))**2)
       end do 
       kl=jcon9(i,ii,2)
       xlle9(i)=xlle9(i)+sqrt((u(i,kl,3)-xtu9(i))**2+
     + (v(i,kl,3)-xtv9(i))**2)
       end if


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat line 1 (9-11) in n spaces (rib i-1)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c       if (ii.eq.rib(i+1,15)) then ! why i+1?
       if (ii.eq.rib(i,15)) then


c      Reformat in 120 spaces

       n1vr=jcon9(i,1,2)-jcon11(i,int(rib(i,15)),2)+1    
       n2vr=121

c      Load data polyline
       xlin1(1)=xtu9(i)
       ylin1(1)=xtv9(i)
       do j=2,n1vr-1
       xlin1(j)=u(i,jcon9(i,1,2)-j+1,3)
       ylin1(j)=v(i,jcon9(i,1,2)-j+1,3)
c      MIRAR SI CAL +-1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       end do
       xlin1(n1vr)=xtu11(i)
       ylin1(n1vr)=xtv11(i)

c      Esborrar?       
       do j=1,n1vr-1
c       call line(xlin1(j),-300-ylin1(j),xlin1(j+1),-300-ylin1(j+1),3)
       end do

c      Call subroutine vector redistribution

       call vredis(xlin1,ylin1,xlin3,ylin3,n1vr,n2vr)

c      Load result polyline

       do j=1,n2vr
       ucnt1(i,ii,j)=xlin3(j)
       vcnt1(i,ii,j)=ylin3(j)
       end do

       end if ! ii=rib(i+1,15)


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.2.3 Points 9-10-11 in Rib i+1
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      We only need first "9" and last "11"

       i=hvr(k,3)+1
       ii=hvr(k,4)

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,1)=ucnt(i,ii,3)-hvr(k,10)
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,10)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,10)
       ucnt(i,ii,5)=ucnt(i,ii,3)+hvr(k,10)
       ucnt(i,ii,6)=ucnt(i,ii,1)
       ucnt(i,ii,7)=ucnt(i,ii,3)
       ucnt(i,ii,8)=ucnt(i,ii,5)
       ucnt(i,ii,9)=ucnt(i,ii,1)
       ucnt(i,ii,10)=ucnt(i,ii,3)
       ucnt(i,ii,11)=ucnt(i,ii,5)

c      Points 2,3,4 interpolation in rib i+1
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,2).and.u(i,j+1,3).ge.ucnt(i,ii,2)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,2)=xm*ucnt(i,ii,2)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,4).and.u(i,j+1,3).ge.ucnt(i,ii,4)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,4)=xm*ucnt(i,ii,4)+xb
       end if

       end do

c      Points 9,10,11 interpolation in rib i+1 (not used)
       do j=1,np(i,2)

       if (u(i,j,3).gt.ucnt(i,ii,9).and.u(i,j+1,3).le.ucnt(i,ii,9)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,9)=xm*ucnt(i,ii,9)+xb
       jcon(i,ii,9)=j+1
       end if

       if (u(i,j,3).gt.ucnt(i,ii,10).and.u(i,j+1,3).le.ucnt(i,ii,10)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,10)=xm*ucnt(i,ii,10)+xb
       jcon(i,ii,10)=j+1
       end if

       if (u(i,j,3).gt.ucnt(i,ii,11).and.u(i,j+1,3).le.ucnt(i,ii,11)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,11)=xm*ucnt(i,ii,11)+xb
       jcon(i,ii,11)=j+1
       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Detect fisrt 9 and last 11 (rib i+1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      First 9
       if (ii.eq.1) then

c      Line "r"
       xru(1)=ucnt(i,ii,2)
       xrv(1)=vcnt(i,ii,2)
       xru(2)=ucnt(i,ii,2)-1.
       xrv(2)=vcnt(i,ii,2)+dtan(hvr(k,7)*pi/180.)

c      Look at segments near "A"
       do ki=jcon(i,ii,10),np(i,2)

c      Line "s"
       xsu(1)=u(i,ki,3)
       xsv(1)=v(i,ki,3)
       xsu(2)=u(i,ki+1,3)
       xsv(2)=v(i,ki+1,3)

       call xrxs(xru,xrv,xsu,xsv,xtu,xtv)

       if (xsu(1).ge.xtu.and.xsu(2).lt.xtu.and.xsv(2).ge.0.) then
       xtu9(i)=xtu
       xtv9(i)=xtv
       jcon9(i,ii,2)=ki+1
       end if
     
       end do

       end if   ! First 9

c      Last 11
       if (ii.eq.rib(i,15)) then

c      Line "r"
       xru(1)=ucnt(i,ii,4)
       xrv(1)=vcnt(i,ii,4)
       xru(2)=ucnt(i,ii,4)+1.
       xrv(2)=vcnt(i,ii,4)+dtan(hvr(k,8)*pi/180.)

c      Look at segments near "A"
       do ki=1,np(i,2)

c      Line "s"
       xsu(1)=u(i,ki,3)
       xsv(1)=v(i,ki,3)
       xsu(2)=u(i,ki+1,3)
       xsv(2)=v(i,ki+1,3)

       call xrxs(xru,xrv,xsu,xsv,xtu,xtv)

       if (xsu(1).ge.xtu.and.xsu(2).lt.xtu.and.xsv(2).ge.0.) then
       xtu11(i)=xtu
       xtv11(i)=xtv
       jcon11(i,ii,2)=ki+1

c      Calcule te-11
       rib(i,105)=0.
       do jj=1,jcon11(i,ii,2)-2
       rib(i,105)=rib(i,105)+sqrt((u(i,jj+1,3)-u(i,jj,3))**2+
     + (v(i,jj+1,3)-v(i,jj,3))**2)
       end do
       rib(i,105)=rib(1,105)+sqrt((u(i,jcon11(i,ii,2)-1,3)-xtu11(i))
     + **2+(v(i,jcon11(i,ii,2)-1,3)-xtv11(i))**2)
c      Verificar graficament que OK

       end if
     
       end do

       end if   ! Last 11

       end do

c      Calculus of partial lenghts in rib i+1

c      Calculus of te-11 length
       if (ii.eq.rib(i,15)) then
       xrte11(i)=0.
       do kl=1,jcon11(i,ii,2)-2
       xrte11(i)=xrte11(i)+sqrt((u(i,kl+1,3)-u(i,kl,3))**2+
     + (v(i,kl+1,3)-v(i,kl,3))**2)
       end do 
       kl=jcon11(i,ii,2)-1
       xrte11(i)=xrte11(i)+sqrt((u(i,kl,3)-xtu11(i))**2+
     + (v(i,kl,3)-xtv11(i))**2)
c       write (*,*) "xrte11 ",i,xrte11(i)
       end if

c      Calculus of le-9 length
       if (ii.eq.1) then
c       write (*,*) "Epppp   ", jcon9(i,ii,2),np(i,2)
       xrle9(i)=0.
       do kl=jcon9(i,ii,2),np(i,2)-1
       xrle9(i)=xrle9(i)+sqrt((u(i,kl+1,3)-u(i,kl,3))**2+
     + (v(i,kl+1,3)-v(i,kl,3))**2)
       end do 
       kl=jcon9(i,ii,2)
       xrle9(i)=xrle9(i)+sqrt((u(i,kl,3)-xtu9(i))**2+
     + (v(i,kl,3)-xtv9(i))**2)
c       write (*,*) "xrle9 ok ",i,xrle9(i)
       end if

c      Calculus of partial lenghts in rib i (intrados)

c      Calculus of te-4 length
       if (ii.eq.rib(i,15)) then

             end if

c      Calculus of le-2 length
       if (ii.eq.1) then

             end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat line 3 9-11 in n spaces (rib i+1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      if (ii.eq.rib(i-1,15)) then ! why i-1?
       if (ii.eq.rib(i,15)) then

c      Reformat in 120 spaces

       n1vr=jcon9(i,1,2)-jcon11(i,int(rib(i,15)),2)+1    
       n2vr=121

c      Load data polyline
       xlin1(1)=xtu9(i)
       ylin1(1)=xtv9(i)
       do j=2,n1vr-1
       xlin1(j)=u(i,jcon9(i,1,2)-j+1,3)
       ylin1(j)=v(i,jcon9(i,1,2)-j+1,3)
c      MIRAR SI CAL +-1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       end do
       xlin1(n1vr)=xtu11(i)
       ylin1(n1vr)=xtv11(i)

       do j=1,n1vr-1
c       call line(xlin1(j),-312-ylin1(j),xlin1(j+1),-312-ylin1(j+1),6)
       end do

c      Call subroutine vector redistribution

       call vredis(xlin1,ylin1,xlin3,ylin3,n1vr,n2vr)

       do j=1,n2vr-1
c       call line(xlin3(j),-310-ylin3(j),xlin3(j+1),-310-ylin3(j+1),4)
       end do

c      Load result polyline

       do j=1,n2vr
       ucnt3(i,ii,j)=xlin3(j)
       vcnt3(i,ii,j)=ylin3(j)
       end do

       end if ! ii=rib(i-1,15)


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Rib localisation
       i=hvr(k,3)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (ii.eq.rib(i,15)) then
       i=hvr(k,3)-1
       do j=1,121
c       write (*,*) "C2: ",ucnt1(i,ii,j),vcnt1(i,ii,j)
       end do
c       write (*,*) "control ", i,ii,j,n2vr
       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.2.4 Lines 1 2 3 transportation to 3D espace
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (ii.eq.rib(i,15)) then

c      Rib i-1 (Line 1)

       i=hvr(k,3)-1

       tetha=rib(i,8)*pi/180.

       do j=1,121
       ru(i,j,3)=ucnt1(i,ii,j)
       rv(i,j,3)=vcnt1(i,ii,j)-rib(i,50)
c       write (*,*) "C3: ",ucnt1(i,ii,j),vcnt1(i,ii,j)
       end do
c       write (*,*) "control ", i,ii,j,n2vr

c      ESBORRAR
c       do j=1,n2vr-1
c       call line(300+ru(i,j,3),-300-rv(i,j,3),
c     + 300+ru(i,j+1,3),-300-rv(i,j+1,3),1)
c       end do


       do j=1,121

c      V-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      V-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      V-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       rx1(i+1,j,ii)=rx(i,j)
       ry1(i+1,j,ii)=ry(i,j)
       rz1(i+1,j,ii)=rz(i,j)

c       write (*,*) j, rx(i,j),ry(i,j),rz(i,j)


       end do

c      Rib i (Line 2)

       i=hvr(k,3)

       tetha=rib(i,8)*pi/180.
       
       do j=1,121
       ru(i,j,3)=ucnt2(i,ii,j)
       rv(i,j,3)=vcnt2(i,ii,j)-rib(i,50)
       end do

       do j=1,121

c      V-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      V-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      V-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       rx2(i,j,ii)=rx(i,j)
       ry2(i,j,ii)=ry(i,j)
       rz2(i,j,ii)=rz(i,j)

       end do

c      Rib i+1 (Line 3)

       i=hvr(k,3)+1

       tetha=rib(i,8)*pi/180.

       do j=1,121
       ru(i,j,3)=ucnt3(i,ii,j)
       rv(i,j,3)=vcnt3(i,ii,j)-rib(i,50)
c      COMPTE AMB el rib(i,50) A ESTUDIAR       
       end do

       do j=1,121

c      V-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      V-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      V-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       rx3(i-1,j,ii)=rx(i,j)
       ry3(i-1,j,ii)=ry(i,j)
       rz3(i-1,j,ii)=rz(i,j)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.3.2.5 V-ribs full calculus and drawing in 3D and 2D
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc       
c      16.3.2.5.1 Left rib (blue) 1-2
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      AQUEST IF es tanca al final del rib 15??????????????????
       if (ii.eq.rib(i,15)) then

       i=hvr(k,3)-1

c      Call flattening subroutine

       call flatt(i,n2vr,rx,ry,rz,
     + pl1x,pl1y,pl2x,pl2y,pr1x,pr1y,pr2x,pr2y)

c      Rotate ribs in 2D
c      Align using right side
       angle=datan((pr1x(i,121)-pr1x(i,1))/(pr1y(i,121)-pr1y(i,1)))
       angle=angle*180./pi
       angle2=angle

       xc=dcos(angle*pi/180.0d0)
       xs=dsin(angle*pi/180.0d0)
      
       do j=1,n2vr
       px9o(j)=xc*pl1x(i,j)-xs*pl1y(i,j)
       py9o(j)=xs*pl1x(i,j)+xc*pl1y(i,j)
       end do
       do j=1,n2vr
       pl1x(i,j)=px9o(j)
       pl1y(i,j)=py9o(j)
       end do

       do j=1,n2vr
       px9o(j)=xc*pl2x(i,j)-xs*pl2y(i,j)
       py9o(j)=xs*pl2x(i,j)+xc*pl2y(i,j)
       end do
       do j=1,n2vr
       pl2x(i,j)=px9o(j)
       pl2y(i,j)=py9o(j)
       end do

       do j=1,n2vr
       px9o(j)=xc*pr1x(i,j)-xs*pr1y(i,j)
       py9o(j)=xs*pr1x(i,j)+xc*pr1y(i,j)
       end do
       do j=1,n2vr
       pr1x(i,j)=px9o(j)
       pr1y(i,j)=py9o(j)
       end do

       do j=1,n2vr
       px9o(j)=xc*pr2x(i,j)-xs*pr2y(i,j)
       py9o(j)=xs*pr2x(i,j)+xc*pr2y(i,j)
       end do
       do j=1,n2vr
       pr2x(i,j)=px9o(j)
       pr2y(i,j)=py9o(j)
       end do
      
c      Drawing in 2D model (BOX 2,7)
       
       psep=5820.*xkf+xrsep*1.6*float(i)-150
       psey=800.*xkf+yrsep*float(ii)-500.

       if (hvr(k,5).eq.1) then

c      Draw basic contour, left and right
       do j=1,120
       call line(psep+pl1x(i,j),psey+pl1y(i,j),
     + psep+pl1x(i,j+1),psey+pl1y(i,j+1),5)
       call line(psep+pr1x(i,j),psey+pr1y(i,j),
     + psep+pr1x(i,j+1),psey+pr1y(i,j+1),5)
       end do

       j=1
       call line(psep+pl1x(i,j),psey+pl1y(i,j),
     + psep+pr1x(i,j),psey+pr1y(i,j),5)

c      xsegment definition
       xsegment=sqrt((pl1x(i,j)-pr1x(i,j))**2+
     + (pl1y(i,j)-pr1y(i,j))**2)
c      xrvlen
       xrvlen=sqrt((pr1x(i,1)-pr1x(i,121))**2+
     + (pr1y(i,1)-pr1y(i,121))**2)

       j=121
       call line(psep+pl1x(i,j),psey+pl1y(i,j),
     + psep+pr1x(i,j),psey+pr1y(i,j),5)


c      External edges calculus and drawing

       do j=1,121

c      Edges left
       alpl=-(datan((pl1y(i,j)-pl2y(i,j))/(pl1x(i,j)-pl2x(i,j))))
       if (alpl.lt.0.) then
       alpl=alpl+pi
       end if
c      Correction in alpl
       if (j.eq.120) then
       alpl120=alpl
       end if
       if (j.eq.121) then
       alpl=alpl120
       end if

       lvcx(i,j)=psep+pl1x(i,j)-xrib*0.1*dsin(alpl)
       lvcy(i,j)=psey+pl1y(i,j)-xrib*0.1*dcos(alpl)

c      Edges right
       alpr=-(datan((pr1y(i,j)-pr2y(i,j))/(pr1x(i,j)-pr2x(i,j))))
       if (alpr.lt.0.) then
       alpr=alpr+pi
       end if
c      Correction in alpr
       if (j.eq.120) then
       alpr120=alpr
       end if
       if (j.eq.121) then
       alpr=alpr120
       end if

       rvcx(i,j)=psep+pr1x(i,j)+xrib*0.1*dsin(alpr)
       rvcy(i,j)=psey+pr1y(i,j)+xrib*0.1*dcos(alpr)

       end do

c      Edges drawing       
       do j=1,120
       call line(lvcx(i,j),lvcy(i,j),lvcx(i,j+1),lvcy(i,j+1),5)
       call line(rvcx(i,j),rvcy(i,j),rvcx(i,j+1),rvcy(i,j+1),5)
       end do

c      Segments drawing

       j=1
       call line(lvcx(i,j),lvcy(i,j),psep+pl1x(i,j),psey+pl1y(i,j),5)
       call line(rvcx(i,j),rvcy(i,j),psep+pr1x(i,j),psey+pr1y(i,j),5)
       j=121
       call line(lvcx(i,j),lvcy(i,j),psep+pl1x(i,j),psey+pl1y(i,j),5)
       call line(rvcx(i,j),rvcy(i,j),psep+pr1x(i,j),psey+pr1y(i,j),5)

c      Calculus of 9-11 length in planar rib i-1
        
       xl911(i)=0.
       do j=1,120
       xl911(i)=xl911(i)+sqrt((pl1x(i,j)-pl1x(i,j+1))**2+
     + (pl1y(i,j)-pl1y(i,j+1))**2)
       end do 

c      Calculus of 2-4 length in planar rib i-1 (rib i)
        
       xc24(i+1)=0.
       do j=1,120
       xc24(i+1)=xc24(i+1)+sqrt((pr1x(i,j)-pr1x(i,j+1))**2+
     + (pr1y(i,j)-pr1y(i,j+1))**2)
       end do 


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      VERIFICATION left     
c       write (*,*) "Rib i-1 ",i,xlle9(i),xl911(i),xlte11(i),rib(i,31),
c     + xlle9(i)+xl911(i)+xlte11(i) !OK
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc



ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Naming and marks in V-rib full coninous (left-blue)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      V-rib length
       hvr(k,15)=sqrt((lvcx(i,1)-rvcx(i,1))**2.+
     + (lvcy(i,1)-rvcy(i,1))**2.)

c      Naming ribs with number

       call itxt(psep-1.5*hvr(k,15),psey-10.,10.0d0,0.0d0,i,7)
       call itxt(psep-0.5*hvr(k,15),psey-10.,10.0d0,0.0d0,i+1,7)

c      Mark rib at left (roman number) 

       alpha=-(datan((pl1y(i,1)-pr1y(i,1))/(pl1x(i,1)-pr1x(i,1))))

       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       sl=1.
       
       xpx=pl1x(i,1)*0.8+pr1x(i,1)*0.2-0.2*xrib*dsin(alpha) !double xrib
       xpy=pl1y(i,1)*0.8+pr1y(i,1)*0.2-0.2*xrib*dcos(alpha)
       xpx2=psep+xpx
       xpy2=psey+xpy

       call romano(i,xpx2,xpy2,alpha,0.4d0,3)

c      Mark rib at right (roman number) 

       alpha=-(datan((pl1y(i,1)-pr1y(i,1))/(pl1x(i,1)-pr1x(i,1))))

       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       sr=1.
       
       xpx=pl1x(i,1)*0.2+pr1x(i,1)*0.8-0.2*xrib*dsin(alpha)
       xpy=pl1y(i,1)*0.2+pr1y(i,1)*0.8-0.2*xrib*dcos(alpha) 
       xpx2=psep+xpx
       xpy2=psey+xpy

       call romano(i+1,xpx2,xpy2,alpha,0.4d0,3)


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Mark equidistant points in left rib (upper surface)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       jcontrol=1

       do jm=1,60 ! Till 60 marks

       xmarkjm=xmark*float(jm)

c      Draw only in rib
       if (xmarkjm.ge.rib(i,105).and.xmarkjm.le.rib(i,105)+xl911(i)) 
     + then

c      Define rib(i,106) only for first mark
       if (jcontrol.eq.1) then
       rib(i,106)=xmarkjm-rib(i,105)
       end if
       jcontrol=0

       xlen=0.
       xlenp=sqrt((pl1x(i,121)-pl1x(i,120))**2+
     + (pl1y(i,121)-pl1y(i,120))**2)

       do j=121,3,-1
       
c      Detect and draw equidistant point
       if (xmarkjm-rib(i,105).ge.xlen.and.xmarkjm-rib(i,105).lt.xlenp) 
     + then

       rib(i,107)=xmarkjm-xlen-rib(i,105)
       rib(i,108)=sqrt((pl1x(i,j-1)-pl1x(i,j))**2+
     + (pl1y(i,j-1)-pl1y(i,j))**2)

c      Interpolate
       xequis=pl1x(i,j)-(rib(i,107)*(pl1x(i,j)-pl1x(i,j-1)))/rib(i,108)
       yequis=pl1y(i,j)-(rib(i,107)*(pl1y(i,j)-pl1y(i,j-1)))/rib(i,108)

c      Draw
       alpha=-(datan((pl1y(i,j)-pl1y(i,j-1))/(pl1x(i,j)-pl1x(i,j-1))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xpeq=xequis-1.*xdes*dsin(alpha)
       ypeq=yequis+1.*xdes*dcos(alpha)

       call point (psep+xpeq,psey+ypeq,3)

       end if ! detect point

       xlen=xlen+sqrt((pl1x(i,j)-pl1x(i,j-1))**2+
     + (pl1y(i,j)-pl1y(i,j-1))**2)
       xlenp=xlen+sqrt((pl1x(i,j-1)-pl1x(i,j-2))**2+
     + (pl1y(i,j-1)-pl1y(i,j-2))**2)

       end do ! contour V-rib

       end if ! marks zone

       end do ! marks jm

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Mark equidistant points in bottom surface (rib i+1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Move to rib i+1

       jcontrol=1

       do jm=1,60 ! Till 50 marks

       xmarkjm=xmark*float(jm)

c      Draw only in rib
       if (xmarkjm.ge.rib(i+1,104).and.xmarkjm.le.rib(i+1,104)+
     + xc24(i+1)) then

c      Define rib(i,106) only for first mark
       if (jcontrol.eq.1) then
       rib(i+1,106)=xmarkjm-rib(i+1,104)
       end if
       jcontrol=0

       xlen=0.
       xlenp=sqrt((pr1x(i,121)-pr1x(i,120))**2+
     + (pr1y(i,121)-pr1y(i,120))**2)

       do j=121,3,-1
       
c      Detect and draw equidistant point
       if (xmarkjm-rib(i+1,104).ge.xlen.and.xmarkjm-rib(i+1,104).lt.
     + xlenp) then

       rib(i+1,107)=xmarkjm-xlen-rib(i+1,104)
       rib(i+1,108)=sqrt((pr1x(i,j-1)-pr1x(i,j))**2+
     + (pr1y(i,j-1)-pr1y(i,j))**2)

c      Interpolate
       xequis=pr1x(i,j)-(rib(i+1,107)*(pr1x(i,j)-pr1x(i,j-1)))/
     + rib(i+1,108)
       yequis=pr1y(i,j)-(rib(i+1,107)*(pr1y(i,j)-pr1y(i,j-1)))/
     + rib(i+1,108)

c      Draw
       alpha=-(datan((pr1y(i,j)-pr1y(i,j-1))/(pr1x(i,j)-pr1x(i,j-1))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xpeq=xequis+1.*xdes*dsin(alpha)
       ypeq=yequis-1.*xdes*dcos(alpha)

       call point (psep+xpeq,psey+ypeq,3)

       end if ! detect point

       xlen=xlen+sqrt((pr1x(i,j)-pr1x(i,j-1))**2+
     + (pr1y(i,j)-pr1y(i,j-1))**2)
       xlenp=xlen+sqrt((pr1x(i,j-1)-pr1x(i,j-2))**2+
     + (pr1y(i,j-1)-pr1y(i,j-2))**2)

       end do ! contour V-rib

       end if ! marks zone

       end do ! marks jm

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Mark anchor points in left rib
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do klz=1,rib(i+1,15)

       xlen=0.
       xlenp=sqrt((pr1x(i,121)-pr1x(i,120))**2+
     + (pr1y(i,121)-pr1y(i,120))**2)

       do j=121,3,-1

c      Detect and draw anchor point
       if (rib(i+1,130+klz)-rib(i+1,104).ge.xlen.and.
     + rib(i+1,130+klz)-rib(i+1,104).lt.
     + xlenp) then

    
       rib(i+1,107)=rib(i+1,130+klz)-xlen-rib(i+1,104)
       rib(i+1,108)=sqrt((pr1x(i,j-1)-pr1x(i,j))**2+
     + (pr1y(i,j-1)-pr1y(i,j))**2)

c      Interpolate
       xequis=pr1x(i,j)-(rib(i+1,107)*(pr1x(i,j)-pr1x(i,j-1)))/
     + rib(i+1,108)
       yequis=pr1y(i,j)-(rib(i+1,107)*(pr1y(i,j)-pr1y(i,j-1)))/
     + rib(i+1,108)

c      Define anchor points in planar V-rib
       xanchor(i+1,klz)=xequis
       yanchor(i+1,klz)=yequis

c      Draw
       alpha=-(datan((pr1y(i,j)-pr1y(i,j-1))/(pr1x(i,j)-pr1x(i,j-1))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xpeq=xequis+1.*xdes*dsin(alpha)
       ypeq=yequis-1.*xdes*dcos(alpha)

c      Girar angle
       call point (psep+xpeq,psey+ypeq,30)
       call point (psep+xpeq-1.,psey+ypeq,30)
       call point (psep+xpeq-2.,psey+ypeq,30)

       end if ! detect point

       xlen=xlen+sqrt((pr1x(i,j)-pr1x(i,j-1))**2+
     + (pr1y(i,j)-pr1y(i,j-1))**2)
       xlenp=xlen+sqrt((pr1x(i,j-1)-pr1x(i,j-2))**2+
     + (pr1y(i,j-1)-pr1y(i,j-2))**2)

       end do ! in contour

       end do ! in anchors

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Draw parabolic holes in left rib
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


       do klz=1,rib(i+1,15)-1

       xprb(i+1,klz,0)=(xanchor(i+1,klz)+xanchor(i+1,klz+1))/2.
       yprb(i+1,klz,0)=(yanchor(i+1,klz)+yanchor(i+1,klz+1))/2.

       do j=1,120

c      Point 5
       if (pl1y(i,j).le.yprb(i+1,klz,0).and.pl1y(i,j+1).gt.
     + yprb(i+1,klz,0)) then

       xm=(pl1y(i,j+1)-pl1y(i,j))/(pl1x(i,j+1)-pl1x(i,j))
       xb=pl1y(i,j)-xm*pl1x(i,j)

       yprb(i+1,klz,5)=yprb(i+1,klz,0)
       xprb(i+1,klz,5)=(yprb(i+1,klz,5)-xb)/xm
       
c      Point 6
       dist05=xprb(i+1,klz,0)-xprb(i+1,klz,5)
       dist06=dist05*hvr(k,9)/100.
       yprb(i+1,klz,6)=yprb(i+1,klz,0)
       xprb(i+1,klz,6)=xprb(i+1,klz,0)-dist06
       end if

c      Point 1

       if (pr1y(i,j).le.yanchor(i+1,klz)+hvr(k,10).and.pr1y(i,j+1).gt.
     + yanchor(i+1,klz)+hvr(k,10)) then

       xm=(pr1y(i,j+1)-pr1y(i,j))/(pr1x(i,j+1)-pr1x(i,j))
       xb=pr1y(i,j)-xm*pr1x(i,j)

       yprb(i+1,klz,1)=yanchor(i+1,klz)+hvr(k,10)
       xprb(i+1,klz,1)=(yprb(i+1,klz,1)-xb)/xm
       end if

       end do ! end j

       end do ! end klz


       do klz=1,rib(i+1,15)-1

       do j=1,120

c      Point 2 Intersection right side parabola with airfoil contour

       if (pr1y(i,j).ge.yprb(i+1,klz,0).and.pr1y(i,j).lt.
     + yanchor(i+1,klz+1)) then

c      Line "r" (parabola)

       xkprb(klz)=(xprb(i+1,klz,1)-xprb(i+1,klz,6))/
     + ((yprb(i+1,klz,1)-yprb(i+1,klz,6))**2.)

       xru(1)=xkprb(klz)*((pr1y(i,j)-yprb(i+1,klz,6))**2.)+
     + xprb(i+1,klz,6)
       xrv(1)=pr1y(i,j)
       xru(2)=xkprb(klz)*((pr1y(i,j+1)-yprb(i+1,klz,6))**2.)+
     + xprb(i+1,klz,6)
       xrv(2)=pr1y(i,j+1)

c      Line "s" (bottom surface)

       xsu(1)=pr1x(i,j)
       xsv(1)=pr1y(i,j)
       xsu(2)=pr1x(i,j+1)
       xsv(2)=pr1y(i,j+1)

       call xrxs(xru,xrv,xsu,xsv,xtu,xtv)


       if (xsv(1).le.xtv.and.xsv(2).gt.xtv) then  !!REVISAR
       yprb(i+1,klz,2)=xtv
       xprb(i+1,klz,2)=xtu
       end if  


       end if   

       end do ! in j

      
c       call line(psep+xprb(i+1,klz,0),psey+yprb(i+1,klz,0),
c     + psep+xprb(i+1,klz,6),psey+yprb(i+1,klz,6),2)

c       call line(psep+xprb(i+1,klz,1),psey+yprb(i+1,klz,1),
c     + psep+xprb(i+1,klz,6),psey+yprb(i+1,klz,6),3)

c       call line(psep+xprb(i+1,klz,2),psey+yprb(i+1,klz,2),
c     + psep+xprb(i+1,klz,6),psey+yprb(i+1,klz,6),1)

c      Draw parabolas


c      Detect extremal points
       do j=1,120

       if (pr1y(i,j).le.yprb(i+1,klz,1).and.pr1y(i,j+1).gt.
     + yprb(i+1,klz,1)) then
       jconi(klz)=j+1
       end if
       if (pr1y(i,j).le.yprb(i+1,klz,2).and.pr1y(i,j+1).gt.
     + yprb(i+1,klz,2)) then
       jconf(klz)=j
       end if

       end do

c      Draw parabolas

       if (hvr(k,9).le.100.) then

       j=jconi(klz)
       xpa1=xkprb(klz)*((pr1y(i,j)-yprb(i+1,klz,6))**2.)+
     + xprb(i+1,klz,6)
       call line(psep+xprb(i+1,klz,1),psey+yprb(i+1,klz,1),
     + psep+xpa1,psey+pr1y(i,j),5)
       do j=jconi(klz),jconf(klz)-1
       xpa1=xkprb(klz)*((pr1y(i,j)-yprb(i+1,klz,6))**2.)+
     + xprb(i+1,klz,6)
       xpa2=xkprb(klz)*((pr1y(i,j+1)-yprb(i+1,klz,6))**2.)+
     + xprb(i+1,klz,6)
       call line(psep+xpa1,psey+pr1y(i,j),
     + psep+xpa2,psey+pr1y(i,j+1),5)
       end do
       j=jconf(klz)
       xpa1=xkprb(klz)*((pr1y(i,j)-yprb(i+1,klz,6))**2.)+
     + xprb(i+1,klz,6)
       call line(psep+xprb(i+1,klz,2),psey+yprb(i+1,klz,2),
     + psep+xpa1,psey+pr1y(i,j),5)

       end if

       
c      Draw ellipses

       if (hvr(k,9).gt.100) then

       xprb(i+1,klz,7)=(xprb(i+1,klz,0)+xprb(i+1,klz,5))/2.
       yprb(i+1,klz,7)=yprb(i+1,klz,0)
       
       xa=0.5*((xprb(i+1,klz,0)-xprb(i+1,klz,5))*
     + (1.-(2.*(hvr(k,9)-100.)/100.)))
       xb=0.5*(yprb(i+1,klz,2)-yprb(i+1,klz,1)-2.*hvr(k,10))

       xgir=0.0d0

       do j=1,100-2.*pi/100.

       xsu(1)=xprb(i+1,klz,7)+xa*dcos(xgir)
       xsv(1)=yprb(i+1,klz,7)+xb*dsin(xgir)
       xsu(2)=xprb(i+1,klz,7)+xa*dcos(xgir+2.*pi/100.)
       xsv(2)=yprb(i+1,klz,7)+xb*dsin(xgir+2.*pi/100.)

       call line(psep+xsu(1),psey+xsv(1),psep+xsu(2),psey+xsv(2),5)

       xgir=xgir+2.*pi/100.

       end do

       end if

       end do ! in klz

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Draw left diagonal in 3D space
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (ii.eq.rib(i,15)) then
       do j=1,121
       call line3d(rx2(i+1,j,ii),ry2(i+1,j,ii),rz2(i+1,j,ii),
     + rx1(i+1,j,ii),ry1(i+1,j,ii),rz1(i+1,j,ii),5)
       call line3d(-rx2(i+1,j,ii),ry2(i+1,j,ii),rz2(i+1,j,ii),
     + -rx1(i+1,j,ii),ry1(i+1,j,ii),rz1(i+1,j,ii),5)
       end do
       end if

       end if ! Draw left diagonal


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc       
c      16.3.2.5.2 Right rib (red) 2-3
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)

c      Call flattening subroutine

       call flatt(i,n2vr,rx,ry,rz,
     + pl1x,pl1y,pl2x,pl2y,pr1x,pr1y,pr2x,pr2y)

c      Rotate ribs in 2D
c      Align using left side
       angle=datan((pr1x(i,121)-pr1x(i,1))/(pr1y(i,121)-pr1y(i,1)))
       angle=angle*180./pi

       xc=dcos(angle*pi/180.)
       xs=dsin(angle*pi/180.)

c      And do displacement using xsegment and angle2 defined in left rib
       xdx=xsegment*dcos(angle2*pi/180)
       xdy=xsegment*dsin(angle2*pi/180)

       do j=1,n2vr
       px9o(j)=xc*pl1x(i,j)-xs*pl1y(i,j)
       py9o(j)=xs*pl1x(i,j)+xc*pl1y(i,j)+xdy
       end do
       do j=1,n2vr
       pl1x(i,j)=px9o(j)
       pl1y(i,j)=py9o(j)
       end do

       do j=1,n2vr
       px9o(j)=xc*pl2x(i,j)-xs*pl2y(i,j)
       py9o(j)=xs*pl2x(i,j)+xc*pl2y(i,j)+xdy
       end do
       do j=1,n2vr
       pl2x(i,j)=px9o(j)
       pl2y(i,j)=py9o(j)
       end do

       do j=1,n2vr
       px9o(j)=xc*pr1x(i,j)-xs*pr1y(i,j)
       py9o(j)=xs*pr1x(i,j)+xc*pr1y(i,j)+xdy
       end do
       do j=1,n2vr
       pr1x(i,j)=px9o(j)
       pr1y(i,j)=py9o(j)
       end do

       do j=1,n2vr
       px9o(j)=xc*pr2x(i,j)-xs*pr2y(i,j)
       py9o(j)=xs*pr2x(i,j)+xc*pr2y(i,j)+xdy
       end do
       do j=1,n2vr
       pr2x(i,j)=px9o(j)
       pr2y(i,j)=py9o(j)
       end do


c      Drawing in 2D model
       
       psep=5820.*xkf+xrsep*1.6*float(i-1)+1.5*xsegment-150
       psey=800.*xkf+yrsep*float(ii)-500.

       if (hvr(k,6).eq.1) then

c      Draw basic contour
       do j=1,120
       call line(psep+pl1x(i,j),psey+pl1y(i,j),
     + psep+pl1x(i,j+1),psey+pl1y(i,j+1),1)
       call line(psep+pr1x(i,j),psey+pr1y(i,j),
     + psep+pr1x(i,j+1),psey+pr1y(i,j+1),1)
       end do

       j=1
       call line(psep+pl1x(i,j),psey+pl1y(i,j),
     + psep+pr1x(i,j),psey+pr1y(i,j),1)
       j=121
       call line(psep+pl1x(i,j),psey+pl1y(i,j),
     + psep+pr1x(i,j),psey+pr1y(i,j),1)


c      External edges calculus and drawing

       do j=1,121

c      Edges left
       alpl=-(datan((pl1y(i,j)-pl2y(i,j))/(pl1x(i,j)-pl2x(i,j))))
       if (alpl.lt.0.) then
       alpl=alpl+pi
       end if

c      Correction in alpl
       if (j.eq.120) then
       alpl120=alpl
       end if
       if (j.eq.121) then
       alpl=alpl120
       end if

       lvcx(i,j)=psep+pl1x(i,j)-xrib*0.1*dsin(alpl)
       lvcy(i,j)=psey+pl1y(i,j)-xrib*0.1*dcos(alpl)

c      Edges right
       alpr=-(datan((pr1y(i,j)-pr2y(i,j))/(pr1x(i,j)-pr2x(i,j))))
       if (alpr.lt.0.) then
       alpr=alpr+pi
       end if
c      Correction in alpr
       if (j.eq.120) then
       alpr120=alpr
       end if
       if (j.eq.121) then
       alpr=alpr120
       end if

       rvcx(i,j)=psep+pr1x(i,j)+xrib*0.1*dsin(alpr)
       rvcy(i,j)=psey+pr1y(i,j)+xrib*0.1*dcos(alpr)

       end do

c      Edges drawing       
       do j=1,120
       call line(lvcx(i,j),lvcy(i,j),lvcx(i,j+1),lvcy(i,j+1),1)
       call line(rvcx(i,j),rvcy(i,j),rvcx(i,j+1),rvcy(i,j+1),1)
       end do

c      Segments drawing
       j=1
       call line(lvcx(i,j),lvcy(i,j),psep+pl1x(i,j),psey+pl1y(i,j),1)
       call line(rvcx(i,j),rvcy(i,j),psep+pr1x(i,j),psey+pr1y(i,j),1)
       j=121
       call line(lvcx(i,j),lvcy(i,j),psep+pl1x(i,j),psey+pl1y(i,j),1)
       call line(rvcx(i,j),rvcy(i,j),psep+pr1x(i,j),psey+pr1y(i,j),1)


c      Calculus of 9-11 length in planar rib i+1
        
       xr911(i+1)=0.
       do j=1,120
       xr911(i+1)=xr911(i+1)+sqrt((pr1x(i,j)-pr1x(i,j+1))**2+
     + (pr1y(i,j)-pr1y(i,j+1))**2)
       end do 

c      Calculus of 2-4 length in planar rib i
        
       xc24i=xc24(i) ! Left side
       xc24(i)=0.
       do j=1,120
       xc24(i)=xc24(i)+sqrt((pl1x(i,j)-pl1x(i,j+1))**2+
     + (pl1y(i,j)-pl1y(i,j+1))**2)
       end do 

c       write (*,*) "xc24(i) ",i,xc24i,xc24(i)
c      Petites diferencies 1 mm a corregir


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      VERIFICATION right     
c       write (*,*) "Rib i+1 ",i+1,xrle9(i+1),xr911(i+1),xrte11(i+1),
c     + rib(i+1,31),xrle9(i+1)+xr911(i+1)+xrte11(i+1) !
c      Hi ha petit error de 1 mm, a revisar (potser calcul r influ)
c      menys exacte r que l? a rutina planar
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc



ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Naming and marks in V-rib (right-red)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      V-rib length
       hvr(k,15)=sqrt((lvcx(i,1)-rvcx(i,1))**2.+
     + (lvcy(i,1)-rvcy(i,1))**2.)

c      Naming ribs with number

       call itxt(psep-1.5*hvr(k,15),psey-10,10.0d0,0.0d0,i,7)
       call itxt(psep-0.5*hvr(k,15),psey-10,10.0d0,0.0d0,i+1,7)

       
c      Mark rib at left (roman number) 

       alpha=-(datan((pl1y(i,1)-pr1y(i,1))/(pl1x(i,1)-pr1x(i,1))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       sl=1.
       
       xpx=pl1x(i,1)*0.8+pr1x(i,1)*0.2+0.2*xrib*dsin(alpha) !double xrib
       xpy=pl1y(i,1)*0.8+pr1y(i,1)*0.2+0.2*xrib*dcos(alpha) 
       xpx2=psep+xpx
       xpy2=psey+xpy

       call romano(i,xpx2,xpy2,alpha,0.4d0,3)

c      Mark rib at right (roman number) 

       alpha=-(datan((pl1y(i,1)-pr1y(i,1))/(pl1x(i,1)-pr1x(i,1))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       sr=1.
       
       xpx=pl1x(i,1)*0.2+pr1x(i,1)*0.8+0.2*xrib*dsin(alpha)
       xpy=pl1y(i,1)*0.2+pr1y(i,1)*0.8+0.2*xrib*dcos(alpha)
       xpx2=psep+xpx
       xpy2=psey+xpy

       call romano(i+1,xpx2,xpy2,alpha,0.4d0,3)


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Mark equidistant points in right rib (upper surface) rib i+1
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       jcontrol=1

       do jm=1,60 ! Till 50 marks

       xmarkjm=xmark*float(jm)

c      Draw only in rib
       if (xmarkjm.ge.rib(i+1,105).and.xmarkjm.le.rib(i+1,105)+
     + xr911(i+1)) then

c      Define rib(i+1,106) only for first mark
       if (jcontrol.eq.1) then
       rib(i+1,106)=xmarkjm-rib(i+1,105)
       end if
       jcontrol=0

       xlen=0.
       xlenp=sqrt((pr1x(i,121)-pr1x(i,120))**2+
     + (pr1y(i,121)-pr1y(i,120))**2)

       do j=121,3,-1  !!!!! REVISAR !!!!!!!!!!!!!!
c       do j=120,3,-1
       
c      Detect and draw equidistant point
       if (xmarkjm-rib(i+1,105).ge.xlen.and.xmarkjm-rib(i+1,105).lt.
     + xlenp) then

       rib(i+1,107)=xmarkjm-xlen-rib(i+1,105)
       rib(i+1,108)=sqrt((pr1x(i,j-1)-pr1x(i,j))**2+
     + (pr1y(i,j-1)-pr1y(i,j))**2)

c      Interpolate
       xequis=pr1x(i,j)-(rib(i+1,107)*(pr1x(i,j)-pr1x(i,j-1)))/
     + rib(i+1,108)
       yequis=pr1y(i,j)-(rib(i+1,107)*(pr1y(i,j)-pr1y(i,j-1)))/
     + rib(i+1,108)

c      Draw
       alpha=-(datan((pr1y(i,j)-pr1y(i,j-1))/(pr1x(i,j)-pr1x(i,j-1))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xpeq=xequis+1.*xdes*dsin(alpha)
       ypeq=yequis-1.*xdes*dcos(alpha)

       call point (psep+xpeq,psey+ypeq,3)

       end if ! detect point

       xlen=xlen+sqrt((pr1x(i,j)-pr1x(i,j-1))**2+
     + (pr1y(i,j)-pr1y(i,j-1))**2)
       xlenp=xlen+sqrt((pr1x(i,j-1)-pr1x(i,j-2))**2+
     + (pr1y(i,j-1)-pr1y(i,j-2))**2)

       end do ! contour V-rib

       end if ! marks zone

       end do ! marks jm

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Mark equidistant points in bottom surface (rib i)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Move to rib i

       jcontrol=1

       do jm=1,60 ! Till 50 marks

       xmarkjm=xmark*float(jm)

c      Draw only in rib
       if (xmarkjm.ge.rib(i,104).and.xmarkjm.le.rib(i,104)+
     + xc24(i)) then

c      Define rib(i,106) only for first mark
       if (jcontrol.eq.1) then
       rib(i,106)=xmarkjm-rib(i,104)
       end if
       jcontrol=0

       xlen=0.
       xlenp=sqrt((pl1x(i,121)-pl1x(i,120))**2+
     + (pl1y(i,121)-pl1y(i,120))**2)

       do j=121,3,-1
       
c      Detect and draw equidistant point
       if (xmarkjm-rib(i,104).ge.xlen.and.xmarkjm-rib(i,104).lt.
     + xlenp) then

       rib(i,107)=xmarkjm-xlen-rib(i,104)
       rib(i,108)=sqrt((pl1x(i,j-1)-pl1x(i,j))**2+
     + (pl1y(i,j-1)-pl1y(i,j))**2)

c      Interpolate
       xequis=pl1x(i,j)-(rib(i,107)*(pl1x(i,j)-pl1x(i,j-1)))/
     + rib(i,108)
       yequis=pl1y(i,j)-(rib(i,107)*(pl1y(i,j)-pl1y(i,j-1)))/
     + rib(i,108)

c      Draw
       alpha=-(datan((pl1y(i,j)-pl1y(i,j-1))/(pl1x(i,j)-pl1x(i,j-1))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xpeq=xequis-1.*xdes*dsin(alpha)
       ypeq=yequis+1.*xdes*dcos(alpha)

       call point (psep+xpeq,psey+ypeq,3)

       end if ! detect point

       xlen=xlen+sqrt((pl1x(i,j)-pl1x(i,j-1))**2+
     + (pl1y(i,j)-pl1y(i,j-1))**2)
       xlenp=xlen+sqrt((pl1x(i,j-1)-pl1x(i,j-2))**2+
     + (pl1y(i,j-1)-pl1y(i,j-2))**2)

       end do ! contour V-rib

       end if ! marks zone

       end do ! marks jm


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Mark anchor points in right rib
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do klz=1,rib(i,15)

       xlen=0.
       xlenp=sqrt((pl1x(i,121)-pl1x(i,120))**2+
     + (pl1y(i,121)-pl1y(i,120))**2)

       do j=121,3,-1

c      Detect and draw anchor point
       if (rib(i,130+klz)-rib(i,104).ge.xlen.and.
     + rib(i,130+klz)-rib(i,104).lt.
     + xlenp) then

    
       rib(i,107)=rib(i,130+klz)-xlen-rib(i,104)
       rib(i,108)=sqrt((pl1x(i,j-1)-pl1x(i,j))**2+
     + (pl1y(i,j-1)-pl1y(i,j))**2)

c      Interpolate
       xequis=pl1x(i,j)-(rib(i,107)*(pl1x(i,j)-pl1x(i,j-1)))/
     + rib(i,108)
       yequis=pl1y(i,j)-(rib(i,107)*(pl1y(i,j)-pl1y(i,j-1)))/
     + rib(i,108)

c      Define anchor points in planar V-rib
       xanchor(i,klz)=xequis
       yanchor(i,klz)=yequis

c      Draw
       alpha=-(datan((pl1y(i,j)-pl1y(i,j-1))/(pl1x(i,j)-pl1x(i,j-1))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xpeq=xequis+1.*xdes*dsin(alpha)
       ypeq=yequis-1.*xdes*dcos(alpha)

c      Girar angle
       call point (psep+xpeq,psey+ypeq,30)
       call point (psep+xpeq+1.,psey+ypeq,30)
       call point (psep+xpeq+2.,psey+ypeq,30)

       end if ! detect point

       xlen=xlen+sqrt((pl1x(i,j)-pl1x(i,j-1))**2+
     + (pl1y(i,j)-pl1y(i,j-1))**2)
       xlenp=xlen+sqrt((pl1x(i,j-1)-pl1x(i,j-2))**2+
     + (pl1y(i,j-1)-pl1y(i,j-2))**2)


       end do ! in contour


       end do ! in anchors



ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Draw parabolic holes in right rib
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


       do klz=1,rib(i,15)-1

       xprb(i,klz,0)=(xanchor(i,klz)+xanchor(i,klz+1))/2.
       yprb(i,klz,0)=(yanchor(i,klz)+yanchor(i,klz+1))/2.

       do j=1,120

c      Point 5
       if (pr1y(i,j).le.yprb(i,klz,0).and.pr1y(i,j+1).gt.
     + yprb(i,klz,0)) then

       xm=(pr1y(i,j+1)-pr1y(i,j))/(pr1x(i,j+1)-pr1x(i,j))
       xb=pr1y(i,j)-xm*pr1x(i,j)

       yprb(i,klz,5)=yprb(i,klz,0)
       xprb(i,klz,5)=(yprb(i,klz,5)-xb)/xm

c       call line(psep+xprb(i,klz,5),psey+yprb(i,klz,5),
c     + psep+xprb(i,klz,5)+30,psey+yprb(i,klz,5),2)

       
c      Point 6
       dist05=-xprb(i,klz,0)+xprb(i,klz,5)
       dist06=dist05*hvr(k,9)/100.
       yprb(i,klz,6)=yprb(i,klz,0)
       xprb(i,klz,6)=xprb(i,klz,0)+dist06
       end if

c      Point 1

       if (pl1y(i,j).le.yanchor(i,klz)+hvr(k,10).and.pl1y(i,j+1).gt.
     + yanchor(i,klz)+hvr(k,10)) then

       xm=(pl1y(i,j+1)-pl1y(i,j))/(pl1x(i,j+1)-pl1x(i,j))
       xb=pl1y(i,j)-xm*pl1x(i,j)

       yprb(i,klz,1)=yanchor(i,klz)+hvr(k,10)
       xprb(i,klz,1)=(yprb(i,klz,1)-xb)/xm
       end if

       end do ! end j

       end do ! end klz


       do klz=1,rib(i+1,15)-1

       do j=1,120

c      Point 2 Intersection right side parabola with airfoil contour

       if (pl1y(i,j).ge.yprb(i,klz,0).and.pl1y(i,j).lt.
     + yanchor(i,klz+1)) then

c      Line "r" (parabola)

       xkprb(klz)=(xprb(i,klz,1)-xprb(i,klz,6))/
     + ((yprb(i,klz,1)-yprb(i,klz,6))**2.)

       xru(1)=xkprb(klz)*((pl1y(i,j)-yprb(i,klz,6))**2.)+
     + xprb(i,klz,6)
       xrv(1)=pl1y(i,j)
       xru(2)=xkprb(klz)*((pl1y(i,j+1)-yprb(i,klz,6))**2.)+
     + xprb(i,klz,6)
       xrv(2)=pl1y(i,j+1)

c      Line "s" (bottom surface)

       xsu(1)=pl1x(i,j)
       xsv(1)=pl1y(i,j)
       xsu(2)=pl1x(i,j+1)
       xsv(2)=pl1y(i,j+1)

       call xrxs(xru,xrv,xsu,xsv,xtu,xtv)


       if (xsv(1).le.xtv.and.xsv(2).gt.xtv) then  !!REVISAR
       yprb(i,klz,2)=xtv
       xprb(i,klz,2)=xtu
       end if  


       end if   

       end do ! in j

      
c       call line(psep+xprb(i,klz,0),psey+yprb(i,klz,0),
c     + psep+xprb(i,klz,6),psey+yprb(i,klz,6),2)

c       call line(psep+xprb(i,klz,1),psey+yprb(i,klz,1),
c     + psep+xprb(i,klz,6),psey+yprb(i,klz,6),3)

c       call line(psep+xprb(i,klz,2),psey+yprb(i,klz,2),
c     + psep+xprb(i,klz,6),psey+yprb(i,klz,6),1)

c      Draw parabolas


c      Detect extremal points
       do j=1,120

       if (pl1y(i,j).le.yprb(i,klz,1).and.pl1y(i,j+1).gt.
     + yprb(i,klz,1)) then
       jconi(klz)=j+1
       end if
       if (pl1y(i,j).le.yprb(i,klz,2).and.pl1y(i,j+1).gt.
     + yprb(i,klz,2)) then
       jconf(klz)=j
       end if

       end do

c      Draw parabolas

       if (hvr(k,9).le.100.) then

       j=jconi(klz)
       xpa1=xkprb(klz)*((pl1y(i,j)-yprb(i,klz,6))**2.)+
     + xprb(i,klz,6)
       call line(psep+xprb(i,klz,1),psey+yprb(i,klz,1),
     + psep+xpa1,psey+pl1y(i,j),1)
       do j=jconi(klz),jconf(klz)-1
       xpa1=xkprb(klz)*((pl1y(i,j)-yprb(i,klz,6))**2.)+
     + xprb(i,klz,6)
       xpa2=xkprb(klz)*((pl1y(i,j+1)-yprb(i,klz,6))**2.)+
     + xprb(i,klz,6)
       call line(psep+xpa1,psey+pl1y(i,j),
     + psep+xpa2,psey+pl1y(i,j+1),1)
       end do
       j=jconf(klz)
       xpa1=xkprb(klz)*((pl1y(i,j)-yprb(i,klz,6))**2.)+
     + xprb(i,klz,6)
       call line(psep+xprb(i,klz,2),psey+yprb(i,klz,2),
     + psep+xpa1,psey+pl1y(i,j),1)

       end if


c      Draw ellipses

       if (hvr(k,9).gt.100) then

       xprb(i,klz,7)=(xprb(i,klz,5)+xprb(i,klz,0))/2.
       yprb(i,klz,7)=yprb(i,klz,0)
       
       xa=0.5*((xprb(i,klz,5)-xprb(i,klz,0))*
     + (1.-(2.*(hvr(k,9)-100.)/100.)))
       xb=0.5*(yprb(i,klz,2)-yprb(i,klz,1)-2.*hvr(k,10))

       xgir=0.

       do j=1,100-2.*pi/100.

       xsu(1)=xprb(i,klz,7)+xa*dcos(xgir)
       xsv(1)=yprb(i,klz,7)+xb*dsin(xgir)
       xsu(2)=xprb(i,klz,7)+xa*dcos(xgir+2.*pi/100.)
       xsv(2)=yprb(i,klz,7)+xb*dsin(xgir+2.*pi/100.)

       call line(psep+xsu(1),psey+xsv(1),psep+xsu(2),psey+xsv(2),1)

       xgir=xgir+2.*pi/100.

       end do

       end if

       end do ! in klz

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Draw right diagonal in 3D space
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (ii.eq.rib(i,15)) then
       do j=1,121
       call line3d(rx2(i,j,ii),ry2(i,j,ii),rz2(i,j,ii),
     + rx3(i,j,ii),ry3(i,j,ii),rz3(i,j,ii),1)
       call line3d(-rx2(i,j,ii),ry2(i,j,ii),rz2(i,j,ii),
     + -rx3(i,j,ii),ry3(i,j,ii),rz3(i,j,ii),1)
       end do
       end if

       end if ! Draw right diagonal

       end if  ! rigth


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Marks in main ribs (rib i, bottom surface) plott and MC
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       sepxx=700.*xkf
       sepyy=100.*xkf

c      Rib i (center)
       kx=int((float(i-1)/6.))
       ky=i-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

       do klz=1,3
      
       alpha=-datan((xtv9(i-1)-vcnt(i-1,1,2))/(xtu9(i-1)-ucnt(i-1,1,2)))
       xp22=xtu2(i)+(1-klz+xdes)*dcos(alpha)
       yp22=xtv2(i)-(1-klz+xdes)*dsin(alpha)
       xu=sepx+xp22
       xv=-sepy+yp22
       call pointg(xu,xv,xcir,6) ! Box (1,2)
       call point(xu+2530.*xkf,-xv,6) ! Box (1,4)

       alpha=datan((xtv11(i-1)-vcnt(i-1,ii,4))/
     + (xtu11(i-1)-ucnt(i-1,ii,4)))
       xp44=xtu4(i)-(1-klz+xdes)*dcos(alpha)
       yp44=xtv4(i)-(1-klz+xdes)*dsin(alpha)
       xu=sepx+xp44
       xv=-sepy+yp44
       call pointg(xu,xv,xcir,6) ! Box (1,2)
       call point(xu+2530.*xkf,-xv,6) ! Box (1,4)

       end do

      if (ii.eq.rib(i,15)) then

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Full V-ribs marks in ribs plotting and MC
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box (1,2)

       sepxx=700.*xkf
       sepyy=100.*xkf

c      Rib i-1 Left side
       kx=int((float(i-2)/6.))
       ky=i-1-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)       

       if (hvr(k,5).eq.1) then
       call line(sepx+xtu9(i-1),-xtv9(i-1)+sepy,
     + sepx+ucnt(i-1,1,2),-vcnt(i-1,1,2)+sepy,5)
       call line(sepx+xtu11(i-1),-xtv11(i-1)+sepy,
     + sepx+ucnt(i-1,ii,4),-vcnt(i-1,ii,4)+sepy,5)

c      Marks 9-10 in V-rib left

       do klz=1,3
      
       alpha=-datan((xtv9(i-1)-vcnt(i-1,1,2))/(xtu9(i-1)-ucnt(i-1,1,2)))
       xp9=xtu9(i-1)-(1-klz+xdes)*dcos(alpha)
       yp9=xtv9(i-1)+(1-klz+xdes)*dsin(alpha)
       xu=sepx+xp9
       xv=-sepy+yp9
       call pointg(xu,xv,xcir,6) ! Box (1,2)
       call point(xu+2530.*xkf,-xv,6) ! Box (1,4)

       alpha=datan((xtv11(i-1)-vcnt(i-1,ii,4))/
     + (xtu11(i-1)-ucnt(i-1,ii,4)))
       xp11=xtu11(i-1)+(1-klz+xdes)*dcos(alpha)
       yp11=xtv11(i-1)+(1-klz+xdes)*dsin(alpha)
       xu=sepx+xp11
       xv=-sepy+yp11
       call pointg(xu,xv,xcir,6) ! Box (1,2)
       call point(xu+2530.*xkf,-xv,6) ! Box (1,4)

       end do

       end if  ! Left side


c      Rib i+1 Right side

       kx=int((float(i)/6.))
       ky=i+1-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

       if (hvr(k,6).eq.1) then
       call line(sepx+xtu9(i+1),-xtv9(i+1)+sepy,
     + sepx+ucnt(i+1,1,2),-vcnt(i+1,1,2)+sepy,1)
       call line(sepx+xtu11(i+1),-xtv11(i+1)+sepy,
     + sepx+ucnt(i+1,ii,4),-vcnt(i+1,ii,4)+sepy,1)

c      Marks 9-11 in V-rib right

       do klz=1,3 ! Tree points
      
       alpha=-datan((xtv9(i+1)-vcnt(i+1,1,2))/(xtu9(i+1)-ucnt(i+1,1,2)))
       xp9=xtu9(i+1)-(1-klz+xdes)*dcos(alpha)
       yp9=xtv9(i+1)+(1-klz+xdes)*dsin(alpha)
       xu=sepx+xp9
       xv=-sepy+yp9
       call pointg(xu,xv,xcir,6)
       call point(xu+2530.*xkf,-xv,6) ! Box (1,4)

       alpha=datan((xtv11(i+1)-vcnt(i+1,ii,4))/
     + (xtu11(i+1)-ucnt(i+1,ii,4)))
       xp11=xtu11(i+1)+(1-klz+xdes)*dcos(alpha)
       yp11=xtv11(i+1)+(1-klz+xdes)*dsin(alpha)
       xu=sepx+xp11
       xv=-sepy+yp11
       call pointg(xu,xv,xcir,6)
       call point(xu+2530.*xkf,-xv,6) ! Box (1,4)

       end do

       end if  ! Right side

       end if  ! rib(i,15)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       end if ! ii=rib(i,15)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       end if ! end type 5

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

 







ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.4 HV ribs
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,2).eq.4) then

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.4.1 Rib i-1
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)-1
       ii=hvr(k,4)

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,1)=ucnt(i,ii,3)-hvr(k,8)
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,7)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,7)
       ucnt(i,ii,5)=ucnt(i,ii,3)+hvr(k,8)
       ucnt(i,ii,6)=ucnt(i,ii,1)
       ucnt(i,ii,7)=ucnt(i,ii,3)
       ucnt(i,ii,8)=ucnt(i,ii,5)
       ucnt(i,ii,9)=ucnt(i,ii,1)
       ucnt(i,ii,10)=ucnt(i,ii,3)
       ucnt(i,ii,11)=ucnt(i,ii,5)


c      Points 2,3,4 interpolation in rib i-1
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,2).and.u(i,j+1,3).ge.ucnt(i,ii,2)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,2)=xm*ucnt(i,ii,2)+xb
       jcon(i,ii,2)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       jcon(i,ii,3)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,4).and.u(i,j+1,3).ge.ucnt(i,ii,4)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,4)=xm*ucnt(i,ii,4)+xb
       jcon(i,ii,4)=j
       end if

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat line 2-3-4 in n regular spaces   
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       uinc=0.
       vinc=0.

       do j=1,21
       ucnt2(i,ii,j)=ucnt(i,ii,2)+uinc
       uinc=uinc+(ucnt(i,ii,4)-ucnt(i,ii,2))/20.

c      Between 2 and jcon(i,ii,2)+1
       if (ucnt2(i,ii,j).le.u(i,jcon(i,ii,2)+1,3)) then
       xm=(v(i,jcon(i,ii,2)+1,3)-vcnt(i,ii,2))/(u(i,jcon(i,ii,2)+1,3)-
     + ucnt(i,ii,2))
       xb=vcnt(i,ii,2)-xm*ucnt(i,ii,2)
       vcnt2(i,ii,j)=xm*ucnt2(i,ii,j)+xb
       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Between jcon(i,ii,2)+1 and jcon(i,ii,4)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (ucnt2(i,ii,j).ge.u(i,jcon(i,ii,2)+1,3).and.ucnt2(i,ii,j)
     + .le.u(i,jcon(i,ii,4),3)) then
c      
       do l=jcon(i,ii,2)+1,jcon(i,ii,4)-1

c      Seleccionar tram d'interpolació

       if (ucnt2(i,ii,j).ge.u(i,l,3).and.ucnt2(i,ii,j).le.u(i,l+1,3)) 
     + then
       xm=(v(i,l+1,3)-v(i,l,3))/(u(i,l+1,3)-u(i,l,3))
       xb=v(i,l,3)-xm*u(i,l,3)
       end if
       end do
c       xm=(v(i,jcon(i,ii,2)+j,3)-v(i,jcon(i,ii,2)+j-1,3))/
c     + (u(i,jcon(i,ii,2)+j,3)-u(i,jcon(i,ii,2)+j-1,3))
c       xb=v(i,jcon(i,ii,2)+j-1,3)-xm*u(i,jcon(i,ii,2)+j-1,3)
       vcnt2(i,ii,j)=xm*ucnt2(i,ii,j)+xb
       end if

c      Between jcon(i,ii,4) and 4       
       if (ucnt2(i,ii,j).gt.u(i,jcon(i,ii,4),3)) then
       xm=(vcnt(i,ii,4)-v(i,jcon(i,ii,4),3))/(ucnt(i,ii,4)-
     + u(i,jcon(i,ii,4),3))
       xb=vcnt(i,ii,4)-xm*ucnt(i,ii,4)
       vcnt2(i,ii,j)=xm*ucnt2(i,ii,j)+xb
       end if

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.4.2 Rib i
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)
       ii=hvr(k,4)

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,1)=ucnt(i,ii,3)-hvr(k,8)
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,7)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,7)
       ucnt(i,ii,5)=ucnt(i,ii,3)+hvr(k,8)
       ucnt(i,ii,6)=ucnt(i,ii,1)
       ucnt(i,ii,7)=ucnt(i,ii,3)
       ucnt(i,ii,8)=ucnt(i,ii,5)
       ucnt(i,ii,9)=ucnt(i,ii,1)
       ucnt(i,ii,10)=ucnt(i,ii,3)
       ucnt(i,ii,11)=ucnt(i,ii,5)

c      Points 1,3,5 interpolation in rib i
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,1).and.u(i,j+1,3).ge.ucnt(i,ii,1)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,1)=xm*ucnt(i,ii,1)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,5).and.u(i,j+1,3).ge.ucnt(i,ii,5)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,5)=xm*ucnt(i,ii,5)+xb
       end if

       end do

c      Points 9,10,11 interpolation in rib i
       do j=1,np(i,2)

       if (u(i,j,3).ge.ucnt(i,ii,9).and.u(i,j+1,3).le.ucnt(i,ii,9)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,9)=xm*ucnt(i,ii,9)+xb
       end if

       if (u(i,j,3).ge.ucnt(i,ii,10).and.u(i,j+1,3).le.ucnt(i,ii,10)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,10)=xm*ucnt(i,ii,10)+xb
       end if

       if (u(i,j,3).ge.ucnt(i,ii,11).and.u(i,j+1,3).le.ucnt(i,ii,11)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,11)=xm*ucnt(i,ii,11)+xb
       end if

       end do

c      Calculus of 6,7,8 points in rib i
       vcnt(i,ii,6)=(vcnt(i,ii,9)-vcnt(i,ii,1))*(hvr(k,9)/100.)+
     + vcnt(i,ii,1)
       vcnt(i,ii,7)=(vcnt(i,ii,10)-vcnt(i,ii,3))*(hvr(k,9)/100.)+
     + vcnt(i,ii,3)
       vcnt(i,ii,8)=(vcnt(i,ii,11)-vcnt(i,ii,5))*(hvr(k,9)/100.)+
     + vcnt(i,ii,5)

c      Redefinition of points 6,8 if angle is not 90     
       if (hvr(k,10).ne.90.) then
       ucnt(i,ii,6)=ucnt(i,ii,7)-hvr(k,8)*dcos((pi/180.)*hvr(k,10))
       ucnt(i,ii,8)=ucnt(i,ii,7)+hvr(k,8)*dcos((pi/180.)*hvr(k,10))
       vcnt(i,ii,6)=vcnt(i,ii,7)-hvr(k,8)*dsin((pi/180.)*hvr(k,10))
       vcnt(i,ii,8)=vcnt(i,ii,7)+hvr(k,8)*dsin((pi/180.)*hvr(k,10))
       end if

c      Divide line 6-8 in n segments

       uinc=0.
       vinc=0.
       do j=1,21
       ucnt1(i,ii,j)=ucnt(i,ii,6)+uinc
       uinc=uinc+(ucnt(i,ii,8)-ucnt(i,ii,6))/20.
       vcnt1(i,ii,j)=vcnt(i,ii,6)+vinc
       vinc=vinc+(vcnt(i,ii,8)-vcnt(i,ii,6))/20.
       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Print in 3D diagonal i-1 to i
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      MES ENDAVANT
c      Lines ucnt2 - ucnt1

       do j=1,21


       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.4.3 Rib i+1
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)+1
       ii=hvr(k,4)

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,1)=ucnt(i,ii,3)-hvr(k,8)
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,7)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,7)
       ucnt(i,ii,5)=ucnt(i,ii,3)+hvr(k,8)
       ucnt(i,ii,6)=ucnt(i,ii,1)
       ucnt(i,ii,7)=ucnt(i,ii,3)
       ucnt(i,ii,8)=ucnt(i,ii,5)
       ucnt(i,ii,9)=ucnt(i,ii,1)
       ucnt(i,ii,10)=ucnt(i,ii,3)
       ucnt(i,ii,11)=ucnt(i,ii,5)

c      Points 1,3,5 interpolation in rib i+1
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,1).and.u(i,j+1,3).ge.ucnt(i,ii,1)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,1)=xm*ucnt(i,ii,1)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       end if

       if (u(i,j,3).le.ucnt(i,ii,5).and.u(i,j+1,3).ge.ucnt(i,ii,5)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,5)=xm*ucnt(i,ii,5)+xb
       end if

       end do

c      Points 9,10,11 interpolation in rib i+1
       do j=1,np(i,2)

       if (u(i,j,3).ge.ucnt(i,ii,9).and.u(i,j+1,3).le.ucnt(i,ii,9)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,9)=xm*ucnt(i,ii,9)+xb
       end if

       if (u(i,j,3).ge.ucnt(i,ii,10).and.u(i,j+1,3).le.ucnt(i,ii,10)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,10)=xm*ucnt(i,ii,10)+xb
       end if

       if (u(i,j,3).ge.ucnt(i,ii,11).and.u(i,j+1,3).le.ucnt(i,ii,11)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,11)=xm*ucnt(i,ii,11)+xb
       end if

       end do

c      Calculus of 6,7,8 points in rib i+1
       vcnt(i,ii,6)=(vcnt(i,ii,9)-vcnt(i,ii,1))*(hvr(k,9)/100.)+
     + vcnt(i,ii,1)
       vcnt(i,ii,7)=(vcnt(i,ii,10)-vcnt(i,ii,3))*(hvr(k,9)/100.)+
     + vcnt(i,ii,3)
       vcnt(i,ii,8)=(vcnt(i,ii,11)-vcnt(i,ii,5))*(hvr(k,9)/100.)+
     + vcnt(i,ii,5)

c      Redefinition of points 7,8 if angle is not 90     
       if (hvr(k,10).ne.90.) then
       ucnt(i,ii,6)=ucnt(i,ii,7)-hvr(k,8)*dcos((pi/180.)*hvr(k,10))
       ucnt(i,ii,8)=ucnt(i,ii,7)+hvr(k,8)*dcos((pi/180.)*hvr(k,10))
       vcnt(i,ii,6)=vcnt(i,ii,7)-hvr(k,8)*dsin((pi/180.)*hvr(k,10))
       vcnt(i,ii,8)=vcnt(i,ii,7)+hvr(k,8)*dsin((pi/180.)*hvr(k,10))
       end if

c      Divide line 6-8 in n segments

       uinc=0.
       vinc=0.
       do j=1,21
       ucnt3(i,ii,j)=ucnt(i,ii,6)+uinc
       uinc=uinc+(ucnt(i,ii,8)-ucnt(i,ii,6))/20.
       vcnt3(i,ii,j)=vcnt(i,ii,6)+vinc
       vinc=vinc+(vcnt(i,ii,8)-vcnt(i,ii,6))/20.
       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.4.4 Rib i+2
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)+2
       ii=hvr(k,4)

       ucnt(i,ii,3)=u(i,ii,6)
       ucnt(i,ii,1)=ucnt(i,ii,3)-hvr(k,8)
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,7)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,7)
       ucnt(i,ii,5)=ucnt(i,ii,3)+hvr(k,8)
       ucnt(i,ii,6)=ucnt(i,ii,1)
       ucnt(i,ii,7)=ucnt(i,ii,3)
       ucnt(i,ii,8)=ucnt(i,ii,5)
       ucnt(i,ii,9)=ucnt(i,ii,1)
       ucnt(i,ii,10)=ucnt(i,ii,3)
       ucnt(i,ii,11)=ucnt(i,ii,5)


c      Points 2,3,4 interpolation in rib i+2
       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,2).and.u(i,j+1,3).ge.ucnt(i,ii,2)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,2)=xm*ucnt(i,ii,2)+xb
       jcon(i,ii,2)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       jcon(i,ii,3)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,4).and.u(i,j+1,3).ge.ucnt(i,ii,4)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,4)=xm*ucnt(i,ii,4)+xb
       jcon(i,ii,4)=j
       end if

       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat line 2-3-4 in n regular spaces   
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       uinc=0.
       vinc=0.

       do j=1,21
       ucnt4(i,ii,j)=ucnt(i,ii,2)+uinc
       uinc=uinc+(ucnt(i,ii,4)-ucnt(i,ii,2))/20.

c      Between 2 and jcon(i,ii,2)+1
       if (ucnt4(i,ii,j).le.u(i,jcon(i,ii,2)+1,3)) then
       xm=(v(i,jcon(i,ii,2)+1,3)-vcnt(i,ii,2))/(u(i,jcon(i,ii,2)+1,3)-
     + ucnt(i,ii,2))
       xb=vcnt(i,ii,2)-xm*ucnt(i,ii,2)
       vcnt4(i,ii,j)=xm*ucnt4(i,ii,j)+xb
       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Between jcon(i,ii,2)+1 and jcon(i,ii,4)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (ucnt4(i,ii,j).ge.u(i,jcon(i,ii,2)+1,3).and.ucnt4(i,ii,j)
     + .le.u(i,jcon(i,ii,4),3)) then
c      
       do l=jcon(i,ii,2)+1,jcon(i,ii,4)-1

c      Seleccionar tram d'interpolació

       if (ucnt4(i,ii,j).ge.u(i,l,3).and.ucnt4(i,ii,j).le.u(i,l+1,3)) 
     + then
       xm=(v(i,l+1,3)-v(i,l,3))/(u(i,l+1,3)-u(i,l,3))
       xb=v(i,l,3)-xm*u(i,l,3)
       end if
       end do
c       xm=(v(i,jcon(i,ii,2)+j,3)-v(i,jcon(i,ii,2)+j-1,3))/
c     + (u(i,jcon(i,ii,2)+j,3)-u(i,jcon(i,ii,2)+j-1,3))
c       xb=v(i,jcon(i,ii,2)+j-1,3)-xm*u(i,jcon(i,ii,2)+j-1,3)
       vcnt4(i,ii,j)=xm*ucnt4(i,ii,j)+xb
       end if

c      Between jcon(i,ii,4) and 4       
       if (ucnt4(i,ii,j).gt.u(i,jcon(i,ii,4),3)) then
       xm=(vcnt(i,ii,4)-v(i,jcon(i,ii,4),3))/(ucnt(i,ii,4)-
     + u(i,jcon(i,ii,4),3))
       xb=vcnt(i,ii,4)-xm*ucnt(i,ii,4)
       vcnt4(i,ii,j)=xm*ucnt4(i,ii,j)+xb
       end if

       end do


c      Rib localisation
       i=hvr(k,3)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.4.4 VH-ribs lines 1 2 3 4 transportation to 3D espace
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Rib i (Line 1)

       i=hvr(k,3)

       tetha=rib(i,8)*pi/180.

       do j=1,21
       ru(i,j,3)=ucnt1(i,ii,j)
       rv(i,j,3)=vcnt1(i,ii,j)-rib(i,50)
       end do

       do j=1,21

c      VH-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      VH-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      VH-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       sx1(i,j,ii)=rx(i,j)
       sy1(i,j,ii)=ry(i,j)
       sz1(i,j,ii)=rz(i,j)

       end do

c      Rib i-1 (Line 2)

       i=hvr(k,3)-1

       tetha=rib(i,8)*pi/180.
       
       do j=1,21
       ru(i,j,3)=ucnt2(i,ii,j)
       rv(i,j,3)=vcnt2(i,ii,j)-rib(i,50)
       end do

       do j=1,21

c      VH-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      VH-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      VH-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       sx2(i,j,ii)=rx(i,j)
       sy2(i,j,ii)=ry(i,j)
       sz2(i,j,ii)=rz(i,j)

       end do

c      Rib i+1 (Line 3)

       i=hvr(k,3)+1

       tetha=rib(i,8)*pi/180.

       do j=1,21
       ru(i,j,3)=ucnt3(i,ii,j)
       rv(i,j,3)=vcnt3(i,ii,j)-rib(i,50)
c      COMPTE AMB el rib(i,50) A ESTUDIAR       
       end do

       do j=1,21

c      V-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      V-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      V-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       sx3(i,j,ii)=rx(i,j)
       sy3(i,j,ii)=ry(i,j)
       sz3(i,j,ii)=rz(i,j)

       end do

c      Rib i+2 (Line 4)

       i=hvr(k,3)+2

       tetha=rib(i,8)*pi/180.
       
       do j=1,21
       ru(i,j,3)=ucnt4(i,ii,j)
       rv(i,j,3)=vcnt4(i,ii,j)-rib(i,50)
       end do

       do j=1,21

c      VH-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      VH-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      VH-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       sx4(i,j,ii)=rx(i,j)
       sy4(i,j,ii)=ry(i,j)
       sz4(i,j,ii)=rz(i,j)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Drawing VH-3D
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do j=1,21

c      Rib i-1 to i+2

       i=hvr(k,3)

       call line3d(sx2(i-1,j,ii),sy2(i-1,j,ii),sz2(i-1,j,ii),
     + sx1(i,j,ii),sy1(i,j,ii),sz1(i,j,ii),3)

       call line3d(sx1(i,j,ii),sy1(i,j,ii),sz1(i,j,ii),
     + sx3(i+1,j,ii),sy3(i+1,j,ii),sz3(i+1,j,ii),2)

       call line3d(sx3(i+1,j,ii),sy3(i+1,j,ii),sz3(i+1,j,ii),
     + sx4(i+2,j,ii),sy4(i+2,j,ii),sz4(i+2,j,ii),1)

       call line3d(-sx2(i-1,j,ii),sy2(i-1,j,ii),sz2(i-1,j,ii),
     + -sx1(i,j,ii),sy1(i,j,ii),sz1(i,j,ii),3)

       call line3d(-sx1(i,j,ii),sy1(i,j,ii),sz1(i,j,ii),
     + -sx3(i+1,j,ii),sy3(i+1,j,ii),sz3(i+1,j,ii),2)

       call line3d(-sx3(i+1,j,ii),sy3(i+1,j,ii),sz3(i+1,j,ii),
     + -sx4(i+2,j,ii),sy4(i+2,j,ii),sz4(i+2,j,ii),1)


       end do




ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.4.5 VH-ribs calculus and drawing in 2D and 3D
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      VH-rib 1-2 in 2D model
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)-1

       px0=0.
       py0=0.
       ptheta=0.

       do j=1,21

c      Distances between points
       pa=sqrt((rx(i+1,j)-rx(i,j))**2.+(ry(i+1,j)-ry(i,j))**2.+
     + (rz(i+1,j)-rz(i,j))**2.)
       pb=sqrt((rx(i+1,j+1)-rx(i,j))**2.+(ry(i+1,j+1)-ry(i,j))**2.+
     + (rz(i+1,j+1)-rz(i,j))**2.)
       pc=sqrt((rx(i+1,j+1)-rx(i+1,j))**2.+(ry(i+1,j+1)-ry(i+1,j))**2.+
     + (rz(i+1,j+1)-rz(i+1,j))**2.)
       pd=sqrt((rx(i+1,j)-rx(i,j+1))**2.+(ry(i+1,j)-ry(i,j+1))**2.+
     + (rz(i+1,j)-rz(i,j+1))**2.)
       pe=sqrt((rx(i,j+1)-rx(i,j))**2.+(ry(i,j+1)-ry(i,j))**2.+
     + (rz(i,j+1)-rz(i,j))**2.)
       pf=sqrt((rx(i+1,j+1)-rx(i,j+1))**2.+(ry(i+1,j+1)-ry(i,j+1))**2.+
     + (rz(i+1,j+1)-rz(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

       pb2t=(pb*pb-pe*pe+pf*pf)/(2.*pb)
       pb1t=pb-pb2t
       pht=sqrt(pf*pf-pb2t*pb2t)
       
       pw1=datan(phr/pa1r)
       phu=pb1t*dtan(pw1)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0
       
       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

c      Iteration
       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
       
       end do

c      Drawing in 2D model
       
       psep=3300.*xkf+xrsep*float(i)
       psey=800.*xkf+yrsep*float(ii)

       if (hvr(k,5).eq.1) then

       j=1

       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),1)

       j=21

       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),1)

       do j=1,21-1

       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pl2x(i,j),
     + psey+pl2y(i,j),1)

       call line(psep+pr1x(i,j),psey+pr1y(i,j),psep+pr2x(i,j),
     + psey+pr2y(i,j),1)

c      Vores de costura esquerra
       alpl=abs(datan((pl2y(i,j)-pl1y(i,j))/(pl2x(i,j)-pl1x(i,j))))

       call line(psep+pl1x(i,j)-xvrib*dsin(alpl),psey+pl1y(i,j)
     + +xvrib*dcos(alpl),psep+pl2x(i,j)-xvrib*dsin(alpl),
     + psey+pl2y(i,j)+xvrib*dcos(alpl),3)

c      Vores de costura dreta
       alpr=abs(datan((pr2y(i,j)-pr1y(i,j))/(pr2x(i,j)-pr1x(i,j))))

       call line(psep+pr1x(i,j)+xvrib*dsin(alpr),psey+pr1y(i,j)
     + -xvrib*dcos(alpr),psep+pr2x(i,j)+xvrib*dsin(alpr),
     + psey+pr2y(i,j)-xvrib*dcos(alpr),3)

c      Tancament lateral inici
       if (j.eq.1) then
       call line(psep+pl1x(i,j)-xvrib*dsin(alpl),psey+pl1y(i,j)
     + +xvrib*dcos(alpl),psep+pl1x(i,j),psey+pl1y(i,j),1)
       call line(psep+pr1x(i,j)+xvrib*dsin(alpr),psey+pr1y(i,j)
     + -xvrib*dcos(alpr),psep+pr1x(i,j),psey+pr1y(i,j),1)
       end if

c      Tancament lateral fi
       if (j.eq.20) then
       call line(psep+pl2x(i,j)-xvrib*dsin(alpl),psey+pl2y(i,j)
     + +xvrib*dcos(alpl),psep+pl2x(i,j),psey+pl2y(i,j),4)
       call line(psep+pr2x(i,j)+xvrib*dsin(alpr),psey+pr2y(i,j)
     + -xvrib*dcos(alpr),psep+pr2x(i,j),psey+pr2y(i,j),4)
       end if

c      REVISAR PRESENTACIO

c      Numera cintes V
       call itxt(psep-20-xrsep,psey-10,10.0d0,0.0d0,i,7)
       call itxt(psep+20-xrsep,psey-10,10.0d0,0.0d0,i+1,7)
       
       end do

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      VH-rib 3-4 in 2D model
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)+1

       px0=0.0d0
       py0=0.0d0
       ptheta=0.0d0

       do j=1,21

c      Distances between points
       pa=sqrt((rx(i+1,j)-rx(i,j))**2.+(ry(i+1,j)-ry(i,j))**2.+
     + (rz(i+1,j)-rz(i,j))**2.)
       pb=sqrt((rx(i+1,j+1)-rx(i,j))**2.+(ry(i+1,j+1)-ry(i,j))**2.+
     + (rz(i+1,j+1)-rz(i,j))**2.)
       pc=sqrt((rx(i+1,j+1)-rx(i+1,j))**2.+(ry(i+1,j+1)-ry(i+1,j))**2.+
     + (rz(i+1,j+1)-rz(i+1,j))**2.)
       pd=sqrt((rx(i+1,j)-rx(i,j+1))**2.+(ry(i+1,j)-ry(i,j+1))**2.+
     + (rz(i+1,j)-rz(i,j+1))**2.)
       pe=sqrt((rx(i,j+1)-rx(i,j))**2.+(ry(i,j+1)-ry(i,j))**2.+
     + (rz(i,j+1)-rz(i,j))**2.)
       pf=sqrt((rx(i+1,j+1)-rx(i,j+1))**2.+(ry(i+1,j+1)-ry(i,j+1))**2.+
     + (rz(i+1,j+1)-rz(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

       pb2t=(pb*pb-pe*pe+pf*pf)/(2.*pb)
       pb1t=pb-pb2t
       pht=sqrt(pf*pf-pb2t*pb2t)
       
       pw1=datan(phr/pa1r)
       phu=pb1t*dtan(pw1)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0
       
       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

c      Iteration
       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
       
       
       end do

c      Drawing in 2D model
       
       psep=3300.*xkf+xrsep*float(i)
       psey=800.*xkf+yrsep*float(ii)

       if (hvr(k,6).eq.1) then

       j=1

       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),1)

       j=21

       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),1)

       do j=1,21-1

       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pl2x(i,j),
     + psey+pl2y(i,j),1)

       call line(psep+pr1x(i,j),psey+pr1y(i,j),psep+pr2x(i,j),
     + psey+pr2y(i,j),1)

c      Vores de costura esquerra
       alpl=abs(datan((pl2y(i,j)-pl1y(i,j))/(pl2x(i,j)-pl1x(i,j))))

       call line(psep+pl1x(i,j)-xvrib*dsin(alpl),psey+pl1y(i,j)
     + +xvrib*dcos(alpl),psep+pl2x(i,j)-xvrib*dsin(alpl),
     + psey+pl2y(i,j)+xvrib*dcos(alpl),3)

c      Vores de costura dreta
       alpr=abs(datan((pr2y(i,j)-pr1y(i,j))/(pr2x(i,j)-pr1x(i,j))))

       call line(psep+pr1x(i,j)+xvrib*dsin(alpr),psey+pr1y(i,j)
     + -xvrib*dcos(alpr),psep+pr2x(i,j)+xvrib*dsin(alpr),
     + psey+pr2y(i,j)-xvrib*dcos(alpr),3)

c      Tancament lateral inici
       if (j.eq.1) then
       call line(psep+pl1x(i,j)-xvrib*dsin(alpl),psey+pl1y(i,j)
     + +xvrib*dcos(alpl),psep+pl1x(i,j),psey+pl1y(i,j),1)
       call line(psep+pr1x(i,j)+xvrib*dsin(alpr),psey+pr1y(i,j)
     + -xvrib*dcos(alpr),psep+pr1x(i,j),psey+pr1y(i,j),1)
       end if

c      Tancament lateral fi
       if (j.eq.20) then
       call line(psep+pl2x(i,j)-xvrib*dsin(alpl),psey+pl2y(i,j)
     + +xvrib*dcos(alpl),psep+pl2x(i,j),psey+pl2y(i,j),4)
       call line(psep+pr2x(i,j)+xvrib*dsin(alpr),psey+pr2y(i,j)
     + -xvrib*dcos(alpr),psep+pr2x(i,j),psey+pr2y(i,j),4)
       end if

c      REVISAR PRESENTACIO

c      Numera cintes V
       call itxt(psep-20-xrsep,psey-10,10.0d0,0.0d0,i,7)
       call itxt(psep+20-xrsep,psey-10,10.0d0,0.0d0,i+1,7)

       end do

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      VH-rib 1-3 in 2D model
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)

       px0=0.
       py0=0.
       ptheta=0.

       do j=1,21

c      Distances between points
       pa=sqrt((rx(i+1,j)-rx(i,j))**2.+(ry(i+1,j)-ry(i,j))**2.+
     + (rz(i+1,j)-rz(i,j))**2.)
       pb=sqrt((rx(i+1,j+1)-rx(i,j))**2.+(ry(i+1,j+1)-ry(i,j))**2.+
     + (rz(i+1,j+1)-rz(i,j))**2.)
       pc=sqrt((rx(i+1,j+1)-rx(i+1,j))**2.+(ry(i+1,j+1)-ry(i+1,j))**2.+
     + (rz(i+1,j+1)-rz(i+1,j))**2.)
       pd=sqrt((rx(i+1,j)-rx(i,j+1))**2.+(ry(i+1,j)-ry(i,j+1))**2.+
     + (rz(i+1,j)-rz(i,j+1))**2.)
       pe=sqrt((rx(i,j+1)-rx(i,j))**2.+(ry(i,j+1)-ry(i,j))**2.+
     + (rz(i,j+1)-rz(i,j))**2.)
       pf=sqrt((rx(i+1,j+1)-rx(i,j+1))**2.+(ry(i+1,j+1)-ry(i,j+1))**2.+
     + (rz(i+1,j+1)-rz(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

       pb2t=(pb*pb-pe*pe+pf*pf)/(2.*pb)
       pb1t=pb-pb2t
       pht=sqrt(pf*pf-pb2t*pb2t)
       
       pw1=datan(phr/pa1r)
       phu=pb1t*dtan(pw1)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0
       
       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

c      Iteration
       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
       
       
       end do

c      Drawing in 2D model
       
       psep=3300.*xkf+xrsep*float(i)
       psey=800.*xkf+yrsep*float(ii)

       j=1

       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),1)

       j=21

       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),1)

       do j=1,21-1

       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pl2x(i,j),
     + psey+pl2y(i,j),1)

       call line(psep+pr1x(i,j),psey+pr1y(i,j),psep+pr2x(i,j),
     + psey+pr2y(i,j),1)


c      Vores de costura esquerra
       alpl=abs(datan((pl2y(i,j)-pl1y(i,j))/(pl2x(i,j)-pl1x(i,j))))

       call line(psep+pl1x(i,j)-xvrib*dsin(alpl),psey+pl1y(i,j)
     + +xvrib*dcos(alpl),psep+pl2x(i,j)-xvrib*dsin(alpl),
     + psey+pl2y(i,j)+xvrib*dcos(alpl),3)

c      Vores de costura dreta
       alpr=abs(datan((pr2y(i,j)-pr1y(i,j))/(pr2x(i,j)-pr1x(i,j))))

       call line(psep+pr1x(i,j)+xvrib*dsin(alpr),psey+pr1y(i,j)
     + -xvrib*dcos(alpr),psep+pr2x(i,j)+xvrib*dsin(alpr),
     + psey+pr2y(i,j)-xvrib*dcos(alpr),3)

c      Tancament lateral inici
       if (j.eq.1) then
       call line(psep+pl1x(i,j)-xvrib*dsin(alpl),psey+pl1y(i,j)
     + +xvrib*dcos(alpl),psep+pl1x(i,j),psey+pl1y(i,j),1)
       call line(psep+pr1x(i,j)+xvrib*dsin(alpr),psey+pr1y(i,j)
     + -xvrib*dcos(alpr),psep+pr1x(i,j),psey+pr1y(i,j),1)
       end if

c      Tancament lateral fi
       if (j.eq.20) then
       call line(psep+pl2x(i,j)-xvrib*dsin(alpl),psey+pl2y(i,j)
     + +xvrib*dcos(alpl),psep+pl2x(i,j),psey+pl2y(i,j),4)
       call line(psep+pr2x(i,j)+xvrib*dsin(alpr),psey+pr2y(i,j)
     + -xvrib*dcos(alpr),psep+pr2x(i,j),psey+pr2y(i,j),4)
       end if

       end do

c      REVISAR PRESENTACIO

c      Numera cintes H
       call itxt(psep-30-xrsep,psey-10,10.0d0,0.0d0,i,7)
       call itxt(psep+10-xrsep,psey-10,10.0d0,0.0d0,i+1,7)


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Drawing VH-ribs in 2D ribs
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box (1,2)

       sepxx=700.*xkf
       sepyy=100.*xkf

c      Rib i-1
       kx=int((float(i-2)/6.))
       ky=i-1-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

c       write (*,*) "i,kx,ky ",i,kx,ky,sepx,sepy

       if (hvr(k,5).eq.1) then
       call line(sepx+ucnt(i-1,ii,6),-vcnt(i-1,ii,6)+sepy,
     + sepx+ucnt(i-1,ii,8),-vcnt(i-1,ii,8)+sepy,1)
       end if

c      Rib i (center)
       kx=int((float(i-1)/6.))
       ky=i-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

       call line(sepx+ucnt(i,ii,2),-vcnt(i,ii,2)+sepy,
     + sepx+ucnt(i,ii,4),-vcnt(i,ii,4)+sepy,4)

c      Rib i+1
       kx=int((float(i)/6.))
       ky=i+1-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

       if (hvr(k,6).eq.1) then
       call line(sepx+ucnt(i+1,ii,6),-vcnt(i+1,ii,6)+sepy,
     + sepx+ucnt(i+1,ii,8),-vcnt(i+1,ii,8)+sepy,5)
       end if

c      Rib i+2
       kx=int((float(i)/6.))
       ky=i+2-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

       if (hvr(k,6).eq.1) then
       call line(sepx+ucnt(i+2,ii,6),-vcnt(i+2,ii,6)+sepy,
     + sepx+ucnt(i+2,ii,8),-vcnt(i+2,ii,8)+sepy,5)
       end if

       end if   ! end type VH



ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.6 V-rib type 6 GENERAL TYPE
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.6.1 Rib i
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Now ii is virtual row, assigned automatically for each rib
       iii=1

       if (hvr(k,2).eq.6) then

c      Define types 6 along rib
       if (k.ge.2.and.hvr(k-1,2).eq.6.and.hvr(k-1,3).eq.hvr(k,3)) then
       iii=iii+1
       end if

c      Define main points 2,3,4,9,10,11

       i=hvr(k,3)    ! rib i
       ii=iii       ! virtual row ii, in rib i

       ucnt(i,ii,3)=rib(i,5)*hvr(k,4)/100.0d0
       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,7)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,6)
       ucnt(i,ii,6)=ucnt(i,ii,2)
       ucnt(i,ii,7)=ucnt(i,ii,3)
       ucnt(i,ii,8)=ucnt(i,ii,4)
       ucnt(i,ii,9)=ucnt(i,ii,2)
       ucnt(i,ii,10)=ucnt(i,ii,3)
       ucnt(i,ii,11)=ucnt(i,ii,4)

c      Points 2,3,4 interpolation in rib i

       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,2).and.u(i,j+1,3).ge.ucnt(i,ii,2)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,2)=xm*ucnt(i,ii,2)+xb
       jcon(i,ii,2)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       jcon(i,ii,3)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,4).and.u(i,j+1,3).ge.ucnt(i,ii,4)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,4)=xm*ucnt(i,ii,4)+xb
       jcon(i,ii,4)=j
       end if

       end do

c      Points 9,10,11 interpolation in rib i

       do j=1,np(i,2)

       if (u(i,j,3).gt.ucnt(i,ii,9).and.u(i,j+1,3).le.ucnt(i,ii,9)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,9)=xm*ucnt(i,ii,9)+xb
       jcon(i,ii,9)=j+1
       end if

       if (u(i,j,3).gt.ucnt(i,ii,10).and.u(i,j+1,3).le.ucnt(i,ii,10)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,10)=xm*ucnt(i,ii,10)+xb
       jcon(i,ii,10)=j+1
       end if

       if (u(i,j,3).gt.ucnt(i,ii,11).and.u(i,j+1,3).le.ucnt(i,ii,11)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,11)=xm*ucnt(i,ii,11)+xb
       jcon(i,ii,11)=j+1
       end if

       end do

c      Points 6,8 interpolation in rib i

       vcnt(i,ii,6)=(vcnt(i,ii,9)-vcnt(i,ii,2))*(hvr(k,5)/100.)+
     + vcnt(i,ii,2)
       vcnt(i,ii,8)=(vcnt(i,ii,11)-vcnt(i,ii,4))*(hvr(k,5)/100.)+
     + vcnt(i,ii,4)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Case h1=0.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       if (hvr(k,5).eq.0.) then

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat line 2-3-4 in n regular spaces   
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Experimental version     
c      Reformat in 20 spaces

       n1vr=jcon(i,ii,4)-jcon(i,ii,2)+1
       n2vr=20+1

c      Load data polyline
       xlin1(1)=ucnt(i,ii,2)
       ylin1(1)=vcnt(i,ii,2)
       do j=2,n1vr-1
       xlin1(j)=u(i,jcon(i,ii,2)+j-1,3)
       ylin1(j)=v(i,jcon(i,ii,2)+j-1,3)
c      MIRAR SI CAL +-1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       end do
       xlin1(n1vr)=ucnt(i,ii,4)
       ylin1(n1vr)=vcnt(i,ii,4)

c      Call subroutine vector redistribution

       call vredis(xlin1,ylin1,xlin3,ylin3,n1vr,n2vr)

c      Load result polyline

       do j=1,n2vr
       ucnt2(i,ii,j)=xlin3(j)
       vcnt2(i,ii,j)=ylin3(j)
       end do

       end if ! case h1=0.

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Case 0. < h1 < 100.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Redefine line 2: ucnt2(i,ii,j) - vcnt2(i,ii,j)
c      Divide line 6-8 in n segments

       uinc=0.
       vinc=0.
       do j=1,21
       ucnt2(i,ii,j)=ucnt(i,ii,6)+uinc
       uinc=uinc+(ucnt(i,ii,8)-ucnt(i,ii,6))/20.
       vcnt2(i,ii,j)=vcnt(i,ii,6)+vinc
       vinc=vinc+(vcnt(i,ii,8)-vcnt(i,ii,6))/20.
       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Case h1=100.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,5).eq.100.) then

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat 9-10-11 in n spaces (rib i)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
   
c      Reformat in 20 spaces

       n1vr=jcon(i,ii,9)-jcon(i,ii,11)+1    
       n2vr=20+1

c      Load data polyline
       xlin1(1)=ucnt(i,ii,9)
       ylin1(1)=vcnt(i,ii,9)
       do j=2,n1vr-1
       xlin1(j)=u(i,jcon(i,ii,9)-j+1,3)
       ylin1(j)=v(i,jcon(i,ii,9)-j+1,3)
c      MIRAR SI CAL +-1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       end do
       xlin1(n1vr)=ucnt(i,ii,11)
       ylin1(n1vr)=vcnt(i,ii,11)

c      Call subroutine vector redistribution

       call vredis(xlin1,ylin1,xlin3,ylin3,n1vr,n2vr)

c      Load result polyline

       do j=1,n2vr
       ucnt2(i,ii,j)=xlin3(j)
       vcnt2(i,ii,j)=ylin3(j)
       end do
 
       end if ! Case h1=100.


cccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.6.2 Rib i+1
cccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,8)   ! rib i+1
c      ii use virtial row 

       ucnt(i,ii,3)=rib(i,5)*hvr(k,9)/100.0d0

c       ucnt(i,ii,1)=ucnt(i,ii,3)-hvr(k,8)

       ucnt(i,ii,2)=ucnt(i,ii,3)-hvr(k,12)
       ucnt(i,ii,4)=ucnt(i,ii,3)+hvr(k,11)
       ucnt(i,ii,6)=ucnt(i,ii,2)
       ucnt(i,ii,8)=ucnt(i,ii,4)
       ucnt(i,ii,9)=ucnt(i,ii,2)
       ucnt(i,ii,11)=ucnt(i,ii,4)

c      Points 2,3,4 interpolation in rib i+1

       do j=np(i,2),np(i,1)

       if (u(i,j,3).le.ucnt(i,ii,2).and.u(i,j+1,3).ge.ucnt(i,ii,2)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,2)=xm*ucnt(i,ii,2)+xb
       jcon(i,ii,2)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,3).and.u(i,j+1,3).ge.ucnt(i,ii,3)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,3)=xm*ucnt(i,ii,3)+xb
       jcon(i,ii,3)=j
       end if

       if (u(i,j,3).le.ucnt(i,ii,4).and.u(i,j+1,3).ge.ucnt(i,ii,4)) then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,4)=xm*ucnt(i,ii,4)+xb
       jcon(i,ii,4)=j
       end if

       end do

c      Points 9,10,11 interpolation in rib i+1

       do j=1,np(i,2)

       if (u(i,j,3).gt.ucnt(i,ii,9).and.u(i,j+1,3).le.ucnt(i,ii,9)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,9)=xm*ucnt(i,ii,9)+xb
       jcon(i,ii,9)=j+1
       end if

       if (u(i,j,3).gt.ucnt(i,ii,10).and.u(i,j+1,3).le.ucnt(i,ii,10)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,10)=xm*ucnt(i,ii,10)+xb
       jcon(i,ii,10)=j+1
       end if

       if (u(i,j,3).gt.ucnt(i,ii,11).and.u(i,j+1,3).le.ucnt(i,ii,11)) 
     + then
       xm=(v(i,j+1,3)-v(i,j,3))/(u(i,j+1,3)-u(i,j,3))
       xb=v(i,j,3)-xm*u(i,j,3)
       vcnt(i,ii,11)=xm*ucnt(i,ii,11)+xb
       jcon(i,ii,11)=j+1
       end if

       end do

c      Points 6,8 interpolation in rib i+1

       vcnt(i,ii,6)=(vcnt(i,ii,9)-vcnt(i,ii,2))*(hvr(k,10)/100.)+
     + vcnt(i,ii,2)
       vcnt(i,ii,8)=(vcnt(i,ii,11)-vcnt(i,ii,4))*(hvr(k,10)/100.)+
     + vcnt(i,ii,4)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Case h2=0.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,10).eq.0.) then

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat line 2-3-4 in n regular spaces   
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Experimental version     
c      Reformat in 20 spaces

       n1vr=jcon(i,ii,4)-jcon(i,ii,2)+1
       n2vr=20+1

c      Load data polyline
       xlin1(1)=ucnt(i,ii,2)
       ylin1(1)=vcnt(i,ii,2)
       do j=2,n1vr-1
       xlin1(j)=u(i,jcon(i,ii,2)+j-1,3)
       ylin1(j)=v(i,jcon(i,ii,2)+j-1,3)
c      MIRAR SI CAL +-1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       end do
       xlin1(n1vr)=ucnt(i,ii,4)
       ylin1(n1vr)=vcnt(i,ii,4)

c      Call subroutine vector redistribution

       call vredis(xlin1,ylin1,xlin3,ylin3,n1vr,n2vr)

c      Load result polyline

       do j=1,n2vr
       ucnt3(i,ii,j)=xlin3(j)
       vcnt3(i,ii,j)=ylin3(j)
       end do

       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Case 0. < h2 < 100.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Redefine line 2: ucnt3(i,ii,j) - vcnt3(i,ii,j)
c      Divide line 6-8 in n segments

       uinc=0.
       vinc=0.
       do j=1,21
       ucnt3(i,ii,j)=ucnt(i,ii,6)+uinc
       uinc=uinc+(ucnt(i,ii,8)-ucnt(i,ii,6))/20.
       vcnt3(i,ii,j)=vcnt(i,ii,6)+vinc
       vinc=vinc+(vcnt(i,ii,8)-vcnt(i,ii,6))/20.
       end do

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Case h2=100.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,10).eq.100.) then

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Reformat 9-10-11 in n spaces (rib i+1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Experimental version     
c      Reformat in 20 spaces

       n1vr=jcon(i,ii,9)-jcon(i,ii,11)+1
       n2vr=20+1

c      Load data polyline
       xlin1(1)=ucnt(i,ii,9)
       ylin1(1)=vcnt(i,ii,9)
       do j=2,n1vr-1
       xlin1(j)=u(i,jcon(i,ii,9)-j+1,3)
       ylin1(j)=v(i,jcon(i,ii,9)-j+1,3)
c      MIRAR SI CAL +-1 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       end do
       xlin1(n1vr)=ucnt(i,ii,11)
       ylin1(n1vr)=vcnt(i,ii,11)

c      Call subroutine vector redistribution

       call vredis(xlin1,ylin1,xlin3,ylin3,n1vr,n2vr)

c      Load result polyline

       do j=1,n2vr
       ucnt3(i,ii,j)=xlin3(j)
       vcnt3(i,ii,j)=ylin3(j)
       end do

       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Rib localisation
       i=hvr(k,3)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.6.3 V-ribs lines 2 3 transportation to 3D espace
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Rib i (Line 2)

       i=hvr(k,3)

       tetha=rib(i,8)*pi/180.
       
       do j=1,21
       ru(i,j,3)=ucnt2(i,ii,j)
       rv(i,j,3)=vcnt2(i,ii,j)-rib(i,50)
       end do

       do j=1,21

c      V-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      V-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      V-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       rx2(i,j,ii)=rx(i,j)
       ry2(i,j,ii)=ry(i,j)
       rz2(i,j,ii)=rz(i,j)

       end do

c      Rib i+1 (Line 3)

       i=hvr(k,8)

       tetha=rib(i,8)*pi/180.

       do j=1,21
       ru(i,j,3)=ucnt3(i,ii,j)
       rv(i,j,3)=vcnt3(i,ii,j)-rib(i,50)
c      COMPTE AMB el rib(i,50) A ESTUDIAR       
       end do

       do j=1,21

c      V-ribs washin coordinates
       ru(i,j,4)=(ru(i,j,3)-(rib(i,10)/100.)*rib(i,5))*dcos(tetha)+
     + (rv(i,j,3))*dsin(tetha)+(rib(i,10)/100.)*rib(i,5)
       rv(i,j,4)=(-ru(i,j,3)+(rib(i,10)/100.)*rib(i,5))*dsin(tetha)+
     + (rv(i,j,3))*dcos(tetha)

c      V-ribs (u,v,w) espace coordinates
       ru(i,j,5)=ru(i,j,4)
       rv(i,j,5)=rv(i,j,4)*dcos(rib(i,9)*pi/180.)
       rw(i,j,5)=-rv(i,j,4)*dsin(rib(i,9)*pi/180.)

c      V-ribs (x,y,z) absolute coordinates
       rx(i,j)=rib(i,6)-rw(i,j,5)
       ry(i,j)=rib(i,3)+ru(i,j,5)
       rz(i,j)=rib(i,7)-rv(i,j,5)
       rx3(i-1,j,ii)=rx(i,j)
       ry3(i-1,j,ii)=ry(i,j)
       rz3(i-1,j,ii)=rz(i,j)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.6.4 V-ribs calculus and drawing in 3D and 2D
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.6.4 V-rib 2-3 in 2D model (red)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       i=hvr(k,3)

       px0=0.
       py0=0.
       ptheta=0.

       do j=1,21

c      Distances between points
       pa=sqrt((rx(i+1,j)-rx(i,j))**2.+(ry(i+1,j)-ry(i,j))**2.+
     + (rz(i+1,j)-rz(i,j))**2.)
       pb=sqrt((rx(i+1,j+1)-rx(i,j))**2.+(ry(i+1,j+1)-ry(i,j))**2.+
     + (rz(i+1,j+1)-rz(i,j))**2.)
       pc=sqrt((rx(i+1,j+1)-rx(i+1,j))**2.+(ry(i+1,j+1)-ry(i+1,j))**2.+
     + (rz(i+1,j+1)-rz(i+1,j))**2.)
       pd=sqrt((rx(i+1,j)-rx(i,j+1))**2.+(ry(i+1,j)-ry(i,j+1))**2.+
     + (rz(i+1,j)-rz(i,j+1))**2.)
       pe=sqrt((rx(i,j+1)-rx(i,j))**2.+(ry(i,j+1)-ry(i,j))**2.+
     + (rz(i,j+1)-rz(i,j))**2.)
       pf=sqrt((rx(i+1,j+1)-rx(i,j+1))**2.+(ry(i+1,j+1)-ry(i,j+1))**2.+
     + (rz(i+1,j+1)-rz(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

       pb2t=(pb*pb-pe*pe+pf*pf)/(2.*pb)
       pb1t=pb-pb2t
       pht=sqrt(pf*pf-pb2t*pb2t)
       
       pw1=datan(phr/pa1r)
       phu=pb1t*dtan(pw1)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0
       
       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

c      Iteration
       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
       
       
       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Drawing Type-6 in 2D model
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       

c      Draw in BOX(2,6)

       psep=(3300.+1260.+1260.)*xkf+xrsep*float(i)
       psey=(800.+890.85)*xkf+yrsep*float(ii)

c       write (*,*) "i,ii ",i,ii

       j=1

c      Costat vora d'atac
       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),1)

       j=21
c      Costat fuga
       call line(psep+pl1x(i,j),psey+pl1y(i,j),psep+pr1x(i,j),
     + psey+pr1y(i,j),1)


c      Marca punts MC a l'esquerra

       alpha=-(datan((pl1y(i,1)-pl2y(i,20))/(pl1x(i,1)-pl2x(i,20))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xp6=pl1x(i,1)-xdes*dsin(alpha)-2.*xdes*dcos(alpha)
       yp6=pl1y(i,1)-xdes*dcos(alpha)+2.*xdes*dsin(alpha)
       xp8=pl1x(i,21)-xdes*dsin(alpha)+2.*xdes*dcos(alpha)
       yp8=pl1y(i,21)-xdes*dcos(alpha)-2.*xdes*dsin(alpha)
c       xp7=0.5*(pl1x(i,1)+pl1x(i,21))-xdes*dsin(alpha)
c       yp7=0.5*(pl1y(i,1)+pl1y(i,21))-xdes*dcos(alpha)

c       call point(psep+xp7,psey+yp7,2)

       call point(psep+xp6,psey+yp6,1)
c       call point(psep+xp7,psey+yp7,1)
       call point(psep+xp8,psey+yp8,1)


c      Romano costat esquerra

       sl=1.
       
       xpx=(pl1x(i,1)+pl2x(i,20))/2.-sl*xdes*dsin(alpha)
       xpy=(pl1y(i,1)+pl2y(i,20))/2.-sl*xdes*dcos(alpha)

       xpx2=psep+xpx+0.3*hvr(k,7)*dcos(alpha)-0.3*xvrib*dsin(alpha)
       xpy2=psey+xpy-0.3*hvr(k,7)*dsin(alpha)-0.3*xvrib*dcos(alpha) 

       call romano(i,xpx2,xpy2,alpha,0.4d0,3)

c      Marca punts MC a la dreta

       alpha=-(datan((pr1y(i,1)-pr2y(i,20))/(pr1x(i,1)
     + -pr2x(i,20))))
       if (alpha.lt.0.) then
       alpha=alpha+pi
       end if

       xp6=pr1x(i,1)+xdes*dsin(alpha)-2.*xdes*dcos(alpha)
       yp6=pr1y(i,1)+xdes*dcos(alpha)+2.*xdes*dsin(alpha)
       xp8=pr1x(i,21)+xdes*dsin(alpha)+2.*xdes*dcos(alpha)
       yp8=pr1y(i,21)+xdes*dcos(alpha)-2.*xdes*dsin(alpha)
       xp7=0.5*(xp6+xp8)
       yp7=0.5*(yp6+yp8)

       call point(psep+xp6,psey+yp6,1)
c       call point(psep+xp7,psey+yp7,1)
       call point(psep+xp8,psey+yp8,1)

c      Romano costat dret

       sr=1.
       
       xpx=(pr1x(i,1)+pr2x(i,20))/2.+xdes*dsin(alpha)
       xpy=(pr1y(i,1)+pr2y(i,20))/2.+xdes*dcos(alpha)

       xpx2=psep+xpx+0.5*hvr(k,8)*dcos(alpha)+0.3*xvrib*dsin(alpha)
       xpy2=psey+xpy-0.5*hvr(k,8)*dsin(alpha)+0.3*xvrib*dcos(alpha) 

       call romano(i+1,xpx2,xpy2,alpha,0.4d0,3)

       xpx2=psep+xpx-0.5*hvr(k,8)*dcos(alpha)+0.3*xvrib*dsin(alpha)
       xpy2=psey+xpy+0.5*hvr(k,8)*dsin(alpha)+0.3*xvrib*dcos(alpha) 

       call romano(int(hvr(k,4)),xpx2,xpy2,alpha,0.4d0,3)

c      Vores de costura

       do j=1,21-1

c      Vores de costura esquerra
       alpl=-(datan((pl1y(i,j)-pl2y(i,j))/(pl1x(i,j)-pl2x(i,j))))
       if (alpl.lt.0.) then
       alpl=alpl+pi
       end if

       lvcx(i,j)=psep+pl1x(i,j)-xvrib*dsin(alpl)
       lvcy(i,j)=psey+pl1y(i,j)-xvrib*dcos(alpl)

c      Vores de costura dreta
       alpr=-(datan((pr1y(i,j)-pr2y(i,j))/(pr1x(i,j)-pr2x(i,j))))
       if (alpr.lt.0.) then
       alpr=alpr+pi
       end if

       rvcx(i,j)=psep+pr1x(i,j)+xvrib*dsin(alpr)
       rvcy(i,j)=psey+pr1y(i,j)+xvrib*dcos(alpr)

c      Tancament lateral inici
       if (j.eq.1) then
       call line(psep+pl1x(i,j)-xvrib*dsin(alpl),psey+pl1y(i,j)
     + -xvrib*dcos(alpl),psep+pl1x(i,j),psey+pl1y(i,j),1)
       call line(psep+pr1x(i,j)+xvrib*dsin(alpr),psey+pr1y(i,j)
     + +xvrib*dcos(alpr),psep+pr1x(i,j),psey+pr1y(i,j),1)
       end if

c      Tancament lateral fi
       if (j.eq.20) then
       call line(psep+pl2x(i,j)-xvrib*dsin(alpl),psey+pl2y(i,j)
     + -xvrib*dcos(alpl),psep+pl2x(i,j),psey+pl2y(i,j),1)
       call line(psep+pr2x(i,j)+xvrib*dsin(alpr),psey+pr2y(i,j)
     + +xvrib*dcos(alpr),psep+pr2x(i,j),psey+pr2y(i,j),1)

       lvcx(i,j+1)=psep+pl2x(i,j)-xvrib*dsin(alpl)
       lvcy(i,j+1)=psey+pl2y(i,j)-xvrib*dcos(alpl)

       rvcx(i,j+1)=psep+pr2x(i,j)+xvrib*dsin(alpr)
       rvcy(i,j+1)=psey+pr2y(i,j)+xvrib*dcos(alpr)

       end if

c      V-rib length
       hvr(k,15)=sqrt((lvcx(i,1)-rvcx(i,1))**2.+
     + (lvcy(i,1)-rvcy(i,1))**2.)

c      Numera cintes V
       call itxt(psep-xrsep,psey-10,10.0d0,0.0d0,i,7)
       call itxt(psep+hvr(k,15)-xrsep,psey-10,10.0d0,0.0d0,i+1,7)

       end do

c      Dibuixa vores amb segments completament enllaçats       
       do j=1,20

       call line(lvcx(i,j),lvcy(i,j),lvcx(i,j+1),lvcy(i,j+1),1)
       call line(rvcx(i,j),rvcy(i,j),rvcx(i,j+1),rvcy(i,j+1),1)

       end do


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.6.5 Drawing V-ribs marks in 2D ribs
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Drawing in 2D ribs printing and MC (+2530.xkf)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Box (1,2)

       sepxx=700.*xkf
       sepyy=100.*xkf

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Rib i (center)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       kx=int((float(i-1)/6.))
       ky=i-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Case h1=0.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,5).eq.0.) then

c      Segment
       call line(sepx+ucnt(i,ii,2),-vcnt(i,ii,2)+sepy,
     + sepx+ucnt(i,ii,4),-vcnt(i,ii,4)+sepy,1)
       call line(sepx+2530.*xkf+ucnt(i,ii,2),-vcnt(i,ii,2)+sepy,
     + sepx+2530.*xkf+ucnt(i,ii,4),-vcnt(i,ii,4)+sepy,1)

c      Points in 2 and 4 (Experimental)

c      Points in 2
       alpha=(datan((v(i,jcon(i,ii,2)-1,3)-v(i,jcon(i,ii,2)+1,
     + 3))/(u(i,jcon(i,ii,2)-1,3)-u(i,jcon(i,ii,2)+1,3))))
       xpeq=ucnt(i,ii,2)+1.*xdes*dsin(alpha)
       ypeq=vcnt(i,ii,2)-1.*xdes*dcos(alpha)
       call point(sepx+xpeq,sepy-ypeq,1)
       call point(sepx+xpeq-1*dsin(alpha),sepy-ypeq-1*dcos(alpha),1)
       call point(sepx+xpeq-2*dsin(alpha),sepy-ypeq-2*dcos(alpha),1)
       call point(2530.*xkf+sepx+xpeq,sepy-ypeq,1)
       call point(2530.*xkf+sepx+xpeq-1*dsin(alpha),sepy-ypeq-
     + 1*dcos(alpha),1)
       call point(2530.*xkf+sepx+xpeq-2*dsin(alpha),sepy-ypeq-
     + 2*dcos(alpha),1)

c      Points in 4
       alpha=(datan((v(i,jcon(i,ii,4)-1,3)-v(i,jcon(i,ii,4)+1,
     + 3))/(u(i,jcon(i,ii,4)-1,3)-u(i,jcon(i,ii,4)+1,3))))
       xpeq=ucnt(i,ii,4)+1.*xdes*dsin(alpha)
       ypeq=vcnt(i,ii,4)-1.*xdes*dcos(alpha)
       call point(sepx+xpeq,sepy-ypeq,1)
       call point(sepx+xpeq-1*dsin(alpha),sepy-ypeq-1*dcos(alpha),1)
       call point(sepx+xpeq-2*dsin(alpha),sepy-ypeq-2*dcos(alpha),1)
       call point(2530.*xkf+sepx+xpeq,sepy-ypeq,1)
       call point(2530.*xkf+sepx+xpeq-1*dsin(alpha),sepy-ypeq-
     + 1*dcos(alpha),1)
       call point(2530.*xkf+sepx+xpeq-2*dsin(alpha),sepy-ypeq-
     + 2*dcos(alpha),1)

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Case 0. < h1 < 100.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,5).gt.0.and.hvr(k,5).lt.100.) then

c      Segment
       call line(sepx+ucnt(i,ii,6),-vcnt(i,ii,6)+sepy,
     + sepx+ucnt(i,ii,8),-vcnt(i,ii,8)+sepy,1)
       call line(sepx+2530.*xkf+ucnt(i,ii,6),-vcnt(i,ii,6)+sepy,
     + sepx+2530.*xkf+ucnt(i,ii,8),-vcnt(i,ii,8)+sepy,1)

c      Punts marcatge V-rib
       alpha=datan((vcnt(i,ii,8)-vcnt(i,ii,6))/
     + (ucnt(i,ii,8)-ucnt(i,ii,6)))
       xp6=ucnt(i,ii,6)-xdes*dsin(alpha)
       yp6=vcnt(i,ii,6)+xdes*dcos(alpha)
       xp8=ucnt(i,ii,8)-xdes*dsin(alpha)
       yp8=vcnt(i,ii,8)+xdes*dcos(alpha)
       xp7=0.5*(xp6+xp8)
       yp7=0.5*(yp6+yp8)
       call point(sepx+xp6,sepy-yp6,1)
       call point(sepx+xp7,sepy-yp7,1)
       call point(sepx+xp8,sepy-yp8,1)
       call point(sepx+2530.*xkf+xp6,sepy-yp6,1)
       call point(sepx+2530.*xkf+xp7,sepy-yp7,1)
       call point(sepx+2530.*xkf+xp8,sepy-yp8,1)

       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Case h1=100.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,5).eq.100.) then

c      Segment
       call line(sepx+ucnt(i,ii,9),-vcnt(i,ii,9)+sepy,
     + sepx+ucnt(i,ii,11),-vcnt(i,ii,11)+sepy,1)
       call line(sepx+2530.*xkf+ucnt(i,ii,9),-vcnt(i,ii,9)+sepy,
     + sepx+2530.*xkf+ucnt(i,ii,11),-vcnt(i,ii,11)+sepy,1)

c      Points in 9
       alpha=(datan((v(i,jcon(i,ii,9)-1,3)-v(i,jcon(i,ii,9)+1,
     + 3))/(u(i,jcon(i,ii,9)-1,3)-u(i,jcon(i,ii,9)+1,3))))
       xpeq=ucnt(i,ii,9)-1.*xdes*dsin(alpha)
       ypeq=vcnt(i,ii,9)+1.*xdes*dcos(alpha)
       call point(sepx+xpeq,sepy-ypeq,1)
       call point(sepx+xpeq+1*dsin(alpha),sepy-ypeq+1*dcos(alpha),1)
       call point(sepx+xpeq+2*dsin(alpha),sepy-ypeq+2*dcos(alpha),1)
       call point(2530.*xkf+sepx+xpeq,sepy-ypeq,1)
       call point(2530.*xkf+sepx+xpeq+1*dsin(alpha),sepy-ypeq+
     + 1*dcos(alpha),1)
       call point(2530.*xkf+sepx+xpeq+2*dsin(alpha),sepy-ypeq+
     + 2*dcos(alpha),1)

c      Points in 11
       alpha=(datan((v(i,jcon(i,ii,11)-1,3)-v(i,jcon(i,ii,11)+1,
     + 3))/(u(i,jcon(i,ii,11)-1,3)-u(i,jcon(i,ii,11)+1,3))))
       xpeq=ucnt(i,ii,11)-1.*xdes*dsin(alpha)
       ypeq=vcnt(i,ii,11)+1.*xdes*dcos(alpha)
       call point(sepx+xpeq,sepy-ypeq,1)
       call point(sepx+xpeq+1*dsin(alpha),sepy-ypeq+1*dcos(alpha),1)
       call point(sepx+xpeq+2*dsin(alpha),sepy-ypeq+2*dcos(alpha),1)
       call point(2530.*xkf+sepx+xpeq,sepy-ypeq,1)
       call point(2530.*xkf+sepx+xpeq+1*dsin(alpha),sepy-ypeq+
     + 1*dcos(alpha),1)
       call point(2530.*xkf+sepx+xpeq+2*dsin(alpha),sepy-ypeq+
     + 2*dcos(alpha),1)

       end if


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Rib i+1
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       kx=int((float(i)/6.))
       ky=i+1-kx*6

       sepx=sepxx+seprix*float(kx)
       sepy=sepyy+sepriy*float(ky-1)

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Case h2=0.
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,10).eq.0.) then

c      Segments
       call line(sepx+ucnt(i+1,ii,2),-vcnt(i+1,ii,2)+sepy,
     + sepx+ucnt(i+1,ii,4),-vcnt(i+1,ii,4)+sepy,4)
       call line(sepx+2530.*xkf+ucnt(i+1,ii,2),-vcnt(i+1,ii,2)+sepy,
     + sepx+2530.*xkf+ucnt(i+1,ii,4),-vcnt(i+1,ii,4)+sepy,4)

c      Draw 3 point in 2 and 4

c      Points in 2 and 4 (Experimental)

c      Points in 2
       alpha=(datan((v(i+1,jcon(i+1,ii,2)-1,3)-v(i+1,jcon(i+1,ii,2)+1,
     + 3))/(u(i+1,jcon(i+1,ii,2)-1,3)-u(i+1,jcon(i+1,ii,2)+1,3))))
       xpeq=ucnt(i+1,ii,2)+1.*xdes*dsin(alpha)
       ypeq=vcnt(i+1,ii,2)-1.*xdes*dcos(alpha)
       call point(sepx+xpeq,sepy-ypeq,4)
       call point(sepx+xpeq-1*dsin(alpha),sepy-ypeq-1*dcos(alpha),4)
       call point(sepx+xpeq-2*dsin(alpha),sepy-ypeq-2*dcos(alpha),4)
       call point(2530.*xkf+sepx+xpeq,sepy-ypeq,4)
       call point(2530.*xkf+sepx+xpeq-1*dsin(alpha),sepy-ypeq-
     + 1*dcos(alpha),4)
       call point(2530.*xkf+sepx+xpeq-2*dsin(alpha),sepy-ypeq-
     + 2*dcos(alpha),4)

c      Points in 4
       alpha=(datan((v(i+1,jcon(i+1,ii,4)-1,3)-v(i+1,jcon(i+1,ii,4)+1,
     + 3))/(u(i+1,jcon(i+1,ii,4)-1,3)-u(i+1,jcon(i+1,ii,4)+1,3))))
       xpeq=ucnt(i+1,ii,4)+1.*xdes*dsin(alpha)
       ypeq=vcnt(i+1,ii,4)-1.*xdes*dcos(alpha)
       call point(sepx+xpeq,sepy-ypeq,4)
       call point(sepx+xpeq-1*dsin(alpha),sepy-ypeq-1*dcos(alpha),4)
       call point(sepx+xpeq-2*dsin(alpha),sepy-ypeq-2*dcos(alpha),4)
       call point(2530.*xkf+sepx+xpeq,sepy-ypeq,4)
       call point(2530.*xkf+sepx+xpeq-1*dsin(alpha),sepy-ypeq-
     + 1*dcos(alpha),4)
       call point(2530.*xkf+sepx+xpeq-2*dsin(alpha),sepy-ypeq-
     + 2*dcos(alpha),4)

       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Case 0. < h2 < 100.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,10).gt.0.and.hvr(k,10).lt.100.) then

c      Segments
       call line(sepx+ucnt(i+1,ii,6),-vcnt(i+1,ii,6)+sepy,
     + sepx+ucnt(i+1,ii,8),-vcnt(i+1,ii,8)+sepy,4)
       call line(sepx+2530.*xkf+ucnt(i+1,ii,6),-vcnt(i+1,ii,6)+sepy,
     + sepx+2530.*xkf+ucnt(i+1,ii,8),-vcnt(i+1,ii,8)+sepy,4)

c      Punts marcatge V-rib
       alpha=datan((vcnt(i+1,ii,8)-vcnt(i+1,ii,6))/
     + (ucnt(i+1,ii,8)-ucnt(i+1,ii,6)))
       xp6=ucnt(i+1,ii,6)-xdes*dsin(alpha)
       yp6=vcnt(i+1,ii,6)+xdes*dcos(alpha)
       xp8=ucnt(i+1,ii,8)-xdes*dsin(alpha)
       yp8=vcnt(i+1,ii,8)+xdes*dcos(alpha)
       xp7=0.5*(xp6+xp8)
       yp7=0.5*(yp6+yp8)
       call point(sepx+xp6,sepy-yp6,4)
       call point(sepx+xp7,sepy-yp7,4)
       call point(sepx+xp8,sepy-yp8,4)
       call point(sepx+2530.*xkf+xp6,sepy-yp6,4)
       call point(sepx+2530.*xkf+xp7,sepy-yp7,4)
       call point(sepx+2530.*xkf+xp8,sepy-yp8,4)

       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Case h2=100.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,10).eq.100.) then

c      Segements
       call line(sepx+ucnt(i+1,ii,9),-vcnt(i+1,ii,9)+sepy,
     + sepx+ucnt(i+1,ii,11),-vcnt(i+1,ii,11)+sepy,4)
       call line(sepx+2530.*xkf+ucnt(i+1,ii,9),-vcnt(i+1,ii,9)+sepy,
     + sepx+2530.*xkf+ucnt(i+1,ii,11),-vcnt(i+1,ii,11)+sepy,4)

c      Draw 3 point in 9 and 11

c      Points in 9
       alpha=(datan((v(i+1,jcon(i+1,ii,9)-1,3)-v(i+1,jcon(i+1,ii,9)+1,
     + 3))/(u(i+1,jcon(i+1,ii,9)-1,3)-u(i+1,jcon(i+1,ii,9)+1,3))))
       xpeq=ucnt(i+1,ii,9)-1.*xdes*dsin(alpha)
       ypeq=vcnt(i+1,ii,9)+1.*xdes*dcos(alpha)
       call point(sepx+xpeq,sepy-ypeq,4)
       call point(sepx+xpeq+1*dsin(alpha),sepy-ypeq+1*dcos(alpha),4)
       call point(sepx+xpeq+2*dsin(alpha),sepy-ypeq+2*dcos(alpha),4)
       call point(2530.*xkf+sepx+xpeq,sepy-ypeq,4)
       call point(2530.*xkf+sepx+xpeq+1*dsin(alpha),sepy-ypeq+
     + 1*dcos(alpha),4)
       call point(2530.*xkf+sepx+xpeq+2*dsin(alpha),sepy-ypeq+
     + 2*dcos(alpha),4)

c      Points in 11
       alpha=(datan((v(i+1,jcon(i+1,ii,11)-1,3)-v(i+1,jcon(i+1,ii,11)+1,
     + 3))/(u(i+1,jcon(i+1,ii,11)-1,3)-u(i+1,jcon(i+1,ii,11)+1,3))))
       xpeq=ucnt(i+1,ii,11)-1.*xdes*dsin(alpha)
       ypeq=vcnt(i+1,ii,11)+1.*xdes*dcos(alpha)
       call point(sepx+xpeq,sepy-ypeq,4)
       call point(sepx+xpeq+1*dsin(alpha),sepy-ypeq+1*dcos(alpha),4)
       call point(sepx+xpeq+2*dsin(alpha),sepy-ypeq+2*dcos(alpha),4)
       call point(2530.*xkf+sepx+xpeq,sepy-ypeq,4)
       call point(2530.*xkf+sepx+xpeq+1*dsin(alpha),sepy-ypeq+
     + 1*dcos(alpha),4)
       call point(2530.*xkf+sepx+xpeq+2*dsin(alpha),sepy-ypeq+
     + 2*dcos(alpha),4)

       end if

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      16.6.6 Draw V-rib type 6 in 3D model
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Colors definition if even or odd
       control=((hvr(k,3))/2.)-float(int((hvr(k,3))/2.))
       if (control.ne.0) then
       icolor=4
       else
       icolor=30
       end if

c      Draw in 3D model
       do j=1,21
       call line3d(rx2(i,j,ii),ry2(i,j,ii),rz2(i,j,ii),
     + rx3(i,j,ii),ry3(i,j,ii),rz3(i,j,ii),icolor)
       call line3d(-rx2(i,j,ii),ry2(i,j,ii),rz2(i,j,ii),
     + -rx3(i,j,ii),ry3(i,j,ii),rz3(i,j,ii),icolor)
       end do

c      end if V-rib type 6
       end if


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c   End type 6
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


c      Seguent dispositiu

       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     17. TXT OUTPUT lep-out.txt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       write (23,*)
       write (23,*) "LABORATORI D'ENVOL PARAGLIDING 2.60 version ", 
     + """Les Escaules"" "
       write (23,*) "by Pere Casellas 2010-2016"
       write (23,*) "http://www.laboratoridenvol.com"
       write (23,*) "General Public License GNU/GPL 3.0"
       write (23,*)
       write (23,*) "Brand: ", bname
       if (atp.eq."pc") then
       write (23,*) "Parachute model: ", wname
       else
       write (23,*) "Paraglider model: ", wname
       end if
       write (23,*) "scale: ", xwf

c      Area

       farea=(rib(1,4)-rib(1,3))*rib(1,2)

       parea=(rib(1,4)-rib(1,3))*rib(1,6)

       do i=1,nribss-1

       farea=farea+(rib(i,4)-rib(i,3)+rib(i+1,4)-rib(i+1,3))*0.5*
     + (rib(i+1,2)-rib(i,2))

       parea=parea+(rib(i,4)-rib(i,3)+rib(i+1,4)-rib(i+1,3))*0.5*
     + (rib(i+1,6)-rib(i,6))

       end do

       farea=farea*2./10000.
       parea=parea*2./10000.

c      Span

       fspan=2.*rib(nribss,2)/100.
       pspan=2.*rib(nribss,6)/100.

c      A/R Aspect Ratio

       faratio=fspan*fspan/farea
       paratio=pspan*pspan/parea

       write (23,*)
       write (23,*) "1. MAIN PARAMETERS:"
       write (23,*) "-------------------------------------------------"
       write (23,'(A,1x,F5.2,A,F6.1,A)') "Flat area = ", farea, " m2 ",
     + farea*10.7639," ft2"
       write (23,'(A,1x,F5.2,A,F6.1,A)') "Flat span = ",fspan, " m  ",
     + fspan/0.3048," ft" 
       write (23,'(A,1x,F4.2)') "Flat A/R = ", faratio
       write (23,*)
       write (23,'(A,1x,F5.2,A,F6.1,A)') "Projected area = ", parea, 
     + " m2 ",parea*10.7639," ft2"
       write (23,'(A,1x,F5.2,A,F6.1,A)') "Projected span = ",pspan, 
     + " m  ",pspan/0.3048," ft" 
       write (23,'(A,1x,F4.2)') "Projected A/R = ", paratio
       write (23,'(A,1x,F5.2)') "Flattening = ", ((farea-parea)/farea)*100.

c      More geometric parameters
       write (23,*)
       write (23,'(A)') "More geometric parameters:"
       varrow=(rib(nribss,7)-rib(1,7))*xwf/100
       write (23,'(A,1x,F5.2,A)') "Vault arrow = ", varrow, " m"
       write (23,'(A,1x,F5.2)') "Proj_span/arrow = ", pspan/varrow
       write (23,'(A,1x,F5.2,A)') "Line heigth (included risers) = ", 
     + (clengr+clengl)/100, " m"
       write (23,'(A,1x,F5.2)') "Proj_span/Line_heigth = ", 
     + pspan*100/(clengl)
       clli=(sqrt((clengl-rib(nribss,7)*xwf)*(clengl-rib(nribss,7)*xwf)+
     + (pspan*0.5*100)*(pspan*0.5*100)))/100
       write (23,'(A,1x,F5.2,A)') "Karabiners - wingtip = ", clli, " m"
       write (23,'(A,1x,F5.2)') "Proj_span/(Karabiners - wingtip) = ",
     + pspan/clli

c      Wing type
       write (23,*) 
       write (23,'(A,A)') "Wing type is: ", atp
       write (23,*)

c      Center of gravity

       write (23,'(A,F5.2,A)') "Planform center of gravity at ", cdg, 
     + " % from leading edge"

c      Calage properties     

       write (23,*)
       write (23,*) "2. CALAGE PROPERTIES:"
       write (23,*) "-------------------------------------------------"
       write (23,'(A,1x,F5.2)') "finesse GR ", finesse
       write (23,'(A,1x,F5.2)') "glide angle ", afinesse
       write (23,'(A,1x,F5.2)') "AoA ", aoa
       write (23,'(A,1x,F5.2)') "assiette ", assiette
       write (23,'(A,1x,F6.0,A)') "total height hcp (inc risers)", 
     + hcp, " cm"
       write (23,'(A,1x,F6.0,A)') "risers", clengr, " cm"
       write (23,'(A,1x,F6.2,2x,F6.2)') "calage, pilot centering % cm"
     + , calage, calag
       write (23,'(2A,1x,F6.2,2x,F6.2)') "center pressure (estimation)",
     + " cm", cpress, cple
       write (23,'(A,3(3x,F7.2))') "karabiners (x,y,z) ",xkar,ykar,zkar
       write (23,*)

c      Rib properties

       write (23,*) "3. RIB PROPERTIES:"
       write (23,*) "-------------------------------------------------"
       write (23,*) "Ribs number = ", nribss*2
       write (23,*) "Cells number = ", nribss*2-1
       if (rib(1,2).lt.0.01) then
       write (23,*) "Zero-thickness central cell"
       end if
       write (23,*)

       write (23,*) "Rib - Chord - washin - beta "
       write (23,*) "-------------------------------------------------"

       do i=1,nribss

       write (23,'(I2,5x,F6.2,2x,F6.3,2x,F5.2)') i,rib(i,5), rib(i,8), 
     + rib(i,9)

       end do

c      Cell properties

       write(23,*)

       write (23,*) "Cell   width (cm)"
      
       write (23,'(I2,7x,F5.2)') 0, 2.*rib(1,2)
       
       do i=1,nribss-1

       write (23,'(I2,5x,F5.2)') i, rib(i+1,2)-rib(i,2)

       end do

c      Anchor points

c      Lines

       xlength=0.

       write (23,*)
       write (23,*) "4. LINE MATRIX, LINE LENGTHS,AND LINE LOADS:"
       write (23,*) "Line-plan- level- order- ap  - r - row - rib -  L  
     +  -   length -length_e - load (Kg)"
       write (23,*) "------------------------------------------------",
     + "--------------------------"

       do i=1,cordat

       write (23,'(8(I3,3x),A,3x,3(F6.2,3x))') i,corda(i,1),
     + corda(i,2),corda(i,3),corda(i,4),corda(i,5),corda(i,6),
     + corda(i,7)," L = ",xline(i), xlifi(i), xload(i)

       if (corda(i,2).ne.1) then
       xlength=xlength+xline(i)
       end if

       end do

       write (23,*)
       write (23,'(A,1x,F8.2)') "Total line lengths (without loops) = " 
     + , xlength*2./100.

      write (23,'(A,1x,F8.2)') "Total line lengths (with loops) = " 
     + , xlength*2./100.+(10.*2.*cordat*2)/100.
      write (23,*) "(estimation of 10 cm additional per loop)"

       write (23,*)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      17+ Adjustment seam parameters 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      
c      Ajust de costura

       write (23,*)
       write (23,*) "5. Adjustment seam parameters on the inner side" 
       write (23,*) "of extrados panels (fig. 10 of the manual)"
       write (23,*) "-------------------------------------------------"

       if (ndif.eq.1000) then
       write (23,*) "Not used ( ndif=1000 )"
       else
       write (23,*) "Points number= ", ndif, "  scale= ",xndif
       do i=1,nribss-1
       write (23,*) "Rib= ", i, " dif= ", rib(i,81)
       end do
       end if

       write (23,*)

c      Panels and rib differences report

       write (23,*)
       write (23,*) "6. VERIFICATION Panels and rib differences (mm):"
       write (23,*) "-------------------------------------------------"
       write (23,*) "NOTE: Maximal accuracy ",
     + "<< 0.02 mm in extrados and intrados panels"
       write (23,*)
       write (23,*) "Number - Panel at left - Rib - Panel at right -", 
     + " max dif (mm)"

       if (atp.eq."ss") then
       do i=1,nribss-1
       xmax=max(abs(rib(i,30)-rib(i,31)),abs(rib(i,32)-rib(i,31)))
       write(23,'(I2,3x,F10.2,F10.2,F10.2,F10.2,F10.2)') 
     + i,10.*rib(i,30)+10.*rib(i,26),10.*rib(i,31)+10.*rib(i,26),
     + 10.*rib(i,32)+10.*rib(i,26),10.*xmax
       end do
       end if

       if (atp.ne."ss") then

c      Ribs 1 to nribss-1
       do i=1,nribss-1
       xmaxe=max(abs(rib(i,30)-rib(i,31)),abs(rib(i,32)-rib(i,31)))
       xmaxi=max(abs(rib(i,33)-rib(i,34)),abs(rib(i,35)-rib(i,34)))
       write (23,*)
       write (23,'(I2,2x,F10.2,F10.2,F10.2,F10.3,A6)') 
     + i,10*rib(i,30),10*rib(i,31),10*rib(i,32),10.*xmaxe," extra"
       write (23,'(I2,2x,F10.2,F10.2,F10.2,F10.3,A6)') 
     + i,10*rib(i,33),10*rib(i,34),10*rib(i,35),10.*xmaxi," intra"
       end do

c      Last rib
       i=nribss
       xmaxe=abs(rib(i,30)-rib(i,31))
       xmaxi=abs(rib(i,33)-rib(i,34))
       write (23,*)
       write (23,'(I2,2x,F10.2,F10.2,A10,F10.3,A6)') 
     + i,10*rib(i,30),10*rib(i,31),"   -    ",10.*xmaxe," extra"
       write (23,'(I2,2x,F10.2,F10.2,A10,F10.3,A6)') 
     + i,10*rib(i,33),10*rib(i,34),"   -    ",10.*xmaxi," intra"

       end if


       write (23,*)

c      Print distorsions

       write (23,*) "Panel distorsions in the leading edge (mm):"
       write (23,*) "-------------------------------------------"
       write (23,*) "Panel   D. extra   D. intra"
       do i=0,nribss-1
       write (23,'(I3,2x,F10.4,F10.4)')
     + i,(rib(i,97)-rib(i,96))*10.,(rib(i,99)-rib(i,98))*10.
       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      18. lines.txt List of lines - labels in human readable format
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       write (30,*) "LEparagliding"
       write (30,*) "List of lines, human readable format"
       write (30,*) "Ready also to import in .ods or .xls formats"
       write (30,*)
       write (30,*) "Line number - Label - Lenght (cm)"
       write (30,*) 

       do i=1, cordat

c      Select letter as final row of the line
       write (ln1,'(I1)') corda (i,2)

       if (corda(i,6).eq.1) ln2="A"
       if (corda(i,6).eq.2) ln2="B"
       if (corda(i,6).eq.3) ln2="C"
       if (corda(i,6).eq.4) ln2="D"
       if (corda(i,6).eq.5) ln2="E"
       if (corda(i,6).eq.6) ln2="F"

c      If only two levels
c      Is OK

c      If tree levels
c      1 and 2 level will be named acording lineplan

c      Renames letters if levels 1 or 2

       if (corda(i,2).le.2.and.corda(i,5).ge.3) then

       if (corda(i,1).eq.1) ln2="A"
       if (corda(i,1).eq.2) ln2="B"
       if (corda(i,1).eq.3) ln2="C"
       if (corda(i,1).eq.4) ln2="D"
       if (corda(i,1).eq.5) ln2="E"
       if (corda(i,1).eq.6) ln2="F"

       end if

       if (corda(i,2).eq.1.and.corda(i,5).eq.2) then

       if (corda(i,1).eq.1) ln2="A"
       if (corda(i,1).eq.2) ln2="B"
       if (corda(i,1).eq.3) ln2="C"
       if (corda(i,1).eq.4) ln2="D"
       if (corda(i,1).eq.5) ln2="E"
       if (corda(i,1).eq.6) ln2="F"

       end if

c      Adjust brake letter to F

       if (i.gt.cordam) ln2="F"

c      Put 2 characters
       
c       if (corda(i,3).le.9)  write (ln3,'(I,I)') 0,corda(i,3)
c       if (corda(i,3).gt.9)  write (ln3,'(I2)') corda(i,3)

c       write (ln3,'(I2)') corda(i,3)

       if (corda(i,3).ge.10) then
       write (ln3,'(I2)') corda(i,3)
       end if

       if (corda(i,3).lt.10) then
       write (ln3,'(I1)') corda(i,3)
       end if


c      Change line order by final rib if upper line

       if (corda(i,2).eq.corda(i,5)) then

c       if (corda(i,7).le.9)  write (ln3,'(I,I)') 0,corda(i,7)
c       if (corda(i,7).gt.9)  write (ln3,'(I2)') corda(i,7)

       if (corda(i,7).ge.10) then
       write (ln3,'(I2)') corda(i,7)
       end if

       if (corda(i,7).lt.10) then
       write (ln3,'(I1)') corda(i,7)
       end if


       end if

c      Write line labels

       write (ln4(i),'(A1,A1,A2)') ln1,ln2,ln3
c       write (ln4(i),'(A1,A1)') ln1,ln2


       if (corda(i,6).eq.6) xlifi(i)=xline(i)

c      Row plan A

       if (i.eq.1) then 
       slpi(1)=i
       write (30,*)
       write (30,*) "Plan A"
       write (30,*) 
       end if

c      Rows plan B,C,D,E,F

       if(i.ge.2.and.corda(i-1,1).lt.corda(i,1)) then

       if (corda(i,1).eq.2) then
       slpi(2)=i
       write (30,*)
       write (30,*) "Plan B"
       write (30,*) 
       end if

       if (corda(i,1).eq.3) then
       slpi(3)=i
       write (30,*)
       write (30,*) "Plan C"
       write (30,*) 
       end if

       if (corda(i,1).eq.4.and.i.le.cordam) then
       slpi(4)=i
       write (30,*)
       write (30,*) "Plan D"
       write (30,*) 
       end if

       if (corda(i,1).eq.5.and.i.le.cordam) then
       slpi(5)=i
       write (30,*)
       write (30,*) "Plan E"
       write (30,*) 
       end if

       end if

c      Plan F

       if (i.eq.cordam+1) then
       slpi(6)=i
       write (30,*)
       write (30,*) "Brake lines"
       write (30,*) 
       end if

       write (30,'(I3,3x,A4,3x,F5.1)')  i, ln4(i), xlifi(i)

       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     18+. Draw labels in 2D (in tree of lines)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      Labels in lines
       corda1=cordam

       do i=1,corda1

       x0=(1260.-160.)*xkf
       y0=1800.*xkf

       x00=1260.*xkf*float(corda(i,1)-1)

       xlabel=((x1line(corda(i,1),corda(i,2),corda(i,3))+x0+x00)+
     + (x2line(corda(i,1),corda(i,2),corda(i,3))+x0+x00))*0.5d0

       zlabel=((z1line(corda(i,1),corda(i,2),corda(i,3))+y0)+
     + (z2line(corda(i,1),corda(i,2),corda(i,3))+y0))*0.5d0

c      Text size = 8
       xtext=ln4(i)
       call txt(xlabel,zlabel,8.0d0,0.0d0,xtext,7)

       end do
   
c      Labels in brakes
       do i=cordam+1,cordat

       x0=(1260.-160.)*xkf
       y0=(1800.+890.95)*xkf

       x00=1260.*xkf*float(corda(i,1)-1)

       xlabel=((x1line(corda(i,1),corda(i,2),corda(i,3))+x0+x00)+
     + (x2line(corda(i,1),corda(i,2),corda(i,3))+x0+x00))*0.5d0

       zlabel=((z1line(corda(i,1),corda(i,2),corda(i,3))+y0)+
     + (z2line(corda(i,1),corda(i,2),corda(i,3))+y0))*0.5d0

c      Text size = 8   
       xtext=ln4(i)
       call txt(xlabel,zlabel,8.0d0,0.0d0,xtext,7)

       end do

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      19. 3D model DXF drawing
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c       call dxfinit(25)

       do i=1,nribss

c      19.1 Extrados blue

       do j=1,np(i,2)-1

       p1x=x(i,j)
       p1y=y(i,j)
       p1z=z(i,j)
       p2x=x(i,j+1)
       p2y=y(i,j+1)
       p2z=z(i,j+1)

       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,5)

       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,5)

       end do

c      19.2 Vents

c      Case "ds" or "ss"
       if (atp.eq."ds".or.atp.eq."ss") then

       do j=np(i,2),np(i,2)+np(i,3)-2

       p1x=x(i,j)
       p1y=y(i,j)
       p1z=z(i,j)
       p2x=x(i,j+1)
       p2y=y(i,j+1)
       p2z=z(i,j+1)

       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,1)

       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,1)

       end do

       end if

c      Case "pc"
       if (atp.eq."pc") then

       j1=np(i,2)
       j2=np(i,2)+np(i,3)-1

       p1x=x(i,j1)
       p1y=y(i,j1)
       p1z=z(i,j1)
       p2x=x(i,j2)
       p2y=y(i,j2)
       p2z=z(i,j2)

       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,1)

       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,1)

       end if

c      19.3 Intrados 

       do j=np(i,2)+np(i,3)-1,np(i,1)-1

       p1x=x(i,j)
       p1y=y(i,j)
       p1z=z(i,j)
       p2x=x(i,j+1)
       p2y=y(i,j+1)
       p2z=z(i,j+1)

       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,3)

       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,3)

       end do

       end do

c      19.4 Trailing edge

       do i=1,nribss-1

       p1x=x(i,1)
       p1y=y(i,1)
       p1z=z(i,1)
       p2x=x(i+1,1)
       p2y=y(i+1,1)
       p2z=z(i+1,1)

       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,5)
       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,5)

       end do

       p1x=x(1,1)
       p1y=y(1,1)
       p1z=z(1,1)
       p2x=-x(1,1)
       p2y=y(1,1)
       p2z=z(1,1)

       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,5)

c      19.5 Leading edge

c      Vent in

       do i=1,nribss

       p1x=x(i-1,np(i,2))
       p1y=y(i-1,np(i,2))
       p1z=z(i-1,np(i,2))
       p2x=x(i,np(i,2))
       p2y=y(i,np(i,2))
       p2z=z(i,np(i,2))

       if (rib(i,14).eq.1) then
       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,1)
       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,1)
       end if
       if (rib(i,14).eq.0) then
       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,9)
       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,9)
       end if


       end do

c       p1x=x(1,np(i,2))
c       p1y=y(1,np(i,2))
c       p1z=z(1,np(i,2))
c       p2x=-x(1,np(i,2))
c       p2y=y(1,np(i,2))
c       p2z=z(1,np(i,2))

c       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,1)

c      Vent out

       do i=1,nribss

       j=np(i,2)+np(i,3)-1

       p1x=x(i-1,j)
       p1y=y(i-1,j)
       p1z=z(i-1,j)
       p2x=x(i,j)
       p2y=y(i,j)
       p2z=z(i,j)

       if (rib(i,14).eq.1) then
       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,1)
       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,1)
       end if
       if (rib(i,14).eq.4) then
       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,9)
       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,9)
       end if


       end do

c       p1x=x(1,j)
c       p1y=y(1,j)
c       p1z=z(1,j)
c       p2x=-x(1,j)
c       p2y=y(1,j)
c       p2z=z(1,j)

c       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,1)

c      19.6 lines 3D

c      Lines A,B,C,D,...

       do i=1,cordam

       p2x=x2line(corda(i,1),corda(i,2),corda(i,3))
       p1x=x1line(corda(i,1),corda(i,2),corda(i,3))
       p2y=y2line(corda(i,1),corda(i,2),corda(i,3))
       p1y=y1line(corda(i,1),corda(i,2),corda(i,3))
       p2z=z2line(corda(i,1),corda(i,2),corda(i,3))
       p1z=z1line(corda(i,1),corda(i,2),corda(i,3))

       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,8)
       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,8)

       end do

c      19.7 Brakes

       do i=cordam+1,cordat

       p2x=x2line(corda(i,1),corda(i,2),corda(i,3))
       p1x=x1line(corda(i,1),corda(i,2),corda(i,3))
       p2y=y2line(corda(i,1),corda(i,2),corda(i,3))
       p1y=y1line(corda(i,1),corda(i,2),corda(i,3))
       p2z=z2line(corda(i,1),corda(i,2),corda(i,3))
       p1z=z1line(corda(i,1),corda(i,2),corda(i,3))

       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,30)
       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,30)

       end do


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      19.8 H-V-ribs 3D drawing
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       do k=1,nhvr

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      19.8.1 H-ribs
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,2).eq.1) then
       i=hvr(k,3)
c      warning
       ii=hvr(k,4)

       do j=1,21

       p1x=hx3(i,j,ii)
       p1y=hy3(i,j,ii)
       p1z=hz3(i,j,ii)
       p2x=hx2(i,j,ii)
       p2y=hy2(i,j,ii)
       p2z=hz2(i,j,ii)

       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,2)

       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,2)

       if (j.lt.21) then

       call line3d(-hx2(i,j,ii),hy2(i,j,ii),hz2(i,j,ii),
     + -hx2(i,j+1,ii),hy2(i,j+1,ii),hz2(i,j+1,ii),2)
       call line3d(-hx3(i,j,ii),hy3(i,j,ii),hz3(i,j,ii),
     + -hx3(i,j+1,ii),hy3(i,j,ii),hz3(i,j+1,ii),2)

       call line3d(hx2(i,j,ii),hy2(i,j,ii),hz2(i,j,ii),
     + hx2(i,j+1,ii),hy2(i,j+1,ii),hz2(i,j+1,ii),2)
       call line3d(hx3(i,j,ii),hy3(i,j,ii),hz3(i,j,ii),
     + hx3(i,j+1,ii),hy3(i,j,ii),hz3(i,j+1,ii),2)

       end if

       end do

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      19.8.2 V-ribs partial
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       if (hvr(k,2).eq.2) then
       i=hvr(k,3)
       ii=hvr(k,4)

       do j=1,21

       p1x=rx1(i,j,ii)
       p1y=ry1(i,j,ii)
       p1z=rz1(i,j,ii)
       p2x=rx2(i,j,ii)
       p2y=ry2(i,j,ii)
       p2z=rz2(i,j,ii)

c      Diagonal i-1 to i
       if (hvr(k,5).eq.1) then
       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,5)
       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,5)
       end if

       if (j.lt.21) then
       if (hvr(k,5).eq.1) then
       call line3d(rx1(i,j,ii),ry1(i,j,ii),rz1(i,j,ii),
     + rx1(i,j+1,ii),ry1(i,j+1,ii),rz1(i,j+1,ii),5)
       call line3d(-rx1(i,j,ii),ry1(i,j,ii),rz1(i,j,ii),
     + -rx1(i,j+1,ii),ry1(i,j+1,ii),rz1(i,j+1,ii),5)
       end if
       end if

       p1x=rx3(i,j,ii)
       p1y=ry3(i,j,ii)
       p1z=rz3(i,j,ii)
       p2x=rx2(i,j,ii)
       p2y=ry2(i,j,ii)
       p2z=rz2(i,j,ii)

c      Diagonal i to i+1
       if (hvr(k,6).eq.1) then
       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,1)
       call line3d(-p1x,p1y,p1z,-p2x,p2y,p2z,1)
       end if

       if (j.lt.21) then
       if (hvr(k,6).eq.1) then
       call line3d(rx3(i,j,ii),ry3(i,j,ii),rz3(i,j,ii),
     + rx3(i,j+1,ii),ry3(i,j+1,ii),rz3(i,j+1,ii),1)
       call line3d(-rx3(i,j,ii),ry3(i,j,ii),rz3(i,j,ii),
     + -rx3(i,j+1,ii),ry3(i,j+1,ii),rz3(i,j+1,ii),1)
       end if
       end if

       end do

       end if

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      19.8.4 VH-ribs
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

c      OBSOLETE, draw before. ERASE

       if (hvr(k,2).eq.4) then
       i=hvr(k,3)-1
       ii=hvr(k,4)

       do j=1,21

c      Diagonal i-1 to i

       p1x=sx1(i,j,ii)
       p1y=sy1(i,j,ii)
       p1z=sz1(i,j,ii)
       p2x=sx2(i,j,ii)
       p2y=sy2(i,j,ii)
       p2z=sz2(i,j,ii)

       if (hvr(k,5).eq.1) then
c       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,4)
       end if

       if (j.lt.21) then
       if (hvr(k,5).eq.1) then
c       call line3d(rx1(i,j,ii),ry1(i,j,ii),rz1(i,j,ii),
c     + rx1(i,j+1,ii),ry1(i,j+1,ii),rz1(i,j+1,ii),4)
       end if
       end if

c      Horizontal i to i+1

       p1x=sx1(i,j,ii)
       p1y=sy1(i,j,ii)
       p1z=sz1(i,j,ii)
       p2x=sx3(i,j,ii)
       p2y=sy3(i,j,ii)
       p2z=sz3(i,j,ii)

       if (hvr(k,5).eq.1.or.hvr(k,6).eq.1) then
c       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,4)
       end if

       if (j.lt.21) then
       if (hvr(k,5).eq.1) then
c       call line3d(rx1(i,j,ii),ry1(i,j,ii),rz1(i,j,ii),
c     + rx1(i,j+1,ii),ry1(i,j+1,ii),rz1(i,j+1,ii),4)
       end if
       end if

c      Diagonal i+1 to i+2

       p1x=sx3(i,j,ii)
       p1y=sy3(i,j,ii)
       p1z=sz3(i,j,ii)
       p2x=sx4(i,j,ii)
       p2y=sy4(i,j,ii)
       p2z=sz4(i,j,ii)

       if (hvr(k,6).eq.1) then
       call line3d(p1x,p1y,p1z,p2x,p2y,p2z,4)
       end if

       if (j.lt.21) then
       if (hvr(k,6).eq.1) then
c       call line3d(rx3(i,j,ii),ry3(i,j,ii),rz3(i,j,ii),
c     + rx3(i,j+1,ii),ry3(i,j+1,ii),rz3(i,j+1,ii),4)
       end if
       end if

       end do

       end if

       end do

       call dxfend(25)

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      20. TEXT NOTES
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       xtext=bname
       call txt(-630.*xkf,-100.*xkf,50.0d0,0.0d0,xtext,3)
   
       xtext=wname
       call txt(600.*xkf,-100.*xkf,50.0d0,0.0d0,xtext,1)

       xtext=lepv
       call txt(1400.*xkf,-100.*xkf,50.0d0,0.0d0,xtext,3)

c      Row 1

       xpos=0.*xkf
       ypos=800.*xkf
       xtext="1-1 PLANFORM AND VAULT"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)
       xtext=bname
       call txt(xpos,ypos-300.*xkf,10.0d0,0.0d0,xtext,7)
       xtext=wname
       call txt(xpos+170.,ypos-300.*xkf,10.0d0,0.0d0,xtext,7)
       xtext="Flat area (m2) : "
       call txt(xpos,ypos-280.*xkf,10.0d0,0.0d0,xtext,7)
       write (xtext, '(F5.2)') farea
       call txt(xpos+170.,ypos-280.*xkf,10.0d0,0.0d0,xtext,7)
       xtext="Flat span (m) : "
       call txt(xpos,ypos-260.*xkf,10.0d0,0.0d0,xtext,7)
       write (xtext, '(F5.2)') fspan
       call txt(xpos+170.,ypos-260.*xkf,10.0d0,0.0d0,xtext,7)
       xtext="Flat aspect ratio : "
       call txt(xpos,ypos-240.*xkf,10.0d0,0.0d0,xtext,7)
       write (xtext, '(F5.2)') faratio
       call txt(xpos+170.,ypos-240.*xkf,10.0d0,0.0d0,xtext,7)
       xtext="Cells number : "
       call txt(xpos,ypos-220.*xkf,10.0d0,0.0d0,xtext,7)
       write (xtext, '(I3)') nribss*2-1
       if (rib(1,2).le.0.01) then
       write (xtext, '(I3)') nribss*2-2
       end if
       call txt(xpos+170.,ypos-220.*xkf,10.0d0,0.0d0,xtext,7)


       xpos=xpos+1260.*xkf
       xtext="1-2 RIBS"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

       xpos=xpos+1260.*xkf
       xtext="1-3 EXTRADOS PANELS"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)
       xtext="Leading edge"
       call txt(xpos,ypos-810.*xkf,10.0d0,0.0d0,xtext,7)
       xtext="Trailing edge"
       call txt(xpos,ypos-160.*xkf,10.0d0,0.0d0,xtext,7)

       xpos=xpos+1260.*xkf
       xtext="1-4 RIBS (FOR CUTTING TABLE)"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

       xpos=xpos+1260.*xkf
       xtext="1-5 EXTRADOS PANELS (FOR CUTTING TABLE)"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)
       xtext="Leading edge"
       call txt(xpos,ypos-810.*xkf,10.0d0,0.0d0,xtext,7)
       xtext="Trailing edge"
       call txt(xpos,ypos-160.*xkf,10.0d0,0.0d0,xtext,7)

       xpos=xpos+1260.*xkf
       xtext="1-6 MIDDLE UNLOADED RIBS"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)


c      Row 2

       xpos=0.*xkf
       ypos=ypos+890.95*xkf
       xtext="2-1 CALAGE ESTIMATION"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

       xpos=xpos+1260.*xkf
       xtext="2-2 RIBS WASHIN ANGLE"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

       xpos=xpos+1260.*xkf
       xtext="2-3 INTRADOS PANELS"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)
       xtext="Trailing edge"
       call txt(xpos,ypos-810.*xkf,10.0d0,0.0d0,xtext,7)
       xtext="Leading edge"
       call txt(xpos,ypos-160.*xkf,10.0d0,0.0d0,xtext,7)


       xpos=xpos+1260.*xkf
       xtext="2-4 MINI-RIBS"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

       xpos=xpos+1260.*xkf
       xtext="2-5 INTRADOS PANELS (FOR CUTTING TABLE)"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)
       xtext="Trailing edge"
       call txt(xpos,ypos-810.*xkf,10.0d0,0.0d0,xtext,7)
       xtext="Leading edge"
       call txt(xpos,ypos-160.*xkf,10.0d0,0.0d0,xtext,7)

       xpos=xpos+1260.*xkf
       xtext="2-6 FULL DIAGONAL RIBS"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)


c      Row 3

       xpos=0.*xkf
       ypos=ypos+890.95*xkf
       xtext="3-1 UPPER VIEW"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

       xpos=xpos+1260.*xkf
       xtext="3-2 LINES A"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

c      write lines in plan A
       if (slp.ge.1) then
       xqw=0.
       xtext="Line - Label - Length"
       call txt(xpos-500.*xkf,ypos+(-718.+xqw)*
     + xkf,12.0d0,0.0d0,xtext,9)
       do i=1,slpi(2)-1
       xqw=xqw+18.
       write (xtext,'(I3,3x,A4,3x,F5.1)') i,ln4(i),xlifi(i)
       call txt(xpos-500.*xkf,ypos+(-700.+xqw)*
     + xkf,12.0d0,0.0d0,xtext,9)
       end do
       end if

       xpos=xpos+1260.*xkf
       xtext="3-3 LINES B"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

c      write lines in plan B
       if (slp.ge.2) then
       if (slp.eq.2) slpi(3)=cordam+1
       xqw=0.
       xtext="Line - Label - Length"
       call txt(xpos-500.*xkf,ypos+(-718.+xqw)*
     + xkf,12.0d0,0.0d0,xtext,9)
       do i=slpi(2),slpi(3)-1
       xqw=xqw+18.
       write (xtext,'(I3,3x,A4,3x,F5.1)') i,ln4(i),xlifi(i)
       call txt(xpos-500.*xkf,ypos+(-700.+xqw)*
     + xkf,12.0d0,0.0d0,xtext,9)
       end do
       end if

       xpos=xpos+1260.*xkf
       xtext="3-4 LINES C"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

c      write lines in plan C
       if (slp.ge.3) then
       if (slp.eq.3) slpi(4)=cordam+1
       xqw=0.
       xtext="Line - Label - Length"
       call txt(xpos-500.*xkf,ypos+(-718.+xqw)*
     + xkf,12.0d0,0.0d0,xtext,9)
       do i=slpi(3),slpi(4)-1
       xqw=xqw+18.
       write (xtext,'(I3,3x,A4,3x,F5.1)') i,ln4(i),xlifi(i)
       call txt(xpos-500.*xkf,ypos+(-700.+xqw)*
     + xkf,12.0d0,0.0d0,xtext,9)
       end do
       end if

       xpos=xpos+1260.*xkf
       xtext="3-5 LINES D"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

c      write lines in plan D
       if (slp.ge.4) then
       if (slp.eq.4) slpi(5)=cordam+1
       xqw=0.
       xtext="Line - Label - Length"
       call txt(xpos-500.*xkf,ypos+(-718.+xqw)*
     + xkf,12.0d0,0.0d0,xtext,9)
       do i=slpi(4),slpi(5)-1
       xqw=xqw+18.
       write (xtext,'(I3,3x,A4,3x,F5.1)') i,ln4(i),xlifi(i)
       call txt(xpos-500.*xkf,ypos+(-700.+xqw)*
     + xkf,12.0d0,0.0d0,xtext,9)
       end do
       end if

c      Box for V-rib Type-6

       xpos=xpos+1260.*xkf
       xtext="3-6 V-rib Type-6"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

c      Row 4

       xpos=0.*xkf
       ypos=ypos+890.95*xkf
       xtext="4-1 VAULT VIEW"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

       xpos=xpos+1260.*xkf
       xtext="4-2 LATERAL VIEW"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

       xpos=xpos+1260.*xkf
       xtext="4-3 BRAKE DISTRIBUTION"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

       xpos=xpos+1260.*xkf
       xtext="4-4"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

       xpos=xpos+1260.*xkf
       xtext="4-5 BRAKES"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)

c      write lines in brakes
       xqw=0.
       xtext="Line - Label - Length"
       call txt(xpos-500.*xkf,ypos+(-718.+xqw)*
     + xkf,12.0d0,0.0d0,xtext,9)
       do i=cordam+1,cordat
       xqw=xqw+18.
       write (xtext,'(I3,3x,A4,3x,F5.1)') i,ln4(i),xlifi(i)
       call txt(xpos-500.*xkf,ypos+(-700.+xqw)*
     + xkf,12.0d0,0.0d0,xtext,9)
       end do

       xpos=xpos+1260.*xkf
       xtext="4-6"
       call txt(xpos,ypos,12.0d0,0.0d0,xtext,7)


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      21. END OF MAIN PROGRAM
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc   

       call dxfend(20)

       write (*,*)

       if (atp.eq."pc") then
       write (*,'(A,1x,F6.2,A,F7.1,A)') " Total line length = ",
     + xlength*2./100.," m ",(xlength*2./100.)/0.3048," ft"
       write (*,*)
       else
       write (*,'(A,1x,F6.2,A)') " Total line length = ",
     + xlength*2./100.," m"
       write (*,*)
       end if

       if (atp.eq."ds".or.atp.eq."ss") then
       write (*,*) "OK, paraglider calculated !"
       end if
       if (atp.eq."pc") then
       write (*,*) "OK, parachute calculated !"
       end if
       write (*,*)
       write (*,*) "Please open the following files:" 
       write (*,*)
       write (*,*) "   leparagliding.dxf"
       write (*,*) "   lep-3d.dxf"
       write (*,*) "   lep-out.txt"
       write (*,*) "   lines.txt"
       write (*,*)


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      END MAIN PROGRAM
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 

       end


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      20. GRAPHICAL SUBROUTINES
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      SUBROUTINE pointg (radius xcir)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       SUBROUTINE pointg(xu,xv,xcir,pointcolor)

       integer pointcolor

       real*8 pi,angle1,angle2,xu,xv,xcir

       pi=4.*datan(1.0d0)

c      Draw cross
       call line(xu-xcir,-(xv),xu+xcir,-(xv),pointcolor)
       call line(xu,-(xv-xcir),xu,-(xv+xcir),pointcolor)

c      Draw circle
       do l=1,8

       angle1=float(l-1)*2.*pi/8.
       xlu1=xcir*dcos(angle1)
       xlv1=xcir*dsin(angle1)
       angle2=float(l)*2.*pi/8.
       xlu2=xcir*dcos(angle2)
       xlv2=xcir*dsin(angle2)

       call line(xu+xlu1,-(xv+xlv1),xu+xlu2,-(xv+xlv2),pointcolor)

       end do

       return

       end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      SUBROUTINE POINT 2D
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       SUBROUTINE point(x1,y1,pointcolor)
c      line P1-P2

       real*8 x1,y1
       integer pointcolor
c       write (*,*) "pointcolor ",pointcolor

       write(20,'(A,/,I1,/,A)') "POINT",8,"default"
       write(20,'(I1,/,A)') 6,"CONTINUOUS"
       write(20,'(I2,/,F12.2,/,I2,/,F12.2)') 10,x1,20,-y1
       write(20,'(I2,/,I2,/,I2,/,I3,/,I2)') 39,0,62,pointcolor,0
       return
       end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      SUBROUTINE LINE 2D
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       SUBROUTINE line(p1x,p1y,p2x,p2y,linecolor)
c      line P1-P2

       real*8 p1x,p1y,p2x,p2y

       write(20,'(A,/,I1,/,A)') "LINE",8,"default"
       write(20,'(I1,/,A)') 6,"CONTINUOUS"
       write(20,'(I2,/,F14.4,/,I2,/,F14.4)') 10,p1x,20,-p1y
       write(20,'(I2,/,F14.4,/,I2,/,F14.4)') 11,p2x,21,-p2y
       write(20,'(I2,/,I2,/,I2,/,I2,/,I2)') 39,0,62,linecolor,0
       return
       end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc        
c     SUBROUTINE LINE 3D
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       SUBROUTINE line3d(p1x,p1y,p1z,p2x,p2y,p2z,linecolor)
c      line P1-P2

       real*8 p1x,p1y,p1z,p2x,p2y,p2z

       write(25,'(A,/,I1,/,A)') "LINE",8,"default"
c       write(25,'(I3,/,A)') 100,"AcDbLine"
       write(25,'(I1,/,A)') 6,"CONTINUOUS"
       write(25,'(I2,/,F8.3,/,I2,/,F8.3,/,I2,/,F8.3)') 
     + 10,p1x,20,p1y,30,p1z
       write(25,'(I2,/,F8.3,/,I2,/,F8.3,/,I2,/,F8.3)') 
     + 11,p2x,21,p2y,31,p2z
       write(25,'(I2,/,I2,/,I2,/,I2,/,I2)') 39,0,62,linecolor,0
       return
       end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      POLYLINE 2D
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       SUBROUTINE poly2d(plx,ply,nvertex,linecolor)

       real*8 plx(300),ply(300)

       write (20,'(A,/,I1,/,I1,/,I2)') "POLYLINE",8,0,62
       write (20,'(I3,/,I2,/,I1)') linecolor,66,1
       write (20,'(I2,/,F3.1,/,I2,/,F3.1,/,I2,/,F3.1,/,I1)') 
     + 10,0.0,20,0.0,30,0.0,0
       
       do k=1,nvertex

       write (20,'(A,/,I1,/,I1,/,I2)') "VERTEX",8,0,62
       write (20,'(I3,/,I2,/,I1)') linecolor,66,1 
       write (20,'(I2,/,F9.3,/,I2,/,F9.3,/,I2,/,F9.3,/,I1)') 
     + 10,plx(k),20,ply(k),30,0.0,0

       end do
       
       write (20,'(A,/,I1,/,I1,/,I2)') "SEQEND",8,0,62
       write (20,'(I3,/,I1)') linecolor,0 

c       write (*,'(A,/,I1,/,I1,/,I2)') "POLYLINE",8,0,62
c       write (*,'(I3,/,I2,/,I1)') linecolor,66,1
c       write (*,'(I2,/,F3.1,/,I2,/,F3.1,/,I2,/,F3.1,/,I1)') 
c     + 10,0.0,20,0.0,30,0.0,0
       
c       do k=1,nvertex

c       write (*,'(A,/,I1,/,I1,/,I2)') "VERTEX",8,0,62
c       write (*,'(I3,/,I2,/,I1)') linecolor,66,1 
c       write (*,'(I2,/,F9.3,/,I2,/,F9.3,/,I2,/,F9.3,/,I1)') 
c     + 10,plx(k),20,ply(k),30,0.0,0

c       end do

c       write (*,'(A,/,I1,/,I1,/,I2)') "SEQEND",8,0,62
c       write (*,'(I3,/,I1)') linecolor,0 

       return

       end


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      ELLIPSE
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       SUBROUTINE ellipse(u0,v0,a,b,tet0,linecolor)

       real*8 xe(300),ye(300)

       real*8 pi,u0,v0,a,b,tet,tet0

       real*8 p1x,p1y,p2x,p2y

       pi=4.*datan(1.0d0)

       do ll=1,40

       tet=2.*pi*((float(ll)-1.)/39.)

c      write (*,*) ll,float(ll),tet," ",pi,"---"

       xe(ll)=u0+a*dcos(tet)*dcos(tet0)-b*dsin(tet)*dsin(tet0)
       ye(ll)=v0+a*dcos(tet)*dsin(tet0)+b*dsin(tet)*dcos(tet0)

       end do

       do ll=1,39

       p1x=xe(ll)
       p2x=xe(ll+1)
       p1y=ye(ll)
       p2y=ye(ll+1)

       call line(p1x,p1y,p2x,p2y,linecolor)

c       write (*,*) ll,tet*180./pi,xe(ll),ye(ll)

       end do

       return

       end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      SUBROUTINE ROMANO
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       SUBROUTINE romano(rn,rx0,ry0,ralp,requi,rcolor)

       integer rn, rn1, rn2, rn3, rcolor

       real*8 rx0, ry0, ralp, requi, dx

       dx=0.0d0

       rn1=int(float(rn)/10.)
       rn2=int((float(rn)-10.*float(rn1))/5.)
       rn3=rn-10*rn1-5*rn2

c      write (*,*) "rn1= ", rn, rn1, rn2, rn3

       do i=1,rn1

       call point(rx0+dx*dcos(ralp),ry0-dx*dsin(ralp),7)
       call point(rx0+dx*dcos(ralp)+requi*dsin(ralp),
     + ry0-dx*dsin(ralp)+requi*dcos(ralp),7)
       dx=dx+requi
       call point(rx0+dx*dcos(ralp),ry0-dx*dsin(ralp),7)
       call point(rx0+dx*dcos(ralp)+requi*dsin(ralp),
     + ry0-dx*dsin(ralp)+requi*dcos(ralp),7)
       dx=dx+requi

       end do

       do i=1,rn2

       call point(rx0+dx*dcos(ralp),ry0-dx*dsin(ralp),7)
       call point(rx0+(dx+0.5*requi)*dcos(ralp)+requi*dsin(ralp),
     + ry0-(dx+0.5*requi)*dsin(ralp)+requi*dcos(ralp),7)
       dx=dx+requi
       call point(rx0+dx*dcos(ralp),ry0-dx*dsin(ralp),7)
       dx=dx+requi

       end do

       do i=1,rn3

       call point(rx0+dx*dcos(ralp),ry0-dx*dsin(ralp),7)
       dx=dx+requi

       end do

       return

       end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      SUBROUTINE TEXT
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       SUBROUTINE txt(p1x,p1y,htext,atext,xtext,txtcolor)
c      line P1-P2

       real*8 atext,htext,p1x,p1y
       character*50 xtext
       integer txtcolor

       write(20,'(A,/,I1,/,A)') "TEXT",5,"10A38"
       write(20,'(I1,/,I1)') 8, 0
       write(20,'(I1,/,A)') 6,"CONTINUOUS"
       write(20,'(I2,/,I3)') 62, txtcolor
       write(20,'(I2,/,F12.2,/,I2,/,F12.2)') 10,p1x,20,-p1y
       write(20,'(I2,/,F12.2)') 30,0.0
       write(20,'(I2,/,F12.2)') 40, htext
       write(20,'(I2,/,A50)') 1, xtext
       write(20,'(I2,/,F12.2,/I1)') 50, atext,0

       return
       end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      SUBROUTINE ITEXT
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       SUBROUTINE itxt(p1x,p1y,htext,atext,itext,txtcolor)
c      line P1-P2

       real*8 atext,htext,p1x,p1y
       integer itext, txtcolor

       write(20,'(A,/,I1,/,A)') "TEXT",5,"10A38"
       write(20,'(I1,/,I1)') 8, 0
       write(20,'(I1,/,A)') 6,"CONTINUOUS"
       write(20,'(I2,/,I3)') 62, txtcolor
       write(20,'(I2,/,F12.2,/,I2,/,F12.2)') 10,p1x,20,-p1y
       write(20,'(I2,/,F12.2)') 30,0.0
       write(20,'(I2,/,F12.2)') 40, htext
       write(20,'(I2,/,I12)') 1, itext
       write(20,'(I2,/,F12.2,/I1)') 50, atext,0

       return
       end

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      DXF init
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
       
       SUBROUTINE dxfinit(nunit)
       
       write(nunit,'(I1,/,A,/,I1)') 0,"SECTION",2
       write(nunit,'(A)') "HEADER"
       write(nunit,'(I1,/,A)') 9,"$EXTMAX"
       write(nunit,'(I2,/,F12.3,/,I2,/,F12.3)') 10,-670.,20,-3630.
       write(nunit,'(I1,/,A)') 9,"$EXTMIN"
       write(nunit,'(I2,/,F12.3,/,I2,/,F12.3)') 10,7000.,20,120.
       write(nunit,'(I1,/,A,/,I1)') 0,"ENDSEC",0
       write(nunit,'(A,/,I1)') "SECTION",2
       write(nunit,'(A,/,I1)') "ENTITIES",0

       return
       end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      DXF end
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       SUBROUTINE dxfend(nunit)

       write(nunit,'(A,/,I1,/,A)') "ENDSEC",0,"EOF"
       return
       end

 
cccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      Subroutine vectors redistribution             c
c                                                    c
c      Read polyline (xlin1,ylin1) in n1vr points    c
c      and redistribute in polyline                  c
c      (xlin3,ylin3) in n2vr points                  c
cccccccccccccccccccccccccccccccccccccccccccccccccccccc

       subroutine vredis(xlin1,ylin1,xlin3,ylin3,n1vr,n2vr)  

       real*8 xlin1(5000),ylin1(5000)
       real*8 xlin2(50000),ylin2(50000)
       real*8 xlin3(5000),ylin3(5000)
   

c      Case n1vr > 3

c      j2vr counter in x10 multiplied vector
       j2vr=0

c      Define local vector
       do j1vr=1,n1vr-1

       xj=xlin1(j1vr)
       yj=ylin1(j1vr)
       xjm1=xlin1(j1vr+1)
       yjm1=ylin1(j1vr+1)

       do kvr=0,10
       stvr=float(kvr)/10.
       j2vr=j2vr+1
c      Parametric equation in each segment
       xlin2(j2vr)=xj+stvr*(xjm1-xj)
       ylin2(j2vr)=yj+stvr*(yjm1-yj)
       end do
       j2vr=j2vr-1

       end do

       j2max=j2vr+1
      
       icount=int(float((10*n1vr-1)/(n2vr-1)))
       iespai=icount*(n2vr-1)
       isobra=10*(n1vr-1)-iespai

       itotes=10*(n1vr-1)

c      Assign vector 3

c      j3 counter in final vector
       j3vr=1
       j2vr=1
       do j22vr=1,j2max

       xlin3(j3vr)=xlin2(j2vr)
       ylin3(j3vr)=ylin2(j2vr)

c      Ajust exactly the final point
       if (j3vr.eq.n2vr) then
       xlin3(j3vr)=xlin1(n1vr)
       ylin3(j3vr)=ylin1(n1vr)
       end if

c      Assign excess of spaces
       iplus=0
       if (j3vr.le.isobra) then
       iplus=1
       end if

c      Count
       do ijkvr=1,icount+iplus
       j2vr=j2vr+1
       end do
      
       j3vr=j3vr+1

       end do

c      Special case n1vr=2
       if (n1vr.eq.2) then 
             
       disx=(xlin1(2)-xlin1(1))/float(n2vr-1)
       disy=(ylin1(2)-ylin1(1))/float(n2vr-1)

       do j=1,n2vr
       xlin3(j)=xlin1(1)+disx*float(j-1)
       ylin3(j)=ylin1(1)+disy*float(j-1)
       end do

       end if


       return

       end


cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c SUBROUTINE r and s lines 2D intersection
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      SUBROUTINE xrxs(xru,xrv,xsu,xsv,xtu,xtv)

      real*8 xru(2),xrv(2),xsu(2),xsv(2)

      xmr=(xrv(2)-xrv(1))/(xru(2)-xru(1))
      xbr=xrv(1)-xmr*xru(1)
      if ((xru(2)-xru(1)).eq.0.) then
      xmr=(xrv(2)-xrv(1))/0.000001
      end if

      xms=(xsv(2)-xsv(1))/(xsu(2)-xsu(1))
      xbs=xsv(1)-xms*xsu(1)
      if ((xsu(2)-xsu(1)).eq.0.) then
      xms=(xsv(2)-xsv(1))/0.000001
      end if

      xtu=(xbs-xbr)/(xmr-xms)
      xtv=xmr*xtu+xbr
     
c      write (*,*) "Z ", xru(1),xrv(1),xmr,xms,xtu,xtv

      return

      end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     SUBROUTINE  flatteninig
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       SUBROUTINE flatt(ni,npunts,rx,ry,rz,
     + pl1x,pl1y,pl2x,pl2y,pr1x,pr1y,pr2x,pr2y)

       real*8 rx(0:100,300),ry(0:100,300),rz(0:100,300)

       real*8 pl1x(0:100,300),pl1y(0:100,300),pl2x(0:100,300),
     + pl2y(0:100,300)
       real*8 pr1x(0:100,300),pr1y(0:100,300),pr2x(0:100,300),
     + pr2y(0:100,300)

       real*8 phr,pa1r,px0,py0,ptheta,pw1

       i=ni

       px0=0.0d0
       py0=0.0d0
       ptheta=0.0d0

       do j=1,npunts

c       write (*,*) "rx ry rx ", j, rx(i,j),ry(i,j),rz(i,j)

c      Distances between points
       pa=sqrt((rx(i+1,j)-rx(i,j))**2.+(ry(i+1,j)-ry(i,j))**2.+
     + (rz(i+1,j)-rz(i,j))**2.)
       pb=sqrt((rx(i+1,j+1)-rx(i,j))**2.+(ry(i+1,j+1)-ry(i,j))**2.+
     + (rz(i+1,j+1)-rz(i,j))**2.)
       pc=sqrt((rx(i+1,j+1)-rx(i+1,j))**2.+(ry(i+1,j+1)-ry(i+1,j))**2.+
     + (rz(i+1,j+1)-rz(i+1,j))**2.)
       pd=sqrt((rx(i+1,j)-rx(i,j+1))**2.+(ry(i+1,j)-ry(i,j+1))**2.+
     + (rz(i+1,j)-rz(i,j+1))**2.)
       pe=sqrt((rx(i,j+1)-rx(i,j))**2.+(ry(i,j+1)-ry(i,j))**2.+
     + (rz(i,j+1)-rz(i,j))**2.)
       pf=sqrt((rx(i+1,j+1)-rx(i,j+1))**2.+(ry(i+1,j+1)-ry(i,j+1))**2.+
     + (rz(i+1,j+1)-rz(i,j+1))**2.)
       
       pa2r=(pa*pa-pb*pb+pc*pc)/(2.*pa)
       pa1r=pa-pa2r
       phr=sqrt(pc*pc-pa2r*pa2r)

       pa2l=(pa*pa-pe*pe+pd*pd)/(2.*pa)
       pa1l=pa-pa2l
       phl=sqrt(pd*pd-pa2l*pa2l)

       pb2t=(pb*pb-pe*pe+pf*pf)/(2.*pb)
       pb1t=pb-pb2t
       pht=sqrt(pf*pf-pb2t*pb2t)
       
       pw1=datan(phr/pa1r)
       phu=pb1t*dtan(pw1)

c      Quadrilater coordinates
       pl1x(i,j)=px0
       pl1y(i,j)=py0

       pr1x(i,j)=pa*dcos(ptheta)+px0
       pr1y(i,j)=pa*dsin(ptheta)+py0

       pl2x(i,j)=pa1l*dcos(ptheta)-phl*dsin(ptheta)+px0
       pl2y(i,j)=pa1l*dsin(ptheta)+phl*dcos(ptheta)+py0
       
       pr2x(i,j)=pa1r*dcos(ptheta)-phr*dsin(ptheta)+px0
       pr2y(i,j)=pa1r*dsin(ptheta)+phr*dcos(ptheta)+py0

c      Iteration
       px0=pl2x(i,j)
       py0=pl2y(i,j)
       ptheta=datan((pr2y(i,j)-pl2y(i,j))/(pr2x(i,j)-pl2x(i,j)))
       
       end do

       return

       end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     SUBROUTINE  axisch
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       SUBROUTINE axisch(npunts,angle,px9i,py9i,px9o,py9o)

       real*8 px9i(300),py9i(300)
       real*8 px9o(300),py9o(300)

       real*8 angle,xc,xs

       pi=4.*datan(1.0d0)
       angle=0.0d0

       do j=1,npunts

       xc=dcos(angle*pi/180.)
       xs=dsin(angle*pi/180.)

       px9o(j)=xc*px9i(j)-xs*py9i(j)
       py9o(j)=xs*px9i(j)+xc*py9i(j)

       end do

       return

       end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      SUBROUTINE angdis1
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      SUBROUTINE angdis2
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       SUBROUTINE angdis2(p1u,p1v,p2u,p2v,p3u,p3v,angl,dist)

       real*8 du,dv,angl

       real*8 p1u,p1v,p2u,p2v,p3u,p3v,dist

       du=p2u-p1u
       dv=p2v-p1v

c       write (*,*) "sub ",p1u,p1v,p2u,p2v
      
       if (du.ne.0.) then 
       angl=abs(datan(dv/du))
       end if
       if (du.eq.0.) then angl=2.*datan(1.0d0)
c       write (*,*) "sub dv du",dv,du,angl

c      Case 1
       if (du.ge.0.and.dv.ge.0) then
       p3u=p1u-dist*dsin(angl)
       p3v=p1v+dist*dcos(angl)
       end if

c      Case 2
       if (du.lt.0.and.dv.ge.0) then
       p3u=p1u-dist*dsin(angl)
       p3v=p1v-dist*dcos(angl)
       end if

c      Case 3
       if (du.ge.0.and.dv.le.0) then
c       p3u=p1u+dist*dsin(angl)
c       p3v=p1v+dist*dcos(angl)
       end if

c      Case 4
       if (du.lt.0.and.dv.le.0) then
c       p3u=p1u+dist*dsin(angl)
c       p3v=p1v-dist*dcos(angl)
       end if

c       write(*,*) "4444 ",angl,p3u,p3v

      
       return

       end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      SUBROUTINE angdis3
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc


ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      SUBROUTINE d3p
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

       


