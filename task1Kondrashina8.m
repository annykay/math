%Отчет по первой задаче лабораторной работы по решшению уравнения
%тепопроводности студентки 7111 группы Кондрашиной Анны 
%задача 8
%u_tt = u_xx
%u(0,x) = x*exp{-x^2}
%точное решение: 
%u(t,x) = x*(1+4*t)^{-3/2}*exp{-x^2/(1+4*t)}
%0<x<L, 0<t<T

%зная точное решение, дополним задачу граничными условиями:
%u(t,0) = 0
%u(t,L) = L*(1+4*t)^{-3/2}*exp{-L^2/(1+4*t)}

%Предположим, что область имеет следующие границы:
T=2;
L=10;




N = 4000;
M = 100;
h = L/M;
tau = T/N;

x = 0:h:L;
t = 0:tau:T;
%Посчитаем параболическое число Куранто
disp('Число Куранто:');
disp(tau/2/h^2);

X = zeros(N,M); %иничиализируем сетку координат
Th = zeros(N,M);%иничиализируем сетку времени
Y = zeros(N,M);%иничиализируем матрицу для точного решения
U = zeros(N,M);%иничиализируем матрицу для численного решения явным методом

%Заполним матрицу времени, одинаковые значения по строкам 
for i=1:1:N
    for j = 1:1:M
        Th(i,j) = t(i);
    end
end


%Заполняем матрицу координат, одинаковые значения по столбцам
for j=1:1:M
    for i=1:1:N
        X(i,j)=x(j);
    end
end

%Вычислим точное решение:
for i=1:1:N
    for j=2:1:M
        Y(i,j)= X(i,j)*(1+4*Th(i,j))^(-3/2)*exp(-(X(i,j))^2/(1+4*Th(i,j)));
    end
end

%Первой рассмотрим явную схему, то есть вес кси равен нулю.Для
%устойчивости этого метода нужно, чтобы число Курвнто быо меньше 1/2

%Зададим начальное условие. U(0,x) = x*exp(-x^2)
for j=1:1:M
    U(1,j)=(j-1)*h*exp(-((j-1)*h)^2);
end

%Заполним граничное условие. U(t,0) = 0 - можно не заполнять; 
%U(t,L) = L*(1+4*t)^(-3/2)*exp(-x^2/(1+4t)
for i=1:1:N
    U(i,M)=L*(1+(i-1)*tau)^(-3/2)*exp(-L^2/(1+4*(i-1)*tau));
end

%Вычислим каждое следующее значение функции явно:
for i=2:1:(N-1)
    for j=2:1:(M-1)
        U(i,j)=U(i-1,j)+tau*(U(i-1,j+1)-2*U(i-1,j)+U(i-1,j-1))/h^2;
    end
end


%Теперь попробуем решить задачу неявным методом

A = zeros(M,M);%матрица слау
U1=zeros(N,M);%значение функции 
%Заполняем матрицу, согласно разностной схеме
A(1,1) = -(2+h^2/tau);
A(1,2) = 1;
for i=2:1:(M-1)
    A(i,i-1) = 1;
    A(i,i) = -2-h^2/tau;
    A(i, i+1) = 1;
end
A(M,M-1) = 1;
A(M,M) = -(2+h^2/tau);
%Зададим начальное условие. U(0,x) = x*exp(-x^2)
for i=1:1:M
    U1(1,i) = (i-1)*h*exp(-((i-1)*h)^2);
end
%Заполним граничное условие. U(t,0) = 0 - можно не заполнять; 
%U(t,L) = L*(1+4*t)^(-3/2)*exp(-x^2/(1+4t)
for i=1:1:N
    U1(i,M) = L*(1+4*(j-1)*tau)^(-3/2)*exp(-L^2/(1+4*tau*(j-1)));
end
f = zeros(M);
x1 = zeros(M);
%заполним остальные значения функции, решая СЛАУ
for i=2:1:N
    f(1) = U1(i-1,1);
    f(M)=-h^2/tau*U1(i-1,M-1)-U1(i,M);
    for j=2:1:M-1
        f(j) = -h^2/tau*U1(i-1,j);
    end
    x1 = A\f;
    for j=1:1:M
        U1(i,j)= x1(j);
    end
end
%Теперь реализуем метод Кранка-Никльсона 
A1 = zeros(M,M);
%Заполняем матрицу согласно новой схемы 
A1(1,1) = -(1+tau/h^2);
A1(1,2) = tau/2/h^2;
A1(M-1,M) = tau/(2*h^2);
A1(M,M) = -(1+tau/h^2);

for i=2:1:M-1
    A1(i,i-1) = tau/(2*h^2);
    A1(i,i) = -(1+tau/h^2);
    A1(i,i+1) = tau/(2*h^2);
end

U2=zeros(N,M);
%начальные условия
for i=1:1:M
    U2(1,i) = (i-1)*h*exp(-((i-1)*h)^2);
end
%граничные условия
for i=1:1:N
    U2(i,M) = L*(1+4*(i-1)*tau)^(-3/2)*exp(-L^2/(1+4*tau*(i-1)));
    
end
f2 = zeros(M);
x2 = zeros(M);
%Заполняем таблицу со значениями функции, решая слау
for i=2:1:N
    f2(1)=-tau/(2*h^2)*U2(i,1)-tau/(2*h^2)*U2(i-1,1)+(tau/h^2-1)*U2(i-1,2)-tau/(2*h^2)*U2(i-1,3);
    f2(M)=-tau/(2*h^2)*U2(i,M)-tau/(2*h^2)*U2(i-1,M-2)+(tau/h^2-1)*U2(i-1,M-1)-tau/(2*h^2)*U2(i,M);
    for j=2:1:M-1
        f2(j) = -tau/(2*h^2)*U2(i-1,j-1)+(tau/h^2-1)*U2(i-1,j)-tau/(2*h^2)*U2(i-1,j+1);
        
    end
    x2 = A1\f2;
    for j=2:1:M-1
        U2(i,j)= x2(j);
    end
    
end

%Добавим цикл для рассчета ошибки:
err = sqrt(sum((Y-U).^2, 2));
err1 = sqrt(sum((Y-U1).^2, 2));
err2 = sqrt(sum((Y-U2).^2, 2));
 
figure(1)
subplot(1, 2, 1)

%Желтым будем рисовать точное решение, красным - решение, полученное явным
%методом, циановым - решение, полученное неявным методом, а голубым -
%решение, полученное методом Кранка-Никльсона 
plot3(Th, X, Y, 'y')
hold on;
plot3(Th, X,U, 'r')
hold on;
plot3(Th, X, U1, 'c')
hold on;
plot3(Th, X, U2, 'b')
xlabel('t')
ylabel('x')
zlabel('u')
title('Numerical solution (six-layer difference scheme)')

ti = tau:tau:T;

subplot(1, 2, 2)
plot(ti, err, 'r')
pold on;
plot(ti, err1, 'c')
hold on;
plot(ti, err2, 'b')
xlabel('t')
ylabel('error')
title('Error(t)')

%Меняя шаги разностных схем, придем к выводу, что явная разностная схема
%теряет устойчивость при росте числа Куранто. Когда число Куранто
%становится больше 1/2, ошибки становятся больше для всех сетодов
        