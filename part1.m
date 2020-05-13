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

% Show the histogram of intensity values 
[hn , hx ] = hist(x(:), 0:1/255:1);
figure 
bar(hx,hn)

%function call for x1 = 0.1956 , y1 = 0.0354 , x2 = 0.8345 , y2 = 0.9465
y =  pointtransform(x,0.1956, 0.0354, 0.8345, 0.9465);
%function call for x1 = 0.0000 , y1 = 0.0000 , x2 = 0.0000 , y2 = 1.0000 
y =  pointtransform(x,0.0000, 0.0000, 0.5000, 1.0000);



function Y = pointtransform(X , x1 , y1 , x2 , y2  )
r = 0:1/255:1;
%We assume that if user sets x1 values equals to 0 , we will use clipping.
%Clipping 
if x1 == 0 
    xval = (x2  - x1)*256;
    yval = (y2-y1) ;
    f = [ zeros(1,(xval))   yval*ones(1,xval) ];
    size(f)
%Contrast Stretching    
else
    %y - y1 = ((y2-y1)/(x2-x1))*(x-x1) line equation to make the lines 
    l1 = ((y1/x1)*(0:1/255:x1));
    l2 = ( ((y2-y1)/(x2-x1))*(x1:1/255:x2) - ((y2-y1)/(x2-x1))*x1 + y1   );
    l3 = ( ((1-y2)/(1-x2))*(x2:1/255:1)  - ((1-y2)/(1-x2))*x2 + y2  ) ;
    f = [ l1   l2  l3 ];
    
end
%Plots
figure
subplot(131)
imshow(X)
title('Original image')
subplot(132)
plot(r , f ,'r')
title('f(r)' );
subplot(133)
Y=f(floor(255*X)+1);
imshow(Y)
title('Edited image')
end


