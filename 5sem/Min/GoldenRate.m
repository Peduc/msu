clear
clc

%Входные параметры
leftin=1;
rightin=4;
type1=[];
left=[];
right=[];
fnewr=[];
fnewl=[];
newl=[];
newr=[];

N=1000;
h=(rightin-leftin)/(N-1);
ratio=(3-sqrt(5))/2;
eps=0.01;
flag=0;

% %Формирование исходной сетки для рисования. 
for i=1:N
    x(i)=leftin+(i-1)*h;
    y(i)=mini(x(i));
end;

i=0;
%Поиск минимума
while (flag ==0)
    i=i+1;
    if i==1
        left=leftin;
        right=rightin;
        newl=(left+(right-left)*ratio);
        newr=(right-(right-left)*ratio);
        fnewl=mini(newl);
        fnewr=mini(newr);
        if fnewl<=fnewr
            right=newr;
            newr=newl;
            fnewr=fnewl;
            type1=1;
            disp(left);
            disp(right);
            disp(type1);
        else
            left=newl;
            newl=newr;
            fnewl=fnewr;
            type1=2;
            disp(left);
            disp(right);
            disp(type1);
        end;
    else
        if (type1==1)
            newl=(left+(right-left)*ratio);
            fnewl=mini(fnewl);
            if fnewl<=fnewr
                right=newr;
                newr=newl;
                fnewr=fnewl;
                type1=1;
                disp(left);
                disp(right);
                disp(type1);                
            else
                left=newl;
                newl=newr;
                fnewl=fnewr;
                type1=2;
                disp(left);
                disp(right);
                disp(type1);                 
            end;
        else
            newr=(right-(right-left)*ratio);
            fnewr=mini(fnewr);
            if fnewl<=fnewr
                right=newr;
                newr=newl;
                fnewr=fnewl;
                type1=1;
                disp(left);
                disp(right);
                disp(type1);                 
            else
                left=newl;
                newl=newr;
                fnewl=fnewr;
                type1=2;
                disp(left);
                disp(right);
                disp(type1);                 
            end;            
        end;
    if ((i>1)&&((right-left)/(rightin-leftin)<=eps))
        flag=1;
%         disp(right);
%         disp(left);    
    end;
    end;
%     disp(i);
end;

plot(x,y);