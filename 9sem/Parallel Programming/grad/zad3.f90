program main
    
    include 'mpif.h'
    
    integer N,M, Mmod, ch
    integer i,j,k,status(MPI_STATUS_SIZE)
    real(16),allocatable :: x1(:),x2(:),b(:),b_temp(:)
	integer,allocatable :: distr(:)

	integer rank,numprocs,ierr
   
	call MPI_Init(ierr)
	call MPI_Comm_rank(MPI_COMM_WORLD,rank,ierr)	
	call MPI_Comm_size(MPI_COMM_WORLD,numprocs,ierr)
    
    if (rank==0) then
        ! Считываем из файло число строк M и число столбцов N
        open(1,file = 'in.dat')
            ! read(1,*) N ! Считываем число столбцов N
	        read(1,*) M ! Считываем число строк M
	    close(1)
	endif

	allocate(distr(numprocs-1))
	
	if (rank==0) then
		if (mod(M,numprocs-1)/=0) then
			Mmod=M
			ch=0
			do while (mod(Mmod,numprocs-1)/=0)
				Mmod=Mmod-1
				ch=ch+1
			enddo
		endif
		do i = 1,numprocs-1 
			if (i<=ch) then
				distr(i)=(M/(numprocs-1))+1
			else
				distr(i)=(M/(numprocs-1))
			endif
		enddo
	endif
	
	! call MPI_BCAST(N,1,MPI_INTEGER,0,MPI_COMM_WORLD,ierr)
	call MPI_BCAST(M,1,MPI_INTEGER,0,MPI_COMM_WORLD,ierr)
	call MPI_BCAST(distr,(numprocs-1),MPI_INTEGER,0,MPI_COMM_WORLD,ierr)
	
	! 
	! allocate(x1(1))
	
	! if (rank /= 0) then
		! write(*,*) rank,distr(rank)
	! endif
	
	if (rank==0) then
	    ! Считываем из файла вектор x1
        open(2,file = 'xData.dat')
	        do k = 1,numprocs-1
				write(*,*) distr(k)
	            allocate(x1(distr(k)))
	            do j = 1,distr(k)
	                read(2,*) x1(j)
					write(*,*) x1(j)
		        enddo
		        call MPI_SEND(x1,distr(k),MPI_REAL16,k,207,MPI_COMM_WORLD,ierr)
		        deallocate(x1)
		    enddo
	    close(2)
	else
		! write(*,*) rank,distr(rank)
	    allocate(x1(distr(rank)))
	    call MPI_RECV(x1,distr(rank),MPI_REAL16,0,MPI_ANY_TAG,MPI_COMM_WORLD,STATUS,ierr)
	endif
	
	! if (rank==0) then
	    ! ! Считываем из файла вектор x2
        ! open(3,file = 'xData.dat')
	        ! do i = 1,N 
		        ! read(3,*) x(i)
				! write(*,*) x(j)
				! enddo
	    ! close(3)
	! endif
	
	! call MPI_BCAST(x,N,MPI_REAL16,0,MPI_COMM_WORLD,ierr)
	
	! if (rank==0) then
	    ! allocate(b(M))
	! endif
! !	allocate(b_temp())
	
	! ! Основная вычислительная часть программы
	! ! Умножаем матрцу A на вектор x
	! ! ------------------------------------------------------------
	! if (rank /= 0) then
		! allocate(b_temp(distr(rank)))
	    ! do j = 1,distr(rank)
	        ! b_temp(j) = 0.0q0
	        ! do i = 1,N
	            ! b_temp(j) = b_temp(j) + A(j,i)*x(i)
	        ! enddo
		! ! write(*,*) b_temp(j)	
	    ! enddo
		! call MPI_SEND(b_temp,distr(rank),MPI_REAL16,0,207,MPI_COMM_WORLD,ierr)
		! deallocate(b_temp)
	! else 
        ! do k = 1,numprocs-1
			! allocate(b_temp(distr(k)))
            ! call MPI_RECV(b_temp,distr(k),MPI_REAL16,k,MPI_ANY_TAG,MPI_COMM_WORLD,STATUS,ierr)
            ! do j = 1,distr(k)
                ! if ((status(MPI_SOURCE))<=ch) then
					! b((status(MPI_SOURCE)-1)*(distr(k)) + j) = b_temp(j)
				! else
					! b((status(MPI_SOURCE)-1)*(distr(k)) + j + ch) = b_temp(j)
				! endif
				! ! write(*,*) b_temp(j)
            ! enddo
			! deallocate(b_temp)
        ! enddo
	! endif
	
	! if (rank == 0) then
	    ! do j = 1,M
	        ! print*, b(j)
	    ! enddo
	! endif
	
	
	! ! ! Сохраняем результат вычислений в файл
	! ! !open(4,file='Results.dat')
    ! ! !    do j = 1,M
	! ! !       write(4,*) b(j)
	! ! !	enddo
	! ! !close(4)
	
	! call MPI_Finalize(ierr)

end
