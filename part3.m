%Load image , and convert it to gray-scale
x = imread('lena.bmp');
%figure
%RGB scale
%imshow(x);
x = rgb2gray(x);
%figure
%Grayscale
%imshow(x);

%Normalization at [0,1]
x = double(x) / 255 ;

printOriginal(x);

%Uniform at [0,1] 
d1= linspace(0,1,100);
f1 = @(x)unifpdf(x,0,1);
h = pdf2hist(d1,f1);
v = createV(d1,1);
Y = histtransform(x,h,v);
printRes(Y);
    
%Uniform at [0,2]
d2= linspace(0,2,100);
f2 = @(x)unifpdf(x,0,2);
h = pdf2hist(d2,f2);
v = createV(d2,2);
Y = histtransform(x,h,v);
printRes(Y);

%Normal Distribution at with mu = 0.5 s = 0.1
d3 = linspace(0,1,100);
f3 = @(x)normpdf(x,0.5,0.1);
h = pdf2hist(d3,f3);
v = createV(d3,1);
Y = histtransform(x,h,v);
printRes(Y);


%Implementation of the createV function
function val = createV(d,a)
v=[];
for i = 1 : (size(d,2) - 1)
    
    v = [ v , (d(i)+d(i+1))/(2*a)];
end
val = v ;
end


function printRes(x)
pixS = size(x,1)*size(x,2);
figure
[hn , hx ] = hist(x(:), 0:1/255:1); 
subplot(122)
normHn = hn ./ (pixS);
s = sum(normHn); 
bar(hx,normHn) 
title('Edited Histogram');
subplot(121)
imshow(x);
title('Edited image');


end

function printOriginal(original)
figure
subplot(121);
imshow(original);
title('Original image');
[hn , hx ] = hist(original(:), 0:1/255:1);
subplot(122)
bar(hx,hn)
title('Histogram of the Original image');

end


%Implementation of the pdf2hist function
function h = pdf2hist(d ,f ) 
 h = [] ;
 %Create [d(1),d(2)], [d(2),d(3)], ..., [d(end - 1),d(end)] 
 % And update the h value 
 %We use integral function to calculate the propability 
for i = 1 : (size(d,2)-1)
    %Get the mean of the left and right reimann sums 
    a = leftsum(f,d(i) , d(i+1) , size(d(i),2));
    b = rightsum(f,d(i) , d(i+1) , size(d(i),2));
   % h=[h ,  integral(f,d(i),d(i+1))];
    h = [h , (a+b)/2];
end
%To check that our hist is normalized 
%s = sum(h); 
end


%Implementation of the left riemann sum that approaches the integral
%Arithmetic Calculation
function [I] = leftsum(f,a,b,n)

dx = (b-a)/n;
x=linspace(a,b,n+1);
I=0;
for i=1:n
 I = I + feval(f,x(i))*dx;
end
end

%Implementation of the left riemann sum that approaches the integral
%Arithmetic Calculation
function [I] = rightsum(f,a,b,n)

dx = (b-a)/n;
x=linspace(a,b,n+1);
I=0;
for i=2:n+1
 I = I + feval(f,x(i))*dx;
end
end



%Implementation of the hisstransform function 
function Y = histtransform(X, h, v) 
%Initialization of the pixels array
pixelsAtv =zeros(1,size(h,2)) ;
%Counter that identifies the v index 
inCounter = 1 ; 
%The total pixels number
pixS = size(X,1)*size(X,2);
%Sort in ascending order the elements of each row
[xS, idx ] = sort(X,2);
%Main loops
for i  = 1: size(X,1)
    for j = 1 : size(X,2)
        if (pixelsAtv(inCounter) / pixS) < h(inCounter)
            %Update the pixels at the specific v 
            pixelsAtv(inCounter) = pixelsAtv(inCounter) + 1 ;
            %Get the original index value  
            c = idx(j,i);
            %Store  back the correct value 
            X(j,c) = v(inCounter);
        else
            %Change the index of the v 
            inCounter = inCounter + 1 ;
            %Update the pixels at the specific v 
            pixelsAtv(inCounter) = pixelsAtv(inCounter) + 1 ;
            %Get the original index value 
            c = idx(j,i);
            %Store back the correct value 
            X(j,c) = v(inCounter);
        end
    end
end
Y=X;
end
