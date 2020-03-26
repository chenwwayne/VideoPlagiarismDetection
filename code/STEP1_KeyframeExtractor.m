img_file = dir('images\3-1\');  
img_dir  = 'images\3-1\' ; 
NOF = max(size(img_file) - 2);
imglist=img_file(3 : NOF + 2);
video = VideoReader('3-1.mpg');

step = 3;
frame_len = NOF + 2;
img_diff(round(frame_len / step)) = 0;

%遍历视频，计算两图片的RGB的特征值，分别作差取绝对值进行求和，得到RGB特征点的差异值
for i = 1 : step : frame_len  
    frame = imread(strcat(img_dir,imglist(i).name)); 
    rHist = double(imhist(frame(:,:,1), 256));
    gHist = double(imhist(frame(:,:,2), 256));
    bHist = double(imhist(frame(:,:,3), 256));
    
    
    if i < (frame_len - step)
        frame1 = imread(strcat(img_dir,imglist(i + step).name));
        r1Hist = double(imhist(frame1(:,:,1), 256));
        g1Hist = double(imhist(frame1(:,:,2), 256));
        b1Hist = double(imhist(frame1(:,:,3), 256));
    end
    
    img_diff(i)= sum(abs(rHist-r1Hist) + abs(gHist-g1Hist) + abs(bHist-b1Hist))/3;

    %显示运行进度
	clc;
	X = ['Process: ', num2str(int64((i/frame_len)*100)), '%'];
    disp(X)
end

%剔除离群值求平均，算出阈值
Threshold=trimmean(img_diff,0.3) * 11;

for i = 1 : step : frame_len 
    
	tmp = 0;
    if (i  >  frame_len - step)
         if( 0 == tmp ) %只进入一次
            imwrite(read(video, i), ['.\3-keyframe\' num2str(i) '.jpg']);
            tmp = tmp + 1;
         end
    end
     
    if(img_diff(i) > Threshold)
       imwrite(read(video, i), ['.\3-keyframe\'  num2str(i) '.jpg']);
    end;
end


