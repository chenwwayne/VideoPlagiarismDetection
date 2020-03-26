d = dir('images\1-4\'); 
NOF = max(size(d) - 2);
imglist = d(3 : NOF + 2);
hammingDistance = zeros(NOF-1, 1);

Threshold = 8; 
similarImgNum = 0;

% read a keyframe for test
keyFrame = Mean_hash_algorithm('651.jpg');

%逐帧遍历
for i=1:NOF-1  

    noiseFrame = Mean_hash_algorithm(strcat('images\1-4\', imglist(i).name));
    hammingWeight = bitxor(keyFrame, noiseFrame); %计算汉明权重
    hammingDistance(i) = sum(hammingWeight(:) == 1); %计算汉明距离
    
    if(hammingDistance(i) < 7)
        similarImgNum = similarImgNum + 1;
    end
end;

fprintf ('number of Similar Image is %d', similarImgNum);
if (similarImgNum > 3)
    fprintf ('one fragment was stolen');
else
    fprintf ('No fragments were stolen');
end


% function :binary to hex 
function str=BinToHex(A)
str='';
    for  i=1:8
        for j=1:4:8
            temp = dec2hex(bin2dec(num2str(A(i,j:j+3))));
            str=strcat(str,num2str(temp));
        end
    end
end


% function: Mean_hash_algorithm
% img_dir : directory of input  image 
function A= Mean_hash_algorithm(img_dir)

    img=imread(img_dir);
    temp=rgb2gray(img);

    img2=imresize(temp,[8 8]);
    img2=uint8(double(img2) / 4);

    average=mean(mean(img2));

    img2(img2 < average) = 0;
    img2(img2 >= average) = 1;
    A = img2;
    
    Str = BinToHex(A); %compute fingerprint of image
end