clear all
image = imread('lena_color_512.tif');
[row,col,band_num] = size(image);
% convert image pixels to floating numbers
image = double(image);

% mean and normalizing image
for i=1:band_num
    % finding bandwise mean 
    mean(1,i) = mean2(image(:,:,i));
    % bandwise normalization
    X(:,:,i)=image(:,:,i)-mean(1,i)*ones(row,col);
    Y(:,:,i)=image(:,:,i)-mean(1,i)*ones(row,col);
end

% for covariance matrix
sum1=0;
for m=1:band_num
    for k=1:band_num
         for ro=1:row
            for co=1:col
                z=X(ro,co,m)*Y(ro,co,k);
                sum1= sum1+z;
            end
         end
         cov = sum1/((row*col)-1);
         cov_mat(m,k)=cov;
         sum1=0;
    end
end
    
                

% eigen value(val) and eigen vector(vect)
[vect,val] = eig(cov_mat);
% columnise eigen value
val = diag(val);
% sorting eigen value in descending order with their indices
[sort_val,index]=sort(val,'descend');

% sorting eigen vectors according to corresponding sorted eigen values
for j=1:length(sort_val)
    sort_vect(:,j) = vect(:,index(j));
end

% 
for r=1:row
    for c=1:col
        for b=1:band_num
            % pixel value of normalized image
            norml_img(b,1)= X(r,c,b);
        end
        % transformed value of each pixel
        % transformed = feture vector transpose * normalized image
        pct = sort_vect.'*norml_img;
        for count=1:band_num
            % principal component
            pct_img(r,c,count)=pct(count,1);
        end
    end
end


figure, imshow(pct_img(:,:,1),[]);
figure, imshow(pct_img(:,:,2),[]);
figure, imshow(pct_img(:,:,3),[]);