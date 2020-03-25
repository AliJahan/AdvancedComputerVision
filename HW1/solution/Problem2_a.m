display('***** Image Transforms *****');
display('1. DCT Transform');
display('2. DFT Transform (Show real)');
display('3. DFT Transform (Show imag)');
ch=input('Enter choice of transform: ');
if ch==1
    a=dctmtx(4);   
elseif ch==2
    a=dftmtx(4);
elseif ch==3
    a=dftmtx(4);
else
    display('Invalid Choice entered');
    return;
end
[m n]=size(a);
t=a';
for i=1:m
    for j=1:n
        if i==1
            p(j,1)=t(j,i);
        elseif i==2
            p(j+4,1)=t(j,i);
        elseif i==3
            p(j+8,1)=t(j,i);
        elseif i==4
            p(j+12,1)=t(j,i);
        end
    end
end
q=p';
r=p*q;
c=m*n;
h=1;
for e=1:m:c
    for f=1:n:c
        for o=1:m
            for q=1:n
                g(o,q)=r(e+o-1,f+q-1);
            end
        end
        if ch==1
            s=mat2gray(g);
        elseif ch==2
            s=mat2gray(real(g));
        elseif ch==3
            s=mat2gray(imag(g));
        end
        subplot(m,n,h);
        imshow(s)
        h=h+1;
    end
end