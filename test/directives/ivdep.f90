! RUN: %flang -O2 -S -emit-llvm %s -o - | FileCheck %s
! RUN: %flang -S -emit-llvm %s -o - | FileCheck %s -check-prefix=METADATA

subroutine sum(myarr1,myarr2,ub)
  integer, pointer :: myarr1(:)
  integer, pointer :: myarr2(:)
  integer :: ub

  !dir$ ivdep
  do i=1,ub
    myarr1(i) = myarr1(i)+myarr2(i)
  end do
end subroutine

! CHECK:  {{.*}} add nsw i32 {{.*}}
! METADATA: load {{.*}}, !llvm.access.group ![[TAG1:[0-9]+]]
! METADATA: store {{.*}}, !llvm.access.group ![[TAG1]]
! METADATA: ![[TAG2:[0-9]+]] = !{!"llvm.loop.vectorize.enable", i1 true}
! METADATA: ![[TAG3:[0-9]+]] = !{!"llvm.loop.parallel_accesses", ![[TAG4:[0-9]+]]}
! METADATA: ![[TAG4]] = distinct !{}
! METADATA: ![[TAG1:[0-9]+]] = distinct !{![[TAG1]], ![[TAG2]], ![[TAG3]]}
