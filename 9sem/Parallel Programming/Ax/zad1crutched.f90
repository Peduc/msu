program main
    
    include 'mpif.h'
    
    integer N,M
	integer Mmod, ch
    integer i,j,k,status(MPI_STATUS_SIZE)
    real(16),allocatable :: A(:,:),x(:),b(:),b_temp(:)

	integer rank,numprocs,ierr
   
	call MPI_Init(ierr)
	call MPI_Comm_rank(MPI_COMM_WORLD,rank,ierr)	
	call MPI_Comm_size(MPI_COMM_WORLD,numprocs,ierr)
    
    if (rank==0) then
        ! Считываем из файло число строк M и число столбцов N
        open(1,file = 'in.dat')
            read(1,*) N ! Считываем число столбцов N
	        read(1,*) M ! Считываем число строк M
			if (mod(M,numprocs-1)/=0) then
				Mmod=M
				ch=0
				do while (mod(Mmod,numprocs-1)/=0)
					Mmod=Mmod+1
					ch=ch+1
				enddo
			endif
	    close(1)
		! write(*,*) Mmod
	endif
	
	
	
	call MPI_BCAST(N,1,MPI_INTEGER,0,MPI_COMM_WORLD,ierr)
	call MPI_BCAST(Mmod,1,MPI_INTEGER,0,MPI_COMM_WORLD,ierr)
	
	! Выделяем под матрицы A,x и b соответствующее место в памяти
	allocate(x(N))

	if (rank==0) then
	    ! Считываем из файла матрицу A
        open(2,file = 'AData.dat')		
	        do k = 1,(numprocs-1)
	            allocate(A(Mmod/(numprocs-1),N))
				if (k<(numprocs-1)) then
					do j = 1,Mmod/(numprocs-1)
						do i = 1,N 
							read(2,*) A(j,i)
							! write(*,*) A(j,i)
						enddo
					enddo
				else
					do j = 1,Mmod/(numprocs-1)
						if ((((Mmod/(numprocs-1))*(numprocs-2))+j)<=M) then
							do i = 1,N 
								read(2,*) A(j,i)
								! write(*,*) A(j,i)
							enddo
						else
							do i = 1,N 
								A(j,i)=0
								! write(*,*) A(j,i)
								!! ch=ch+1
								!! write(*,*) ch
							enddo
						endif
					enddo
				endif
		        call MPI_SEND(A,Mmod/(numprocs-1)*N,MPI_REAL16,k,100500,MPI_COMM_WORLD,ierr)
		        deallocate(A)
		    enddo
	    close(2)
	 else
	    allocate(A(Mmod/(numprocs-1),N))
	    call MPI_RECV(A,Mmod/(numprocs-1)*N,MPI_REAL16,0,MPI_ANY_TAG,MPI_COMM_WORLD,STATUS,ierr)
	 endif
	
	if (rank==0) then
	    ! Считываем из файла вектор x
        open(3,file = 'xData.dat')
	        do i = 1,N 
		        read(3,*) x(i)
		    enddo
	    close(3)
	endif
		
	
	call MPI_BCAST(x,N,MPI_REAL16,0,MPI_COMM_WORLD,ierr)
	
	if (rank==0) then
	    allocate(b(Mmod))
	endif
	allocate(b_temp(Mmod/(numprocs-1)))
		
	
	! Основная вычислительная часть программы
	! Умножаем матрцу A на вектор x
	! ------------------------------------------------------------
	if (rank /= 0) then
	    do j = 1,Mmod/(numprocs-1)
	        b_temp(j) = 0.0q0
	        do i = 1,N
	            b_temp(j) = b_temp(j) + A(j,i)*x(i)
	        enddo
	    enddo
	endif
	! ------------------------------------------------------------
		
	
    if (rank==0) then
        do k = 1,numprocs-1
            call MPI_RECV(b_temp,Mmod/(numprocs-1),MPI_REAL16,MPI_ANY_SOURCE,MPI_ANY_TAG,MPI_COMM_WORLD,STATUS,ierr)
            do j = 1,Mmod/(numprocs-1)
                if
					b((status(MPI_SOURCE)-1)*(Mmod/(numprocs - 1)) + j) = b_temp(j)
            enddo
        enddo
    else
        call MPI_SEND(b_temp,Mmod/(numprocs-1),MPI_REAL16,0,207,MPI_COMM_WORLD,ierr)
    endif
			
		
	if (rank == 0) then
	    do j = 1,M
	        print*, b(j)
	    enddo
	endif
	
	
	! Сохраняем результат вычислений в файл
	!open(4,file='Results.dat')
    !    do j = 1,M
	!       write(4,*) b(j)
	!	enddo
	!close(4)
	
	call MPI_Finalize(ierr)

end
