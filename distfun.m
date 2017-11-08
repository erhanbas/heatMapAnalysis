function d = distfun(XI,XJ)
XI = XI>0;
XJ = XJ>0;
d=sum(bsxfun(@times,XI,XJ),2);
