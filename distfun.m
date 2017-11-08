function d = distfun(XI,XJ,type)
XI = XI>0;
XJ = XJ>0;
if strcmp(type,'hist')
    d=sum(bsxfun(@times,XI,XJ),2);
elseif strcmp(type,'jaccard')
    d=sum(bsxfun(@times,XI,XJ),2)./sum(bsxfun(@or,XI,XJ),2);
else
end
