img_file = dir('images\1-1\');  
img_dir  = 'images\1-1\' ; 
NOF = max(size(img_file) - 2);
imglist = img_file(1:NOF + 2);
video = VideoReader('1-1.mpg');

step = 3;
frame_len = NOF + 2;
img_diff(round(frame_len / step)) = 0;
hammingDistance(round(frame_len / step)) = 0;
hammingDistanceThreshold = 20;

%遍历视频，计算RGB特征点的差异值，融合感知哈希算法
for i = 1 : step : frame_len  
    frame1 = imread(strcat(img_dir,imglist(i).name)); 
    rHist = double(imhist(frame1(:,:,1), 256));
    gHist = double(imhist(frame1(:,:,2), 256));
    bHist = double(imhist(frame1(:,:,3), 256));
    pHash_of_frame1 = Perceptual_hash_algorithm(strcat(img_dir,imglist(i).name));
    
    if i < (frame_len - step)
        frame2 = imread(strcat(img_dir,imglist(i + step).name));
        r1Hist = double(imhist(frame2(:,:,1), 256));
        g1Hist = double(imhist(frame2(:,:,2), 256));
        b1Hist = double(imhist(frame2(:,:,3), 256));
        pHash_of_frame2 = Perceptual_hash_algorithm(strcat(img_dir,imglist(i + step).name));
    end
    
    img_diff(i)= sum(abs(rHist-r1Hist) + abs(gHist-g1Hist) + abs(bHist-b1Hist))/3;
    
    hammingWeight = bitxor(pHash_of_frame1, pHash_of_frame2);%哈希权重
    hammingDistance(i)=sum(hammingWeight(:)==1);%哈希距离

    %显示运行进度
    clc;
    X = ['Process: ', num2str(int64((i/frame_len)*100)), '%'];
    disp(X)
end

%剔除离群值求平均，算出阈值
Threshold = trimmean(img_diff,0.1)* 11 ;

for i = 1 : step : frame_len 
    tmp = 0;
    if (i >  frame_len - step)        
         if( 0 == tmp)
            imwrite(read(video, i), ['.\1-keyframe\'  num2str(i) '.jpg']);
            tmp = tmp + 1;
         end
    end
     
    
    if( img_diff(i)>Threshold && hammingDistance(i) > hammingDistanceThreshold )
       imwrite(read(video, i), ['.\1-keyframe\'  num2str(i) '.jpg']);
    end;
    
end


% function: Perceptual_hash_algorithm
% img_dir : directory of input  image 
function pHash= Perceptual_hash_algorithm( img_dir )
    dIdx = zeros(1, 64);
    mean = 0.0;
    k = 1;
    pHash = zeros(1,64);
    
    img=imresize(rgb2gray(imread(img_dir)),[8 8]); 
    dctCoeff = dct2(img);
    
    for ii = 1 : 8
        for jj =1 : 8
            dIdx(k) = dctCoeff(ii,jj);
            mean = mean + dctCoeff(ii,jj)/64;
            k = k + 1;
        end
    end
    
    for ii = 1 : 64
        if (dIdx(ii) >= mean)
            pHash(ii) = 1;
        else
            pHash(ii) = 0;
        end
    end
end

