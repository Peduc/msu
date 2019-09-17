program main

    include 'mpif.h'

	integer rank,numprocs,ierr
   
	call MPI_Init(ierr)
	call MPI_Comm_rank(MPI_COMM_WORLD,rank,ierr)	
	call MPI_Comm_size(MPI_COMM_WORLD,numprocs,ierr)

    print*,'Process ', rank, 'of ',numprocs, 'is ready'
    
	call MPI_Finalize(ierr)

end
