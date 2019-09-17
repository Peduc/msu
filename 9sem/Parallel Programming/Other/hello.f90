program hello   
    include 'mpif.h'	   
	   
	integer rank,numprocs,ierr, i,j,k
	real(17), allocatable:: A(:,:),x(:)
   
	call MPI_Init(ierr)
	call MPI_Comm_rank(MPI_COMM_WORLD,rank,ierr)	
	call MPI_Comm_size(MPI_COMM_WORLD,numprocs,ierr)

    print*,'Process ', rank, 'of ',numprocs, 'is ready'
    
	N=20
	k=1
	
	allocate(A(1:N,1:N))

	open(207, file="AData.dat")

    read(*,*)
	do i=1,(N*N),1
		write(*,*), i,k
		if  ((mod(i,N)==0) .AND. (k<20)) then
			k=k+1
			print*, "k", k
		endif		
		read(207,*)A(k,i)
		write(*,*) A(k,i)		
	enddo	
		
	k=0
	write(*,*), k		

!	do i=1,N
!		do j=1,N
!			write(*,*) A(j,i) 
!		enddo
!	enddo
		
	close(207)
	
	call MPI_Finalize(ierr)	   
		
!		open(1, file="xData.dat")
!		close(1)
     
	print *, "Hello World!"
end 