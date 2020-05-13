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
 


% Case 1
L = 10;
v = linspace(0, 1, L);
h = ones([1, L]) / L;
Y = histtransform(x,h,v);
printRes(Y,x);


% Case 2
L = 20;
v = linspace(0,1,L);
h = ones([1,L]) / L;
Y = histtransform(x,h,v);
printRes(Y,x);


%Case 3 
L = 10 ; 
v = linspace(0,1,L);
h = normpdf(v, 0.5) / sum(normpdf(v, 0.5)); 
Y = histtransform(x,h,v);
printRes(Y,x);

%Implementation of the printRes function
%We use this function to print out plots 
function printRes(x,original)
pixS = size(x,1)*size(x,2);
figure
subplot(221);
imshow(original);
title('Original image');
[hn , hx ] = hist(x(:), 0:1/255:1); 
subplot(224)
normHn = hn ./ (pixS);
s = sum(normHn); 
bar(hx,normHn) 
title('Edited Histogram');
subplot(222)
imshow(x);
title('Edited image');
[hn , hx ] = hist(original(:), 0:1/255:1);
subplot(223)
bar(hx,hn)
title('Histogram of the Original image');

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